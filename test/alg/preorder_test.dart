library graphlib.test.alg.preorder;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, preorder;

preorderTest() {
  group("alg preorder", () {
    test("returns the root for a singleton graph", () {
      var g = new Graph();
      g.setNode("a");
      expect(preorder(g, ["a"]), equals(["a"]));
    });

    test("visits each node in the graph once", () {
      var g = new Graph();
      g.setPath(["a", "b", "d", "e"]);
      g.setPath(["a", "c", "d", "e"]);

      var nodes = preorder(g, ["a"]);
      expect(nodes, unorderedEquals(["a", "b", "c", "d", "e"]));
    });

    test("works for a tree", () {
      var g = new Graph();
      g.setEdge("a", "b");
      g.setPath(["a", "c", "d"]);
      g.setEdge("c", "e");

      var nodes = preorder(g, ["a"]);
      expect(nodes, unorderedEquals(["a", "b", "c", "d", "e"]));
      expect(nodes.indexOf("b"), greaterThan(nodes.indexOf("a")));
      expect(nodes.indexOf("c"), greaterThan(nodes.indexOf("a")));
      expect(nodes.indexOf("d"), greaterThan(nodes.indexOf("c")));
      expect(nodes.indexOf("e"), greaterThan(nodes.indexOf("c")));
    });

    test("works for an array of roots", () {
      var g = new Graph();
      g.setEdge("a", "b");
      g.setEdge("c", "d");
      g.setNode("e");
      g.setNode("f");

      var nodes = preorder(g, ["a", "c", "e"]);
      expect(nodes, unorderedEquals(["a", "b", "c", "d", "e"]));
      expect(nodes.indexOf("b"), greaterThan(nodes.indexOf("a")));
      expect(nodes.indexOf("d"), greaterThan(nodes.indexOf("c")));
    });

    test("fails if root is not in the graph", () {
      var g = new Graph();
      g.setNode("a");
      expect(() => preorder(g, ["b"]), throws);
    });
  });
}
