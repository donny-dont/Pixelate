// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library location;

import 'item.dart';
import 'package:dartdoc_viewer/app.dart' show viewer;
import 'package:dartdoc_viewer/shared.dart';

import 'dart:html';

// These regular expressions are not strictly accurate for picking Dart
// identifiers out of arbitrary text, e.g. identifiers must start with an
// alphabetic or underscore, this would allow "9a" as a library name. But
// they should be sufficient for extracting them from URLs that were created
// from valid identifiers.

/// A package in one of our URIs is an identifer and ends with a slash
final packageMatch = new RegExp(r'(\w+)/');

/// A library in one of our URIs is an identifier but may contain either
/// ':' or '-' in place of the '.' that is legal in a Dart library name.
final libraryMatch = new RegExp(r'([\w\-\:]+)');

/// A member or sub-member in one of our URI's starts with a '.' and is
/// an identifier.
final memberMatch = new RegExp(r'\.(\w+)');

/// A sub-member can be a normal identifier but can also be an operator.
/// Constructors always contain a "-" and are of the form
/// "className-constructorName" (if constructorName is empty, it will just be
/// "className-".
final subMemberMatch = new RegExp(r'\.([\w\<\+\|\[\]\>\/\^\=\&\*\-\%]+)');

RegExp get anchorMatch {
  var anchorPrefix = ANCHOR_STRING;
  if (useHistory) anchorPrefix = ANCHOR_PLUS_PREFIX;
  return new RegExp(r'\' + anchorPrefix +
      r'([\w\<\+\|\[\]\>\/\^\=\&\*\-\%\.\,]+)');
}

/// The character used to separator the parameter from the method in a
/// link which is to a method on the same page as its class. So, e.g.
/// in `dart-core.Object@id_noSuchMethod,invocation` this separates
/// the method `noSuchMethod` from the parameter `invocation`.
const PARAMETER_SEPARATOR = ",";

/// The character used to separate the class name from the constructor
/// name, e.g. `Future.Future-delayed`. Will occur by itself for
/// an unnamed constructor. e.g. `Future.Future-`
const CONSTRUCTOR_SEPARATOR = "-";

/// The prefix we use in the URL to identify where the location portion of
/// the URL is.
String get BASIC_LOCATION_PREFIX => useHistory? r"/dartdoc-viewer/" :
    ANCHOR_STRING;

/// The separator to use between the "anchor" portion of the location, which
/// is shown as part of the larger page, and the main portion. This doesn't
/// necessarily correspond to an HTML anchor, though it may.
const ANCHOR_STRING = "#";

const ANCHOR_PLUS_PREFIX = useHistory ? ANCHOR_STRING : '@';

/// Character to separate the version number (if present) from the actual member
/// name.
const VERSION_NUM_SEPARATOR = '~';

/// String to identify an anchor on a subproperty on a page (for example, a
/// parameter name in a method).
const ID_STRING = 'id_';

/// Prefix the string with the separator we are using between the main
/// URL and the location.
String locationPrefixed(String s) =>
    "$entryPoint$BASIC_LOCATION_PREFIX$getVersionStr$s";

/// When we can, return the prefixed (link local to this app) link to the item.
/// Otherwise, return the canonical link to the Dart SDK documentation (if
/// redirectToDartlang is true).
String prefixedLocationWhenPossible(DocsLocation location, String linkVersion)
    => viewer.redirectToDartlang && location.isSDK ?
        fullDartlangLocation(linkVersion) : locationPrefixed(linkVersion);

/// Return the full URL for dart core APIs.
String fullDartlangLocation(String location) =>
    'https://api.dartlang.org/apidocs/channels/${dartdocMain.sdkChannel}'
    '/dartdoc-viewer/${dartdocMain.sdkRevisionNum}' + location;

String get getVersionStr {
  if (dartdocMain.hostDocsVersion != '') {
    return dartdocMain.hostDocsVersion + VERSION_NUM_SEPARATOR;
  }
  return dartdocMain.hostDocsVersion;
}

