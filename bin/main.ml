open Arkanoid.Context
open Tsdl

let rec loop context : (unit, string) result =
    match Events.handle () with
    | Error err -> Error err
    | Ok (Some `Quit) -> ()
    | Ok event ->
        match context.Context.game_state with
        | Ready
        | ReportingKill
        | Paused ->
            Context.process_event_at_pause context event >>= fun new_context ->
                loop new_context
        | Over ->
            Context.process_event_at_over context event >>= fun new_context ->
                loop new_context
        | Playing ->
            (* process event *)
            Context.process_event_at_playing context event >>= fun new_context ->
                (* process frame *)
                Context.process_frame new_context >== fun new_context ->
                    (* render *)
                    let sdl_renderer in new_context.Context.sdl_renderer in
                    Graphics.render sdl_renderer;
                    (* delay *)
                    let delay_time = 16l in
                    Sdl.delay delay_time;
                    (* loop *)
                    loop new_context

let main () : int =
    match Sdl.init Sdl.Init.(video + events) with
    | Error (`Msg err) -> Sdl.log "Init error: %s" err; 1
    | Ok () ->
        let width = Controls.window_width in
        let height = Controls.window_height in
        match Sdl.create_window ~w:width ~h:height "SDL OpenGL" Sdl.Window.opengl with
        | Error (`Msg err) -> Sdl.log "Create window error: %s" err; 1
        | Ok sdl_window ->
            match Sdl.create_renderer sdl_window ~flags:Sdl.Renderer.accelerated with
            | Error (`Msg err) -> Sdl.log "Create renderer error: %s" err; 1
            | Ok sdl_renderer ->
                let context = Context.default in
                let graphics = { Graphics.t.sdl_renderer }
                match loop context graphics with
                | Error _ -> 1
                | Ok () ->
                    Sdl.destroy_renderer sdl_renderer;
                    Sdl.destroy_window sdl_window;
                    Sdl.quit ();
                    0

let () =
    if !Sys.interactive then ()
    else exit (main ())
