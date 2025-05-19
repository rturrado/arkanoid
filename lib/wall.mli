open Brick

module Wall : sig
    type t = Brick.t list

    val default : Brick.t list

    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