/// The prefix on our URLs. Used to construct absolute URLs because we
/// use / in to separate packages, which messes up relative URLs
String get entryPoint {
  if (!useHistory) return '';
  var basic = window.location.pathname.split(BASIC_LOCATION_PREFIX)[0];
  return basic == '/' ? '' : basic;
}

/// The entry point for JSON docs.
String get docsEntryPoint {
  // TODO(alanknight): There must be some better way than hard-coding
  // the test for index.html.
  if (entryPoint.endsWith("index.html")) {
    return entryPoint.substring(0, entryPoint.lastIndexOf('/') + 1);
  } else if (entryPoint.endsWith("/")) {
      return entryPoint.substring(0, entryPoint.length - 1);
  } else return entryPoint;
}

/// Remove the anchor prefix from [s] if it's present.
String locationDeprefixed(String s) {
  var result = s;
  if (useHistory && s.startsWith(entryPoint)) {
    result = s.substring(entryPoint.length);
  }
  if (result.startsWith(BASIC_LOCATION_PREFIX)) {
    return result.substring(BASIC_LOCATION_PREFIX.length);
  } else if (result.startsWith(ANCHOR_STRING)) {
    return result.substring(ANCHOR_STRING.length);
  } else {
    return result;
  }
}

/// This represents a component described by a URI and can give us
/// the URI given the component or vice versa.
// TODO(kevmoo): make these fields final
class DocsLocation {
  String packageName;
  String libraryName;
  String memberName;
  String subMemberName;
  String anchor;

  // TODO(alanknight): These might be nicer to work with as immutable value
  // objects with methods to get modified versions.
  DocsLocation.empty();

  DocsLocation(String uri) {
    _extractPieces(uri);
  }

  DocsLocation.fromList(List<String> components) {
    if (components.length > 0) packageName = components[0];
    if (components.length > 1) libraryName = components[1];
    if (components.length > 2) memberName = components[2];
    if (components.length > 3) subMemberName = components[3];
    if (components.length > 4) anchor = components[4];
  }

  DocsLocation.clone(DocsLocation original) {
    packageName = original.packageName;
    libraryName = original.libraryName;
    memberName = original.memberName;
    subMemberName = original.subMemberName;
    anchor = original.anchor;
  }

  bool operator ==(other) {
    if (other is! DocsLocation) return false;
    return packageName == other.packageName
        && libraryName == other.libraryName
        && memberName == other.memberName
        && subMemberName == other.subMemberName
        && anchor == other.anchor;
  }

  /// This isn't a particularly good hash code, but we don't really hash
  /// these very much. Just XOR together all the fields.
  int get hashCode => packageName.hashCode ^ libraryName.hashCode ^
      memberName.hashCode ^ subMemberName.hashCode ^ anchor.hashCode;

  /// Create the location from the pieces in [uri]. It will accept things
  /// that both do and do not start with our leading string. We also
  /// assume that anything that starts with a leading slash and does not
  /// have our indicator means the home page.
  void _extractPieces(String uri) {
    if (uri == null || uri.length == 0) return;
    var resultUri = uri;
    if (useHistory) {
      var startOfOurChunk = uri.lastIndexOf(BASIC_LOCATION_PREFIX);
      if (startOfOurChunk == -1 && uri.startsWith('/')) return;
      resultUri = startOfOurChunk == -1 ? uri :
        uri.substring(startOfOurChunk + BASIC_LOCATION_PREFIX.length);
    }
    var position = 0;

    _check(regex) {
      var match = regex.matchAsPrefix(resultUri, position);
      if (match != null) {
        var matchedString = match.group(1);
        position = position + match.group(0).length;
        return matchedString;
      }
    }

    packageName = _check(packageMatch);
    libraryName = _check(libraryMatch);
    memberName = _check(memberMatch);
    subMemberName = _check(subMemberMatch);
    anchor = _check(anchorMatch);
    if (position < resultUri.length && anchor == null) {
      // allow an anchor that's just dotted, not @ if we don't find an @
      // form and we haven't reached the end.
      anchor = resultUri.substring(position + 1, resultUri.length);
    }
  }

  /// The URI hash string without its leading hash
  /// and without any trailing anchor portion, e.g. for
  /// http://site/#args/args.ArgParser@id_== it would return args/argsArgParser
  String get withoutAnchor =>
      [packagePlus, libraryPlus, memberPlus, subMemberPlus].join("");

