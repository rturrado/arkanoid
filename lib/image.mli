module Image : sig
    type t = {
        path : string;
        width : float;
        height : float
    }

    val init : unit -> (unit, string) result
    val quit : unit -> unit
    val load : string -> (Tsdl.Sdl.surface, string) result
end
