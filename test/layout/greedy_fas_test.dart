library graphlib.test.layout.greedy_fas;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, findCycles;
import 'package:graphlib/src/layout/greedy_fas.dart';

greedyFasTest() {
  group("greedyFAS", () {
    Graph g;

    setUp(() {
      g = new Graph();
    });

    test("returns the empty set for empty graphs", () {
      expect(greedyFAS(g), equals([]));
    });

    test("returns the empty set for single-node graphs", () {
      g.setNode("a");
      expect(greedyFAS(g), equals([]));
    });

    test("returns an empty set if the input graph is acyclic", () {
      var g = new Graph();
      g.setEdge("a", "b");
      g.setEdge("b", "c");
      g.setEdge("b", "d");
      g.setEdge("a", "e");
      expect(greedyFAS(g), equals([]));
    });

    test("returns a single edge with a simple cycle", () {
      var g = new Graph();
      g.setEdge("a", "b");
      g.setEdge("b", "a");
      checkFAS(g, greedyFAS(g));
    });

    test("returns a single edge in a 4-node cycle", () {
      var g = new Graph();
      g.setEdge("n1", "n2");
      g.setPath(["n2", "n3", "n4", "n5", "n2"]);
      g.setEdge("n3", "n5");
      g.setEdge("n4", "n2");
      g.setEdge("n4", "n6");
      checkFAS(g, greedyFAS(g));
    });

    test("returns two edges for two 4-node cycles", () {
      var g = new Graph();
      g.setEdge("n1", "n2");
      g.setPath(["n2", "n3", "n4", "n5", "n2"]);
      g.setEdge("n3", "n5");
      g.setEdge("n4", "n2");
      g.setEdge("n4", "n6");
      g.setPath(["n6", "n7", "n8", "n9", "n6"]);
      g.setEdge("n7", "n9");
      g.setEdge("n8", "n6");
      g.setEdge("n8", "n10");
      checkFAS(g, greedyFAS(g));
    });

    test("works with arbitrarily weighted edges", () {
      // Our algorithm should also work for graphs with multi-edges, a graph
      // where more than one edge can be pointing in the same direction between
      // the same pair of incident nodes. We try this by assigning weights to
      // our edges representing the number of edges from one node to the other.

      var g1 = new Graph();
      g1.setEdge("n1", "n2", 2);
      g1.setEdge("n2", "n1", 1);
      expect(greedyFAS(g1, weightFn(g1)), equals([{"v": "n2", "w": "n1"}]));

      var g2 = new Graph();
      g2.setEdge("n1", "n2", 1);
      g2.setEdge("n2", "n1", 2);
      expect(greedyFAS(g2, weightFn(g2)), equals([{"v": "n1", "": "n2"}]));
    });

    test("works for multigraphs", () {
      var g = new Graph(multigraph: true);
      g.setEdge("a", "b", 5, "foo");
      g.setEdge("b", "a", 2, "bar");
      g.setEdge("b", "a", 2, "baz");
      expect(greedyFAS(g, weightFn(g)), unorderedEquals([
        { "v": "b", "w": "a", "name": "bar" },
        { "v": "b", "w": "a", "name": "baz" }
      ]));
    });
  });
}

checkFAS(g, fas) {
  var n = g.nodeCount(),
      m = g.edgeCount();
  fas.forEach((edge) {
    g.removeEdge(edge.v, edge.w);
  });
  expect(findCycles(g), equals([]));
  // The more direct m/2 - n/6 fails for the simple cycle A <-> B, where one
  // edge must be reversed, but the performance bound implies that only 2/3rds
  // of an edge can be reversed. I'm using floors to acount for this.
  expect(fas.length, lessThan((m/2).floor() - (n/6).floor()));
}

weightFn(g) {
  return (e) => g.edge(e);
}

main() {
  greedyFasTest();
}
