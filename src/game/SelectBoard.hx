package game;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Tween.TweenType;

class SelectBoard extends Entity {

    private var _bombs:Array<Array<SelectBomb>>;
    private var _width:Int;
    private var _height:Int;
    private var _w:Int;
    private var _h:Int;

    private var _loadingAcc:Float = 0.0;
    private var _loadingTempo:Float = 0.1;
    private var _loadingStep:Int = 0;

    private var _level:Int = 0;
    private var _page:Int = 0;

    private var _loading:Bool = false;
    public var loading(get, null):Bool;
    private inline function get_loading():Bool { return _loading; }

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
                _bombs[x][y] = new SelectBomb(this, x, y, time, false);
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

        if (_loading) {
            _loadingAcc += HXP.elapsed;
            if (_loadingStep >= _h) {
                if (_loadingAcc >= 0.7) {
                    _loadingAcc = 0.0;
                    _loadingStep = 0;
                    _loading = false;
                    //TODO: show levels available
                    for (y in 0..._h) {
                        for (x in 0..._w) {
                            var number = x + (_w * y) + (36 * _page);
                            if (number > _level) {
                                break;
                            }
                            toggle(x,y);
                        }
                    }
                }
            } else if (_loadingAcc >= _loadingTempo) {
                _loadingAcc -= _loadingTempo;
                for (c in 0..._w) {
                    _bombs[c][_loadingStep]._play(c != 0);
                    toggle(c, _loadingStep);
                }
                _loadingStep++;
            }
            return;
        }
    }

    public function load(level:Int, page:Int) {
        reset();
        _loading = true;
        clear(false);

        _page = page;
        _level = level;
    }

    public function clear(off:Bool = true) {
        for (x in 0..._w) {
            for (y in 0..._h) {
                if (_bombs[x][y].active == off) {
                    toggle(x, y);
                }
            }
        }
    }

    public function reset() {
        _loadingAcc = 0.0;
        _loadingStep = 0;
        _loading = false;
        clear();
    }

    public function clicked(x:Int, y:Int) {
        if (_loading) {
            return -1;
        }
        var lX:Int = Std.int(x - this.x);
        var lY:Int = Std.int(y - this.y);

        x = Math.floor(lX / _width);
        y = Math.floor(lY / _height);
        var number = x + (_w * y) + (36 * _page);
        return number > _level ? -1 : number;

    }

    public function toggle(x:Int, y:Int) {

        var number = x + (_w * y) + (36 * _page);
        if (!_loading && number > _level) {
             return;
        }
        //toggle bomb plus surrounding in x and y direction
        _bombs[x][y].toggle(_loading ? -1 : number);
    }
}
