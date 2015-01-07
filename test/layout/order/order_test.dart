library graphlib.test.layout.order;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/order/order.dart' show order;
import 'package:graphlib/src/layout/order/cross_count.dart' show crossCount;
import 'package:graphlib/src/layout/util.dart' as util;

orderTest() {
  group("order", () {
    Graph g;

    setUp(() {
      g = new Graph()
        ..defaultEdgeLabelFn = (v, w, n) => { "weight": 1 };
    });

    test("does not add crossings to a tree structure", () {
      g.setNode("a", { "rank": 1 });
      ["b", "e"].forEach((v) {
        g.setNode(v, { "rank": 2 });
      });
      ["c", "d", "f"].forEach((v) {
        g.setNode(v, { "rank": 3 });
      });
      g.setPath(["a", "b", "c"]);
      g.setEdge("b", "d");
      g.setPath(["a", "e", "f"]);
      order(g);
      var layering = util.buildLayerMatrix(g);
      expect(crossCount(g, layering), equals(0));
    });

    test("can solve a simple graph", () {
      // This graph resulted in a single crossing for previous versions of dagre.
      ["a", "d"].forEach((v) {
        g.setNode(v, { "rank": 1 });
      });
      ["b", "f", "e"].forEach((v) {
        g.setNode(v, { "rank": 2 });
      });
      ["c", "g"].forEach((v) {
        g.setNode(v, { "rank": 3 });
      });
      order(g);
      var layering = util.buildLayerMatrix(g);
      expect(crossCount(g, layering), equals(0));
    });

    test("can minimize crossings", () {
      g.setNode("a", { "rank": 1 });
      ["b", "e", "g"].forEach((v) {
        g.setNode(v, { "rank": 2 });
      });
      ["c", "f", "h"].forEach((v) {
        g.setNode(v, { "rank": 3 });
      });
      g.setNode("d", { "rank": 4 });
      order(g);
      var layering = util.buildLayerMatrix(g);
      expect(crossCount(g, layering), lessThanOrEqualTo(1));
    });
  });
}

main() {
  orderTest();
}
