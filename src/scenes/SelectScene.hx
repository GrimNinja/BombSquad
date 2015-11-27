package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Data;
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

    public function new() {
        super();

        _board = new SelectBoard(6,6);
        add(_board);

        _back = new Button("menu");
        _back.x = (HXP.width - _back.width) / 2;
        _back.y = HXP.height - _back.height;
        _back.callback = function() {
            cast(HXP.engine, Main).changeScene("menu");
        }
        add(_back);

        _prev = new Button("<-");
        _prev.y = _back.y;
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
        _next.y = _back.y;
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
    }

    public override function update():Void {
        super.update();

        if (_board.loading) {
            return;
        }

        if (Input.mouseReleased) {
            var e:Entity = collidePoint("board", Input.mouseX, Input.mouseY);
            var but:Entity = collidePoint("button", Input.mouseX, Input.mouseY);
            if (e != null) {
                var b:SelectBoard = cast(e, SelectBoard);
                var level = b.clicked(Input.mouseX, Input.mouseY);
                if (level > -1) {
                    cast(HXP.engine, Main).changeScene("main", level);
                };
            } else if (but != null) {
                var button:Button = cast(but, Button);
                button.click();
            }
        }
    }
}
