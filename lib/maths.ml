module Maths = struct
    let int_of_float (f : float)
    : int =
        Stdlib.int_of_float (Float.round f)

    let float_equal (f1 : float) (f2 : float) (epsilon : float)
    : bool =
        Float.abs (f1 -. f2) < epsilon

    let float_less (f1 : float) (f2 : float) (epsilon : float)
    : bool =
        f1 < f2 -. epsilon

    let float_less_equal (f1 : float) (f2 : float) (epsilon : float)
    : bool =
        float_less f1 f2 epsilon || float_equal f1 f2 epsilon

    let float_greater (f1 : float) (f2 : float) (epsilon : float)
    : bool =
        f1 > f2 +. epsilon

    let float_greater_equal (f1 : float) (f2 : float) (epsilon : float)
    : bool =
        float_greater f1 f2 epsilon || float_equal f1 f2 epsilon
end
