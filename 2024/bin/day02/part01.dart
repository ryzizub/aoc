import 'dart:io';

Future<void> main() async {
  final file = File('assets/day02/part01.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final reports = lines.map((line) {
    final regex = RegExp(r'\d+');
    final matches = regex.allMatches(line);
    final numbers = matches.map((match) => int.parse(match.group(0)!)).toList();

    return numbers;
  });

  var safeReports = 0;

  for (final report in reports) {
    bool? isIncreasing;
    var isValid = true;

    for (var i = 1; i < report.length; i++) {
      final difference = report[i] - report[i - 1];

      if (difference.abs() < 1 || difference.abs() > 3) {
        isValid = false;
        break;
      }

      if (isIncreasing == null) {
        isIncreasing = difference > 0;
        continue;
      }

      if ((difference > 0) != isIncreasing) {
        isValid = false;
        break;
      }
    }

    if (isValid) safeReports++;
  }

  print('final result: $safeReports');
}
