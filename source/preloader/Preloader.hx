package preloader;

import flixel.util.FlxSignal;

class Preloader extends Obj
{
	public var assets(default, null):Int = 0;
	public var progress(default, null):Float = 0.0;

	public var completeSignal:FlxSignal;

	private var done(default, set):Int = 0;

	private function set_done(done:Int):Int
	{
		this.done = done;

		if (done == assets && completeSignal != null)
			completeSignal.dispatch();

		return this.done;
	}

	override public function new(assets = 0)
	{
		super();

		this.assets = assets;

		completeSignal = new FlxSignal();
	}

	override function toString():String
	{
		return 'Preloader(assets: $assets, progress: $progress)';
	}

	public function preload() {}
}
