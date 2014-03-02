// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:convert';
import 'dart:io';
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
    'tag': tagName
  };
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
      var example = new Map();

      example['description'] = 'Testing this';
      example['code'] = file.readAsStringSync(encoding: ASCII).trim();

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
// Entry point
//---------------------------------------------------------------------

void main() {
  var groups = getGroups();
  var siteTemplate = readMustacheTemplate('site_template.html');
  var template = readMustacheTemplate('component_template.html');

  groups.forEach((group) {
    var components = group['components'] as List;

    components.forEach((component) {
      var path = component['path'];
      var partial = {
          'groups': groups,
          'tag': component['tag'],
          'overview': 'Testing this',
          'examples': getExamples(path)
      };

      var site = {
          'title': 'Components',
          'content': template.renderString(partial)
      };

      writeTextFile('../web/${path}index.html', siteTemplate.renderString(site));
    });
  });
}
