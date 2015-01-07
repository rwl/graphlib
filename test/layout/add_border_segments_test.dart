library graphlib.test.layout.add_border_segments;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/add_border_segments.dart';

addBorderSegmentsTest() {
  group("addBorderSegments", () {
    Graph g;

    setUp(() {
      g = new Graph(compound: true);
    });

    test("does not add border nodes for a non-compound graph", () {
      var g = new Graph();
      g.setNode("a", { "rank": 0 });
      addBorderSegments(g);
      expect(g.nodeCount, equals(1));
      expect(g.node("a"), equals({ "rank": 0 }));
    });

    test("does not add border nodes for a graph with no clusters", () {
      g.setNode("a", { "rank": 0 });
      addBorderSegments(g);
      expect(g.nodeCount, equals(1));
      expect(g.node("a"), equals({ "rank": 0 }));
    });

    test("adds a border for a single-rank subgraph", () {
      g.setNode("sg", { "minRank": 1, "maxRank": 1 });
      addBorderSegments(g);

      var bl = g.node("sg").borderLeft[1],
          br = g.node("sg").borderRight[1];
      expect(g.node(bl), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(bl), equals("sg"));
      expect(g.node(br), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(br), equals("sg"));
    });

    test("adds a border for a multi-rank subgraph", () {
      g.setNode("sg", { "minRank": 1, "maxRank": 2 });
      addBorderSegments(g);

      var sgNode = g.node("sg");
      var bl2 = sgNode.borderLeft[1],
          br2 = sgNode.borderRight[1];
      expect(g.node(bl2), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(bl2), equals("sg"));
      expect(g.node(br2), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(br2), equals("sg"));

      var bl1 = sgNode.borderLeft[2],
          br1 = sgNode.borderRight[2];
      expect(g.node(bl1), equals({ "dummy": "border", "rank": 2, "width": 0, "height": 0 }));
      expect(g.parent(bl1), equals("sg"));
      expect(g.node(br1), equals({ "dummy": "border", "rank": 2, "width": 0, "height": 0 }));
      expect(g.parent(br1), equals("sg"));

      expect(g.hasEdge(sgNode.borderLeft[1], sgNode.borderLeft[2]), isTrue);
      expect(g.hasEdge(sgNode.borderRight[1], sgNode.borderRight[2]), isTrue);
    });

    test("adds borders for nested subgraphs", () {
      g.setNode("sg1", { "minRank": 1, "maxRank": 1 });
      g.setNode("sg2", { "minRank": 1, "maxRank": 1 });
      g.setParent("sg2", "sg1");
      addBorderSegments(g);

      var bl1 = g.node("sg1").borderLeft[1],
          br1 = g.node("sg1").borderRight[1];
      expect(g.node(bl1), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(bl1), equals("sg1"));
      expect(g.node(br1), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(br1), equals("sg1"));

      var bl2 = g.node("sg2").borderLeft[1],
          br2 = g.node("sg2").borderRight[1];
      expect(g.node(bl2), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(bl2), equals("sg2"));
      expect(g.node(br2), equals({ "dummy": "border", "rank": 1, "width": 0, "height": 0 }));
      expect(g.parent(br2), equals("sg2"));
    });
  });
}

main() {
  addBorderSegmentsTest();
}
