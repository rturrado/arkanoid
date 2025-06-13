open Ball
open Brick
open Collision
open Events
open Font
open Game_state
open Level_state
open Log
open Message_box
open Paddle
open Player_state
open Time
open Tsdl

let (>>=) = Result.bind

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

    let get_notification_message (game_state : Game_state.t) : string =
        match game_state with
        | Game_state.Ready ->
            "Use < and > to move\n" ^
            "Use P to pause the game\n" ^
            "Press any key to start!"
        | Game_state.Paused ->
            "Press any key to resume!"
        | Game_state.Running ->
            "Running"
        | Game_state.PlayerCompletedLevel ->
            "Level completed!\n" ^
            "Press any key to resume!"
        | Game_state.PlayerKilled ->
            "They've killed you!\n" ^
            "Press any key to resume!"
        | Over ->
            "Game over!"

    let move_paddle (context : t) (direction : Paddle.direction_t)
    : t =
        let updated_level_state = Level_state.move_paddle context.level_state direction in
        { context with level_state = updated_level_state }

    let hit_brick (context : t) (brick_id : Brick.id)
    : t =
        let updated_level_state = Level_state.hit_brick context.level_state brick_id in
        let updated_game_state = if Level_state.is_finished updated_level_state then
            Game_state.PlayerCompletedLevel
        else
            context.game_state
        in
        { context with level_state = updated_level_state; game_state = updated_game_state }

    let is_level_finished (context : t)
    : bool =
        Level_state.is_finished context.level_state

    let is_game_over (context : t)
    : bool =
        Game_state.is_over context.game_state

    let is_frame_over (time : float)
    : bool =
        Time.equal time 0.0

    let should_stop_applying_collisions (context : t)
    : bool =
        is_level_finished context || is_game_over context

    let should_stop_processing_frame (context : t) (time : float)
    : bool =
        is_frame_over time || is_level_finished context || is_game_over context

    let apply_collision_to_ball (ball : Ball.t) (fixed_object_side : Collision.fixed_object_side_t)
    : Ball.t =
        match fixed_object_side with
        | `Left | `Right -> { ball with vx = -. ball.vx }
        | `Top | `Bottom -> { ball with vy = -. ball.vy }

    let apply_collision_to_fixed_object (context : t) (collision : Collision.t)
    : t =
        match collision.fixed_object with
        | `Canvas _ ->
            if collision.fixed_object_side = `Top then
                { context with game_state = Game_state.Over }
            else
                context
        | `Brick brick ->
            hit_brick context brick.id
        | _ -> context

    let rec apply_collisions (context : t) (new_ball : Ball.t) (collisions : Collision.t list) (time : float)
    : t =
        if should_stop_applying_collisions context then
            context
        else
            match collisions with
            | [] ->
                let updated_ball = Ball.move new_ball time in  (* update x, y *)
                let updated_level_state = { context.level_state with ball = updated_ball } in
                { context with level_state = updated_level_state }
            | first_collision :: rest_collisions ->
                let updated_context = apply_collision_to_fixed_object context first_collision in
                let updated_ball = apply_collision_to_ball new_ball first_collision.fixed_object_side in  (* update vx, vy *)
                apply_collisions updated_context updated_ball rest_collisions time

    let rec process_frame_ex ~(time : float) (context : t)
    : t =
        if should_stop_processing_frame context time then
            context
        else
            let ball = context.level_state.ball in
            let new_ball = Ball.move ball time in
            match Collision.get_collisions context.level_state new_ball with
            | Some collisions ->
                let new_context = apply_collisions context new_ball collisions time in
                let first_collision = List.hd collisions in
                let new_time = time -. first_collision.time in
                process_frame_ex ~time:new_time new_context
            | None ->
                let new_level_state = { context.level_state with ball = new_ball } in
                { context with level_state = new_level_state }

    let process_event_at_pause (context : t) (event : Events.event)
    : (t, string) result =
        match event with
        | Some (`Key_press _) ->
            Log.verbose "Paused: key=_";
            Ok { context with game_state = Game_state.Running }
        | _ -> Ok context

    let process_event_at_running (context : t) (event : Events.event)
    : (t, string) result =
        match event with
        | Some (`Key_press keycode) when keycode = Sdl.K.p ->
            Log.verbose "Running: key=p";
            Ok { context with game_state = Game_state.Paused }
        | Some (`Key_press keycode)
        | Some (`Key_hold keycode) when keycode = Sdl.K.left ->
            Log.verbose "Running: key=left";
            Ok (move_paddle context Paddle.Left)
        | Some (`Key_press keycode)
        | Some (`Key_hold keycode) when keycode = Sdl.K.right ->
            Log.verbose "Running: key=right";
            Ok (move_paddle context Paddle.Right)
        | _ -> Ok context

    let process_event_at_over (context : t) (_ : Events.event)
    : (t, string) result =
        Ok context

    let process_frame (context : t)
    : t =
        if context.game_state = Running then
            process_frame_ex context ~time:1.0
        else
            context

    let paint (sdl_renderer : Sdl.renderer) (context : t)
    : (unit, string) result =
        Level_state.paint sdl_renderer context.level_state >>= fun () ->
            if context.game_state = Running then
                Ok ()
            else
                let message = get_notification_message context.game_state in
                Message_box.paint sdl_renderer message Font.arcade_r_20;
end
