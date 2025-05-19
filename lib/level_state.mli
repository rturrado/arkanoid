open Ball
open Paddle
open Wall

module Level_state : sig
    type t = {
        ball : Ball.t;
        paddle : Paddle.t;
        wall : Wall.t;
    }

    val default : t
end
