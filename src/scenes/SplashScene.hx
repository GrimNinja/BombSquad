package scenes;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.ColorTween;
import openfl.display.BitmapData;

/**
 * ...
 * @author Roy Brunton
 */
class SplashScene extends Scene {

    private var splash:Spritemap;

    private var blink_time:Float = 0.5;
    private var start_time:Float = 2;

    private var fade:ColorTween;

    public function new() {
        super();
    }

    override public function begin() {
        super.begin();

        var sprite_sheet:BitmapData = cast(HXP.engine, Main).assets.get("splash");
        splash = new Spritemap(sprite_sheet, sprite_sheet.width, Std.int(sprite_sheet.height / 2));
        splash.add("normal", [0]);
        splash.add("blink", [0, 1, 0, 1, 0], 10, false);
        splash.centerOrigin();

        splash.x = HXP.halfWidth;
        splash.y = HXP.halfHeight;

        splash.alpha = 0;

        addGraphic(splash);

        HXP.alarm(0.5, fadeIn, TweenType.OneShot);
    }

    override public function end() {
        super.end();

        removeAll();
        splash = null;
        fade = null;
    }

    override public function update() {
        super.update();

        if (fade != null) splash.alpha = fade.alpha;
    }

    private function fadeInComplete(arg:Dynamic) {
        HXP.alarm(blink_time, blink, TweenType.OneShot);
    }

    private function fadeOutComplete(ar:Dynamic) {
        //change scene
        cast(HXP.engine, Main).changeScene("menu");
    }

    private function fadeIn(arg:Dynamic) {
        fade = new ColorTween(fadeInComplete, TweenType.OneShot);
        fade.tween(0.5, 0, 0, 0, 1);
        addTween(fade, true);
    }

    private function fadeOut(arg:Dynamic) {
        fade = new ColorTween(fadeOutComplete, TweenType.OneShot);
        fade.tween(0.5, 0, 0, 1, 0);
        addTween(fade, true);
    }

    private function blink(arg:Dynamic) {
        splash.play("blink");

        HXP.alarm(start_time, fadeOut, TweenType.OneShot);
    }
}
