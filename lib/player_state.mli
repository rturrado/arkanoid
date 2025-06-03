module Player_state : sig
    type t = {
        number_of_lives : int
    }

    val default : t
end
