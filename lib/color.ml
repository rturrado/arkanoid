module Color = struct
    type color_t = {
        red : int;
        green : int;
        blue : int;
        alpha : int;
    }

    let black : color_t = { red = 0; green = 0; blue = 0; alpha = 0; }
    let grey : color_t = { red = 200; green = 200; blue = 200; alpha = 0; }
    let yellow : color_t = { red = 0; green = 255; blue = 255; alpha = 0; }

    let red_1 : color_t = { red = 100; green = 0; blue = 0; alpha = 0; }
    let red_2 : color_t = { red = 125; green = 0; blue = 0; alpha = 0; }
    let red_3 : color_t = { red = 150; green = 0; blue = 0; alpha = 0; }

    let blue_1 : color_t = { red = 0; green = 0; blue = 100; alpha = 0; }
    let blue_2 : color_t = { red = 0; green = 0; blue = 125; alpha = 0; }
    let blue_3 : color_t = { red = 0; green = 0; blue = 150; alpha = 0; }
end
