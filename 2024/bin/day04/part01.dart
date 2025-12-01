import 'dart:io';

Future<void> main() async {
  final file = File('assets/day04/part01.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  var found = 0;

  const correctWord = 'XMAS';

  for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
    for (var charIndex = 0;
        charIndex < lines[lineIndex].split('').length;
        charIndex++) {
      for (final direction in _Direction.values) {
        if (_verifyLines(lines, charIndex, lineIndex, correctWord, direction)) {
          found++;
        }
      }
    }
  }

  print('final result: $found');
}

enum _Direction {
  leftDown,
  rightDown,
  down,
  left,
  right,
  up,
  leftUp,
  rightUp,
}

bool _verifyLines(
  List<String> lines,
  int index,
  int lineIndex,
  String word,
  _Direction direction,
) {
  if (word.isEmpty) {
    return true;
  }

  final startChar = _getChar(lines, index, lineIndex);

  if (startChar == null) {
    return false;
  }

  if (startChar[0] == word[0]) {
    final nextIndex = switch (direction) {
      _Direction.leftDown => index - 1,
      _Direction.rightDown => index + 1,
      _Direction.down => index,
      _Direction.left => index - 1,
      _Direction.right => index + 1,
      _Direction.up => index,
      _Direction.leftUp => index - 1,
      _Direction.rightUp => index + 1,
    };

    final nextLineIndex = switch (direction) {
      _Direction.leftDown => lineIndex + 1,
      _Direction.rightDown => lineIndex + 1,
      _Direction.down => lineIndex + 1,
      _Direction.left => lineIndex,
      _Direction.right => lineIndex,
      _Direction.up => lineIndex - 1,
      _Direction.leftUp => lineIndex - 1,
      _Direction.rightUp => lineIndex - 1,
    };

    return _verifyLines(
      lines,
      nextIndex,
      nextLineIndex,
      word.substring(1),
      direction,
    );
  }

  return false;
}

String? _getChar(List<String> lines, int index, int lineIndex) {
  return lineIndex >= 0 &&
          lineIndex < lines.length &&
          index >= 0 &&
          index < lines[lineIndex].length
      ? lines[lineIndex][index]
      : null;
}
