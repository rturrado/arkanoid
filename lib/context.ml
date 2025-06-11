open Ball
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
        | Game_state.ReportingKill ->
            "They've killed you!\n" ^
            "Press any key to resume!"
        | Over ->
            "Game over!"

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
            if collision.fixed_object_side = `Top then
                { context with game_state = Game_state.Over }
            else
                context
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
            if is_end_of_frame context time then
                new_context
            else
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

    let process_event_at_over (context : t) (event : Events.event)
    : (t, string) result =
        (* show message depending on context.game_state *)
        match event with
        | Some (`Key_press keycode) ->
            Sdl.log "Over: key=%d" keycode;
            Ok context
        | _ -> Ok context

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
                Message_box.paint sdl_renderer message Font.arcade_r;
end
