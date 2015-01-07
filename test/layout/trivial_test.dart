library graphlib.test.layout.trivial;

import 'package:unittest/unittest.dart';
import 'package:graphlib/graphlib.dart' show Graph, layout;

main() {
  test("can do trivial layout", () {
    var g = new Graph().setGraph({});
    g.setNode("a", { "label": "a", "width": 50, "height": 100 });
    g.setNode("b", { "label": "b", "width": 50, "height": 100 });
    g.setEdge("a", "b", { "label": "ab", "width": 50, "height": 100 });

    layout(g);
    expect(g.node("a"), contains("x"));
    expect(g.node("a"), contains("y"));
    expect(g.node("a").x, greaterThanOrEqualTo(0));
    expect(g.node("a").y, greaterThanOrEqualTo(0));
    expect(g.edge("a", "b"), contains("x"));
    expect(g.edge("a", "b"), contains("y"));
    expect(g.edge("a", "b").x, greaterThanOrEqualTo(0));
    expect(g.edge("a", "b").y, greaterThanOrEqualTo(0));
  });
}
