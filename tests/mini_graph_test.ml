open Mini_graph

let g1 = mk_graph [(0, 1); (2, 1); (0, 2)]

let g2 = mk_graph [(1, 0); (2, 1); (0, 2)]


let%test "cycle_g1" =
  has_cycle g1 = false

let%test "cycle_g2" =
  has_cycle g2 = true

