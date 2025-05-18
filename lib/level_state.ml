open Canvas

module LevelState = struct
    let x = Canvas.window_width/2 - Ball.default.w in
    let y = Canvas.window_height - Paddle.default.h - Canvas.margin_size in
    let ball : Ball.t = { }Ball.default with x = x; and y = y }

    let x = Canvas.window_width/2 - Paddle.default.w/2 in
    let y = Canvas.window_height - Paddle.default.h - Canvas.margin_size in
    let paddle : Paddle.t = { Paddle.default with x = x; y = y }

    let wall : Wall.t = [
        (* first row *)
        { rectangle = { x = 0 ; y = 60; w = 60; h = 20 }; color = Color.red_1 },
        { rectangle = { x = 60; y = 60; w = 60; h = 20 }; color = Color.red_1 },
        { rectangle = { x = 120; y = 60; w = 60; h = 20 }; color = Color.red_1 },
        { rectangle = { x = 180; y = 60; w = 60; h = 20 }; color = Color.red_3 },
        { rectangle = { x = 240; y = 60; w = 60; h = 20 }; color = Color.red_3 },
        { rectangle = { x = 300; y = 60; w = 60; h = 20 }; color = Color.red_2 },
        { rectangle = { x = 360; y = 60; w = 60; h = 20 }; color = Color.red_2 },
        { rectangle = { x = 420; y = 60; w = 60; h = 20 }; color = Color.red_2 },
        (* second row *)
        { rectangle = { x = 0 ; y = 100; w = 40; h = 20 }; color = Color.blue_1 },
        { rectangle = { x = 40; y = 100; w = 80; h = 20 }; color = Color.blue_1 },
        { rectangle = { x = 120; y = 100; w = 40; h = 20 }; color = Color.blue_3 },
        { rectangle = { x = 160; y = 100; w = 80; h = 20 }; color = Color.blue_3 },
        { rectangle = { x = 240; y = 100; w = 80; h = 20 }; color = Color.blue_3 },
        { rectangle = { x = 320; y = 100; w = 40; h = 20 }; color = Color.blue_3 },
        { rectangle = { x = 360; y = 100; w = 80; h = 20 }; color = Color.blue_2 },
        { rectangle = { x = 440; y = 100; w = 40; h = 20 }; color = Color.blue_2 },
    ]
end
