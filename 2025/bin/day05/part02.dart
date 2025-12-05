import 'dart:io';

Future<void> main() async {
  final file = File('assets/day05/part02.txt');
  final content = await file.readAsString();

  final lines = content.split(
    '\n'
    '\n',
  );

  final freshRanges = lines[0].split('\n').map((line) {
    final split = line.split('-');
    return (int.parse(split[0]), int.parse(split[1]));
  }).toList()..sort((a, b) => a.$1.compareTo(b.$1));

  final mergedRanges = <(int, int)>[];
  var currentStart = freshRanges[0].$1;
  var currentEnd = freshRanges[0].$2;

  // Overlap merge
  for (var i = 1; i < freshRanges.length; i++) {
    final range = freshRanges[i];
    if (range.$1 <= currentEnd + 1) {
      currentEnd = currentEnd > range.$2 ? currentEnd : range.$2;
      if (i == freshRanges.length - 1) {
        mergedRanges.add((currentStart, currentEnd));
      }
    } else {
      mergedRanges.add((currentStart, currentEnd));
      currentStart = range.$1;
      currentEnd = range.$2;
      if (i == freshRanges.length - 1) {
        mergedRanges.add((currentStart, currentEnd));
      }
    }
  }

  var result = 0;
  for (final range in mergedRanges) {
    result += range.$2 - range.$1 + 1;
  }

  print(result);
}
