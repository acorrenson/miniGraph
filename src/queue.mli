type 'a queue

val empty : unit -> 'a queue

val is_empty : 'a queue -> bool

val push : 'a queue -> 'a -> unit

val pop : 'a queue -> 'a
