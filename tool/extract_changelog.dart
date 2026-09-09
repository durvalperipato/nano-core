import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/extract_changelog.dart <version> [changelog_path]',
    );
    exit(1);
  }

  final version = arguments[0].replaceFirst(RegExp(r'^v'), '').trim();
  final changelogPath = arguments.length > 1 ? arguments[1] : 'CHANGELOG.md';

  final file = File(changelogPath);
  if (!file.existsSync()) {
    stderr.writeln('Error: $changelogPath not found.');
    exit(1);
  }

  final content = file.readAsStringSync();
  final escapedVersion = RegExp.escape(version);
  final regex = RegExp(
    r'##\s*\[?v?' + escapedVersion + r'\]?[^\n]*\n([\s\S]*?)(?=\n##\s|$)',
  );

  final match = regex.firstMatch(content);
  if (match == null) {
    stderr.writeln('Warning: Version $version not found in $changelogPath');
    exit(0);
  }

  final extracted = match.group(1)?.trim() ?? '';
  stdout.writeln(extracted);
}
