package ui;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import openfl.display.BitmapData;

class Mute extends Entity
{
    public var callback:Void->Void;
    private var _icon:Spritemap;
    private var _on:Bool;

    public function new(on:Bool) {
        super();
        type = "mute";

        var icon_data:BitmapData = cast(HXP.engine, Main).assets.get("mute");
        _icon = new Spritemap(icon_data, icon_data.width, Std.int(icon_data.height/2));
        _icon.add("off", [0]);
        _icon.add("on", [1]);

        _icon.alpha = 0.5;

        //_icon.centerOrigin();
        addGraphic(_icon);

        _on = on;

        if (on) {
            _icon.play("on");
        } else {
            _icon.play("off");
        }

        width = icon_data.width;
        height = Std.int(icon_data.height/2);
    }

    public function set(on:Bool) {
        _on = on;

        if (on) {
            _icon.play("on");
        } else {
            _icon.play("off");
        }
    }

    public function click() {
        if (callback != null) {
            callback();
        }
         _on = !_on;
        if (_on) {
            _icon.play("on");
        } else {
            _icon.play("off");
        }
    }

    public function enable() {
         _icon.alpha = 0.5;
    }

    public function disable() {
        _icon.alpha = 0;
    }
}
