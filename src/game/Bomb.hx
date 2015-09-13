package game;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import openfl.display.BitmapData;
import openfl.media.SoundChannel;

class Bomb {

    private var _active:Bool;
    private var _count:Int;

    public var count(get, null):Int;
    private inline function get_count():Int { return _count; }

    private var _bomb:Spritemap;
    private var _board:Board;

    private var _pitch:Float;

    private var _scale = [
        5/4.0,
        9/8.0,
        1,
        5/6.0,
        3/4.0,
        5/8.0,
        9/16.0,
        0.5
    ];

    public function new(b:Board, x, y, t:Int, a:Bool) {
        _active = a;
        _count = 0;
        _board = b;

        _pitch = _scale[y];

        var bomb_data:BitmapData = cast(HXP.engine, Main).assets.get("bomb");
        _bomb = new Spritemap(bomb_data, bomb_data.width, Std.int(bomb_data.height/2));
        _bomb.add("off", [0]);
        _bomb.add("on", [1]);
        _bomb.x = x*bomb_data.width;
        _bomb.y = y*bomb_data.width;

        _board.addGraphic(_bomb);
    }

    public function play(arg:Dynamic) {
        if (_active) {
            var tone:SoundChannel = cast(HXP.engine, Main).assets.getsound("tone").play();
            tone.pitch = _pitch;
        }
    }

    public function toggle(setting:Bool = false) {
        _active = !_active;
        if (_active) {
            _bomb.play("on");
        } else {
            _bomb.play("off");
        }
        if (setting) {
            _count++;
        } else {
            _count--;
        }
    }
}
