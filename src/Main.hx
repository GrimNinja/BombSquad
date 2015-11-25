import com.haxepunk.Engine;
import com.haxepunk.HXP;
import openfl.system.Capabilities;
import scenes.SplashScene;
import scenes.MenuScene;

class Main extends Engine
{
    private var _assetManager:AssetManager;

    public var assets(get, null):AssetManager;
    private inline function get_assets():AssetManager { return _assetManager; }

    override public function init() {

        HXP.stage.addEventListener(openfl.events.KeyboardEvent.KEY_UP, key_up);

        maxElapsed = 0.1;
        _assetManager = new AssetManager();
        _assetManager.load([["splash", null, 2, HXP.width / 2]]);

        //load graphics here for now
        _assetManager.load([["bomb", "graphics/game", 2, HXP.width / 6]]);
        //load sound here for now too
        _assetManager.loadsound("tone");

        HXP.randomizeSeed();

#if debug
        HXP.console.enable();
        HXP.scene = new MenuScene();
#else
        HXP.scene = new SplashScene();
#end
    }

    override public function focusLost () {
        HXP.scene = new MenuScene();
    }

    private function key_up(e:openfl.events.KeyboardEvent) {
         //HXP.log(Std.string(e.keyCode));
         e.stopImmediatePropagation();
    }

    public static function main() { new Main(); }

}
