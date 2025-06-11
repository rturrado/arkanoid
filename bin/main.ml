open Arkanoid.Context
open Arkanoid.Canvas
open Arkanoid.Constants
open Arkanoid.Events
open Arkanoid.Graphics
open Arkanoid.Log
open Arkanoid.Text
open Tsdl

let (>>=) = Result.bind

let process_event (context : Context.t) (event : Events.event)
: (Context.t, string) result =
    match context.Context.game_state with
    | Ready
    | ReportingKill
    | Paused -> Context.process_event_at_pause context event
    | Over -> Context.process_event_at_over context event
    | Running -> Context.process_event_at_running context event

let rec loop (graphics : Graphics.t) (context : Context.t)
: (unit, string) result =
    match Events.handle () with
    | Some `Quit -> Ok ()
    | event ->
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
: (unit, string) result =
    Log.init();
    Graphics.init () >>= fun () ->
        Text.init () >>= fun () ->
            let width = int_of_float Canvas.window_width in
            let height = int_of_float Canvas.window_height in
            let title = "Arkanoid" in
            Graphics.create_window width height title >>= fun sdl_window ->
                Graphics.create_renderer sdl_window >>= fun sdl_renderer ->
                    let graphics = { Graphics.sdl_renderer = sdl_renderer } in
                    let context = Context.default in
                    match loop graphics context with
                    | Error err -> Error err
                    | Ok () ->
                        Sdl.destroy_renderer sdl_renderer;
                        Sdl.destroy_window sdl_window;
                        Text.quit ();
                        Sdl.quit ();
                        Ok ()

let () =
    if !Sys.interactive then ()
    else
        let exit_code = match main () with
        | Error err -> Log.error "%s" err; 1
        | Ok () -> 0
        in
        exit exit_code