  /// The URI hash for just the library portion of this location.
  String get libraryQualifiedName => "$packagePlus$libraryPlus";

  /// The full URI hash string without the leading hash character.
  /// e.g. for
  /// http://site/#args/args.ArgParser@id_==
  /// it would return args/argsArgParser@id_==
  String get withAnchor => withoutAnchor + anchorPlus;

  DocsLocation get locationWithoutAnchor =>
      new DocsLocation.clone(this)..anchor = null;

  /// The package name with the trailing / separator, or the empty
  /// string if the package name is not set.
  get packagePlus => packageName == null
      ? ''
      : libraryName == null
          ? packageName
          : '$packageName/';

  /// The name of the library. This never has leading or trailing separators,
  /// so it's the same as [libraryName].
  get libraryPlus => libraryName == null ? '' :  libraryName;

  /// The name of the library member, with a leading period if the [memberName]
  /// is non-empty.
  get memberPlus => memberName == null ? '' : '.$memberName';

  /// The name of the member's sub-member (e.g. the field of a class),
  /// with a leading period if the [subMemberName] is non-empty.
  get subMemberPlus =>
      subMemberName == null ? '' : '.$subMemberName';

  /// The trailing anchor e.g. @id_hashCode, including the leading @.
  get anchorPlus => anchor == null ? '' : '$ANCHOR_PLUS_PREFIX$anchor';

  /// Return a list of the components' basic names. Omits the anchor, but
  /// includes the package name, even if it is null.
  List<String> get componentNames =>
      [packageName]..addAll(
          [libraryName, memberName, subMemberName].where((x) => x != null));

  /// Return all component names, including the anchor, and including those
  /// which are null.
  List<String> get allComponentNames =>
      [packageName, libraryName, memberName, subMemberName, anchor];

  /// Return the simple name of the lowest-level component.
  String get name {
    if (anchor != null) return anchor;
    if (subMemberName != null) return subMemberName;
    if (memberName != null) return memberName;
    if (libraryName != null) return libraryName;
    if (packageName != null) return packageName;
    return '';
  }

  /// Return a minimal list of the items along our path, using [root] for
  /// context. The [root] is of type Home, and it returns a list of Item,
  /// but we can't see those types from here. The [includeAllItems] parameter
  /// determines if we return a fixed-length list with all items included,
  /// which may be null, or if we just include the items with values.
  List<Item> items(Item root, {bool includeAllItems: false}) {
    // TODO(alanknight): Re-arrange the structure so that we can see
    // those types without needing to import html as well.
    var items = <Item>[];
    var package, library, member, subMember, anchorItem;
    package = packageName == null
        ? null
        : root.memberNamed(packageName);
    if (package != null) items.add(package);
    if (libraryName == null) return items;
    var home = items.isEmpty ? root : items.last;
    library = home.memberNamed(libraryName);
    if (library == null && !includeAllItems) return items;
    items.add(library);
    // If we don't have a library, we can't have members or sub-members,
    // so short-circuit out of here. Either this is just a package, or it's
    // an invalid location.
    if (library == null) {
      return includeAllItems ? [null, null, null, null, null] : items;
    }
    member = memberName == null
        ? null : library.memberNamed(memberName);
    if (member != null) {
      items.add(member);
      if (subMemberName != null) {
        var lookupName = subMemberName;
        if (subMemberName.contains('-')) {
          // Constructors are hyphenated Classname-constructorname. We want to
          // look up just the constructor name.
          lookupName = subMemberName.substring(subMemberName.indexOf('-') + 1);
        }
        subMember = member.memberNamed(lookupName);
      }
      if (subMember != null) items.add(subMember);
      if (anchor != null) {
        // The anchor might be for a parameter of either a method or a function.
        var container = subMember == null ? member : subMember;
        // Try the anchor both as itself and as id_$anchor
        anchorItem = container.memberNamed(anchor);
        if (anchorItem == null) {
          anchorItem = container.memberNamed(toHash(anchor));
        }
        if (anchorItem != null) items.add(anchorItem);
      }
    }
    return includeAllItems ?
        [package, library, member, subMember, anchorItem] :
        items;
  }

