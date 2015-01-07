library graphlib.test.alg.components;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, components;
import "package:graphlib/src/layout/util.dart" show min;

componentsTest() {
  group("components", () {
    test("returns an empty list for an empty graph", () {
      expect(components(new Graph(directed: false)), isEmpty);
    });

    test("returns singleton lists for unconnected nodes", () {
      var g = new Graph(directed: false);
      g.setNode("a");
      g.setNode("b");

      var result = components(g)..sort((arr1, arr2) {
        return min(arr1).compareTo(min(arr2));
      });
      expect(result, equals([["a"], ["b"]]));
    });

    test("returns a list of nodes in a component", () {
      var g = new Graph(directed: false);
      g.setEdge("a", "b");
      g.setEdge("b", "c");

      var result = components(g).map((xs) => xs..sort());
      expect(result, equals([["a", "b", "c"]]));
    });

    test("returns nodes connected by a neighbor relationship in a digraph", () {
      var g = new Graph();
      g.setPath(["a", "b", "c", "a"]);
      g.setEdge("d", "c");
      g.setEdge("e", "f");

      var result = components(g).map((xs) => xs..sort()).toList()..sort((a, b) {
        return a[0].compareTo(b[0]);
      });
      expect(result, equals([["a", "b", "c", "d"], ["e", "f"]]));
    });
  });
}
