package ui;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import openfl.display.BitmapData;

class Reset extends Entity
{
    public var callback:Void->Void;
    private var _icon:Spritemap;

    public function new() {
        super();
        type = "reset";

        var icon_data:BitmapData = cast(HXP.engine, Main).assets.get("reset");
        _icon = new Spritemap(icon_data, icon_data.width, icon_data.height);
        _icon.alpha = 0.5;

        addGraphic(_icon);

        width = icon_data.width;
        height = icon_data.height;
    }

    public function click() {
        if (callback != null) {
            callback();
        }
    }

    public function enable() {
         _icon.alpha = 0.5;
    }

    public function disable() {
        _icon.alpha = 0;
    }
}
