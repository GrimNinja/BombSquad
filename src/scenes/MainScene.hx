package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import game.*;

class MainScene extends Scene
{
    private var lev:Int = 0;

    private var _board:Board;
    public override function begin() {
        _board = new Board(6, 6);
        add(_board);
    }

    public override function update():Void {
        super.update();

        if (Input.mouseReleased) {
            var e:Entity = collidePoint("board", Input.mouseX, Input.mouseY);
            if (e != null) {
                var b:Board = cast(e, Board);
                b.clicked(Input.mouseX, Input.mouseY);

                if (b.solved) {
                    _board.load(haxe.Json.parse(openfl.Assets.getText("levels/" + Std.string(lev) + ".json")));
                    lev++;
                    if (lev > 30) {
                        lev = 0;
                    }
                }
            } else {
                _board.load(haxe.Json.parse(openfl.Assets.getText("levels/" + Std.string(lev) + ".json")));
                lev++;
                if (lev > 30) {
                    lev = 0;
                }
                return;
                //save level
                var ar = _board.save();
                var next = sys.FileSystem.readDirectory("../../../../../../../assets/levels/");
                sys.io.File.saveContent("../../../../../../../assets/levels/" + next.length + ".json", haxe.Json.stringify(ar));
            }
        }
    }
}
