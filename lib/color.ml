module Color = struct
    type t = {
        red : int;
        green : int;
        blue : int;
        alpha : int
    }

    let black : t = { red = 0; green = 0; blue = 0; alpha = 0; }
    let black_1 : t = { red = 10; green = 10; blue = 10; alpha = 0; }
    let black_2 : t = { red = 20; green = 20; blue = 20; alpha = 0; }
    let black_3 : t = { red = 30; green = 30; blue = 30; alpha = 0; }

    let grey : t = { red = 200; green = 200; blue = 200; alpha = 0; }
    let grey_1 : t = { red = 205; green = 205; blue = 205; alpha = 0; }
    let grey_2 : t = { red = 210; green = 210; blue = 210; alpha = 0; }
    let grey_3 : t = { red = 215; green = 215; blue = 215; alpha = 0; }

    let white : t = { red = 255; green = 255; blue = 255; alpha = 0; }
    let white_1 : t = { red = 250; green = 250; blue = 250; alpha = 0; }
    let white_2 : t = { red = 245; green = 245; blue = 245; alpha = 0; }
    let white_3 : t = { red = 240; green = 240; blue = 240; alpha = 0; }

    let yellow : t = { red = 0; green = 200; blue = 200; alpha = 0; }

    let red : t = { red = 255; green = 0; blue = 0; alpha = 0; }
    let red_1 : t = { red = 150; green = 0; blue = 0; alpha = 0; }
    let red_2 : t = { red = 125; green = 0; blue = 0; alpha = 0; }
    let red_3 : t = { red = 100; green = 0; blue = 0; alpha = 0; }

    let blue : t = { red = 0; green = 0; blue = 255; alpha = 0; }
    let blue_1 : t = { red = 0; green = 0; blue = 150; alpha = 0; }
    let blue_2 : t = { red = 0; green = 0; blue = 125; alpha = 0; }
    let blue_3 : t = { red = 0; green = 0; blue = 100; alpha = 0; }
end
