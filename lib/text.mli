open Color
open Font
open Rectangle

module Text : sig
    val init : unit -> (unit, string) result
    val quit : unit -> unit
    val paint : Tsdl.Sdl.renderer -> string -> Font.t -> Color.t -> Rectangle.t -> (unit, string) result
end
