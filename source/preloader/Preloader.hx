package preloader;

#if sys
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.ui.FlxBar;
import flixel.util.FlxSignal;

class Preloader extends Obj
{
	public var label(default, null):String = 'Empty';

	public var assets(default, null):Int = 0;
	public var progress(default, null):Float = 0.0;

	public var currentTask(default, null):String = '';

	public var completeSignal(default, null):FlxSignal;

	public var done(default, set):Int = 0;

	private function set_done(done:Int):Int
	{
		this.done = done;

		if (done == assets && completeSignal != null) completeSignal.dispatch();

		return this.done;
	}

	override public function new(label, assets = 0)
	{
		super();

		this.label = label;
		this.assets = assets;

		completeSignal = new FlxSignal();
	}

	override function toString():String
	{
		return 'Preloader(label: $label, assets: $assets, done: $done, progress: $progress, currentTask: $currentTask)';
	}

	public function preload() {}

	public function performTask(process:Void->Void)
	{
		if (process == null) return;

		#if sys
		// Thread.create(function()
		// {
		#end
		process();
		done++;
		#if sys
		// });
		#end
	}
}
