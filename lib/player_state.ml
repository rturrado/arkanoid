module PlayerState = struct
    type t = {
        number_of_lives : int;
    }

    let default : t = { number_of_lives = 3 }
end
