library graphlib.test.alg.dijkstra_all;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, Edge, dijkstraAll;
import "all_shortest_paths_test.dart";

dijkstraAllTest() {
  group("alg dijkstraAll", () {
    allShortestPathsTest(dijkstraAll);

    test("throws an Error if it encounters a negative edge weight", () {
      var g = new Graph();
      g.setEdge("a", "b",  1);
      g.setEdge("a", "c", -2);
      g.setEdge("b", "d",  3);
      g.setEdge("c", "d",  3);

      expect(() { dijkstraAll(g, weight(g)); }, throws);
    });
  });
}

weight(Graph g) {
  return (Edge e) => g.edgeObj(e);
}
