import 'dart:io';
import 'dart:math';

class _JunctionBox {
  _JunctionBox(this.x, this.y, this.z);

  final int x;
  final int y;
  final int z;

  double distanceTo(_JunctionBox other) {
    return sqrt(
      pow(x - other.x, 2) + pow(y - other.y, 2) + pow(z - other.z, 2),
    );
  }
}

class _Circuit {
  final Map<_JunctionBox, _JunctionBox> _circuitRepresentative = {};
  final Map<_JunctionBox, int> _circuitDepth = {};

  void _addBox(_JunctionBox box) {
    if (!_circuitRepresentative.containsKey(box)) {
      _circuitRepresentative[box] = box;
      _circuitDepth[box] = 0;
    }
  }

  _JunctionBox _findCircuit(_JunctionBox box) {
    if (_circuitRepresentative[box] != box) {
      _circuitRepresentative[box] = _findCircuit(_circuitRepresentative[box]!);
    }
    return _circuitRepresentative[box]!;
  }

  void connect(_JunctionBox box1, _JunctionBox box2) {
    _addBox(box1);
    _addBox(box2);

    final circuit1 = _findCircuit(box1);
    final circuit2 = _findCircuit(box2);

    if (circuit1 == circuit2) return;

    if (_circuitDepth[circuit1]! < _circuitDepth[circuit2]!) {
      _circuitRepresentative[circuit1] = circuit2;
    } else if (_circuitDepth[circuit1]! > _circuitDepth[circuit2]!) {
      _circuitRepresentative[circuit2] = circuit1;
    } else {
      _circuitRepresentative[circuit2] = circuit1;
      _circuitDepth[circuit1] = _circuitDepth[circuit1]! + 1;
    }
  }

  bool areAllConnected(List<_JunctionBox> allBoxes) {
    if (allBoxes.isEmpty) return true;
    allBoxes.forEach(_addBox);
    final firstCircuit = _findCircuit(allBoxes.first);
    for (var i = 1; i < allBoxes.length; i++) {
      if (_findCircuit(allBoxes[i]) != firstCircuit) {
        return false;
      }
    }
    return true;
  }
}

Future<void> main() async {
  final file = File('assets/day08/part02.txt');
  final content = await file.readAsString();
  final lines = content.split('\n');

  final junctionBoxes = lines.map(
    (line) {
      final coordinates = line.split(',');
      return _JunctionBox(
        int.parse(coordinates[0]),
        int.parse(coordinates[1]),
        int.parse(coordinates[2]),
      );
    },
  ).toList();

  final allPossibleConnections =
      <({_JunctionBox box1, _JunctionBox box2, double distance})>[];
  for (var i = 0; i < junctionBoxes.length; i++) {
    for (var j = i + 1; j < junctionBoxes.length; j++) {
      final distance = junctionBoxes[i].distanceTo(junctionBoxes[j]);
      allPossibleConnections.add((
        box1: junctionBoxes[i],
        box2: junctionBoxes[j],
        distance: distance,
      ));
    }
  }

  allPossibleConnections.sort((a, b) => a.distance.compareTo(b.distance));

  final circuitTracker = _Circuit();
  _JunctionBox? lastBox1;
  _JunctionBox? lastBox2;

  for (final connection in allPossibleConnections) {
    final wereConnectedBefore = circuitTracker.areAllConnected(junctionBoxes);
    circuitTracker.connect(connection.box1, connection.box2);
    final areConnectedNow = circuitTracker.areAllConnected(junctionBoxes);

    if (!wereConnectedBefore && areConnectedNow) {
      lastBox1 = connection.box1;
      lastBox2 = connection.box2;
      break;
    }
  }

  final product = lastBox1!.x * lastBox2!.x;
  print(product);
}
