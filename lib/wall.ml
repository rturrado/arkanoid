open Brick

module Wall = struct
    type t = Brick.t list

    let default : Brick.t list = []

    let paint sdl_renderer wall : (unit, string) result =
        let paint_brick brick =
            Brick.paint sdl_renderer brick
        in
        let results = List.map paint_brick wall in
        match List.find_opt Result.is_error results with
            | Some (Error err) -> Error err
            | _ -> Ok ()
end
