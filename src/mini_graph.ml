(** Type of graphs *)
type graph = int list array

let iter (f : int -> int list -> unit) (g : graph) =
  Array.iteri f g

let succ (g : graph) (x : int) =
  g.(x)

let mk_graph (n : int) =
  Array.init n (fun _ -> [])

let add_arc (g : graph) (x : int) (y : int) =
  if not (List.mem y g.(x)) then
    g.(x) <- y::g.(x)

let add_edge (g : graph) (x : int) (y : int) =
  add_arc g x y;
  add_arc g y x

let add_edges (g : graph) (edges : (int * int) list) =
  List.iter (fun (x, y) -> add_edge g x y) edges

let add_arcs (g : graph) (arcs : (int * int) list) =
  List.iter (fun (x, y) -> add_arc g x y) arcs

let vertices (g : graph) : int =
  Array.length g

let dfs (g : graph) (pre : int -> unit) (post : int -> unit) =
  let n = vertices g in
  let visited = Array.make n false in
  let rec visit x s =
    if not visited.(x) then begin
      visited.(x) <- true;
      pre x;
      List.iter (fun x -> visit x g.(x)) s;
      post x;
    end
  in
  Array.iteri visit g

let dfs_ordered g pre post order =
  let n = vertices g in
  let visited = Array.make n false in 
  let rec visit x =
    if not visited.(x) then begin
      visited.(x) <- true;
      pre x;
      List.iter visit g.(x);
      post x;
    end
  in
  List.iter visit order

let topo_sort (g : graph) =
  let order = ref [] in
  let post x = order := x::!order in
  let () = dfs g (fun _ -> ()) post in
  !order

exception Cycle

let has_cycle (g : graph) =
  let n = vertices g in
  let visited = Array.make n false in
  let in_cycle = Array.make n false in
  let rec visit x =
    if not visited.(x) then begin
      visited.(x) <- true;
      in_cycle.(x) <- true;
      List.iter visit g.(x);
      in_cycle.(x) <- false;
    end else if in_cycle.(x) then raise Cycle
  in
  try Array.iteri (fun i _ -> visit i) g; false
  with Cycle -> true

let transpose (g : graph) =
  let n = vertices g in
  let g' = Array.make n [] in
  let () = Array.iteri (fun x sons ->
      List.iter (fun y -> g'.(y) <- x::g'.(y)) sons
    ) g
  in g'

let kosaraju (g : graph) =
  let g' = transpose g in
  let order = topo_sort g in
  let (ccs, cc, c) = ref [], ref [], ref (-1) in
  let pre x =
    if !c = -1 then c := x;
    cc := x::!cc
  in
  let post x =
    if !c = x then begin
      c := -1;
      ccs := !cc::!ccs;
      cc := [];
    end
  in
  let () = dfs_ordered g' pre post order in
  !ccs

let bfs (g : graph) (s : int) (action : int -> unit) =
  let n = vertices g in
  let visited = Array.make n false in
  let q = Queue.empty () in
  let () = Queue.push q s in
  while not (Queue.is_empty q) do
    let x = Queue.pop q in
    if not visited.(x) then
      action x;
    List.iter (Queue.push q) g.(x)
  done

let dijkstra (g : graph) (s1 : int) (cost : (int * int) -> float) =
  let n = vertices g in
  let visited = Array.make n false in
  let distances = Array.make n max_float in
  let preds = Array.make n None in
  let q = Heap.mk_heap (fun (_, cx) (_, cy) -> cx <= cy) (0, 0.) in
  let () = Heap.add q (s1, 0.) in
  let () = distances.(s1) <- 0. in

  let visit_edge x y =
    let dxy = distances.(x) +. cost (x, y) in
    if distances.(y) > dxy then begin
      distances.(y) <- dxy;
      Heap.add q (y, dxy);
      preds.(y) <- Some x
    end
  in

  while not (Heap.is_empty q) do
    let (x, _) = Heap.get_min q in
    let () = Heap.remove_min q in
    if not visited.(x) then
      visited.(x) <- true;
    List.iter (visit_edge x) g.(x)
  done;

  (distances, preds)

module Clique = Set.Make(Int)
module CliqueSet = Set.Make (Clique)

let bron_kerbosch (g : graph) =
  let rec aux (r : Clique.t) (p : Clique.t) (x : Clique.t) =
    if Clique.(is_empty p && is_empty x) then
      CliqueSet.singleton r
    else
      let init = (CliqueSet.empty, p, x) in
      let (res, _, _) = Clique.fold (fun v (acc, p, x) ->
          let nbg = Clique.of_list g.(v) in
          let r' = Clique.add v r in
          let p' = Clique.inter nbg p in
          let x' = Clique.inter x nbg in
          let np = Clique.remove v p in
          let nx = Clique.add v x in
          let cliques = aux r' p' x' in
          CliqueSet.union cliques acc, np, nx
        ) p init
      in res
  in
  let n = Array.length g in
  let vtx = Clique.of_list (List.init n Fun.id) in
  aux Clique.empty vtx Clique.empty