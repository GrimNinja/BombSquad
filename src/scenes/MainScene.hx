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

class MainScene extends Scene
{
    public var lev:Int = 0;

    private var _board:Board;

    private var _levelText:Text;

    private var _back:Button;
    private var _reset:Reset;

    private var _mute:Mute;

    private var _free = false;

    private var _messages:Dynamic;
    private var _messageText:Text;

    public function new() {
        super();
        _board = new Board(6,6);
        add(_board);

        _levelText = new Text(Std.string(lev));
        _levelText.resizable = true;
        _levelText.size = Std.int(HXP.height / 12);
        _levelText.setTextProperty("color", 0xFFFFFF);
        _levelText.alpha = 0.5;
        _levelText.align = TextFormatAlign.CENTER;

        addGraphic(_levelText);

        _messages = haxe.Json.parse(openfl.Assets.getText("levels/messages.json"));

        _messageText = new Text("");
        _messageText.resizable = true;
        _messageText.size = Std.int(HXP.height / 25);
        _messageText.setTextProperty("color", 0xFFFFFF);
        _messageText.alpha = 0.5;
        _messageText.align = TextFormatAlign.CENTER;
        _messageText.y = _levelText.height;

        addGraphic(_messageText);

        _back = new Button("menu");
        _back.y = HXP.height - _back.height;
        _back.x = (HXP.width - _back.width) / 2;
        _back.callback = function() {
            cast(HXP.engine, Main).changeScene("select");
        }
        add(_back);

        _reset = new Reset();
        _reset.y = HXP.height - _reset.height * 1.25;
        _reset.x = HXP.width - _reset.width * 1.25;
        _reset.callback = function() {
            if (_free) {
                _board.reset();
                _board.load([]);
            } else {
                load(lev-1);
            }
        }
        add(_reset);

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
        super.begin();
        if (lev > -1) {
            _free = false;
            load(lev);
        } else {
            _free = true;
            _levelText.text = "free";
            _levelText.x = (HXP.width - _levelText.width) / 2;
            _board.reset();
            _board.load([]);
        }
        //set mute icon state
        _mute.set(Data.readBool("sound"));
    }

    public override function end() {
        _board.reset();
    }

    public override function update():Void {
        super.update();

        if (Input.released(com.haxepunk.utils.Key.ESCAPE)) {
            HXP.log("PRESSED!");
        }

        if (Input.mouseReleased) {
            var e:Entity = collidePoint("board", Input.mouseX, Input.mouseY);
            var b:Entity = collidePoint("button", Input.mouseX, Input.mouseY);
            var m:Entity = collidePoint("mute", Input.mouseX, Input.mouseY);
            var r:Entity = collidePoint("reset", Input.mouseX, Input.mouseY);
            if (e != null) {
                if (_board.loading || (!_free && _board.solved)) {
                    return;
                }

                var b:Board = cast(e, Board);
                b.clicked(Input.mouseX, Input.mouseY);

                if (!_free && b.solved) {
                    HXP.alarm(0.75, function(arg:Dynamic) {
                        if (lev == 60) {
                            cast(HXP.engine, Main).changeScene("select");
                        } else {
                            if (lev > Data.readInt("level")) {
                                Data.write("level", lev);
                                Data.save("tonesout");
                            }
                            load(lev);
                        }
                    });
                }
            } else if (b != null) {
                var button:Button = cast(b, Button);
                button.click();
            } else if (m != null) {
                var mute:Mute = cast(m, Mute);
                mute.click();
            } else if (r != null) {
                var reset:Reset = cast(r, Reset);
                reset.click();
            } else {
                return;
                //save level
                var ar = _board.save();
                var next = sys.FileSystem.readDirectory("../../../../../../../assets/levels/");
                sys.io.File.saveContent("../../../../../../../assets/levels/" + next.length + ".json", haxe.Json.stringify(ar));
            }
        }
    }

    public function load(level:Int) {
        if (_messages[lev] != null) {
            _messageText.text = _messages[lev];
            _messageText.x = (HXP.width - _messageText.width) / 2;
        } else {
            _messageText.text = "";
        }
        _board.reset();
        _board.load(haxe.Json.parse(openfl.Assets.getText("levels/" + Std.string(level) + ".json")));
        lev = level + 1;
        _levelText.text = Std.string(lev);
        _levelText.x = (HXP.width - _levelText.width) / 2;
    }

}
