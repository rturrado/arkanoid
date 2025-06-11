module Font : sig
    type t = {
        path : string;
        size : int
    }

    val arcade_r : t
end
