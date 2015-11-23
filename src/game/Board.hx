package game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Tween.TweenType;

class Board extends Entity {

    private var _bombs:Array<Array<Bomb>>;
    private var _width:Int;
    private var _height:Int;
    private var _w:Int;
    private var _h:Int;

    private var _beat:Int = 0;
    private var _tempo:Float = 0.2;
    private var _tempoAcc:Float = 0.0;

    public var cols:Int;
    public var rows:Int;
    public var menu:Bool = false;


    public function new(w:Int, h:Int, menu:Bool = false) {
        super();
        type = "board";
        this.menu = menu;
        _bombs = [];
        _width = Std.int(HXP.width / w);
        _height = Std.int(_width * (h / w));
        _w = w;
        _h = h;

        cols = w;
        rows = h;

        width =  _width * w;
        height = _height * h;
        x = HXP.halfWidth - (width / 2);
        y = HXP.halfHeight - (height / 2);

        for (x in 0...w) {
            _bombs[x] = [];
            for (y in 0...h) {
                var time:Int = 30;
                _bombs[x][y] = new Bomb(this, x, y, time, false);
            }
        }
    }

    public override function update(): Void {
        super.update();

        for (x in 0..._w) {
            for (y in 0..._h) {
                _bombs[x][y].update();
            }
        }

        _tempoAcc += HXP.elapsed;
        if (_tempoAcc >= _tempo) {
            _tempoAcc -= _tempo;
            _tempo = Math.random() + 0.2;

            //loop through the current beat of the board and play a maximum of two lit on that column
            var a = [for (i in 0..._h) i];
            var _p = 0;
            while (_p < 2 && a.length > 0) {
                 var ind = a.splice(Math.floor(Math.random() * a.length), 1)[0];
                 if (_bombs[_beat][ind].active) {
                     HXP.alarm(Math.random() / 10, _bombs[_beat][ind].play, TweenType.OneShot);
                     _p++;
                 }
            }
            _beat++;
            if (_beat >= _w) _beat = 0;
        }
    }

    public function load(level:Array<Dynamic>) {
        clear();
        for (t in level) {
            toggle(t.x, t.y, true, true);
        }
    }

    public function clear() {
        for (x in 0..._w) {
            for (y in 0..._h) {
                if (_bombs[x][y].active) {
                    toggle(x, y, false, true);
                }
            }
        }
    }

    public function save() {
         var ar = [];
         for (x in 0...6) {
             for (y in 0...6) {
                 if (_bombs[x][y].active) {
                      ar.push({x:x, y:y});
                 }
             }
         }
         return ar;
    }

    public function clicked(x:Int, y:Int) {
        var lX:Int = Std.int(x - this.x);
        var lY:Int = Std.int(y - this.y);

        toggle(Math.floor(lX / _width), Math.floor(lY / _height));
    }

    public function toggle(x:Int, y:Int, setting:Bool = false, onlyOne:Bool = false) {

        //toggle bomb plus surrounding in x and y direction
        _bombs[x][y].toggle(setting);
        if (!onlyOne) {
            if (x > 0)      _bombs[x-1][y].toggle(setting);
            if (x < _w - 1) _bombs[x+1][y].toggle(setting);
            if (y > 0)      _bombs[x][y-1].toggle(setting);
            if (y < _h - 1) _bombs[x][y+1].toggle(setting);
        }
    }
}
