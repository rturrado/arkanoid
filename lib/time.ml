open Maths

module Time = struct
    let error = 0.0001

    let equal (t1 : float) (t2 : float)
    : bool =
        Maths.float_equal t1 t2 error

    let less (t1 : float) (t2 : float)
    : bool =
        Maths.float_less t1 t2 error

    let less_equal (t1 : float) (t2 : float)
    : bool =
        Maths.float_less_equal t1 t2 error

    let greater (t1 : float) (t2 : float)
    : bool =
        Maths.float_greater t1 t2 error

    let greater_equal (t1 : float) (t2 : float)
    : bool =
        Maths.float_greater_equal t1 t2 error
end