  /// Find the part of us that refers to an [Item] accessible from
  /// root and return a new [DocsLocation] with just that portion.
  /// e.g. if we had dart-core.String.substring.startIndex it
  /// would return dart-core.String.substring, since the method
  /// parameter doesn't have an [Item]. The [root] parameter is a Home.
  DocsLocation itemLocation(root) => item(root).location;

  /// Find the bottom-most [Item] that we refer to, accessible from
  /// root, and return it.
  /// e.g. if we had dart-core.String.substring.startIndex it
  /// would return the substring [Method], since the method
  /// parameter doesn't have an [Item]. The [root] parameter is a Home.
  Item item(Item root) {
    var myItems = items(root);
    return myItems.isEmpty ? null : myItems.last;
  }

  /// Find the item that corresponds to the last field in the location.
  /// As compared to [item], which will just return the last found
  /// [Item], this will return null if there's not a match for the
  /// last item.
  Item exactItem(Item root) {
    var myItems = items(root, includeAllItems: true);
    if (anchor != null) return myItems[4];
    if (subMemberName != null) return myItems[3];
    if (memberName != null) return myItems[2];
    if (libraryName != null) return myItems[1];
    if (packageName != null) return myItems[0];
    return null;
  }

  /// Given a location with an @id_ anchor, transform it into one with
  /// a corresponding sub-member.
  DocsLocation get asMemberOrSubMemberNotAnchor {
    if (anchor == null) return this;
    if (subMemberName != null || anchor.length <= ID_STRING.length) {
      throw new FormatException("DocsLocation invalid: $this");
    }
    var result = new DocsLocation.clone(this);
    result.anchor = null;
    var newName = anchor.substring(ID_STRING.length, anchor.length);
    var withParameterName = newName.split(PARAMETER_SEPARATOR);
    var parameterName =
        (withParameterName.length > 1) ? withParameterName[1] : null;
    if (result.memberName == null) {
      result.memberName = withParameterName.first;
      result.subMemberName = parameterName;
    } else {
      result.subMemberName = withParameterName.first;
      result.anchor = parameterName;
    }
    return result;
  }

  /// Given a potentially invalid location, find the parent location
  /// which is valid.
  DocsLocation firstValidParent(root) {
    var myItem = item(root);
    return myItem == null ? root.location : myItem.location;
  }

  /// Return the item in the list that corresponds to the thing we represent.
  /// Assumes that the items all match what we describe, so really amounts
  /// to finding the last non-nil entry.
  itemFromList(List items) => items.reversed
      .firstWhere((x) => x != null, orElse: () => null);

  /// Change [hash] into the form we use for identifying a doc entry within
  /// a larger page.
  String toHash(String hash) => ID_STRING + hash;

  /// The string that identifies our parent (e.g. the package containing a
  /// library, or the class containing a method) or an empty string if
  /// we don't have a parent.
  String get parentQualifiedName => parentLocation.withoutAnchor;

  /// The [DocsLocation] that identifies our parent (e.g. the package
  /// containing a
  /// library, or the class containing a method)
  DocsLocation get parentLocation =>
      new DocsLocation.fromList(componentNames..removeLast());

  DocsLocation get asHash =>
      parentLocation..anchor = toHash(name);

  /// The simple name of our parent
  String get parentName {
    var names = componentNames;
    return names.length < 2 ? '' : names[names.length - 2];
  }

  bool get isEmpty => packageName == null && libraryName == null
      && memberName == null && subMemberName == null && anchor == null;

  /// Return the last component for which we have a value, not counting
  /// the anchor.
  String get lastName {
    if (anchor != null) return anchor;
    if (subMemberName != null) return subMemberName;
    if (memberName != null) return memberName;
    if (libraryName != null) return libraryName;
    if (packageName != null) return packageName;
    return null;
  }

  /// Return true if this is a location documenting an item only defined in the
  /// Dart SDK.
  bool get isSDK => libraryName != null && libraryName.startsWith('dart-');

  toString() => 'DocsLocation($withAnchor)';
}
