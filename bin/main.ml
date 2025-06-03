open Arkanoid.Context
open Arkanoid.Canvas
open Arkanoid.Events
open Arkanoid.Graphics
open Tsdl

let (>>=) = Result.bind

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
        match context.Context.game_state with
        | Ready
        | ReportingKill
        | Paused ->
            Sdl.log "Ready | ReportingKill | Paused";
            Context.process_event_at_pause context event >>= fun new_context ->
                loop graphics new_context
        | Over ->
            Sdl.log "Over";
            Context.process_event_at_over context event >>= fun new_context ->
                loop graphics new_context
        | Running ->
            (* clear *)
            Graphics.clear graphics.Graphics.sdl_renderer >>= fun () ->
                (* process event *)
                Context.process_event_at_running context event >>= fun new_context ->
                    (* process frame *)
                    let new_context = Context.process_frame new_context in
                    (* paint *)
                    Context.paint graphics.Graphics.sdl_renderer new_context >>= fun () ->
                        (* render *)
                        Graphics.render graphics.Graphics.sdl_renderer;
                        (* delay *)
                        let delay_time : int32 = 16l in
                        Graphics.delay delay_time;
                        (* loop *)
                        loop graphics new_context

let main ()
: int =
    match Sdl.init Sdl.Init.(video + events) with
    | Error (`Msg err) -> Sdl.log "Init error: %s" err; 1
    | Ok () ->
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
