package contrast.object.preloader;

import flixel.util.FlxSignal;

class Preloader extends Obj
{
	@:allow(Main)
	public static var taskMultiplier(default, null):Int = 1;

	public var label(default, null):String = 'Empty';

	public var assets(default, null):Int = 0;
	public var progress(default, null):Float = 0.0;

	public var currentTask(default, null):String = '';

	public var completeSignal(default, null):FlxSignal;

	public var tickSignal(default, null):FlxSignal;

	public var done(default, set):Int = 0;

	private function set_done(done:Int):Int
	{
		this.done = done;

		if (tickSignal != null) tickSignal.dispatch();

		if (done == assets)
		{
			currentTask = 'Done!';
			if (completeSignal != null) completeSignal.dispatch();
		}

		return this.done;
	}

	override public function new(label, assets = 0)
	{
		super();

		this.label = label;
		this.assets = assets * taskMultiplier;

		tickSignal = new FlxSignal();
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

		process();
		done++;
	}
}
