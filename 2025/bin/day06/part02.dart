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
  final file = File('assets/day06/part02.txt');
  final content = await file.readAsString();

  final lines = content.split('\n');

  final problems = <_Problem>[];
  final numbers = <int>[];

  var _operator = _Operator.add;

  for (var i = 0; i < lines.first.length; i++) {
    final column = lines
        .sublist(0, lines.length - 1)
        .map((line) => line[i])
        .toList();
    final isEmptyBlock = column.every((element) => element == ' ');

    if (isEmptyBlock) {
      final problem = _Problem(List.from(numbers), _operator);
      problems.add(problem);
      numbers.clear();
      continue;
    }

    if (lines.last[i] == '+') {
      _operator = _Operator.add;
    } else if (lines.last[i] == '*') {
      _operator = _Operator.multiply;
    }

    final number = int.parse(column.join());

    numbers.add(number);
  }

  if (numbers.isNotEmpty) {
    final problem = _Problem(List.from(numbers), _operator);
    problems.add(problem);
  }

  final result = problems
      .map((problem) => problem.solve())
      .reduce((a, b) => a + b);

  print('result: $result');
}
