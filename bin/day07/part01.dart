import 'dart:io';

Future<void> main() async {
  final file = File('assets/day07/part01.txt');
  final content = await file.readAsString();

  final split = content.split('\n');

  final parsedProtocols = split.map(_CalibrationProtocol.fromString).toList();

  final finishedProtocols = parsedProtocols
      .where((protocol) => protocol.isPossibleToFinish())
      .toList();

  final finishedProtocolsSum = finishedProtocols
      .map((protocol) => protocol.target)
      .reduce((a, b) => a + b);

  print('finishedProtocols: ${finishedProtocols.length}');
  print('finishedProtocolsSum: $finishedProtocolsSum');
}

enum _CalibrationOperator {
  sum,
  multiply,
}

class _CalibrationProtocol {
  _CalibrationProtocol(this.target, this.values);

  factory _CalibrationProtocol.fromString(String protocol) {
    final split = protocol.split(': ');
    final target = int.parse(split[0]);
    final values = split[1].split(' ').map(int.parse).toList();
    return _CalibrationProtocol(target, values);
  }

  final int target;
  final List<int> values;

  bool isPossibleToFinish() {
    final combinations = _generateOperatorCombinations(values.length - 1);

    for (final combination in combinations) {
      var result = values.first;
      for (var i = 1; i < values.length; i++) {
        final operator = combination[i - 1];
        if (operator == _CalibrationOperator.sum) {
          result += values[i];
        } else {
          result *= values[i];
        }
      }

      if (result == target) {
        return true;
      }
    }

    return false;
  }
}

List<List<_CalibrationOperator>> _generateOperatorCombinations(int length) {
  final allCombinations = <List<_CalibrationOperator>>[];

  void generate(List<_CalibrationOperator> currentCombination) {
    if (currentCombination.length == length) {
      allCombinations.add(List<_CalibrationOperator>.from(currentCombination));
      return;
    }

    for (final operator in _CalibrationOperator.values) {
      currentCombination.add(operator);

      generate(currentCombination);

      currentCombination.removeLast();
    }
  }

  generate([]);

  return allCombinations;
}
