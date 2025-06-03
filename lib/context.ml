open Ball
open Collision
open Events
open Game_state
open Level_state
open Paddle
open Player_state
open Time
open Tsdl

module Context = struct
    type t = {
        game_state : Game_state.t;
        level_state : Level_state.t;
        player_state : Player_state.t
    }

    let default : t = {
        game_state = Game_state.default;
        level_state = Level_state.default;
        player_state = Player_state.default
    }

    let get_notification_message (game_state : Game_state.t) (player_state : Player_state.t)
    : string =
        match game_state with
        | Game_state.Ready -> "Use < and > to move the paddle. You have 3 lives! Press any key to start the game..."
        | Game_state.Paused -> "Press any key to resume the game..."
        | Game_state.Running -> "Running"
        | Game_state.ReportingKill ->
            let number_of_lives = player_state.Player_state.number_of_lives in
            [%string "Oh no! They've kill you! You have now %d$number_of_lives lives! Press any key to resume the game..."]
        | Over -> "Game over! Press Y to start a new game or N to exit..."

    let move_paddle (context : t) (direction : Paddle.direction_t)
    : t =
        { context with level_state = Level_state.move_paddle context.level_state direction }

    let is_game_over (context : t)
    : bool =
        context.game_state = Game_state.Over

    let is_end_of_frame (context : t) (time : float)
    : bool =
        is_game_over context ||
        Time.equal time 0.0

    let apply_collision_to_ball (ball : Ball.t) (fixed_object_side : Collision.fixed_object_side_t)
    : Ball.t =
        match fixed_object_side with
        | `Left | `Right -> { ball with vx = -. ball.vx }
        | `Top | `Bottom -> { ball with vy = -. ball.vy }

    let apply_collision_to_fixed_object (context : t) (collision : Collision.t)
    : t =
        match collision.fixed_object with
        | `Canvas _ ->
            begin
                match collision.fixed_object_side with
                | `Top -> { context with game_state = Game_state.Over }
                | _ -> context
            end
        | `Brick brick ->
            let updated_level_state = Level_state.hit_brick context.level_state brick.id in
            { context with level_state = updated_level_state }
        | _ -> context

    let rec apply_collisions (context : t) (new_ball : Ball.t) (collisions : Collision.t list) (time : float)
    : t =
        match collisions with
        | [] ->
            let updated_ball = Ball.move new_ball time in  (* update x, y *)
            let updated_level_state = { context.level_state with ball = updated_ball } in
            { context with level_state = updated_level_state }
        | first_collision :: rest_collisions ->
            let updated_context = apply_collision_to_fixed_object context first_collision in
            if is_game_over updated_context then
                updated_context
            else
                let updated_ball = apply_collision_to_ball new_ball first_collision.fixed_object_side in  (* update vx, vy *)
                apply_collisions updated_context updated_ball rest_collisions time

    let rec process_frame_ex ~(time : float) (context : t)
    : t =
        let ball = context.level_state.ball in
        let new_ball = Ball.move ball time in
        match Collision.get_collisions context.level_state new_ball with
        | Some collisions ->
            let new_context = apply_collisions context new_ball collisions time in
            let first_collision = List.hd collisions in
            let new_time = time -. first_collision.time in
            if is_end_of_frame context time
                then new_context
                else process_frame_ex ~time:new_time new_context
        | None ->
            let new_level_state = { context.level_state with ball = new_ball } in
            { context with level_state = new_level_state }

    let process_event_at_pause (context : t) (event : Events.event)
    : (t, string) result =
        match event with
        | Some `Quit -> Ok context
        | _ -> Ok context

    let process_event_at_running (context : t) (event : Events.event)
    : (t, string) result =
        match event with
        | Some (`Keydown keycode) ->
            if keycode = Sdl.K.left then (
                Sdl.log "Running: key=left";
                Ok (move_paddle context Paddle.Left)
            ) else if keycode = Sdl.K.right then (
                Sdl.log "Running: key=right";
                Ok (move_paddle context Paddle.Right)
            ) else (
                Ok context
            )
        | _ -> Ok context

    let process_event_at_over (context : t) (event : Events.event)
    : (t, string) result =
        match event with
        | Some `Quit -> Ok context
        | _ -> Ok context

    let process_frame (context : t)
    : t =
        process_frame_ex context ~time:1.0

    let paint (sdl_renderer : Sdl.renderer) (context : t)
    : (unit, string) result =
        Level_state.paint sdl_renderer context.level_state
end
