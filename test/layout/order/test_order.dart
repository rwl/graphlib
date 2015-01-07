library graphlib.test.layout.order;

import "add_subgraph_constraints_test.dart";
import "barycenter_test.dart";
import "cross_count_test.dart";
import "init_order_test.dart";
import "order_test.dart";
import "resolve_conflicts_test.dart";
import "sort_subgraph_test.dart";
import "sort_test.dart";

testOrder() {
  addSubgraphConstraintsTest();
  barycenterTest();
  crossCountTest();
  initOrderTest();
  //orderTest();
  resolveConflictsTest();
  //sortSubgraphTest();
  //sortTest();
}

main() => testOrder();
