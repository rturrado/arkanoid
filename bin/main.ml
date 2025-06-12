open Arkanoid.Context
open Arkanoid.Canvas
open Arkanoid.Constants
open Arkanoid.Events
open Arkanoid.Graphics
open Arkanoid.Image
open Arkanoid.Intro
open Arkanoid.Log
open Arkanoid.Mixer
open Arkanoid.Music
open Arkanoid.Text

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
            Graphics.render_clear graphics >>= fun () ->
                (* paint context *)
                Context.paint graphics new_context >>= fun () ->
                    (* render graphics *)
                    Graphics.render_present graphics;
                    (* delay *)
                    let delay_time : int32 = Int32.of_float Constants.frame_duration in
                    Graphics.delay delay_time;
                    (* loop *)
                    loop graphics new_context

let main ()
: (unit, string) result =
    Log.init();
    Graphics.init () >>= fun () ->
        Mixer.init () >>= fun () ->
            Music.play Music.one_0 >>= fun mixer_music ->
                Image.init () >>=  fun () ->
                    Text.init () >>= fun () ->
                        let width = int_of_float Canvas.window_width in
                        let height = int_of_float Canvas.window_height in
                        let title = "Arkanoid" in
                        Graphics.create_window width height title >>= fun sdl_window ->
                            Graphics.create_renderer sdl_window >>= fun sdl_renderer ->
                                let graphics : Graphics.t = sdl_renderer in
                                let context : Context.t = Context.default in
                                Intro.paint graphics >>= fun () ->
                                    match loop graphics context with
                                    | Error err -> Error err
                                    | Ok () ->
                                        Graphics.destroy_renderer sdl_renderer;
                                        Graphics.destroy_window sdl_window;
                                        Text.quit ();
                                        Image.quit ();
                                        Music.halt mixer_music >>= fun () ->
                                            Mixer.quit ();
                                            Graphics.quit ();
                                            Ok ()

let () =
    if !Sys.interactive then ()
    else
        let exit_code = match main () with
        | Error err -> Log.error "%s" err; 1
        | Ok () -> 0
        in
        exit exit_code
