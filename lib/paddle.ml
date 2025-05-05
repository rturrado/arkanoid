open Controls
open Rectangle

module Paddle =  struct
    let width : int = 80
    let height : int = 20

    let paddle : Rectangle.rectangle_t = {
        x = Controls.window_width/2 - width/2;
        y = Controls.window_height - height - Controls.margin_size;
        width = width;
        height = height;
    }
end
