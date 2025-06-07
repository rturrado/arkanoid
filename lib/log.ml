open Tsdl

module Log =  struct
    let log_verbose format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_verbose format

    let log_debug format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_debug format

    let log_info format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_info format

    let log_warn format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_warn format

    let log_error format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_error format

    let log_critical format =
        Sdl.log_message Sdl.Log.category_application Sdl.Log.priority_critical format
end
