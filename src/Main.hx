import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Gesture;
import openfl.system.Capabilities;
import scenes.SplashScene;
import scenes.MainScene;

class Main extends Engine
{
    private var _assetManager:AssetManager;

    public var assets(get, null):AssetManager;
    private inline function get_assets():AssetManager { return _assetManager; }

    override public function init() {
        _assetManager = new AssetManager();
        _assetManager.load([["splash", null, 2, true]]);

        Gesture.enable();
        HXP.randomizeSeed();

#if debug
        HXP.console.enable();
        HXP.scene = new MainScene();
#else
        HXP.scene = new SplashScene();
#end
    }

    public static function main() { new Main(); }

}
