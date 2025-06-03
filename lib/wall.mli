open Brick

module Wall : sig
    module BrickMap : Map.S with type key = Brick.id

    type t = Brick.t BrickMap.t

    val default : t

    val map_of_list : Brick.t list -> t
    val list_of_map : t -> Brick.t list
    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
