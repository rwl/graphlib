library graphlib.test.alg.all_shortest_paths;

import "package:unittest/unittest.dart";
import "package:graphlib/graphlib.dart" show Graph, Path, Edge;
import "package:graphlib/src/alg/common.dart" show edgeFunc, weightFunc;

allShortestPathsTest(Map sp(Graph g, [weightFunc weightFn, edgeFunc edgeFn])) {
  group("allShortestPaths", () {
    test("returns 0 for the node itself", () {
      var g = new Graph();
      g.setNode("a");
      expect(sp(g), equals({ "a": { "a": new Path(distance: 0) }}));
    });

    test("returns the distance and path from all nodes to other nodes", () {
      var g = new Graph();
      g.setEdge("a", "b");
      g.setEdge("b", "c");
      expect(sp(g), equals({
        "a": {
          "a": new Path(distance: 0),
          "b": new Path(distance: 1, predecessor: "a"),
          "c": new Path(distance: 2, predecessor: "b")
        },
        "b": {
          "a": new Path(distance: double.INFINITY),
          "b": new Path(distance: 0),
          "c": new Path(distance: 1, predecessor: "b")
        },
        "c": {
          "a": new Path(distance: double.INFINITY),
          "b": new Path(distance: double.INFINITY),
          "c": new Path(distance: 0)
        }
      }));
    });

    test("uses an optionally supplied weight function", () {
      var g = new Graph();
      g.setEdge("a", "b", 2);
      g.setEdge("b", "c", 3);

      expect(sp(g, weightFn(g)), equals({
        "a": {
          "a": new Path(distance: 0),
          "b": new Path(distance: 2, predecessor: "a"),
          "c": new Path(distance: 5, predecessor: "b")
        },
        "b": {
          "a": new Path(distance: double.INFINITY),
          "b": new Path(distance: 0),
          "c": new Path(distance: 3, predecessor: "b")
        },
        "c": {
          "a": new Path(distance: double.INFINITY),
          "b": new Path(distance: double.INFINITY),
          "c": new Path(distance: 0)
        }
      }));
    });

    test("uses an optionally supplied incident function", () {
      var g = new Graph();
      g.setEdge("a", "b");
      g.setEdge("b", "c");

      expect(sp(g, null, (v) => g.inEdges(v).toList()), equals({
        "a": {
          "a": new Path(distance: 0),
          "b": new Path(distance: double.INFINITY),
          "c": new Path(distance: double.INFINITY)
        },
        "b": {
          "a": new Path(distance: 1, predecessor: "b"),
          "b": new Path(distance: 0),
          "c": new Path(distance: double.INFINITY)
        },
        "c": {
          "a": new Path(distance: 2, predecessor: "b"),
          "b": new Path(distance: 1, predecessor: "c"),
          "c": new Path(distance: 0)
        }
      }));
    });

    test("works with undirected graphs", () {
      final g = new Graph(directed: false);
      g.setEdge("a", "b", 1);
      g.setEdge("b", "c", 2);
      g.setEdge("c", "a", 4);
      g.setEdge("b", "d", 6);

      expect(sp(g, weightFn(g), (v) => g.nodeEdges(v)), equals({
        "a": {
          "a": new Path(distance: 0),
          "b": new Path(distance: 1, predecessor: "a"),
          "c": new Path(distance: 3, predecessor: "b"),
          "d": new Path(distance: 7, predecessor: "b"),
        },
        "b": {
          "a": new Path(distance: 1, predecessor: "b"),
          "b": new Path(distance: 0),
          "c": new Path(distance: 2, predecessor: "b"),
          "d": new Path(distance: 6, predecessor: "b"),
        },
        "c": {
          "a": new Path(distance: 3, predecessor: "b"),
          "b": new Path(distance: 2, predecessor: "c"),
          "c": new Path(distance: 0),
          "d": new Path(distance: 8, predecessor: "b"),
        },
        "d": {
          "a": new Path(distance: 7, predecessor: "b"),
          "b": new Path(distance: 6, predecessor: "d"),
          "c": new Path(distance: 8, predecessor: "b"),
          "d": new Path(distance: 0),
        }
      }));
    });
  });
}

weightFn(Graph g) {
  return (Edge e) => g.edgeObj(e);
}
