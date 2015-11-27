package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Data;
import game.*;
import ui.*;

class MainScene extends Scene
{
    public var lev:Int = 0;

    private var _board:Board;

    private var _levelText:Text;

    private var _back:Button;
    private var _reset:Button;

    public function new() {
        super();
        _board = new Board(6,6);
        add(_board);

        _levelText = new Text(Std.string(lev));
        _levelText.resizable = true;
        _levelText.size = Std.int(HXP.height / 12);
        _levelText.setTextProperty("color", 0xFFFFFF);
        _levelText.alpha = 0.25;

        addGraphic(_levelText);

        _back = new Button("<-");
        _back.y = HXP.height - _back.height;
        _back.callback = function() {
            cast(HXP.engine, Main).changeScene("select");
        }
        add(_back);

        _reset = new Button("*");
        _reset.y = HXP.height - _reset.height;
        _reset.x = HXP.width - _reset.width;
        _reset.callback = function() {
            load(lev-1);
        }
        add(_reset);
    }

    public override function begin() {
        super.begin();
        load(lev);
    }

    public override function end() {
        _board.reset();
    }

    public override function update():Void {
        super.update();

        if (Input.released(com.haxepunk.utils.Key.ESCAPE)) {
            HXP.log("PRESSED!");
        }

        if (_board.loading || _board.solved) {
            return;
        }

        if (Input.mouseReleased) {
            var e:Entity = collidePoint("board", Input.mouseX, Input.mouseY);
            var b:Entity = collidePoint("button", Input.mouseX, Input.mouseY);
            if (e != null) {
                var b:Board = cast(e, Board);
                b.clicked(Input.mouseX, Input.mouseY);

                if (b.solved) {
                    HXP.alarm(0.75, function(arg:Dynamic) {
                        if (lev == 31) {
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
        _board.reset();
        _board.load(haxe.Json.parse(openfl.Assets.getText("levels/" + Std.string(level) + ".json")));
        _levelText.text = "Level " + Std.string(level);
        lev = level + 1;
    }

}
