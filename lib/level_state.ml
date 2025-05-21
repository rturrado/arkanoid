open Ball
open Canvas
open Color
open Paddle
open Wall

let (>>=) = Result.bind

module Level_state = struct
    type t = {
        ball : Ball.t;
        paddle : Paddle.t;
        wall : Wall.t;
    }

    let default : t =
        let ball_x = Canvas.window_width/2 - Ball.default.width/2 in
        let ball_y = Canvas.window_height - Ball.default.height - Ball.default.height - Canvas.margin_size in
        let ball : Ball.t = { Ball.default with x = ball_x; y = ball_y } in

        let paddle_x = Canvas.window_width/2 - Paddle.default.rectangle.width/2 in
        let paddle_y = Canvas.window_height - Paddle.default.rectangle.height - Canvas.margin_size in
        let paddle_rectangle = { Paddle.default.rectangle with x = paddle_x; y = paddle_y } in
        let paddle : Paddle.t = { Paddle.default with rectangle = paddle_rectangle } in

        let wall : Wall.t = [
            (* first row *)
            { rectangle = { x = 0 ; y = 60; width = 80; height = 20 };
                fill_color = Color.red_1; border_color = Color.red };
            { rectangle = { x = 80; y = 60; width = 80; height = 20 };
                fill_color = Color.red_1; border_color = Color.red };
            { rectangle = { x = 160; y = 60; width = 80; height = 20 };
                fill_color = Color.red_1; border_color = Color.red };
            { rectangle = { x = 240; y = 60; width = 80; height = 20 };
                fill_color = Color.red_3; border_color = Color.red };
            { rectangle = { x = 320; y = 60; width = 80; height = 20 };
                fill_color = Color.red_3; border_color = Color.red };
            { rectangle = { x = 400; y = 60; width = 80; height = 20 };
                fill_color = Color.red_2; border_color = Color.red };
            { rectangle = { x = 480; y = 60; width = 80; height = 20 };
                fill_color = Color.red_2; border_color = Color.red };
            { rectangle = { x = 560; y = 60; width = 80; height = 20 };
                fill_color = Color.red_2; border_color = Color.red };
            (* second row *)
            { rectangle = { x = 0 ; y = 100; width = 60; height = 20 };
                fill_color = Color.blue_1; border_color = Color.blue };
            { rectangle = { x = 60; y = 100; width = 100; height = 20 };
                fill_color = Color.blue_1; border_color = Color.blue };
            { rectangle = { x = 160; y = 100; width = 60; height = 20 };
                fill_color = Color.blue_3; border_color = Color.blue };
            { rectangle = { x = 220; y = 100; width = 100; height = 20 };
                fill_color = Color.blue_3; border_color = Color.blue };
            { rectangle = { x = 320; y = 100; width = 100; height = 20 };
                fill_color = Color.blue_3; border_color = Color.blue };
            { rectangle = { x = 420; y = 100; width = 60; height = 20 };
                fill_color = Color.blue_3; border_color = Color.blue };
            { rectangle = { x = 480; y = 100; width = 100; height = 20 };
                fill_color = Color.blue_2; border_color = Color.blue };
            { rectangle = { x = 580; y = 100; width = 60; height = 20 };
                fill_color = Color.blue_2; border_color = Color.blue }
        ] in
        { ball = ball; paddle = paddle; wall = wall }

    let move_paddle level_state direction =
        { level_state with paddle = Paddle.move level_state.paddle direction }

    let paint sdl_renderer level_state =
        Ball.paint sdl_renderer level_state.ball >>= fun () ->
            Paddle.paint sdl_renderer level_state.paddle >>= fun () ->
                Wall.paint sdl_renderer level_state.wall
end
