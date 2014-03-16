// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' show join;
import 'package:mustache/mustache.dart' as mustache;

//---------------------------------------------------------------------
// File generation
//---------------------------------------------------------------------

Map getComponentInformation(String name) {
  var parsed = name.split('_');
  var className = '';
  var tagName = '<px';

  parsed.forEach((part) {
    className += '${part.substring(0, 1).toUpperCase()}${part.substring(1)}';
    tagName += '-$part';
  });

  tagName += '>';

  return {
    'name': className,
    'path': 'components/$name/',
    'filename': '${name}.dart',
    'tag': tagName
  };
}

void buildDocs(List<String> sourceFiles) {
  // Generate the docs
  var docgenArgs = ['-j', '-v', '--include-private', '--no-include-sdk',
              '--no-include-dependent-packages', '--package-root=./packages'];
  docgenArgs.addAll(sourceFiles);
  // TODO: fix workingDirectory
  ProcessResult processResult =
      Process.runSync('docgen', docgenArgs, workingDirectory: '../');
  if (processResult.stderr != '') {
    print("failed to create docs: ${processResult.stderr}");
  }

  print("processResult ${processResult.stdout}");
}

String getOverview(Map component) {
  var docNamePart = component["filename"]
                    .substring(0, component["filename"].length - 5);
  var docFile = join('../', 'docs', 'pixelate', 'pixelate_${docNamePart}.json');
  var docData = readJsonFile(docFile) as Map;
  var docClass = (docData["classes"]["class"] as List)
      .firstWhere((e) => e["name"] == component['name']);
  // TODO: is "preview" the right element we want? How about "comment"
  var overview = docClass["preview"] == null ? "" : docClass["preview"];
  return overview;
}

List<String> findComponents(String path) {
  var directory = new Directory(path);
  var contents = directory.listSync();

  print(contents);

  return [];
}

List<Map> getExamples(String path) {
  var directory = new Directory(path);
  var contents = directory.listSync();
  var examples = [];

  contents.forEach((value) {
    if (value is File) {
      var file = value as File;

      // Read the file
      var codeListing = file.readAsStringSync(encoding: ASCII).trim();

      // Get the initial comment string for the description
      var description = '';

      if (codeListing.startsWith('<!--')) {
        var endIndex = codeListing.indexOf('-->');

        description = codeListing.substring(4, endIndex - 1).trim();
        codeListing = codeListing.substring(endIndex + 3).trim();
      } else {
        description = 'Description unavailable';
      }

      // Create the example
      var example = new Map();

      example['description'] = description;
      example['code'] = codeListing;

      examples.add(example);
    }
  });

  return examples;
}

List getGroups() {
  var metadata = readJsonFile('components.json') as List;
  var groups = [];

  metadata.forEach((groupMetadata) {
    var componentNames = groupMetadata['components'] as List;

    var components = [];
    var group = { 'name': groupMetadata['name'], 'components': components };

    groups.add(group);

    componentNames.forEach((componentName) {
      components.add(getComponentInformation(componentName));
    });
  });

  return groups;
}

//---------------------------------------------------------------------
// File I/O
//---------------------------------------------------------------------

String readTextFile(path) {
  var file = new File(path);

  return file.readAsStringSync(encoding: ASCII);
}

dynamic readJsonFile(filename) {
  var contents = readTextFile(filename);

  return JSON.decode(contents);
}

mustache.Template readMustacheTemplate(String path) {
  var source = readTextFile(path);

  return mustache.parse(source);
}

void writeTextFile(String path, String contents) {
  var file = new File(path);

  file.writeAsStringSync(contents, encoding: ASCII);
}

//---------------------------------------------------------------------
// Pages
//---------------------------------------------------------------------

void generateComponentPages(mustache.Template siteTemplate) {
  var groups = getGroups();
  var componentStyles = readJsonFile('styles.json') as Map;
  var template = readMustacheTemplate('component_template.html');

  // Generate the docs
  var sourceFiles = groups
      .map((g) => g['components']
      .map((c) => join('lib', c["path"], c["filename"])))
      .expand((i) => i).toList();
  buildDocs(sourceFiles);

  // Generate the components
  groups.forEach((group) {
    var components = group['components'] as List;

    components.forEach((component) {
      var path = component['path'];
      var name = component['name'];

      var partial = {
          'groups': groups,
          'tag': component['tag'],
          'overview': getOverview(component),
          'examples': getExamples(path)
      };

      // Determine imports
      var componentDirectory = new Directory('packages/pixelate/${path}');
      var imports = [];

      if (componentDirectory.existsSync()) {
        var files = componentDirectory.listSync();

        files.forEach((file) {
          var filePath = file.path;

          if (filePath.endsWith('.html')) {
            imports.add(filePath);
          }
        });
      }

      var styles = componentStyles.containsKey(name)
          ? componentStyles[name]
          : [];

      styles.add('style.css');

      var site = {
          'title': 'Pixelate Components',
          'relativePath': '../../',
          'styles': styles,
          'imports': imports,
          'content': template.renderString(partial)
      };

      var outputPath = '../web/${path}index.html';
      print('Outputing to $outputPath');

      writeTextFile(outputPath, siteTemplate.renderString(site));
    });
  });
}

void generateGettingStartedPage(mustache.Template siteTemplate) {
  var template = readMustacheTemplate('getting_started_template.html');

  var site = {
      'title': 'Pixelate',
      'relativePath': '../',
      'styles': [ 'style.css' ],
      'imports': [],
      'content': template.renderString({})
  };

  var outputPath = '../web/getting_started/index.html';
  print('Outputing to $outputPath');
  writeTextFile(outputPath, siteTemplate.renderString(site));
}

void generateIndexPage(mustache.Template siteTemplate) {
  var template = readMustacheTemplate('index_template.html');

  var partial = {
      'version': 'v0.1.0'
  };

  var site = {
      'title': 'Pixelate',
      'relativePath': '',
      'styles': [],
      'imports': [],
      'content': template.renderString(partial)
  };

  var outputPath = '../web/index.html';
  print('Outputing to $outputPath');
  writeTextFile(outputPath, siteTemplate.renderString(site));
}

//---------------------------------------------------------------------
// Entry point
//---------------------------------------------------------------------

void main() {
  var siteTemplate = readMustacheTemplate('site_template.html');

  generateIndexPage(siteTemplate);
  generateGettingStartedPage(siteTemplate);
  generateComponentPages(siteTemplate);
}
