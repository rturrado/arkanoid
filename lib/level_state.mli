open Ball
open Brick
open Paddle
open Wall

module Level_state : sig
    type t = {
        ball : Ball.t;
        paddle : Paddle.t;
        wall : Wall.t
    }

    val default : t

    val move_paddle : t -> Paddle.direction_t -> t
    val hit_brick : t -> Brick.id -> t
    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
