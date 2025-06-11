open Tsdl

module Log =  struct
    let init ()
    : unit =
        Sdl.log_set_all_priority Sdl.Log.priority_warn

    let verbose format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_verbose format

    let debug format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_debug format

    let info format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_info format

    let warn format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_warn format

    let error format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_error format

    let critical format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_critical format
end
