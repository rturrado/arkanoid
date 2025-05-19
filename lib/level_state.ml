open Ball
open Canvas
open Color
open Paddle
open Wall

module Level_state = struct
    type t = {
        ball : Ball.t;
        paddle : Paddle.t;
        wall : Wall.t;
    }

    let default : t =
        let ball_x = Canvas.window_width/2 - Ball.default.width in
        let ball_y = Canvas.window_height - Paddle.default.height - Canvas.margin_size in
        let ball : Ball.t = { Ball.default with x = ball_x; y = ball_y } in

        let paddle_x = Canvas.window_width/2 - Paddle.default.width/2 in
        let paddle_y = Canvas.window_height - Paddle.default.height - Canvas.margin_size in
        let paddle : Paddle.t = { Paddle.default with x = paddle_x; y = paddle_y } in

        let wall : Wall.t = [
            (* first row *)
            { rectangle = { x = 0 ; y = 60; width = 60; height = 20 }; color = Color.red_1 };
            { rectangle = { x = 60; y = 60; width = 60; height = 20 }; color = Color.red_1 };
            { rectangle = { x = 120; y = 60; width = 60; height = 20 }; color = Color.red_1 };
            { rectangle = { x = 180; y = 60; width = 60; height = 20 }; color = Color.red_3 };
            { rectangle = { x = 240; y = 60; width = 60; height = 20 }; color = Color.red_3 };
            { rectangle = { x = 300; y = 60; width = 60; height = 20 }; color = Color.red_2 };
            { rectangle = { x = 360; y = 60; width = 60; height = 20 }; color = Color.red_2 };
            { rectangle = { x = 420; y = 60; width = 60; height = 20 }; color = Color.red_2 };
            (* second row *)
            { rectangle = { x = 0 ; y = 100; width = 40; height = 20 }; color = Color.blue_1 };
            { rectangle = { x = 40; y = 100; width = 80; height = 20 }; color = Color.blue_1 };
            { rectangle = { x = 120; y = 100; width = 40; height = 20 }; color = Color.blue_3 };
            { rectangle = { x = 160; y = 100; width = 80; height = 20 }; color = Color.blue_3 };
            { rectangle = { x = 240; y = 100; width = 80; height = 20 }; color = Color.blue_3 };
            { rectangle = { x = 320; y = 100; width = 40; height = 20 }; color = Color.blue_3 };
            { rectangle = { x = 360; y = 100; width = 80; height = 20 }; color = Color.blue_2 };
            { rectangle = { x = 440; y = 100; width = 40; height = 20 }; color = Color.blue_2 }
        ] in
        { ball = ball; paddle = paddle; wall = wall }
end
