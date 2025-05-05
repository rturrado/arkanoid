open Arkanoid.Color
open Arkanoid.Context
open Arkanoid.Controls
open Arkanoid.Paddle
open Arkanoid.Rectangle
open Tsdl

let paint_rectangle context rectangle color : (unit, string) result =
    let sdl_renderer = context.Context.sdl_renderer in
    let red = color.Color.red in
    let green = color.Color.green in
    let blue = color.Color.blue in
    let alpha = color.Color.alpha in
    match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
    | Error (`Msg err) -> Sdl.log "Set render draw color (rectangle) error: %s" err; Error err
    | Ok () ->
        let x = rectangle.Rectangle.x in
        let y = rectangle.Rectangle.y in
        let width = rectangle.Rectangle.width in
        let height = rectangle.Rectangle.height in
        let sdl_rect = Sdl.Rect.create ~x:x ~y:y ~w:width ~h:height in
        match Sdl.render_fill_rect sdl_renderer (Some sdl_rect) with
        | Error (`Msg err) -> Sdl.log "Render fill rect error: %s" err; Error err
        | Ok () -> Ok ()

let render context : (unit, string) result =
    let sdl_renderer = context.Context.sdl_renderer in
    let red = Color.black.red in
    let green = Color.black.green in
    let blue = Color.black.blue in
    let alpha = Color.black.alpha in
    match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
    | Error (`Msg err) -> Sdl.log "Set render draw color (clear) error: %s" err; Error err
    | Ok () ->
        match Sdl.render_clear sdl_renderer with
        | Error (`Msg err) -> Sdl.log "Render clear error: %s" err; Error err
        | Ok () ->
                match paint_rectangle context Paddle.paddle Color.grey with
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
        let width = Controls.window_width in
        let height = Controls.window_height in
        match Sdl.create_window ~w:width ~h:height "SDL OpenGL" Sdl.Window.opengl with
        | Error (`Msg err) -> Sdl.log "Create window error: %s" err; 1
        | Ok sdl_window ->
            match Sdl.create_renderer sdl_window ~flags:Sdl.Renderer.accelerated with
            | Error (`Msg err) -> Sdl.log "Create renderer error: %s" err; 1
            | Ok sdl_renderer ->
                let context = { Context.sdl_renderer } in
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
