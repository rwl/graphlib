library graphlib.test.alg.tarjan;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, tarjan;

tarjanTest() {
  group("alg.tarjan", () {
    test("returns an empty array for an empty graph", () {
      expect(tarjan(new Graph()), equals([]));
    });

    test("returns singletons for nodes not in a strongly connected component", () {
      var g = new Graph();
      g.setPath(["a", "b", "c"]);
      g.setEdge("d", "c");
      expect(sort(tarjan(g)), equals([["a"], ["b"], ["c"], ["d"]]));
    });

    test("returns a single component for a cycle of 1 edge", () {
      var g = new Graph();
      g.setPath(["a", "b", "a"]);
      expect(sort(tarjan(g)), equals([["a", "b"]]));
    });

    test("returns a single component for a triangle", () {
      var g = new Graph();
      g.setPath(["a", "b", "c", "a"]);
      expect(sort(tarjan(g)), equals([["a", "b", "c"]]));
    });

    test("can find multiple components", () {
      var g = new Graph();
      g.setPath(["a", "b", "a"]);
      g.setPath(["c", "d", "e", "c"]);
      g.setNode("f");
      expect(sort(tarjan(g)), equals([["a", "b"], ["c", "d", "e"], ["f"]]));
    });
  });
}

// A helper that sorts components and their contents
sort(cmpts) {
  return cmpts.map((cmpt) => cmpt.sort()).sort((cmptsA, cmptsB) {
    return cmptsA[0].compareTo(cmptsB[0]);
  });
}
