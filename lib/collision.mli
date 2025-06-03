open Ball
open Brick
open Level_state
open Paddle
open Rectangle

module Collision : sig
    type fixed_object_t = [
        | `Canvas of Rectangle.t
        | `Paddle of Paddle.t
        | `Brick of Brick.t
    ]

    type fixed_object_side_t = [
        | `Top
        | `Bottom
        | `Left
        | `Right
    ]

    type t = {
        point : float * float;
        time : float;
        fixed_object : fixed_object_t;
        fixed_object_side : fixed_object_side_t
    }

    val get_collisions : Level_state.t -> Ball.t -> t list option
end
