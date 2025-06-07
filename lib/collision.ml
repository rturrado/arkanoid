open Ball
open Base
open Brick
open Canvas
open Level_state
open Paddle
open Physics
open Rectangle
open Time
open Wall

module Collision = struct
    type fixed_object_t = [
        | `Canvas of Rectangle.t
        | `Paddle of Paddle.t
        | `Brick of Brick.t
    ]

    type fixed_object_side_t = [
        | `Top
        | `Bottom
        | `Left
        | `Right
    ]

    type t = {
        point : float * float;
        time : float;
        fixed_object : fixed_object_t;
        fixed_object_side : fixed_object_side_t
    }

    let build (point : float * float) (time : float) (fixed_object : fixed_object_t) (fixed_object_side : fixed_object_side_t)
    : t =
        {
            point = point;
            time = time;
            fixed_object = fixed_object;
            fixed_object_side = fixed_object_side
        }

    let default_fixed_objects
    : fixed_object_t list =
        let canvas_top_area : Rectangle.t = { x = 0.0; y = -10.0; width = Canvas.window_width; height = 10.0 } in
        let canvas_bottom_area : Rectangle.t = { x = 0.0; y = Canvas.window_height; width = Canvas.window_width; height = 10.0 } in
        let canvas_left_area : Rectangle.t = { x = -10.0; y = 0.0; width = 10.0; height = Canvas.window_height } in
        let canvas_right_area : Rectangle.t = { x = Canvas.window_width; y = 0.0; width = 10.0; height = Canvas.window_height } in
        [
            (`Canvas canvas_top_area);
            (`Canvas canvas_bottom_area);
            (`Canvas canvas_left_area);
            (`Canvas canvas_right_area)
        ]

    let get_fixed_objects (level_state : Level_state.t)
    : fixed_object_t list =
        let paddle = (`Paddle level_state.paddle) in
        let brick_list = Wall.list_of_map level_state.wall in
        let bricks = (List.map ~f:(fun brick -> `Brick brick) brick_list) in
        default_fixed_objects @ (paddle :: bricks)

    let rectangle_of_fixed_object (fixed_object : fixed_object_t)
    : Rectangle.t =
        match fixed_object with
        | `Canvas rectangle -> rectangle
        | `Paddle paddle -> paddle.rectangle
        | `Brick brick -> brick.rectangle

    let get_collision_point (ball : Ball.t) (collision_time : float)
    : float * float =
        let (ball_center_x, ball_center_y) = Ball.get_center ball in
        (
            ball_center_x +. (ball.vx *. collision_time),
            ball_center_y +. (ball.vy *. collision_time)
        )

    let detect_collision (ball : Ball.t) (new_ball : Ball.t) (fixed_object : fixed_object_t)
    : t option =
        let ball_rectangle = ball.rectangle in
        let new_ball_rectangle = new_ball.rectangle in
        let fixed_object_rectangle = rectangle_of_fixed_object fixed_object in
        match Physics.swept_aabb ball_rectangle new_ball_rectangle fixed_object_rectangle with
        | None -> None
        | Some (time, fixed_object_side) ->
            let point = get_collision_point ball time in
            let collision = build point time fixed_object fixed_object_side in
            Some collision

    let detect_collisions (ball : Ball.t) (new_ball : Ball.t) (fixed_objects : fixed_object_t list)
    : t list =
        List.filter_map ~f:(fun fixed_object -> detect_collision ball new_ball fixed_object) fixed_objects

    let sort_collisions_by_time (c1 : t) (c2 : t)
    : int =
        if Time.less c1.time c2.time then
            -1
        else
            if Time.greater c1.time c2.time then 1 else 0

    let get_earliest_collisions (collisions : t list)
    : t list option =
        let sorted_collisions = List.sort ~compare:sort_collisions_by_time collisions in
        match sorted_collisions with
        | [] -> None
        | first :: _ ->
            Some (List.take_while ~f:(fun collision -> Time.equal first.time collision.time) sorted_collisions)

    let get_collisions (level_state : Level_state.t) (new_ball : Ball.t)
    : t list option =
        let fixed_objects = get_fixed_objects level_state in
        let detected_collisions = detect_collisions level_state.ball new_ball fixed_objects in
        get_earliest_collisions detected_collisions
end
