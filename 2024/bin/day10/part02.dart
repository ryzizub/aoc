import 'dart:io';

Future<void> main() async {
  final file = File('assets/day10/part02.txt');
  final content = await file.readAsString();

  final positions = content
      .split('\n')
      .map((e) => e.split('').map(int.parse).toList())
      .toList();

  final result = _calculateTrailheadRatings(positions);
  print('Sum of trailhead ratings: $result');
}

int _calculateTrailheadRatings(List<List<int>> map) {
  var totalRating = 0;

  for (var row = 0; row < map.length; row++) {
    for (var col = 0; col < map[0].length; col++) {
      if (map[row][col] == 0) {
        totalRating += calculateTrailheadRating(map, row, col);
      }
    }
  }

  return totalRating;
}

int calculateTrailheadRating(List<List<int>> map, int startRow, int startCol) {
  final result = _findDistinctPaths(map, startRow, startCol, 0, '', <String>{});
  return result.paths.length;
}

({Set<String> paths}) _findDistinctPaths(
  List<List<int>> map,
  int row,
  int col,
  int currentHeight,
  String currentPath,
  Set<String> paths,
) {
  if (!_isValidPosition(map, row, col)) {
    return (paths: paths);
  }
  if (map[row][col] != currentHeight) {
    return (paths: paths);
  }

  if (currentHeight == 9) {
    return (paths: {...paths, currentPath});
  }

  final directions = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1],
  ];

  var result = (paths: paths);
  for (final dir in directions) {
    final newRow = row + dir[0];
    final newCol = col + dir[1];
    result = _findDistinctPaths(
      map,
      newRow,
      newCol,
      currentHeight + 1,
      '$currentPath$newRow,$newCol;',
      result.paths,
    );
  }

  return result;
}

bool _isValidPosition(List<List<int>> map, int row, int col) {
  return row >= 0 && row < map.length && col >= 0 && col < map[0].length;
}
