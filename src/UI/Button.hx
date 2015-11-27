package ui;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

class Button extends Entity
{

    public var callback:Void->Void;
    private var _text:Text;

    public function new(text:String) {
        super();
        type = "button";

        _text = new Text(text);
        _text.resizable = true;
        _text.size = Std.int(HXP.height / 12);
        _text.setTextProperty("color", 0xFFFFFF);
        //addGraphic(_text);
        graphic = _text;
        width = _text.width;
        height = _text.height;
        _text.alpha = 0.25;
    }

    public function click() {
        if (callback != null) {
            callback();
        }
    }

    public function enable() {
         _text.alpha = 0.25;
    }

    public function disable() {
        _text.alpha = 0;
    }
}
