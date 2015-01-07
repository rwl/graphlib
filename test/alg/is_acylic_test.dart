library graphlib.test.alg.is_acylic;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, isAcyclic;

isAcylicTest() {
  group("isAcylic", () {
    test("returns true if the graph has no cycles", () {
      var g = new Graph();
      g.setPath(["a", "b", "c"]);
      expect(isAcyclic(g), isTrue);
    });

    test("returns false if the graph has at least one cycle", () {
      var g = new Graph();
      g.setPath(["a", "b", "c", "a"]);
      expect(isAcyclic(g), isFalse);
    });

    test("rethrows non-CycleException errors", () {
      expect(() { isAcyclic(null); }, throws);
    });
  });
}
