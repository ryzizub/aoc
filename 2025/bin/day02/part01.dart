import 'dart:io';

Future<void> main() async {
  final file = File('assets/day02/part01.txt');
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
      if (strNumber.length.isEven) {
        final halfLength = strNumber.length ~/ 2;
        final firstHalf = strNumber.substring(0, halfLength);
        final secondHalf = strNumber.substring(halfLength);
        if (firstHalf == secondHalf) {
          result += j;
        }
      }
    }
  }

  print('result: $result');
}
