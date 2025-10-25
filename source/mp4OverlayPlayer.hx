package;

#if VIDEOS_ALLOWED
import openfl.display.BlendMode;
import flixel.FlxCamera;
import flixel.FlxG;
import PlayState;

/**
 * MP4 Overlay Player for Psych Engine Mobile 0.6.3
 * Works with polybiusproxy/hxCodec
 * Supports overlay video playback and looping additive videos.
 */
class mp4OverlayPlayer
{
    public static var overlay1:Dynamic = null;
    public static var overlay2:Dynamic = null;

    public static function playOverlayVideo(name:String, ?loop:Bool = true, ?blend:String = "add"):Void
    {
        var ps = PlayState.instance;
        if (ps == null)
        {
            trace("[mp4OverlayPlayer] PlayState not active.");
            return;
        }

        try
        {
            // Clean existing overlay
            if (overlay1 != null)
            {
                Reflect.callMethod(overlay1, Reflect.field(overlay1, "stop"), []);
                ps.remove(overlay1);
                overlay1 = null;
            }

            var path = Paths.video(name);
            var MP4HandlerClass = Type.resolveClass("MP4Handler"); // new hxCodec auto-registers this globally
            if (MP4HandlerClass == null)
            {
                trace("[mp4OverlayPlayer] MP4Handler not found (hxCodec missing or outdated).");
                return;
            }

            overlay1 = Type.createInstance(MP4HandlerClass, [path, loop]);
            if (Reflect.hasField(overlay1, "cameras"))
                Reflect.setField(overlay1, "cameras", [ps.camOther]);
            if (Reflect.hasField(overlay1, "blend"))
                Reflect.setField(overlay1, "blend", blend);

            Reflect.callMethod(overlay1, Reflect.field(overlay1, "play"), []);
            ps.add(overlay1);

            trace("[mp4OverlayPlayer] Playing overlay video: " + name);
        }
        catch (e:Dynamic)
        {
            trace("[mp4OverlayPlayer] Failed to play overlay video: " + e);
        }
    }

    public static function stopOverlayVideo():Void
    {
        var ps = PlayState.instance;
        if (overlay1 != null)
        {
            Reflect.callMethod(overlay1, Reflect.field(overlay1, "stop"), []);
            ps.remove(overlay1);
            overlay1 = null;
            trace("[mp4OverlayPlayer] Stopped overlay video.");
        }
    }
}
#end
