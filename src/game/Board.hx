package game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

class Board extends Entity {

    private var _bombs:Array<Array<Bomb>>;
    private var _width:Int;
    private var _height:Int;
    private var _w:Int;
    private var _h:Int;

    public function new(w:Int, h:Int) {
        super();
        type = "board";
        _bombs = [];
        _width = _height = Std.int(HXP.width / 6);
        _w = w;
        _h = h;
        for (x in 0...w) {
            _bombs[x] = [];
            for (y in 0...h) {
                var time:Int = 30;
                _bombs[x][y] = new Bomb(this, x, y, time, false);
            }
        }
        width =  _width * w;
        height = _height * h;
        x = HXP.halfWidth - (width / 2);
        y = HXP.halfHeight - (height / 2);
    }

    public function clicked(x:Int, y:Int) {
        var lX:Int = Std.int(x - this.x);
        var lY:Int = Std.int(y - this.y);

        toggle(Math.floor(lX / _width), Math.floor(lY / _height));
    }

    public function toggle(x:Int, y:Int, setting:Bool = false) {

        //toggle bomb plus surrounding in x and y direction
        _bombs[x][y].toggle(setting);
        if (x > 0)      _bombs[x-1][y].toggle(setting);
        if (x < _w - 1) _bombs[x+1][y].toggle(setting);
        if (y > 0)      _bombs[x][y-1].toggle(setting);
        if (y < _h - 1) _bombs[x][y+1].toggle(setting);

    }
}
