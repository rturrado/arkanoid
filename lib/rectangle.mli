module Rectangle : sig
    type t = {
        x : float;
        y : float;
        width : float;
        height : float
    }

    val default : t

    val get_center : t -> float * float
end
