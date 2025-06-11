module Font = struct
    type t = {
        path : string;
        size : int
    }

    let arcade_r : t = {
        path = Filename.concat "./res" "arcade_r.ttf";
        size = 20
    }
end
