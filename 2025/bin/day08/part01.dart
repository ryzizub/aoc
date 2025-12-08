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

  Map<_JunctionBox, int> countCircuitSizes(List<_JunctionBox> allBoxes) {
    final sizes = <_JunctionBox, int>{};
    for (final box in allBoxes) {
      _addBox(box);
      final circuitRepresentative = _findCircuit(box);
      sizes[circuitRepresentative] = (sizes[circuitRepresentative] ?? 0) + 1;
    }
    return sizes;
  }
}

Future<void> main() async {
  final file = File('assets/day08/part01.txt');
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
  final connectionsToMake = allPossibleConnections.take(1000).toList();

  final circuitTracker = _Circuit();
  for (final connection in connectionsToMake) {
    circuitTracker.connect(connection.box1, connection.box2);
  }

  final circuitSizes =
      circuitTracker.countCircuitSizes(junctionBoxes).values.toList()
        ..sort((a, b) => b.compareTo(a));

  final product = circuitSizes.take(3).reduce((a, b) => a * b);
  print(product);
}
