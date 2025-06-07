open Arkanoid.Context
open Arkanoid.Canvas
open Arkanoid.Constants
open Arkanoid.Events
open Arkanoid.Graphics
open Tsdl

let (>>=) = Result.bind

let process_event (context : Context.t) (event : Events.event)
: (Context.t, string) result =
    match context.Context.game_state with
    | Ready
    | ReportingKill
    | Paused ->
        Context.process_event_at_pause context event
    | Over ->
        Context.process_event_at_over context event
    | Running ->
        Context.process_event_at_running context event

let rec loop (graphics : Graphics.t) (context : Context.t)
: (unit, string) result =
    match Events.handle () with
    | Error err ->
        Sdl.log "Error: %s" err;
        Error err
    | Ok (Some `Quit) ->
        Sdl.log "Ok (Some `Quit)";
        Ok ()
    | Ok event ->
        process_event context event >>= fun new_context ->
            let new_context = Context.process_frame new_context in
            (* clear graphics *)
            Graphics.clear graphics.Graphics.sdl_renderer >>= fun () ->
                (* paint context *)
                Context.paint graphics.Graphics.sdl_renderer new_context >>= fun () ->
                    (* render graphics *)
                    Graphics.render graphics.Graphics.sdl_renderer;
                    (* delay *)
                    let delay_time : int32 = Int32.of_float Constants.frame_duration in
                    Graphics.delay delay_time;
                    (* loop *)
                    loop graphics new_context

let main ()
: int =
    match Sdl.init Sdl.Init.(video + events) with
    | Error (`Msg err) -> Sdl.log "Init error: %s" err; 1
    | Ok () ->
        Sdl.log_set_all_priority Sdl.Log.priority_warn;
        let width = int_of_float Canvas.window_width in
        let height = int_of_float Canvas.window_height in
        match Sdl.create_window ~w:width ~h:height "SDL OpenGL" Sdl.Window.opengl with
        | Error (`Msg err) -> Sdl.log "Create window error: %s" err; 1
        | Ok sdl_window ->
            Sdl.set_window_title sdl_window "Arkanoid";
            match Sdl.create_renderer sdl_window ~flags:Sdl.Renderer.accelerated with
            | Error (`Msg err) -> Sdl.log "Create renderer error: %s" err; 1
            | Ok sdl_renderer ->
                let graphics = { Graphics.sdl_renderer = sdl_renderer } in
                let context = Context.default in
                match loop graphics context with
                | Error _ -> 1
                | Ok () ->
                    Sdl.destroy_renderer sdl_renderer;
                    Sdl.destroy_window sdl_window;
                    Sdl.quit ();
                    0

let () =
    if !Sys.interactive then ()
    else exit (main ())
