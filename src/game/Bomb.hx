package game;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import openfl.display.BitmapData;
import openfl.media.SoundChannel;

class Bomb {

    private var _active:Bool;
    private var _count:Int;

    public var active(get, null):Bool;
    private inline function get_active():Bool { return _active; }
    public var count(get, null):Int;
    private inline function get_count():Int { return _count; }

    private var _bomb:Spritemap;
    private var _board:Board;

    private var _pitch:Float;

    private var _colour = new hxColorToolkit.spaces.HSL(Math.floor(Math.random()*360), 50, 50);
    private var _rate:Float = Math.random() + 1;

    private var _scale = [
        1,
        3/4.0,
        5/8.0,
        9/16.0,
        0.5,
        3/8.0,
        5/16.0,
        9/32.0
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

    public function update() {
        _colour.hue += HXP.elapsed * _rate;
        _colour.hue = _colour.hue % 360;
        if (_active) {
            _bomb.color = _colour.getColor();
        }
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
            _bomb.color = _colour.getColor();
        } else {
            _bomb.play("off");
            _bomb.color = 0xFFFFFF;
        }
        if (setting) {
            _count++;
        } else {
            _count--;
        }
    }
}
