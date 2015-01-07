library graphlib.test.layout.position;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/position/position.dart';

positionTest() {
  group("position", () {
    Graph g;

    setUp(() {
      g = new Graph(compound: true)
        ..setGraph({
          "ranksep": 50,
          "nodesep": 50,
          "edgesep": 10
        });
    });

    test("respects ranksep", () {
      g.graph().ranksep = 1000;
      g.setNode("a", { "width": 50, "height": 100, "rank": 0, "order": 0 });
      g.setNode("b", { "width": 50, "height":  80, "rank": 1, "order": 0 });
      g.setEdge("a", "b");
      position(g);
      expect(g.node("b").y, equals(100 + 1000 + 80 / 2));
    });

    test("use the largest height in each rank with ranksep", () {
      g.graph().ranksep = 1000;
      g.setNode("a", { "width": 50, "height": 100, "rank": 0, "order": 0 });
      g.setNode("b", { "width": 50, "height":  80, "rank": 0, "order": 1 });
      g.setNode("c", { "width": 50, "height":  90, "rank": 1, "order": 0 });
      g.setEdge("a", "c");
      position(g);
      expect(g.node("a").y, equals(100 / 2));
      expect(g.node("b").y, equals(100 / 2)); // Note we used 100 and not 80 here
      expect(g.node("c").y, equals(100 + 1000 + 90 / 2));
    });

    test("respects nodesep", () {
      g.graph().nodesep = 1000;
      g.setNode("a", { "width": 50, "height": 100, "rank": 0, "order": 0 });
      g.setNode("b", { "width": 70, "height":  80, "rank": 0, "order": 1 });
      position(g);
      expect(g.node("b").x, equals(g.node("a").x + 50 / 2 + 1000 + 70 / 2));
    });

    test("should not try to position the subgraph node itself", () {
      g.setNode("a", { "width": 50, "height": 50, "rank": 0, "order": 0 });
      g.setNode("sg1", {});
      g.setParent("a", "sg1");
      position(g);
      expect(g.node("sg1"), isNot(anyElement(equals("x"))));
      expect(g.node("sg1"), isNot(anyElement(equals("y"))));
    });
  });
}

main() {
  positionTest();
}
