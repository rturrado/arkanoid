module Color = struct
    type t = {
        red : int;
        green : int;
        blue : int;
        alpha : int;
    }

    let black : t = { red = 0; green = 0; blue = 0; alpha = 0; }
    let grey : t = { red = 200; green = 200; blue = 200; alpha = 0; }
    let yellow : t = { red = 0; green = 255; blue = 255; alpha = 0; }

    let red_1 : t = { red = 100; green = 0; blue = 0; alpha = 0; }
    let red_2 : t = { red = 125; green = 0; blue = 0; alpha = 0; }
    let red_3 : t = { red = 150; green = 0; blue = 0; alpha = 0; }

    let blue_1 : t = { red = 0; green = 0; blue = 100; alpha = 0; }
    let blue_2 : t = { red = 0; green = 0; blue = 125; alpha = 0; }
    let blue_3 : t = { red = 0; green = 0; blue = 150; alpha = 0; }
end
