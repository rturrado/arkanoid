module Color = struct
    type color_t = {
        red : int;
        green : int;
        blue : int;
        alpha : int;
    }

    let black : color_t = { red = 0; green = 0; blue = 0; alpha = 255; }
    let grey : color_t = { red = 200; green = 200; blue = 200; alpha = 255; }
end
