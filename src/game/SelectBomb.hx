package game;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.MultiVarTween;
import com.haxepunk.tweens.misc.ColorTween;
import openfl.display.BitmapData;
import openfl.media.SoundChannel;

class SelectBomb {

    private var _active:Bool;
    private var _count:Int;

    public var active(get, null):Bool;
    private inline function get_active():Bool { return _active; }
    public var count(get, null):Int;
    private inline function get_count():Int { return _count; }

    private var _bomb:Spritemap;
    private var _board:SelectBoard;

    private var _pitch:Float;
    private var _scale:Float;

    private var _colour = new hxColorToolkit.spaces.HSL(Math.floor(Math.random()*360), 50, 50);
    private var _rate:Float = Math.random() + 1;

    private var _offTween:ColorTween;
    private var _playTween:MultiVarTween;

    private var _level:Text;

    private var _mscale = [
        5/4.0,
        9/8.0,
        1,
        3/4.0,
        //5/8.0,
        9/16.0,
        0.5,
        3/8.0,
        5/4.0,
        9/8.0,
        1,
        3/4.0,
        5/8.0,
        9/16.0,
        0.5,
        3/8.0
    ];

    public function new(b:SelectBoard, x, y, t:Int, a:Bool) {
        _active = a;
        _count = 0;
        _board = b;

        var _sw = b.width / b.cols;

        _pitch = _mscale[y];

        var bomb_data:BitmapData = cast(HXP.engine, Main).assets.get("bomb");
        _bomb = new Spritemap(bomb_data, bomb_data.width, Std.int(bomb_data.height/2));
        _bomb.add("off", [0]);
        _bomb.add("on", [1]);
        _scale = _bomb.scale = _sw / _bomb.width;
        _bomb.x = _bomb.scale * (x*bomb_data.width + bomb_data.width / 2);
        _bomb.y = _bomb.scale * (y*bomb_data.width + bomb_data.width / 2);

        _bomb.alpha = 0.75;

        _bomb.centerOrigin();
        _board.addGraphic(_bomb);

        _playTween = new MultiVarTween(reset, TweenType.Persist);
        _playTween.tween(_bomb, {"scale": _scale * 1.05, "alpha": 1}, 0.2);
        HXP.tweener.addTween(_playTween);

        _offTween = new ColorTween(function(arg:Dynamic) { _bomb.color = 0xFFFFFF; _bomb.play("off"); }, TweenType.Persist);
        _offTween.tween(0.5, 0xFFFFFF, 0x606060);
        HXP.tweener.addTween(_offTween);

        _bomb.alpha = b.menu? 0 : 0.75;

        _level = new Text("00");
        _level.alpha = 0.5;
        _level.size = Std.int( _bomb.height / 3 );
        _level.resizable = true;
        _level.setTextProperty("color", 0xFFFFFF);
        _board.addGraphic(_level);
    }

    public function update() {
        _colour.hue += HXP.elapsed * _rate;
        _colour.hue = _colour.hue % 360;
        if (_offTween.active) {
            _bomb.color = _offTween.color;
        } else if (_active) {
            _bomb.color = _colour.getColor();
        }
    }

    public function play(arg:Dynamic) {
         _play(false);
    }

    public function _play(silent:Bool = false) {
        if (_active) {
            if (!silent) {
                var tone:SoundChannel = cast(HXP.engine, Main).assets.getsound("tone").play();
                tone.pitch = _pitch;
            }
            _playTween.start();
        }
    }

    public function toggle(number:Int) {
        _active = !_active;
        if (_active) {
            _offTween.active = false;
            _bomb.play("on");
            _bomb.alpha = 0.75;
            _bomb.color = _colour.getColor();
            if (number != -1) {
                 //set number
                _level.text = Std.string(number);
                _level.x = _bomb.x - _level.width / 2;
                _level.y = _bomb.y;
            } else {
                 _level.text = "";
            }
        } else {
            _playTween.active = false;
            _offTween.start();
            _level.text = "";
        }
    }

    private function reset(arg:Dynamic) {
        var tween = new MultiVarTween(null, TweenType.OneShot);
        tween.tween(_bomb, {"scale": _scale, "alpha": 0.75}, 0.8);
        HXP.tweener.addTween(tween, true);
    }
}

