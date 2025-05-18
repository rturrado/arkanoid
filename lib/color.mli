module Color : sig
    type color_t = {
        red : int;
        green : int;
        blue : int;
        alpha : int;
    }

    val black : color_t
    val grey : color_t
    val yellow : color_t
end
