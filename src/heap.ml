type 'a heap = {
  mutable data : 'a array;
  mutable size : int;
  mutable capacity : int;
  default : 'a;
  cmp : 'a -> 'a -> bool;
}

let mk_heap (cmp : 'a -> 'a -> bool) (default : 'a) : 'a heap =
  {
    data = Array.make 10 default;
    size = 0;
    capacity = 10;
    default = default;
    cmp = cmp;
  }

let is_empty (h : 'a heap) =
  h.size = 0

let incr_size (h : 'a heap) =
  h.size <- h.size + 1;
  if h.size >= h.capacity then begin
    h.capacity <- 2 * h.capacity;
    h.data <- Array.init h.capacity (fun i -> if i < h.size - 1 then h.data.(i) else h.default)
  end

let decr_size (h : 'a heap) =
  h.size <- h.size - 1

let get_min h =
  if h.capacity = 0 then invalid_arg "get_min"
  else h.data.(0)

let rec move_up h x i =
  if i = 0 then
    h.data.(0) <- x
  else
    let fi = (i - 1) / 2 in
    let y = h.data.(fi) in
    if not (h.cmp y x) then begin
      h.data.(i) <- y;
      move_up h x fi
    end else h.data.(i) <- x

let add h x =
  incr_size h;
  move_up h x (h.size - 1)

let min h l r =
  if h.cmp h.data.(r) h.data.(l) then r else l

let smallest_node h x i =
  let l = 2 * i + 1 in
  let n = h.size in
  if l >= n then i
  else
    let r = l + 1 in
    let j = if r < n then min h l r else l in
    if h.cmp h.data.(j) x then j else i


let rec move_down h x i =
  let j = smallest_node h x i in
  if j = i then
    h.data.(i) <- x
  else begin
    h.data.(i) <- h.data.(j);
    move_down h x j
  end

let remove_min h =
  let n = h.size - 1 in
  if n < 0 then invalid_arg "remove_min";
  decr_size h;
  move_down h h.data.(n) 0
