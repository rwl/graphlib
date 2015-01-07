library graphlib.test.alg.floyd_warshall;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, Edge, floydWarshall, Path;
import "all_shortest_paths_test.dart";

floydWarshallTest() {
  group("floydWarshall", () {
    allShortestPathsTest(floydWarshall);

    test("handles negative weights", () {
      var g = new Graph();
      g.setEdge("a", "b",  1);
      g.setEdge("a", "c", -2);
      g.setEdge("b", "d",  3);
      g.setEdge("c", "d",  3);

      expect(floydWarshall(g, weightFn(g)), equals({
        "a": {
          "a": new Path(distance:  0),
          "b": new Path(distance:  1, predecessor: "a"),
          "c": new Path(distance: -2, predecessor: "a"),
          "d": new Path(distance:  1, predecessor: "c")
        },
        "b": {
          "a": new Path(distance: double.INFINITY),
          "b": new Path(distance: 0),
          "c": new Path(distance: double.INFINITY),
          "d": new Path(distance: 3, predecessor: "b")
        },
        "c": {
          "a": new Path(distance: double.INFINITY),
          "b": new Path(distance: double.INFINITY),
          "c": new Path(distance: 0),
          "d": new Path(distance: 3, predecessor: "c")
        },
        "d": {
          "a": new Path(distance: double.INFINITY),
          "b": new Path(distance: double.INFINITY),
          "c": new Path(distance: double.INFINITY),
          "d": new Path(distance: 0)
        }
      }));
    });

    test("does include negative weight self edges", () {
      var g = new Graph();
      g.setEdge("a", "a", -1);

      // In the case of a negative cycle the distance is not well-defined beyond
      // having a negative value along the diagonal.
      expect(floydWarshall(g, weightFn(g)), equals({
        "a": {
          "a": new Path(distance: -2, predecessor: "a")
        }
      }));
    });
  });
}

weightFn(Graph g) {
  return (Edge edge) => g.edgeObj(edge);
}
