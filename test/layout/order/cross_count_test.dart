library graphlib.test.layout.order.cross_count;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/order/cross_count.dart' show crossCount;

crossCountTest() {
  group("crossCount", () {
    Graph g;

    setUp(() {
      g = new Graph()
        ..defaultEdgeLabelFn = (v, w, n) => { "weight": 1 };
    });

    test("returns 0 for an empty layering", () {
      expect(crossCount(g, []), equals(0));
    });

    test("returns 0 for a layering with no crossings", () {
      g.setEdge("a1", "b1");
      g.setEdge("a2", "b2");
      expect(crossCount(g, [["a1", "a2"], ["b1", "b2"]]), equals(0));
    });

    test("returns 1 for a layering with 1 crossing", () {
      g.setEdge("a1", "b1");
      g.setEdge("a2", "b2");
      expect(crossCount(g, [["a1", "a2"], ["b2", "b1"]]), equals(1));
    });

    test("returns a weighted crossing count for a layering with 1 crossing", () {
      g.setEdge("a1", "b1", { "weight": 2 });
      g.setEdge("a2", "b2", { "weight": 3 });
      expect(crossCount(g, [["a1", "a2"], ["b2", "b1"]]), equals(6));
    });

    test("calculates crossings across layers", () {
      g.setPath(["a1", "b1", "c1"]);
      g.setPath(["a2", "b2", "c2"]);
      expect(crossCount(g, [["a1", "a2"], ["b2", "b1"], ["c1", "c2"]]), equals(2));
    });

    test("works for graph #1", () {
      g.setPath(["a", "b", "c"]);
      g.setPath(["d", "e", "c"]);
      g.setPath(["a", "f", "i"]);
      g.setEdge("a", "e");
      expect(crossCount(g, [["a", "d"], ["b", "e", "f"], ["c", "i"]]), equals(1));
      expect(crossCount(g, [["d", "a"], ["e", "b", "f"], ["c", "i"]]), equals(0));
    });
  });
}

main() {
  crossCountTest();
}
