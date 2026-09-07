package audio;

import flixel.util.FlxSignal;
import flixel.FlxG;
import data.DataLoader;
import flixel.sound.FlxSound;
import lime.utils.Assets;

class Audio extends DataLoader<FlxSound>
{
	public var onComplete:FlxSignal;

	public var volume(get, set):Float;

	private function get_volume():Float
	{
		return data?.volume ?? 0.0;
	}

	private function set_volume(volume:Float):Float
	{
		if (data == null) return 0;

		return data.volume = volume;
	}

	public var playing(get, null):Bool;

	private function get_playing():Bool
	{
		return data.playing;
	}

	public var looped(get, set):Bool;

	private function get_looped():Bool
	{
		return data.looped;
	}

	private function set_looped(looped:Bool):Bool
	{
		if (data == null) return false;

		return data.looped = looped;
	}

	override public function new(?path:String)
	{
		super(null);

		if (path != null) load(path);
	}

	override function toString():String
	{
		return 'Audio(path: $path, volume: $volume, playing: $playing, looped: $looped)';
	}

	override function load(path:String)
	{
		reset();

		super.load(path);

		if (Assets.exists(path))
		{
			this.path = path;

			data = new FlxSound().load(path);
			data.autoDestroy = false;
			FlxG.sound.list.add(data);
		}
	}

	override function reset()
	{
		FlxG.sound.list.remove(data);
		super.reset();
	}

	public function play(forceRestart = false, start = 0.0, ?end:Float)
	{
		if (data != null)
		{
			if (onComplete == null) onComplete = new FlxSignal();

			data.onComplete = onComplete.dispatch;

			data.play(forceRestart, start, end);
		}
	}

	public function loadAndPlay(path:String)
	{
		load(path);

		if (data != null) play();
	}

	public function stop()
	{
		if (data != null) data.stop();
	}
}
