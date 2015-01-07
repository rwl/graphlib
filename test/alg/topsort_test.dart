library graphlib.test.alg.topsort;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, topsort, CycleException;

topsortTest() {
  group("alg.topsort", () {
    test("returns an empty array for an empty graph", () {
      expect(topsort(new Graph()), isEmpty);
    });

    test("sorts nodes such that earlier nodes have directed edges to later nodes", () {
      var g = new Graph();
      g.setPath(["b", "c", "a"]);
      expect(topsort(g), equals(["b", "c", "a"]));
    });

    test("works for a diamond", () {
      var g = new Graph();
      g.setPath(["a", "b", "d"]);
      g.setPath(["a", "c", "d"]);

      var result = topsort(g);
      expect(result.indexOf("a"), equals(0));
      expect(result.indexOf("b"), lessThan(result.indexOf("d")));
      expect(result.indexOf("c"), lessThan(result.indexOf("d")));
      expect(result.indexOf("d"), equals(3));
    });

    test("throws CycleException if there is a cycle #1", () {
      var g = new Graph();
      g.setPath(["b", "c", "a", "b"]);
      expect(() { topsort(g); }, throwsA(new isInstanceOf<CycleException>()));
    });

    test("throws CycleException if there is a cycle #2", () {
      var g = new Graph();
      g.setPath(["b", "c", "a", "b"]);
      g.setEdge("b", "d");
      expect(() { topsort(g); }, throwsA(new isInstanceOf<CycleException>()));
    });

    test("throws CycleException if there is a cycle #3", () {
      var g = new Graph();
      g.setPath(["b", "c", "a", "b"]);
      g.setNode("d");
      expect(() { topsort(g); }, throwsA(new isInstanceOf<CycleException>()));
    });
  });
}
