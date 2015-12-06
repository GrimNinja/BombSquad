import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Data;
import openfl.system.Capabilities;
import scenes.SplashScene;
//import scenes.MenuScene;
import scenes.MainScene;
import scenes.SelectScene;

class Main extends Engine
{
    private var _assetManager:AssetManager;

    private var splashScene:SplashScene;
    //private var menuScene:MenuScene;
    private var mainScene:MainScene;
    private var selectScene:SelectScene;

    public var assets(get, null):AssetManager;
    private inline function get_assets():AssetManager { return _assetManager; }

    override public function init() {

        HXP.stage.addEventListener(openfl.events.KeyboardEvent.KEY_UP, key_up);

        Data.load("tonesout");

        maxElapsed = 0.1;
        _assetManager = new AssetManager();
        _assetManager.load([["splash", null, 2, HXP.width / 2]]);

        //load graphics here for now
        _assetManager.load([["bomb", "graphics/game", 2, HXP.width / 6]]);
        //load sound here for now too
        _assetManager.loadsound("tone");

        HXP.randomizeSeed();

        mainScene = new MainScene();
        selectScene = new SelectScene();
        //menuScene = new MenuScene();
        splashScene = new SplashScene();

#if debug
        HXP.console.enable();
        HXP.scene = selectScene;
#else
        HXP.scene = splashScene;
#end
    }

    public function changeScene(scene:String, data:Dynamic = null) {
        switch(scene) {
            case "main":
                var level = cast(data != null ? data : 0, Int);
                mainScene.lev = level;
                HXP.scene = mainScene;
            //case "menu":
                //HXP.scene = menuScene;
            case "select":
                HXP.scene = selectScene;
            default:
                HXP.scene = selectScene;
        }
    }

    override public function focusLost () {
        //HXP.scene = menuScene;
    }

    private function key_up(e:openfl.events.KeyboardEvent) {
         e.stopImmediatePropagation();
    }

    public static function main() { new Main(); }

}
