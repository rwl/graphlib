library graphlib.test.layout.order.resolve_conflicts;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph;
import 'package:graphlib/src/layout/order/resolve_conflicts.dart' show resolveConflicts;

resolveConflictsTest() {
  group("order/resolveConflicts", () {
    Graph cg;

    setUp(() {
      cg = new Graph();
    });

    test("returns back nodes unchanged when no constraints exist", () {
      var input = [
        { "v": "a", "barycenter": 2, "weight": 3 },
        { "v": "b", "barycenter": 1, "weight": 2 }
      ];
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["a"], "i": 0, "barycenter": 2, "weight": 3 },
        { "vs": ["b"], "i": 1, "barycenter": 1, "weight": 2 }
      ]));
    });

    test("returns back nodes unchanged when no conflicts exist", () {
      var input = [
        { "v": "a", "barycenter": 2, "weight": 3 },
        { "v": "b", "barycenter": 1, "weight": 2 }
      ];
      cg.setEdge("b", "a");
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["a"], "i": 0, "barycenter": 2, "weight": 3 },
        { "vs": ["b"], "i": 1, "barycenter": 1, "weight": 2 }
      ]));
    });

    test("coalesces nodes when there is a conflict", () {
      var input = [
        { "v": "a", "barycenter": 2, "weight": 3 },
        { "v": "b", "barycenter": 1, "weight": 2 }
      ];
      cg.setEdge("a", "b");
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["a", "b"],
          "i": 0,
          "barycenter": (3 * 2 + 2 * 1) / (3 + 2),
          "weight": 3 + 2
        }
      ]));
    });

    test("coalesces nodes when there is a conflict #2", () {
      var input = [
        { "v": "a", "barycenter": 4, "weight": 1 },
        { "v": "b", "barycenter": 3, "weight": 1 },
        { "v": "c", "barycenter": 2, "weight": 1 },
        { "v": "d", "barycenter": 1, "weight": 1 }
      ];
      cg.setPath(["a", "b", "c", "d"]);
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["a", "b", "c", "d"],
          "i": 0,
          "barycenter": (4 + 3 + 2 + 1) / 4,
          "weight": 4
        }
      ]));
    });

    test("works with multiple constraints for the same target #1", () {
      var input = [
        { "v": "a", "barycenter": 4, "weight": 1 },
        { "v": "b", "barycenter": 3, "weight": 1 },
        { "v": "c", "barycenter": 2, "weight": 1 },
      ];
      cg.setEdge("a", "c");
      cg.setEdge("b", "c");
      var results = resolveConflicts(input, cg);
      expect(results, hasLength(equals(1)));
      expect(results[0].vs.indexOf("c"), greaterThan(results[0].vs.indexOf("a")));
      expect(results[0].vs.indexOf("c"), greaterThan(results[0].vs.indexOf("b")));
      expect(results[0].i, equals(0));
      expect(results[0].barycenter, equals((4 + 3 + 2) / 3));
      expect(results[0].weight, equals(3));
    });

    test("works with multiple constraints for the same target #2", () {
      var input = [
        { "v": "a", "barycenter": 4, "weight": 1 },
        { "v": "b", "barycenter": 3, "weight": 1 },
        { "v": "c", "barycenter": 2, "weight": 1 },
        { "v": "d", "barycenter": 1, "weight": 1 },
      ];
      cg.setEdge("a", "c");
      cg.setEdge("a", "d");
      cg.setEdge("b", "c");
      cg.setEdge("c", "d");
      var results = resolveConflicts(input, cg);
      expect(results, hasLength(equals(1)));
      expect(results[0].vs.indexOf("c"), greaterThan(results[0].vs.indexOf("a")));
      expect(results[0].vs.indexOf("c"), greaterThan(results[0].vs.indexOf("b")));
      expect(results[0].vs.indexOf("d"), greaterThan(results[0].vs.indexOf("c")));
      expect(results[0].i, equals(0));
      expect(results[0].barycenter, equals((4 + 3 + 2 + 1) / 4));
      expect(results[0].weight, equals(4));
    });

    test("does nothing to a node lacking both a barycenter and a constraint", () {
      var input = [
        { "v": "a" },
        { "v": "b", "barycenter": 1, "weight": 2 }
      ];
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["a"], "i": 0 },
        { "vs": ["b"], "i": 1, "barycenter": 1, "weight": 2 }
      ]));
    });

    test("treats a node w/o a barycenter as always violating constraints #1", () {
      var input = [
        { "v": "a" },
        { "v": "b", "barycenter": 1, "weight": 2 }
      ];
      cg.setEdge("a", "b");
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["a", "b"], "i": 0, "barycenter": 1, "weight": 2 }
      ]));
    });

    test("treats a node w/o a barycenter as always violating constraints #2", () {
      var input = [
        { "v": "a" },
        { "v": "b", "barycenter": 1, "weight": 2 }
      ];
      cg.setEdge("b", "a");
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["b", "a"], "i": 0, "barycenter": 1, "weight": 2 }
      ]));
    });

    test("ignores edges not related to entries", () {
      var input = [
        { "v": "a", "barycenter": 2, "weight": 3 },
        { "v": "b", "barycenter": 1, "weight": 2 }
      ];
      cg.setEdge("c", "d");
      expect(resolveConflicts(input, cg), unorderedEquals([
        { "vs": ["a"], "i": 0, "barycenter": 2, "weight": 3 },
        { "vs": ["b"], "i": 1, "barycenter": 1, "weight": 2 }
      ]));
    });
  });
}

main() {
  resolveConflictsTest();
}
