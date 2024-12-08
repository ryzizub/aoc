import 'dart:io';

final _regexAntenna = RegExp(r'[a-zA-Z0-9]$');

Future<void> main() async {
  final file = File('assets/day08/part01.txt');
  final content = await file.readAsString();

  final split = content.split('\n');

  final mapSplit = split.map((line) => line.split('')).toList();
  final map = _parseMap(mapSplit);

  _printMap(map);

  final antennas = _getAntennaMap(map);
  final antinodes = _generateAntinodes(map, antennas);

  _printMap(antinodes);

  print(_countAntinodes(antinodes));
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
        newRow.add(e.copyWith());
      } else if (e is _FrequencyAntenna) {
        newRow.add(e.copyWith());
      }
    }
    newMap.add(newRow);
  }
  return newMap;
}

int _countAntinodes(List<List<_Element>> map) {
  return map.fold(0, (acc, row) => acc + row.where((e) => e.isAntinode).length);
}

List<List<_Element>> _generateAntinodes(
  List<List<_Element>> map,
  Map<String, List<_Antenna>> antennasList,
) {
  final mapCopy = _copyMap(map);
  for (final freq in antennasList.keys) {
    final antennas = antennasList[freq]!;
    for (final antenna in antennas) {
      for (final pairAntenna in antennas) {
        if (antenna.x == pairAntenna.x && antenna.y == pairAntenna.y) {
          continue;
        }

        final differenceX = pairAntenna.x > antenna.x
            ? -(pairAntenna.x - antenna.x).abs()
            : (pairAntenna.x - antenna.x).abs();

        final differenceY = pairAntenna.y > antenna.y
            ? -(pairAntenna.y - antenna.y).abs()
            : (pairAntenna.y - antenna.y).abs();

        final oppositeX = antenna.x + differenceX;
        final oppositeY = antenna.y + differenceY;

        if (oppositeY >= 0 &&
            oppositeY < map[0].length &&
            oppositeX >= 0 &&
            oppositeX < map.length) {
          mapCopy[oppositeX][oppositeY] = mapCopy[oppositeX][oppositeY]
                  is _FrequencyAntenna
              ? _FrequencyAntenna(x: oppositeX, y: oppositeY, isAntinode: true)
              : (mapCopy[oppositeX][oppositeY] as _Antenna)
                  .copyWith(isAntinode: true);
          _printMap(mapCopy);
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

Map<String, List<_Antenna>> _getAntennaMap(List<List<_Element>> map) {
  final antennasByFrequency = <String, List<_Antenna>>{};
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[0].length; x++) {
      final element = map[y][x];
      if (element is _Antenna) {
        antennasByFrequency.putIfAbsent(element.name, () => []).add(element);
      }
    }
  }

  return antennasByFrequency;
}

sealed class _Element {
  const _Element({
    required this.x,
    required this.y,
    required this.isAntinode,
  });

  final int x;
  final int y;
  final bool isAntinode;
}

class _Antenna extends _Element {
  _Antenna({
    required this.name,
    required super.x,
    required super.y,
    super.isAntinode = false,
  });

  final String name;

  _Antenna copyWith({
    bool isAntinode = false,
  }) =>
      _Antenna(
        name: name,
        x: x,
        y: y,
        isAntinode: isAntinode,
      );

  @override
  String toString() => isAntinode ? '@' : name;
}

class _FrequencyAntenna extends _Element {
  _FrequencyAntenna({
    required super.x,
    required super.y,
    super.isAntinode = false,
  });

  _FrequencyAntenna copyWith({
    bool isAntinode = false,
  }) =>
      _FrequencyAntenna(
        x: x,
        y: y,
        isAntinode: isAntinode,
      );

  @override
  String toString() => isAntinode ? '#' : '.';
}
