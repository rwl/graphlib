library graphlib.test.layout.order.init_order;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/order/init_order.dart' show initOrder;

initOrderTest() {
  group("order/initOrder", () {
    Graph g;

    setUp(() {
      g = new Graph(compound: true)
        ..defaultEdgeLabelFn = (v, w, n) => { "weight": 1 };
    });

    test("assigns non-overlapping orders for each rank in a tree", () {
      ({ "a": 0, "b": 1, "c": 2, "d": 2, "e": 1 }).forEach((v, rank) {
        g.setNode(v, { "rank": rank });
      });
      g.setPath(["a", "b", "c"]);
      g.setEdge("b", "d");
      g.setEdge("a", "e");

      var layering = initOrder(g);
      expect(layering[0], equals(["a"]));
      expect(layering[1], unorderedEquals(["b", "e"]));
      expect(layering[2], unorderedEquals(["c", "d"]));
    });

    test("assigns non-overlapping orders for each rank in a DAG", () {
      ({ "a": 0, "b": 1, "c": 1, "d": 2 }).forEach((v, rank) {
        g.setNode(v, { "rank": rank });
      });
      g.setPath(["a", "b", "d"]);
      g.setPath(["a", "c", "d"]);

      var layering = initOrder(g);
      expect(layering[0], equals(["a"]));
      expect(layering[1], equals(["b", "c"]));
      expect(layering[2], equals(["d"]));
    });

    test("does not assign an order to subgraph nodes", () {
      g.setNode("a", { "rank": 0 });
      g.setNode("sg1", {});
      g.setParent("a", "sg1");

      var layering = initOrder(g);
      expect(layering, equals([["a"]]));
    });
  });
}

main() {
  initOrderTest();
}
