type 'a heap

val mk_heap : ('a -> 'a -> bool) -> 'a -> 'a heap

val get_min : 'a heap -> 'a

val add : 'a heap -> 'a -> unit

val remove_min : 'a heap -> unit
