import 'dart:io';

Future<void> main() async {
  final file = File('assets/day10/part01.txt');
  final content = await file.readAsString();

  final positions = content
      .split('\n')
      .map((e) => e.split('').map(int.parse).toList())
      .toList();

  final result = _calculateTrailheadScores(positions);
  print('Sum of trailhead scores: $result');
}

int _calculateTrailheadScores(List<List<int>> map) {
  var totalScore = 0;

  for (var row = 0; row < map.length; row++) {
    for (var col = 0; col < map[0].length; col++) {
      if (map[row][col] == 0) {
        totalScore += calculateTrailheadScore(map, row, col);
      }
    }
  }

  return totalScore;
}

int calculateTrailheadScore(List<List<int>> map, int startRow, int startCol) {
  final result =
      _exploreTrail(map, startRow, startCol, 0, <String>{}, <String>{});
  return result.reachableNines.length;
}

({Set<String> visited, Set<String> reachableNines}) _exploreTrail(
  List<List<int>> map,
  int row,
  int col,
  int currentHeight,
  Set<String> visited,
  Set<String> reachableNines,
) {
  if (!_isValidPosition(map, row, col)) {
    return (visited: visited, reachableNines: reachableNines);
  }

  final pos = '$row,$col';
  if (visited.contains(pos) || map[row][col] != currentHeight) {
    return (visited: visited, reachableNines: reachableNines);
  }

  final newVisited = {...visited, pos};
  final newReachableNines = {...reachableNines};

  if (currentHeight == 9) {
    newReachableNines.add(pos);
    return (visited: newVisited, reachableNines: newReachableNines);
  }

  final directions = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1],
  ];

  var result = (visited: newVisited, reachableNines: newReachableNines);
  for (final dir in directions) {
    result = _exploreTrail(
      map,
      row + dir[0],
      col + dir[1],
      currentHeight + 1,
      result.visited,
      result.reachableNines,
    );
  }

  return result;
}

bool _isValidPosition(List<List<int>> map, int row, int col) {
  return row >= 0 && row < map.length && col >= 0 && col < map[0].length;
}
