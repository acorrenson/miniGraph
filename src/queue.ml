type 'a queue = ('a list * 'a list) ref

let empty () =
  ref ([], [])

let is_empty (q : 'a queue) =
  match !q with
  | [], [] -> true
  | _ -> false

let push (q : 'a queue) (x : 'a) =
  let (out, inp) = !q in
  q := (out, x::inp)

let pop (q : 'a queue) =
  match !q with
  | [], [] -> invalid_arg "pop"
  | x::out, inp ->
    q := (out, inp); x
  | [], inp ->
    match List.rev inp with
    | x::out -> q := (out, []); x
    | _ -> assert false