module Font : sig
    type t = {
        path : string;
        size : int
    }

    val arcade_r_20 : t

    val open_font : t -> (Tsdl_ttf.Ttf.font, string) result
    val close_font : Tsdl_ttf.Ttf.font -> unit
    val with_font : Tsdl_ttf.Ttf.font -> (Tsdl_ttf.Ttf.font -> ('a, string) result) -> ('a, string) result
end
