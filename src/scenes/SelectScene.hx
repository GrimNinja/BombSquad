package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Data;
import openfl.text.TextFormatAlign;
import game.*;
import ui.*;

class SelectScene extends Scene
{
    private var _level:Int = 0;
    private var _page:Int = 0;

    private var _board:SelectBoard;

    private var _back:Button;
    private var _prev:Button;
    private var _next:Button;
    private var _mute:Mute;

    private var _titleText:Text;

    public function new() {
        super();

        _board = new SelectBoard(6,6);
        add(_board);

        _back = new Button("free");
        _back.x = (HXP.width - _back.width) / 2;
        _back.y = HXP.height - _back.height;
        _back.callback = function() {
            cast(HXP.engine, Main).changeScene("main", -1);
        }
        add(_back);

        _titleText = new Text("Level Select");
        _titleText.size = Std.int(HXP.height / 15);
        _titleText.x = (HXP.width - _titleText.width) / 2;
        _titleText.y = (_board.y - _titleText.height) / 2;
        _titleText.setTextProperty("color", 0xFFFFFF);
        _titleText.alpha = 0.5;
        _titleText.align = TextFormatAlign.CENTER;

        addGraphic(_titleText);

        _prev = new Button("<-");
        _prev.y = _board.y + _board.height;
        _prev.callback = function() {
            if (_page > 0) {
                _page--;
                _board.load(_level, _page);
                _next.enable();
                if (_page == 0) {
                    _prev.disable();
                } else {
                    _prev.enable();
                }
            }
        }
        add(_prev);

        _next = new Button("->");
        _next.x = HXP.width - _next.width;
        _next.y = _prev.y;
        _next.callback = function() {
            if (_page < Std.int(_level / 36)) {
                 _page++;
                 _board.load(_level, _page);
                 _prev.enable();
                 if (_page == Std.int(_level / 36)) {
                     _next.disable();
                 } else {
                     _next.enable();
                 }
            }
        }
        add(_next);

        _mute = new Mute(Data.readBool("sound"));
        _mute.y = HXP.height - _mute.height * 1.25;
        _mute.x = _mute.width * 0.25;
        _mute.callback = function() {
            Data.write("sound", !Data.readBool("sound"));
            Data.save("tonesout");
        }
        add(_mute);
    }

    public override function begin() {
        //set latest level and page on board
        _level = Data.readInt("level");
        _page = Std.int(Data.readInt("level") / 36);
        _board.load(Data.readInt("level"), Std.int(Data.readInt("level") / 36));
        //_board.load(57, 1);
        //_level = 57;
        //_page = 1;
        _next.disable();
        if (_page > 0) {
            _prev.enable();
        } else {
            _prev.disable();
        }
        //set mute icon state
        _mute.set(Data.readBool("sound"));
    }

    public override function update():Void {
        super.update();

        if (Input.mouseReleased) {
            var e:Entity = collidePoint("board", Input.mouseX, Input.mouseY);
            var but:Entity = collidePoint("button", Input.mouseX, Input.mouseY);
            var m:Entity = collidePoint("mute", Input.mouseX, Input.mouseY);
            if (e != null) {
                if (_board.loading) {
                    return;
                }

                var b:SelectBoard = cast(e, SelectBoard);
                var level = b.clicked(Input.mouseX, Input.mouseY);
                if (level > -1) {
                    cast(HXP.engine, Main).changeScene("main", level);
                };
            } else if (m != null) {
                var mute:Mute = cast(m, Mute);
                mute.click();
            } else if (but != null) {
                var button:Button = cast(but, Button);
                button.click();
            }
        }
    }
}
