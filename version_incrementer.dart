import 'dart:io';

import 'package:yaml_edit/yaml_edit.dart' as yaml_editor;

///
/// Considering a version format of : x.y.z
/// This script increment version of z by 1
///
void main() async {
  const pubscpecFilename = './pubspec.yaml';
  final pubSpecYamlContent = await File(pubscpecFilename).readAsString();
  final yamlEditor = yaml_editor.YamlEditor(pubSpecYamlContent);
  final oldApkVersion = yamlEditor.parseAt(['version']).value;

  final versionParts = oldApkVersion.toString().split('.');

  final newVersionParts = [
    ...versionParts.sublist(0, 2),
    int.parse(versionParts.last) + 1
  ];

  yamlEditor.update(['version'], newVersionParts.join('.'));

  File(pubscpecFilename).writeAsString(yamlEditor.toString());
}
