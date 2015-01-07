library graphlib.test.alg;

import "components_test.dart";
import "dijkstra_all.dart";
import "dijkstra_test.dart";
import "find_cycles_test.dart";
import "floyd_warshall_test.dart";
import "is_acylic_test.dart";
import "postorder_test.dart";
import "preorder_test.dart";
import "prim_test.dart";
import "tarjan_test.dart";
import "topsort_test.dart";

testAlgs() {
  componentsTest();
  dijkstraAllTest();
  dijkstraTest();
  findCyclesTest();
  floydWarshallTest();
  isAcylicTest();
  postorderTest();
  preorderTest();
  primTest();
  tarjanTest();
  topsortTest();
}

main() => testAlgs();
