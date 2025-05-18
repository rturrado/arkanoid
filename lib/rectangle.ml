import Color
import Sdl

module Rectangle = struct
    type t = Tsdl.Sdl.Rect

    let paint_rectangle sdl_renderer rectangle color =
        let red = color.Color.red in
        let green = color.Color.green in
        let blue = color.Color.blue in
        let alpha = color.Color.alpha in
        Sdl.render_draw_color sdl_renderer red green blue alpha;
        Sdl.render_fill_rect renderer rectangle.t
end
