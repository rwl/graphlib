library graphlib.test.alg.prim;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, Edge, prim;

primTest() {
  group("alg.prim", () {
    test("returns an empty graph for an empty input", () {
      var source = new Graph();

      var g = prim(source, weightFn(source));
      expect(g.nodeCount, equals(0));
      expect(g.edgeCount, equals(0));
    });

    test("returns a single node graph for a graph with a single node", () {
      var source = new Graph();
      source.setNode("a");

      var g = prim(source, weightFn(source));
      expect(g.nodes, equals(["a"]));
      expect(g.edgeCount, equals(0));
    });

    test("returns a deterministic result given an optimal solution", () {
      var source = new Graph();
      source.setEdge("a", "b",  1);
      source.setEdge("b", "c",  2);
      source.setEdge("b", "d",  3);
      // This edge should not be in the min spanning tree
      source.setEdge("c", "d", 20);
      // This edge should not be in the min spanning tree
      source.setEdge("c", "e", 60);
      source.setEdge("d", "e",  1);

      var g = prim(source, weightFn(source));
      expect(g.neighbors("a"), unorderedEquals(["b"]));
      expect(g.neighbors("b"), unorderedEquals(["a", "c", "d"]));
      expect(g.neighbors("c"), unorderedEquals(["b"]));
      expect(g.neighbors("d"), unorderedEquals(["b", "e"]));
      expect(g.neighbors("e"), unorderedEquals(["d"]));
    });

    test("throws an Error for unconnected graphs", () {
      var source = new Graph();
      source.setNode("a");
      source.setNode("b");

      expect(() { prim(source, weightFn(source)); }, throws);
    });
  });
}

weightFn(Graph g) {
  return (Edge edge) => g.edgeObj(edge);
}
