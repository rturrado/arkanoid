open Tsdl

type context_t = {
    sdl_renderer : Sdl.renderer;
}

type rectangle_t = {
    x : int;
    y : int;
    width : int;
    height : int;
}

let window_width : int = 640
let window_height : int = 480
let stick_width : int = 20
let stick_height : int = 80
let margin_width : int = 5

let left_stick : rectangle_t = {
    x = margin_width;
    y = window_height/2 - stick_height/2;
    width = stick_width;
    height = stick_height;
}

let right_stick : rectangle_t = {
    x = window_width - stick_width - margin_width;
    y = window_height/2 - stick_height/2;
    width = stick_width;
    height = stick_height;
}

type color_t = {
    red : int;
    green : int;
    blue : int;
    alpha : int;
}

let black : color_t = { red = 0; green = 0; blue = 0; alpha = 255; }

let grey : color_t = { red = 200; green = 200; blue = 200; alpha = 255; }

let paint_rectangle context rectangle color : (unit, string) result =
    match Sdl.set_render_draw_color context.sdl_renderer color.red color.green color.blue color.alpha with
    | Error (`Msg err) -> Sdl.log "Set render draw color (rectangle) error: %s" err; Error err
    | Ok () ->
        let sdl_rect = Sdl.Rect.create ~x:rectangle.x ~y:rectangle.y ~w:rectangle.width ~h:rectangle.height in
        match Sdl.render_fill_rect context.sdl_renderer (Some sdl_rect) with
        | Error (`Msg err) -> Sdl.log "Render fill rect error: %s" err; Error err
        | Ok () -> Ok ()

let render context : (unit, string) result =
    match Sdl.set_render_draw_color context.sdl_renderer black.red black.green black.blue black.alpha with
    | Error (`Msg err) -> Sdl.log "Set render draw color (clear) error: %s" err; Error err
    | Ok () ->
        match Sdl.render_clear context.sdl_renderer with
        | Error (`Msg err) -> Sdl.log "Render clear error: %s" err; Error err
        | Ok () ->
            match paint_rectangle context left_stick grey with
            | Error err -> Error err
            | Ok () ->
                match paint_rectangle context right_stick grey with
                | Error err -> Error err
                | Ok () -> Sdl.render_present context.sdl_renderer; Ok ()

let rec loop context : (unit, string) result =
    let delay_time = 16l in
    let event = Sdl.Event.create () in
    let event_occurred = Sdl.poll_event (Some event) in
    match render context with
    | Error err -> Error err
    | Ok () ->
        Sdl.delay delay_time;
        if event_occurred && Sdl.Event.get event Sdl.Event.typ = Sdl.Event.quit then
            Ok ()
        else
            loop context

let main () : int =
    match Sdl.init Sdl.Init.(video + events) with
    | Error (`Msg err) -> Sdl.log "Init error: %s" err; 1
    | Ok () ->
        match Sdl.create_window ~w:window_width ~h:window_height "SDL OpenGL" Sdl.Window.opengl with
        | Error (`Msg err) -> Sdl.log "Create window error: %s" err; 1
        | Ok sdl_window ->
            match Sdl.create_renderer sdl_window ~flags:Sdl.Renderer.accelerated with
            | Error (`Msg err) -> Sdl.log "Create renderer error: %s" err; 1
            | Ok sdl_renderer ->
                let context = { sdl_renderer } in
                match loop context with
                | Error _ -> 1
                | Ok () ->
                    Sdl.destroy_renderer sdl_renderer;
                    Sdl.destroy_window sdl_window;
                    Sdl.quit ();
                    0

let () =
    if !Sys.interactive then ()
    else exit (main ())

