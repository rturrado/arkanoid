open Color
open Rectangle

module Graphics : sig
    type t = Tsdl.Sdl.renderer

    type texture_t = {
        data : Tsdl.Sdl.texture;
        width : float;
        height : float;
    }

    type textures_t = texture_t list

    val init : unit -> (unit, string) result
    val quit : unit -> unit
    val create_window : int -> int ->  string -> (Tsdl.Sdl.window, string) result
    val create_renderer : Tsdl.Sdl.window -> (t, string) result
    val create_texture_from_surface : Tsdl.Sdl.renderer -> Tsdl.Sdl.surface -> (texture_t, string) result
    val destroy_window : Tsdl.Sdl.window -> unit
    val destroy_renderer : Tsdl.Sdl.renderer -> unit
    val free_surface : Tsdl.Sdl.surface -> unit
    val destroy_texture : texture_t -> unit
    val with_surface : Tsdl.Sdl.surface -> (Tsdl.Sdl.surface -> ('a, string) result) -> ('a, string) result
    val with_texture : texture_t -> (texture_t -> ('a, string) result) -> ('a, string) result
    val with_textures : textures_t -> (textures_t -> ('a, string) result) -> ('a, string) result
    val set_render_draw_color : Tsdl.Sdl.renderer -> Color.t -> (unit, string) result
    val render_clear : Tsdl.Sdl.renderer -> (unit, string) result
    val render_copy : Tsdl.Sdl.renderer -> texture_t -> Rectangle.t -> (unit, string) result
    val render_draw_rect : Tsdl.Sdl.renderer ->  Rectangle.t -> (unit, string) result
    val render_fill_rect : Tsdl.Sdl.renderer -> Rectangle.t -> (unit, string) result
    val render_present : Tsdl.Sdl.renderer -> unit
    val paint_rectangle : Tsdl.Sdl.renderer -> Rectangle.t -> Color.t -> (unit, string) result
    val paint_rectangle_border : Tsdl.Sdl.renderer -> Rectangle.t -> Color.t -> (unit, string) result
    val delay : int32 -> unit
end
