open Rectangle

module Physics : sig
    type fixed_box_side_t = [
        | `Top
        | `Bottom
        | `Left
        | `Right
    ]

    val swept_aabb : Rectangle.t -> Rectangle.t -> Rectangle.t -> (float * fixed_box_side_t) option
    val to_radians : float -> float
end
