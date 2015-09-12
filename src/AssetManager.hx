import openfl.display.BitmapData;
import openfl.system.Capabilities;
import openfl.display.Shape;
import openfl.media.Sound;
import format.SVG;
import com.haxepunk.HXP;
/**
 * ...
 * @author Roy Brunton
 */
class AssetManager {

    private var _bitmapData : Map<String, BitmapData> = new Map<String, BitmapData>();
    private var _soundData : Map<String, Sound> = new Map<String, Sound>();
    private var _cm_to_pixel:Float = Capabilities.screenDPI / 2.54;
    private var _screen_scale:Float= HXP.height / 640;

    public function new() {

    }

  //asset array elements name:String, path:String, frames:Int, scale:Float
    public function load(assets:Array<Array<Dynamic>>, cb:Float -> Void = null) {
        var progress:Float = 0;

        for (asset in assets) {
            _load(asset[0], asset[1], asset[2], asset[3]);
            progress++;

            if (cb != null) cb(progress / assets.length);
        }

    }

    public function loadsound(name:String, path:String = null) {
        if (path == null) {
            path = "audio/" + name + ".wav";
        } else {
            path = path + "/" + name + ".wav";
        }

         var sound:Sound = openfl.Assets.getSound(path);

         _soundData.set(name, sound);
    }

    private function _load(name:String, path:String = null, frames:Int = 1, scale:Float = 1.0) {
        if (path == null) {
            path = "graphics/" + name + ".svg";
        } else {
            path = path + "/" + name + ".svg";
        }

        var svg : SVG = new SVG(openfl.Assets.getText(path));

        if (svg.data.width > 2) {
            trace("Asset " + name + " tooo big!");
        }

        var x:Int = Std.int(svg.data.width * scale);
        var y:Int = Std.int((svg.data.height * scale) / frames) * frames;

        var shape = new Shape();
        svg.render(shape.graphics, 0, 0, x, y);
        var bitmap = new BitmapData(x, y, true, 0x0);
        bitmap.draw(shape);

        _bitmapData.set(name, bitmap);
    }

    public function clear() {
        for (key in _bitmapData.keys()) {
            _bitmapData.remove(key);
        }
        _bitmapData = null;
    }

    public function get(asset:String) : BitmapData {
        if (_bitmapData.exists(asset)) {
            return _bitmapData.get(asset);
        } else {
            //missing asset, log error
            return null;
        }
    }

    public function getsound(asset:String) : Sound {
        if (_soundData.exists(asset)) {
            return _soundData.get(asset);
        } else {
            return null;
        }
    }
}
