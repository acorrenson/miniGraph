(**
  {1 Binary Heap module }
*)

(** The type heaps *)
type 'a heap

(**
  [mk_heap cmp def] creates a new heap with comparison function [cmp] and default values 
    [def]
*)
val mk_heap : ('a -> 'a -> bool) -> 'a -> 'a heap

(**
  Test whether a heap is empty or not
*)
val is_empty : 'a heap -> bool

(**
  Get the minimum value of a heap
*)
val get_min : 'a heap -> 'a

(**
  Add a value in the heap
*)
val add : 'a heap -> 'a -> unit

(**
  Remove the minimum value of a heap
*)
val remove_min : 'a heap -> unit
