library graphlib.test.layout.coordinate_system;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/coordinate_system.dart' as coordinateSystem;

coordinateSystemTest() {
  group("coordinateSystem", () {
    Graph g;

    setUp(() {
      g = new Graph();
    });

    group("coordinateSystem.adjust", () {
      setUp(() {
        g.setNode("a", { "width": 100, "height": 200 });
      });

      test("does nothing to node dimensions with rankdir = TB", () {
        g.setGraph({ "rankdir": "TB" });
        coordinateSystem.adjust(g);
        expect(g.node("a"), equals({ "width": 100, "height": 200 }));
      });

      test("does nothing to node dimensions with rankdir = BT", () {
        g.setGraph({ "rankdir": "BT" });
        coordinateSystem.adjust(g);
        expect(g.node("a"), equals({ "width": 100, "height": 200 }));
      });

      test("swaps width and height for nodes with rankdir = LR", () {
        g.setGraph({ "rankdir": "LR" });
        coordinateSystem.adjust(g);
        expect(g.node("a"), equals({ "width": 200, "height": 100 }));
      });

      test("swaps width and height for nodes with rankdir = RL", () {
        g.setGraph({ "rankdir": "RL" });
        coordinateSystem.adjust(g);
        expect(g.node("a"), equals({ "width": 200, "height": 100 }));
      });
    });

    group("coordinateSystem.undo", () {
      setUp(() {
        g.setNode("a", { "width": 100, "height": 200, "x": 20, "y": 40 });
      });

      test("does nothing to points with rankdir = TB", () {
        g.setGraph({ "rankdir": "TB" });
        coordinateSystem.undo(g);
        expect(g.node("a"), equals({ "x": 20, "y": 40, "width": 100, "height": 200 }));
      });

      test("flips the y coordinate for points with rankdir = BT", () {
        g.setGraph({ "rankdir": "BT" });
        coordinateSystem.undo(g);
        expect(g.node("a"), equals({ "x": 20, "y": -40, "width": 100, "height": 200 }));
      });

      test("swaps dimensions and coordinates for points with rankdir = LR", () {
        g.setGraph({ "rankdir": "LR" });
        coordinateSystem.undo(g);
        expect(g.node("a"), equals({ "x": 40, "y": 20, "width": 200, "height": 100 }));
      });

      test("swaps dims and coords and flips x for points with rankdir = RL", () {
        g.setGraph({ "rankdir": "RL" });
        coordinateSystem.undo(g);
        expect(g.node("a"), equals({ "x": -40, "y": 20, "width": 200, "height": 100 }));
      });
    });
  });
}

main() {
  coordinateSystemTest();
}
