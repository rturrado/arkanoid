open Image

module Intro : sig
    val intro_640_480 : Image.t

    val paint : Tsdl.Sdl.renderer -> (unit, string) result
end
