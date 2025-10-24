/**

mp4OverlayPlayer.hx

Standalone Haxe class for Psych Engine 0.6 Mobile

Plays an MP4 as an overlay


Loop support


Blend mode support


Exposes simple static methods you can call from Lua using runHaxeCode()


Place this file in your project's source/ folder (e.g. source/mp4OverlayPlayer.hx)

Then call from Lua with runHaxeCode("MP4OverlayPlayer.play('assets/videos/your.mp4')")

Notes/compatibility:

Uses openfl.media.NetConnection/NetStream/Video to play mp4.


Adds the Video to the OpenFL stage so it sits above Flx objects (overlay).


Sets video.blendMode using openfl.display.BlendMode string values (e.g. "ADD", "MULTIPLY").


If your build/platform doesn't support NetStream playback of mp4, you'll need to adapt to your video solution. */



import openfl.display.Sprite; import openfl.display.Stage; import openfl.display.Bitmap; import openfl.display.BitmapData; import openfl.display.BlendMode; import openfl.media.NetConnection; import openfl.media.NetStream; import openfl.media.Video; import openfl.events.NetStatusEvent; import openfl.events.Event; import openfl.Lib; import flixel.FlxG;

class MP4OverlayPlayer {

public static var nc:NetConnection;
public static var ns:NetStream;
public static var video:Video;
public static var container:Sprite;
public static var isPlaying:Bool = false;
public static var loop:Bool = true;
public static var _blend:String = BlendMode.NORMAL;
public static var alpha:Float = 1.0;
public static var scaleX:Float = 1.0;
public static var scaleY:Float = 1.0;
public static var posX:Float = 0;
public static var posY:Float = 0;
public static var videoWidth:Int = 0;
public static var videoHeight:Int = 0;
public static var addedToStage:Bool = false;

public function new() {
	// not instantiable
}

/** Initialize OpenFL NetConnection and container if not yet created */
static function ensureInit():Void {
	if (nc != null) return;

	nc = new NetConnection();
	nc.connect(null);

	ns = new NetStream(nc);

	// client object to receive metadata and playStatus callbacks
	ns.client = {
		onMetaData: function(info:Dynamic):Void {
			// store dimensions if provided
			if (info != null) {
				if (Reflect.hasField(info, "width")) videoWidth = Std.int(info.width);
				if (Reflect.hasField(info, "height")) videoHeight = Std.int(info.height);
			}
		},
		onPlayStatus: function(info:Dynamic):Void {
			// sometimes playback end status arrives here
			if (info != null && Reflect.hasField(info, "code")) {
				var code = info.code;
				if (code == "NetStream.Play.Complete" || code == "NetStream.Play.Stop") {
					if (loop) {
						ns.seek(0);
						ns.resume();
					} else {
						stop();
					}
				}
			}
		}
	};

	ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);

	video = new Video();
	video.smoothing = true;
	video.attachNetStream(ns);

	container = new Sprite();
	container.addChild(video);

	// default blending
	setBlendMode(_blend);

	// add to stage above game
	addToStageIfNeeded();
}

static function addToStageIfNeeded():Void {
	if (addedToStage) return;
	if (Lib.current != null && Lib.current.stage != null) {
		FlxG.stage.addChild(container);
		addedToStage = true;
		// update every frame to keep transform in sync
		FlxG.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
}

static function onNetStatus(e:NetStatusEvent):Void {
	// handle some end states
	var code:String = e.info != null && Reflect.hasField(e.info, "code") ? e.info.code : "";
	if (code == "NetStream.Play.Stop" || code == "NetStream.Play.Complete") {
		if (loop) {
			ns.seek(0);
			ns.resume();
		} else {
			stop();
		}
	}
}

static function onEnterFrame(e:Event):Void {
	if (container == null) return;
	container.alpha = alpha;
	container.x = posX;
	container.y = posY;
	container.scaleX = scaleX;
	container.scaleY = scaleY;
	// ensure blend mode applied
	video.blendMode = _blend;
}

/** Play a file. path should be relative to assets or a valid URL. */
public static function play(path:String):Void {
	ensureInit();
	try {
		// NetStream expects a path without the project asset prefix when streaming from local assets
		ns.play(path);
		isPlaying = true;
		addToStageIfNeeded();
	} catch (err:Dynamic) {
		trace('MP4OverlayPlayer.play error: ' + err);
	}
}

public static function stop():Void {
	if (ns != null) {
		ns.pause();
		ns.close();
	}
	isPlaying = false;
}

public static function setLoop(b:Bool):Void {
	loop = b;
}

/** Accepts BlendMode strings: "NORMAL", "ADD", "MULTIPLY", "SCREEN", etc. */
public static function setBlendMode(mode:String):Void {
	_blend = mode;
	if (video != null) video.blendMode = _blend;
}

public static function setAlpha(a:Float):Void {
	alpha = Math.max(0, Math.min(1, a));
}

public static function setPosition(x:Float, y:Float):Void {
	posX = x;
	posY = y;
}

public static function setScale(sx:Float, sy:Float):Void {
	scaleX = sx;
	scaleY = sy;
}

/** Convenience: set size in pixels (will calculate scale relative to video natural size if metadata available) */
public static function setSize(px:Int, py:Int):Void {
	if (videoWidth > 0 && videoHeight > 0) {
		scaleX = px / videoWidth;
		scaleY = py / videoHeight;
	} else {
		// unknown natural size yet; set video display size directly
		video.width = px;
		video.height = py;
	}
}

/** Remove overlay completely */
public static function destroy():Void {
	if (addedToStage && container != null) {
		FlxG.stage.removeChild(container);
		addedToStage = false;
	}
	if (ns != null) {
		ns.close();
		ns = null;
	}
	nc = null;
	video = null;
	container = null;
	isPlaying = false;
}

}