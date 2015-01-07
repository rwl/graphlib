library graphlib.test.layout.charted;

import "dart:html" hide Selection;
import "package:unittest/unittest.dart";
import "package:graphlib/graphlib.dart" show Graph;
import "package:graphlib/charted.dart";
import "package:charted/charted.dart";

main() {
  group("charted", () {
    Selection svg;
    Graph g;

    setUp(() {
      svg = d3.select("body").append("svg");
      g = new Graph()
        ..setGraph({})
        ..defaultNodeLabelFn = ((v) => {})
        ..defaultEdgeLabelFn = (v, w, n) => {};
    });

    tearDown(() {
      svg.remove();
    });

    group("DOM elements", () {
      test("are created for each node", () {
        g.setNode("a", { "id": "a" });
        g.setNode("b", { "id": "b" });
        render(svg, g);

        expect(d3.select("#a").datum(), equals("a"));
        expect(d3.select("#b").datum(), equals("b"));

        // We should also be able to get to the element from the node object.
        expect(g.node("a").elem, equals(d3.select("#a").node()));
        expect(g.node("b").elem, equals(d3.select("#b").node()));
      });

      test("are created for each node label", () {
        g.setNode("a", { "labelId": "a-lab" });
        g.setNode("b", { "labelId": "b-lab" });
        render(svg, g);

        expect(d3.select("#a-lab").datum(), equals("a"));
        expect(d3.select("#b-lab").datum(), equals("b"));
      });

      test("are created for each edge", () {
        g.setNode("a", {});
        g.setNode("b", {});
        g.setEdge("a", "b", { "id": "ab" });
        render(svg, g);

        expect(d3.select("#ab").datum(), equals({ "v": "a", "w": "b" }));
      });

      test("are created for each edge label", () {
        g.setNode("a", {});
        g.setNode("b", {});
        g.setEdge("a", "b", { "labelId": "ab-lab" });
        render(svg, g);

        expect(d3.select("#ab-lab").datum(), equals({ "v": "a", "w": "b" }));
      });
    });

    test("uses node's width and height if specified", () {
      g.setNode("a", { "id": "a", "width": 1000, "height": 2000, "padding": 0 });
      render(svg, g);

      expect(d3.select("#a").node().getBBox().width, equals(1000));
      expect(d3.select("#a").node().getBBox().height, equals(2000));
    });

    test("does not grow node dimensions when re-rendering", () {
      g.setNode("a", { "id": "a" });
      render(svg, g);
      var bbox = svg.select("#a rect").node().getBBox();

      render(svg, g);
      var bbox2 = svg.select("#a rect").node().getBBox();

      expect(bbox.width, equals(bbox2.width));
      expect(bbox.height, equals(bbox2.height));
    });

    test("does not grow edge dimensions when re-rendering", () {
      g.setNode("a");
      g.setNode("b");
      g.setEdge("a", "b", { "labelId": "ab", "label": "foo" });
      render(svg, g);
      var bbox = svg.select("#ab").node().getBBox();

      render(svg, g);
      var bbox2 = svg.select("#ab").node().getBBox();

      expect(bbox.width, equals(bbox2.width));
      expect(bbox.height, equals(bbox2.height));
    });

    group("HTML labels", () {
      test("can be created for a node", () {
        g.setNode("a", { "labelType": "html", "label": "<p id='a-lab'>Hello</p>" });
        render(svg, g);

        expect(d3.select("#a-lab").empty(), isFalse);
        expect(d3.select("#a-lab").text(), equals("Hello"));
      });

      test("can use an existing DOM element", () {
        var elem = document.createElement("p");
        elem.setAttribute("id", "a-lab");
        elem.innerHTML = "Hello";

        g.setNode("a", { "id": "a", "labelType": "html", "label": elem });
        render(svg, g);

        expect(d3.select("#a #a-lab").empty(), isFalse);
        expect(d3.select("#a #a-lab").text(), equals("Hello"));
      });

      test("can use an function that returns a DOM element", () {
        var elem = document.createElement("p");
        elem.setAttribute("id", "a-lab");
        elem.innerHTML = "Hello";

        g.setNode("a", { "id": "a", "labelType": "html", "label": () => elem });
        render(svg, g);

        expect(d3.select("#a #a-lab").empty(), isFalse);
        expect(d3.select("#a #a-lab").text(), equals("Hello"));
      });

      test("can be created for an edge", () {
        g.setNode("a", {});
        g.setNode("b", {});
        g.setEdge("a", "b", { "labelType": "html", "label": "<p id='ab-lab'>Hello</p>" });
        render(svg, g);

        expect(d3.select("#ab-lab").empty(), isFalse);
        expect(d3.select("#ab-lab").text(), equals("Hello"));
      });
    });

    group("breaks label lines", () {
      test("on '\\n'", () {
        g.setNode("a", { "id": "a", "label": "multi\nline" });
        render(svg, g);

        var text = d3.select("#a text");
        expect(text.empty(), isFalse);
        expect(d3.select(text.selectAll("tspan")[0][0]).text(), equals("multi"));
        expect(d3.select(text.selectAll("tspan")[0][1]).text(), equals("line"));
      });

      test("on '\\\\n'", () {
        g.setNode("a", { "id": "a", "label": "multi\\nline" });
        render(svg, g);

        var text = d3.select("#a text");
        expect(text.empty(), isFalse);
        expect(d3.select(text.selectAll("tspan")[0][0]).text(), equals("multi"));
        expect(d3.select(text.selectAll("tspan")[0][1]).text(), equals("line"));
      });
    });

    group("styles", () {
      var canonicalRed;

      setUp(() {
        // Each browser has a different way to represent colors canonically. We
        // create a dummy object here to get the canonical representation for the
        // color red.
        canonicalRed = svg.append("rect").style("fill", "#ff0000").style("fill");
      });

      test("can be applied to a node", () {
        g.setNode("a", { "id": "a", "style": "fill: #ff0000", "shape": "rect" });
        render(svg, g);

        expect(d3.select("#a rect").style("fill"), equals(canonicalRed));
      });

      test("can be applied to a node label", () {
        g.setNode("a", { "labelId": "a-lab", "labelStyle": "stroke: #ff0000" });
        render(svg, g);

        expect(d3.select("#a-lab text").style("stroke"), equals(canonicalRed));
      });

      test("can be applied to an edge", () {
        g.setNode("a", {});
        g.setNode("b", {});
        g.setEdge("a", "b", { "id": "ab", "style": "stroke: #ff0000" });
        render(svg, g);

        expect(d3.select("#ab").style("stroke"), equals(canonicalRed));
      });

      test("can be applied to an edge label", () {
        g.setNode("a", {});
        g.setNode("b", {});
        g.setEdge("a", "b", { "labelId": "ab-lab", "labelStyle": "stroke: #ff0000" });
        render(svg, g);

        expect(d3.select("#ab-lab text").style("stroke"), equals(canonicalRed));
      });
    });

    group("shapes", () {
      test("include a rect", () {
        g.setNode("a", { "id": "a", "shape": "rect", "width": 100, "height": 200, "padding": 0 });
        render(svg, g);

        var rect = d3.select("#a rect");
        expect(rect.empty(), isFalse);
        expect(rect.node().getBBox().width, equals(100));
        expect(rect.node().getBBox().height, equals(200));
      });

      test("include a circle", () {
        g.setNode("a", { "id": "a", "shape": "circle", "width": 100, "height": 250, "padding": 0 });
        render(svg, g);

        var circle = d3.select("#a circle");
        expect(circle.empty(), isFalse);
        // Should be half of greater of width, height
        expect(circle.attr("r") * 2, equals(250));
      });

      test("include an ellipse", () {
        g.setNode("a", { "id": "a", "shape": "ellipse", "width": 100, "height": 250, "padding": 0 });
        render(svg, g);

        var ellipse = d3.select("#a ellipse");
        expect(ellipse.empty(), isFalse);
        expect(ellipse.attr("rx") * 2, equals(100));
        expect(ellipse.attr("ry") * 2, equals(250));
      });
    });

    group("class", () {
      test("can be set for nodes", () {
        g.setNode("a", { "id": "a", "class": (d) => "$d-class" });
        g.setNode("b", { "id": "b", "class": "b-class" });
        render(svg, g);

        expect(d3.select("#a").classed("a-class"), isTrue);
        expect(d3.select("#b").classed("b-class"), isTrue);
      });
    });
  });
}
