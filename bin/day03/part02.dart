import 'dart:io';

Future<void> main() async {
  final file = File('assets/day03/part02.txt');
  final content = await file.readAsString();

  final regex = RegExp(r"mul\((\d+),(\d+)\)|do\(\)|don\'t\(\)");

  final matches = regex.allMatches(content);

  var isEnabled = true;

  final results = matches.map((match) {
    if (match.group(0) == "don't()") {
      isEnabled = false;
      return 0;
    }

    if (match.group(0) == 'do()') {
      isEnabled = true;
      return 0;
    }

    if (match.group(0)!.startsWith('mul') && isEnabled) {
      final x = int.parse(match.group(1)!);
      final y = int.parse(match.group(2)!);

      return x * y;
    }

    return 0;
  });

  final sum = results.reduce((a, b) => a + b);

  print('final result: $sum');
}
