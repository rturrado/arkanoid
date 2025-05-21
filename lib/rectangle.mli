open Color

module Rectangle : sig
    type t = {
        x : int;
        y : int;
        width : int;
        height : int;
    }

    val paint : Tsdl.Sdl.renderer -> t -> Color.t -> (unit, string) result

    val paint_border : Tsdl.Sdl.renderer -> t -> Color.t -> (unit, string) result
end
