library graphlib.test.alg.find_cycles;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, findCycles;

findCyclesTest() {
  group("findCycles", () {
    test("returns an empty array for an empty graph", () {
      expect(findCycles(new Graph()), equals([]));
    });

    test("returns an empty array if the graph has no cycles", () {
      var g = new Graph();
      g.setPath(["a", "b", "c"]);
      expect(findCycles(g), equals([]));
    });

    test("returns a single entry for a cycle of 1 edge", () {
      var g = new Graph();
      g.setPath(["a", "b", "a"]);
      expect(sort(findCycles(g)), equals([["a", "b"]]));
    });

    test("returns a single entry for a triangle", () {
      var g = new Graph();
      g.setPath(["a", "b", "c", "a"]);
      expect(sort(findCycles(g)), equals([["a", "b", "c"]]));
    });

    test("returns multiple entries for multiple cycles", () {
      var g = new Graph();
      g.setPath(["a", "b", "a"]);
      g.setPath(["c", "d", "e", "c"]);
      g.setNode("f");
      expect(sort(findCycles(g)), equals([["a", "b"], ["c", "d", "e"]]));
    });
  });
}

// A helper that sorts components and their contents.
sort(cmpts) {
  return cmpts.map((cmpt) => cmpt.sort()).sort((cmptsA, cmptsB) {
    return cmptsA[0].compareTo(cmptsB[0]);
  });
}
