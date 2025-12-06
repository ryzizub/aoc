import 'dart:io';

enum _Operator {
  add,
  multiply,
}

class _Problem {
  _Problem(this.numbers, this.operator);

  final List<int> numbers;
  final _Operator operator;

  int solve() {
    switch (operator) {
      case _Operator.add:
        return numbers.reduce((a, b) => a + b);
      case _Operator.multiply:
        return numbers.reduce((a, b) => a * b);
    }
  }
}

Future<void> main() async {
  final file = File('assets/day06/part01.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final splittedLines = lines
      .map(
        (line) =>
            line.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList(),
      )
      .toList();

  var result = 0;

  // Last line is the operator
  for (var i = 0; i < splittedLines.last.length; i++) {
    final numbers = <int>[];

    for (var j = 0; j < splittedLines.length - 1; j++) {
      numbers.add(int.parse(splittedLines[j][i]));
    }
    final problem = _Problem(
      numbers,
      splittedLines.last[i] == '+' ? _Operator.add : _Operator.multiply,
    );

    result = result + problem.solve();

    print('result: $result');
  }

  print('final result: $result');
}
