open Mini_graph
open Mini_graph__Heap

let g1 = mk_graph [(0, 1); (2, 1); (0, 2)]

let g2 = mk_graph [(1, 0); (2, 1); (0, 2)]

let t1 = mk_heap (<=) 0

let _ =
  add t1 3;
  add t1 1;
  add t1 2

let t2 = mk_heap (>=) 0

let _ =
  add t2 3;
  add t2 1;
  add t2 2

let t3 = mk_heap (<=) 0

let _ =
  add t3 1;
  add t3 2;
  add t3 3

let t4 = mk_heap (<=) 0

let _ =
  add t4 3;
  add t4 2;
  add t4 1;
  remove_min t4


let%test "cycle_g1" =
  has_cycle g1 = false

let%test "cycle_g2" =
  has_cycle g2 = true

let%test "min_t1" =
  get_min t1 = 1

let%test "min_t2" =
  get_min t2 = 3

let%test "min_t3" =
  get_min t3 = 1

let%test "min_t4" =
  get_min t4 = 2