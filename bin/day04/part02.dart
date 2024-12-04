import 'dart:io';

Future<void> main() async {
  final file = File('assets/day04/part02.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  var found = 0;

  const correctWord = 'MAS';

  final toVerify = [correctWord, correctWord.split('').reversed.join()];

  for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
    for (var charIndex = 0;
        charIndex < lines[lineIndex].split('').length;
        charIndex++) {
      var right = false;
      var left = false;

      for (final word in toVerify) {
        if (_verifyLines(
          lines,
          charIndex,
          lineIndex,
          word,
          _Direction.rightDown,
        )) {
          right = true;
          break;
        }
      }

      for (final word in toVerify) {
        if (_verifyLines(
          lines,
          charIndex + 2,
          lineIndex,
          word,
          _Direction.leftDown,
        )) {
          left = true;
          break;
        }
      }

      if (right && left) {
        found++;
      }
    }
  }

  print('final result: $found');
}

enum _Direction {
  leftDown,
  rightDown,
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
    };

    final nextLineIndex = switch (direction) {
      _Direction.leftDown => lineIndex + 1,
      _Direction.rightDown => lineIndex + 1,
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
