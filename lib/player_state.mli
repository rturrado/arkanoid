module PlayerState = sig
    type t = {
        number_of_lives : int;
    }

    val default : t
end
