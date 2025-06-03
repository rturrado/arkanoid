open Rectangle

module Physics = struct
    type fixed_box_side_t = [
        | `Top
        | `Bottom
        | `Left
        | `Right
    ]

    let get_box_center (box : Rectangle.t)
    : float * float =
        Rectangle.get_center box

    let get_expanded_fixed_box (moving_box : Rectangle.t) (fixed_box : Rectangle.t)
    : Rectangle.t =
        {
            x = fixed_box.x -. moving_box.width /. 2.0;
            y = fixed_box.y -. moving_box.height /. 2.0;
            width = fixed_box.width +. moving_box.width;
            height = fixed_box.height +. moving_box.height
        }

    let get_movement_delta (moving_box_start: Rectangle.t) (moving_box_end: Rectangle.t)
    : float * float =
        (
            moving_box_end.x -. moving_box_start.x,
            moving_box_end.y -. moving_box_start.y
        )

    let swept_aabb_x (moving_box_start_center_x: float) (expanded_fixed_box : Rectangle.t) (dx : float)
    : float * float =
        if dx <> 0.0
        then begin
            let t_left = (expanded_fixed_box.x -. moving_box_start_center_x ) /. dx in
            let t_right = ((expanded_fixed_box.x +. expanded_fixed_box.width) -. moving_box_start_center_x) /. dx in
            (min t_left t_right, max t_left t_right)
        end
        else (Float.neg_infinity, Float.infinity)

    let swept_aabb_y (moving_box_start_center_y: float) (expanded_fixed_box : Rectangle.t) (dy : float)
    : float * float =
        if dy <> 0.0
        then begin
            let t_top = (expanded_fixed_box.y -. moving_box_start_center_y ) /. dy in
            let t_bottom = ((expanded_fixed_box.y +. expanded_fixed_box.height) -. moving_box_start_center_y) /. dy in
            (min t_top t_bottom, max t_top t_bottom)
        end
        else (Float.neg_infinity, Float.infinity)

    let check_collision_time (t_enter : float) (t_exit : float)
    : float option =
        if (t_enter < t_exit && t_enter < 1.0 && t_exit > 0.0)
        then Some t_enter
        else None

    let get_collision_time (t_enter_x : float) (t_exit_x : float) (t_enter_y : float) (t_exit_y : float)
    : float option =
        check_collision_time (max t_enter_x t_enter_y) (min t_exit_x t_exit_y)

    let get_collision_side (dx : float) (dy : float) (t_enter_x : float) (t_enter_y : float)
    : fixed_box_side_t =
        if t_enter_x > t_enter_y then
            if dx > 0.0 then `Left else `Right
        else
            if dy > 0.0 then `Top else `Bottom

    let swept_aabb (moving_box_start : Rectangle.t) (moving_box_end : Rectangle.t) (fixed_box : Rectangle.t)
    : (float * fixed_box_side_t) option =
        let (moving_box_start_center_x, moving_box_start_center_y) = get_box_center moving_box_start in
        let expanded_fixed_box = get_expanded_fixed_box moving_box_start fixed_box in
        let (dx, dy) = get_movement_delta moving_box_start moving_box_end in
        let (t_enter_x, t_exit_x) = swept_aabb_x moving_box_start_center_x expanded_fixed_box dx in
        let (t_enter_y, t_exit_y) = swept_aabb_y moving_box_start_center_y expanded_fixed_box dy in
        match get_collision_time t_enter_x t_exit_x t_enter_y t_exit_y with
        | Some time ->
            let side = get_collision_side dx dy t_enter_x t_enter_y in
            Some (time, side)
        | None -> None

    let to_radians degrees =
        degrees *. (Float.pi /. 180.0)
end
