library graphlib.layout.order.init_order;

import "../../graph.dart" show Graph;
import "../util.dart" show min, max, range;

/// Assigns an initial order value for each node by performing a DFS search
/// starting from nodes in the first rank. Nodes are assigned an order in their
/// rank as they are first visited.
///
/// This approach comes from Gansner, et al., "A Technique for Drawing Directed
/// Graphs."
///
/// Returns a layering matrix with an array per layer and each layer sorted by
/// the order of its nodes.
List<List> initOrder(Graph g) {
  var visited = {},
      simpleNodes = g.nodes.where((v) {
        return g.children(v).length == 0;
      }),
      maxRank = max(simpleNodes.map((v) => g.node(v)["rank"])),
      layers = range(maxRank + 1).map((_) => []);

  dfs(v) {
    if (visited.containsKey(v)) return;
    visited[v] = true;
    var node = g.node(v);
    layers[node["rank"]].add(v);
    g.successors(v).forEach(dfs);
  }

  var orderedVs = simpleNodes.sort((v) => g.node(v)["rank"]);
  orderedVs.forEach(dfs);

  return layers;
}
