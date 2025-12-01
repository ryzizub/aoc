import 'dart:io';

final _regexAntenna = RegExp(r'[a-zA-Z0-9]$');

Future<void> main() async {
  final file = File('assets/day08/part02.txt');
  final content = await file.readAsString();

  final split = content.split('\n');

  final mapSplit = split.map((line) => line.split('')).toList();
  final map = _parseMap(mapSplit);

  _printMap(map);

  final antennas = _getAntennaMap(map);
  final mapFrequency = _generateAntinodes(map, antennas);

  _printMap(mapFrequency);

  final antinodeAnntenas = _getAntennaMap(mapFrequency);
  final antinodedMap = _generateAntinodes(
    mapFrequency,
    antinodeAnntenas,
    addNew: false,
  );

  _printMap(antinodedMap);

  print(_countAntinodes(antinodedMap));
}

List<List<_Element>> _parseMap(List<List<String>> map) {
  final result = <List<_Element>>[];

  for (var x = 0; x < map.length; x++) {
    final line = <_Element>[];

    for (var y = 0; y < map[x].length; y++) {
      final element = map[x][y];

      if (_regexAntenna.hasMatch(element)) {
        line.add(_Antenna(name: element, x: x, y: y));
      } else {
        line.add(_FrequencyAntenna(x: x, y: y));
      }
    }

    result.add(line);
  }

  return result;
}

List<List<_Element>> _copyMap(List<List<_Element>> map) {
  final newMap = <List<_Element>>[];
  for (final row in map) {
    final newRow = <_Element>[];
    for (final e in row) {
      if (e is _Antenna) {
        newRow.add(e.copyWith(isAntinode: e.isAntinode));
      } else if (e is _FrequencyAntenna) {
        newRow.add(e.copyWith(antinodeType: e.antinodeType));
      }
    }
    newMap.add(newRow);
  }
  return newMap;
}

int _countAntinodes(List<List<_Element>> map) {
  return map.fold(
    0,
    (acc, row) =>
        acc +
        row.where(
          (e) {
            if (e is _Antenna) {
              return e.isAntinode;
            }
            if (e is _FrequencyAntenna) {
              return e.antinodeType != null;
            }
            return false;
          },
        ).length,
  );
}

List<List<_Element>> _generateAntinodes(
  List<List<_Element>> map,
  Map<String, List<_Element>> antennasList, {
  bool addNew = true,
}) {
  final mapCopy = _copyMap(map);

  for (final freq in antennasList.keys) {
    final antennas = antennasList[freq]!;
    for (final antenna in antennas) {
      for (final pairAntenna in antennas) {
        if (antenna.x == pairAntenna.x && antenna.y == pairAntenna.y) {
          continue;
        }

        final dx = pairAntenna.x - antenna.x;
        final dy = pairAntenna.y - antenna.y;

        final g = _gcd(dx.abs(), dy.abs());
        final stepX = dx ~/ g;
        final stepY = dy ~/ g;

        var currentX = antenna.x + stepX;
        var currentY = antenna.y + stepY;
        while (currentX >= 0 &&
            currentX < map.length &&
            currentY >= 0 &&
            currentY < map[0].length) {
          mapCopy[currentX][currentY] =
              _markAntinode(mapCopy[currentX][currentY], freq, addNew);
          currentX += stepX;
          currentY += stepY;
        }

        currentX = antenna.x - stepX;
        currentY = antenna.y - stepY;
        while (currentX >= 0 &&
            currentX < map.length &&
            currentY >= 0 &&
            currentY < map[0].length) {
          mapCopy[currentX][currentY] =
              _markAntinode(mapCopy[currentX][currentY], freq, addNew);
          currentX -= stepX;
          currentY -= stepY;
        }
      }
    }
  }

  return mapCopy;
}

void _printMap(List<List<_Element>> map) {
  print('--------------------------------');
  print(map.map((line) => line.map((e) => e.toString()).join()).join('\n'));
  print('--------------------------------');
}

_Element _markAntinode(_Element element, String freq, bool addNew) {
  if (!addNew) {
    if (element is _Antenna) {
      return element.copyWith(isAntinode: true);
    }
    return element;
  } else {
    if (element is _FrequencyAntenna) {
      return _FrequencyAntenna(
        x: element.x,
        y: element.y,
        antinodeType: freq,
      );
    } else if (element is _Antenna) {
      return element.copyWith(isAntinode: true);
    } else {
      return element;
    }
  }
}

Map<String, List<_Element>> _getAntennaMap(List<List<_Element>> map) {
  final antennasByFrequency = <String, List<_Element>>{};
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[0].length; x++) {
      final element = map[y][x];
      if (element is _Antenna) {
        antennasByFrequency.putIfAbsent(element.name, () => []).add(element);
      }
      if (element is _FrequencyAntenna && element.antinodeType != null) {
        antennasByFrequency
            .putIfAbsent(element.antinodeType!, () => [])
            .add(element);
      }
    }
  }

  return antennasByFrequency;
}

int _gcd(int a, int b) {
  var aAbs = a.abs();
  var bAbs = b.abs();

  while (bAbs != 0) {
    final t = bAbs;
    bAbs = aAbs % bAbs;
    aAbs = t;
  }
  return aAbs;
}

sealed class _Element {
  const _Element({
    required this.x,
    required this.y,
  });

  final int x;
  final int y;
}

class _Antenna extends _Element {
  _Antenna({
    required this.name,
    required super.x,
    required super.y,
    this.isAntinode = false,
  });

  final String name;
  final bool isAntinode;

  _Antenna copyWith({
    bool? isAntinode,
  }) =>
      _Antenna(
        name: name,
        x: x,
        y: y,
        isAntinode: isAntinode ?? this.isAntinode,
      );

  @override
  String toString() => isAntinode ? '@' : name;
}

class _FrequencyAntenna extends _Element {
  _FrequencyAntenna({
    required super.x,
    required super.y,
    this.antinodeType,
  });

  final String? antinodeType;

  _FrequencyAntenna copyWith({
    String? antinodeType,
  }) =>
      _FrequencyAntenna(
        x: x,
        y: y,
        antinodeType: antinodeType,
      );

  @override
  String toString() => antinodeType != null ? '#' : '.';
}
