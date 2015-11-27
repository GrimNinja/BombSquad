package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import game.*;

class MenuScene extends Scene
{
    private var _title = [
        {x : 2, y : 2},
        {x : 3, y : 2},
        {x : 4, y : 2},
        {x : 5, y : 2},
        {x : 6, y : 2},
        {x : 8, y : 2},
        {x : 9, y : 2},
        {x : 10, y : 2},
        {x : 11, y : 2},
        {x : 13, y : 2},
        {x : 17, y : 2},
        {x : 19, y : 2},
        {x : 20, y : 2},
        {x : 21, y : 2},
        {x : 22, y : 2},
        {x : 24, y : 2},
        {x : 25, y : 2},
        {x : 26, y : 2},
        {x : 27, y : 2},
        {x : 4, y : 3},
        {x : 8, y : 3},
        {x : 11, y : 3},
        {x : 13, y : 3},
        {x : 14, y : 3},
        {x : 17, y : 3},
        {x : 19, y : 3},
        {x : 24, y : 3},
        {x : 4, y : 4},
        {x : 8, y : 4},
        {x : 11, y : 4},
        {x : 13, y : 4},
        {x : 15, y : 4},
        {x : 17, y : 4},
        {x : 19, y : 4},
        {x : 20, y : 4},
        {x : 21, y : 4},
        {x : 24, y : 4},
        {x : 25, y : 4},
        {x : 26, y : 4},
        {x : 27, y : 4},
        {x : 4, y : 5},
        {x : 8, y : 5},
        {x : 11, y : 5},
        {x : 13, y : 5},
        {x : 16, y : 5},
        {x : 17, y : 5},
        {x : 19, y : 5},
        {x : 27, y : 5},
        {x : 4, y : 6},
        {x : 8, y : 6},
        {x : 9, y : 6},
        {x : 10, y : 6},
        {x : 11, y : 6},
        {x : 13, y : 6},
        {x : 17, y : 6},
        {x : 19, y : 6},
        {x : 20, y : 6},
        {x : 21, y : 6},
        {x : 22, y : 6},
        {x : 24, y : 6},
        {x : 25, y : 6},
        {x : 26, y : 6},
        {x : 27, y : 6},
        {x : 8, y : 8},
        {x : 9, y : 8},
        {x : 10, y : 8},
        {x : 11, y : 8},
        {x : 13, y : 8},
        {x : 16, y : 8},
        {x : 18, y : 8},
        {x : 19, y : 8},
        {x : 20, y : 8},
        {x : 21, y : 8},
        {x : 22, y : 8},
        {x : 8, y : 9},
        {x : 11, y : 9},
        {x : 13, y : 9},
        {x : 16, y : 9},
        {x : 20, y : 9},
        {x : 8, y : 10},
        {x : 11, y : 10},
        {x : 13, y : 10},
        {x : 16, y : 10},
        {x : 20, y : 10},
        {x : 8, y : 11},
        {x : 11, y : 11},
        {x : 13, y : 11},
        {x : 16, y : 11},
        {x : 20, y : 11},
        {x : 8, y : 12},
        {x : 9, y : 12},
        {x : 10, y : 12},
        {x : 11, y : 12},
        {x : 13, y : 12},
        {x : 14, y : 12},
        {x : 15, y : 12},
        {x : 16, y : 12},
        {x : 20, y : 12}
    ];
    private var _board:Board;

    public function new() {
        super();
    }
    public override function begin() {
        super.begin();
        if (_board != null) {
            return;
        }
        _board = new Board(30, 15, true);
        _board.y = _board.height / 2;
        for (c in _title) {
             _board.toggle(c.x, c.y, true, true);
        }
        add(_board);
    }

    public override function update():Void {
        super.update();

        if (Input.mouseReleased) {
            cast(HXP.engine, Main).changeScene("select");
        }
    }
}
