library graphlib.test.alg.dijkstra;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, Edge, dijkstra, Path;

dijkstraTest() {
  group("dijkstra", () {
    test("assigns distance 0 for the source node", () {
      var g = new Graph();
      g.setNode("source");
      expect(dijkstra(g, "source"), equals({ "source": new Path(distance: 0) }));
    });

    test("returns double.INFINITY for unconnected nodes", () {
      var g = new Graph();
      g.setNode("a");
      g.setNode("b");
      expect(dijkstra(g, "a"), equals({
        "a": new Path(distance: 0),
        "b": new Path(distance: double.INFINITY)
      }));
    });

    test("returns the distance and path from the source node to other nodes", () {
      var g = new Graph();
      g.setPath(["a", "b", "c"]);
      g.setEdge("b", "d");
      expect(dijkstra(g, "a"), equals({
        "a": new Path(distance: 0),
        "b": new Path(distance: 1, predecessor: "a"),
        "c": new Path(distance: 2, predecessor: "b"),
        "d": new Path(distance: 2, predecessor: "b")
      }));
    });

    test("works for undirected graphs", () {
      var g = new Graph(directed: false);
      g.setPath(["a", "b", "c"]);
      g.setEdge("b", "d");
      expect(dijkstra(g, "a"), equals({
        "a": new Path(distance: 0),
        "b": new Path(distance: 1, predecessor: "a"),
        "c": new Path(distance: 2, predecessor: "b"),
        "d": new Path(distance: 2, predecessor: "b")
      }));
    });

    test("uses an optionally supplied weight function", () {
      var g = new Graph();
      g.setEdge("a", "b", 1);
      g.setEdge("a", "c", 2);
      g.setEdge("b", "d", 3);
      g.setEdge("c", "d", 3);

      expect(dijkstra(g, "a", weightFn(g)), equals({
        "a": new Path(distance: 0),
        "b": new Path(distance: 1, predecessor: "a"),
        "c": new Path(distance: 2, predecessor: "a"),
        "d": new Path(distance: 4, predecessor: "b")
      }));
    });

    test("uses an optionally supplied edge function", () {
      var g = new Graph();
      g.setPath(["a", "c", "d"]);
      g.setEdge("b", "c");

      expect(dijkstra(g, "d", null, (e) => g.inEdges(e)), {
        "a": new Path(distance: 2, predecessor: "c"),
        "b": new Path(distance: 2, predecessor: "c"),
        "c": new Path(distance: 1, predecessor: "d"),
        "d": new Path(distance: 0)
      });
    });

    test("throws an Error if it encounters a negative edge weight", () {
      var g = new Graph();
      g.setEdge("a", "b",  1);
      g.setEdge("a", "c", -2);
      g.setEdge("b", "d",  3);
      g.setEdge("c", "d",  3);

      expect(() { dijkstra(g, "a", weightFn(g)); }, throws);
    });
  });
}

weightFn(Graph g) {
  return (Edge e) => g.edgeObj(e);
}
