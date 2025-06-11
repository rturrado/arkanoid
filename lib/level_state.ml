open Ball
open Brick
open Canvas
open Color
open Paddle
open Tsdl
open Wall

let (>>=) = Result.bind

module Level_state = struct
    type t = {
        ball : Ball.t;
        paddle : Paddle.t;
        wall : Wall.t
    }

    let default : t =
        let ball_x = Canvas.window_width /. 2.0 -. Ball.default.rectangle.width /. 2.0 in
        let ball_y = Canvas.window_height -. Canvas.margin_size -. Paddle.default.rectangle.height -. Ball.default.rectangle.height in
        let ball_rectangle = { Ball.default.rectangle with x = ball_x; y = ball_y } in
        let ball : Ball.t = { Ball.default with rectangle = ball_rectangle } in

        let paddle_x = Canvas.window_width /. 2.0 -. Paddle.default.rectangle.width /. 2.0 in
        let paddle_y = Canvas.window_height -. Canvas.margin_size -. Paddle.default.rectangle.height in
        let paddle_rectangle = { Paddle.default.rectangle with x = paddle_x; y = paddle_y } in
        let paddle : Paddle.t = { Paddle.default with rectangle = paddle_rectangle } in

        let wall : Wall.t =
            let brick_list : Brick.t list = [
                (* first row *)
                { id = 0; rectangle = { x = 0.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_1; border_color = Color.red; hardness = 1 };
                { id = 1; rectangle = { x = 80.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_1; border_color = Color.red; hardness = 1 };
                { id = 2; rectangle = { x = 160.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_1; border_color = Color.red; hardness = 1 };
                { id = 3; rectangle = { x = 240.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_3; border_color = Color.red; hardness = 3 };
                { id = 4; rectangle = { x = 320.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_3; border_color = Color.red; hardness = 3 };
                { id = 5; rectangle = { x = 400.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_2; border_color = Color.red; hardness = 2 };
                { id = 6; rectangle = { x = 480.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_2; border_color = Color.red; hardness = 2 };
                { id = 7; rectangle = { x = 560.0; y = 60.0; width = 80.0; height = 20.0 };
                    fill_color = Color.red_2; border_color = Color.red; hardness = 2 };
                (* second row *)
                { id = 8; rectangle = { x = 0.0; y = 100.0; width = 60.0; height = 20.0 };
                    fill_color = Color.blue_1; border_color = Color.blue; hardness = 1 };
                { id = 9; rectangle = { x = 60.0; y = 100.0; width = 100.0; height = 20.0 };
                    fill_color = Color.blue_1; border_color = Color.blue; hardness = 1 };
                { id = 10; rectangle = { x = 160.0; y = 100.0; width = 60.0; height = 20.0 };
                    fill_color = Color.blue_3; border_color = Color.blue; hardness = 3 };
                { id = 11; rectangle = { x = 220.0; y = 100.0; width = 100.0; height = 20.0 };
                    fill_color = Color.blue_3; border_color = Color.blue; hardness = 3 };
                { id = 12; rectangle = { x = 320.0; y = 100.0; width = 100.0; height = 20.0 };
                    fill_color = Color.blue_3; border_color = Color.blue; hardness = 3 };
                { id = 13; rectangle = { x = 420.0; y = 100.0; width = 60.0; height = 20.0 };
                    fill_color = Color.blue_3; border_color = Color.blue; hardness = 3 };
                { id = 14; rectangle = { x = 480.0; y = 100.0; width = 100.0; height = 20.0 };
                    fill_color = Color.blue_2; border_color = Color.blue; hardness = 2 };
                { id = 15; rectangle = { x = 580.0; y = 100.0; width = 60.0; height = 20.0 };
                    fill_color = Color.blue_2; border_color = Color.blue; hardness = 2 }
            ] in
            Wall.map_of_list brick_list
        in
        { ball = ball; paddle = paddle; wall = wall }

    let move_paddle (level_state : t) (direction : Paddle.direction_t)
    : t =
        { level_state with paddle = Paddle.move level_state.paddle direction }

    let hit_brick (level_state : t) (brick_id : Brick.id)
    : t =
        match Wall.BrickMap.find_opt brick_id level_state.wall with
        | Some brick ->
            let updated_brick = { brick with hardness = brick.hardness - 1 } in
            if updated_brick.hardness = 0 then
                { level_state with wall = Wall.BrickMap.remove brick_id level_state.wall }
            else
                { level_state with wall = Wall.BrickMap.add brick_id updated_brick level_state.wall }
        | None -> level_state

    let is_finished (level_state : t)
    : bool =
        Wall.is_empty level_state.wall

    let paint (sdl_renderer : Sdl.renderer) (level_state : t)
    : (unit, string) result =
        Ball.paint sdl_renderer level_state.ball >>= fun () ->
            Paddle.paint sdl_renderer level_state.paddle >>= fun () ->
                Wall.paint sdl_renderer level_state.wall
end
