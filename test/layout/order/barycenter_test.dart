library graphlib.test.layout.order.barycenter;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/order/barycenter.dart' show barycenter;

barycenterTest() {
  group("order/barycenter", () {
    Graph g;

    setUp(() {
      g = new Graph()
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = (v, w, n) => { "weight": 1 };
    });

    test("assigns an undefined barycenter for a node with no predecessors", () {
      g.setNode("x", {});

      var results = barycenter(g, ["x"]);
      expect(results, hasLength(equals(1)));
      expect(results[0], equals({ "v": "x" }));
    });

    test("assigns the position of the sole predecessors", () {
      g.setNode("a", { "order": 2 });
      g.setEdge("a", "x");

      var results = barycenter(g, ["x"]);
      expect(results, hasLength(equals(1)));
      expect(results[0], equals({ "v": "x", "barycenter": 2, "weight": 1 }));
    });

    test("assigns the average of multiple predecessors", () {
      g.setNode("a", { "order": 2 });
      g.setNode("b", { "order": 4 });
      g.setEdge("a", "x");
      g.setEdge("b", "x");

      var results = barycenter(g, ["x"]);
      expect(results, hasLength(equals(1)));
      expect(results[0], equals({ "v": "x", "barycenter": 3, "weight": 2 }));
    });

    test("takes into account the weight of edges", () {
      g.setNode("a", { "order": 2 });
      g.setNode("b", { "order": 4 });
      g.setEdge("a", "x", { "weight": 3 });
      g.setEdge("b", "x");

      var results = barycenter(g, ["x"]);
      expect(results, hasLength(equals(1)));
      expect(results[0], equals({ "v": "x", "barycenter": 2.5, "weight": 4 }));
    });

    test("calculates barycenters for all nodes in the movable layer", () {
      g.setNode("a", { "order": 1 });
      g.setNode("b", { "order": 2 });
      g.setNode("c", { "order": 4 });
      g.setEdge("a", "x");
      g.setEdge("b", "x");
      g.setNode("y");
      g.setEdge("a", "z", { "weight": 2 });
      g.setEdge("c", "z");

      var results = barycenter(g, ["x", "y", "z"]);
      expect(results, hasLength(equals(3)));
      expect(results[0], equals({ "v": "x", "barycenter": 1.5, "weight": 2 }));
      expect(results[1], equals({ "v": "y" }));
      expect(results[2], equals({ "v": "z", "barycenter": 2, "weight": 3 }));
    });
  });
}

main() {
  barycenterTest();
}
