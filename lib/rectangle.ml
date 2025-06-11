module Rectangle = struct
    type t = {
        x : float;
        y : float;
        width : float;
        height : float
    }

    let default : t = {
        x = 0.0;
        y = 0.0;
        width = 1.0;
        height = 1.0
    }

    let get_center (rectangle : t)
    : float * float =
        (
            rectangle.x +. rectangle.width /. 2.0,
            rectangle.y +. rectangle.height /. 2.0
        )
end
