package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import game.*;

class MainScene extends Scene
{
    private var _board:Board;
	public override function begin() {
        _board = new Board(6, 8);
        add(_board);
	}

    public override function update():Void {
        super.update();

        if (Input.mouseReleased) {
            var e:Entity = collidePoint("board", Input.mouseX, Input.mouseY);
            if (e != null) {
                var b:Board = cast(e, Board);
                b.clicked(Input.mouseX, Input.mouseY);
            }
        }
    }
}
