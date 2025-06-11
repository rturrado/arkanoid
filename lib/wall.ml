open Brick
open Tsdl

module Wall = struct
    module BrickMap = Map.Make(Int)

    type t = Brick.t BrickMap.t

    let default : t = BrickMap.empty

    let map_of_list (brick_list : Brick.t list)
    : t =
        List.fold_left (fun acc brick -> BrickMap.add brick.Brick.id brick acc) BrickMap.empty brick_list

    let list_of_map (brick_map : t)
    : Brick.t list =
        BrickMap.fold (fun _ brick acc -> brick :: acc) brick_map []

    let is_empty (brick_map : t)
    : bool =
        BrickMap.is_empty brick_map

    let paint (sdl_renderer : Sdl.renderer) (wall : t)
    : (unit, string) result =
        let paint_brick brick =
            Brick.paint sdl_renderer brick
        in
        let brick_list = list_of_map wall in
        let results = List.map paint_brick brick_list in
        match List.find_opt Result.is_error results with
        | Some (Error err) -> Error err
        | _ -> Ok ()
end
