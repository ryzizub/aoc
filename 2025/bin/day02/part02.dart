import 'dart:io';

Future<void> main() async {
  final file = File('assets/day02/part02.txt');
  final content = await file.readAsString();

  final ranges = content.split(',');

  final rangesPairs = ranges.map((range) {
    final numbers = range.split('-').map(int.parse).toList();

    return (numbers[0], numbers[1]);
  }).toList();

  var result = 0;

  for (var i = 0; i < rangesPairs.length; i++) {
    final selectedRange = rangesPairs[i];
    for (var j = selectedRange.$1; j <= selectedRange.$2; j++) {
      final strNumber = j.toString();

      for (
        var patternLength = 1;
        patternLength <= strNumber.length ~/ 2;
        patternLength++
      ) {
        if (strNumber.length % patternLength != 0) continue;

        final pattern = strNumber.substring(0, patternLength);
        var matches = true;

        for (
          var startPat = patternLength;
          startPat < strNumber.length;
          startPat += patternLength
        ) {
          if (strNumber.substring(startPat, startPat + patternLength) !=
              pattern) {
            matches = false;
            break;
          }
        }

        if (matches) {
          result += j;
          break;
        }
      }
    }
  }

  print('result: $result');
}
