package preloader;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.ui.FlxBar;
import flixel.util.FlxSignal;

class Preloader extends Obj
{
	public var assets(default, null):Int = 0;
	public var progress(default, null):Float = 0.0;

	public var currentTask(default, null):String = '';

	public var completeSignal(default, null):FlxSignal;

	private var done(default, null):Int = 0;

	private var progressBar:FlxBar;

	private var camera(default, null):FlxCamera;

	private function set_done(done:Int):Int
	{
		this.done = done;

		if (done == assets && completeSignal != null)
			completeSignal.dispatch();

		return this.done;
	}

	override public function new(assets = 0, ?camera:FlxCamera)
	{
		super();

		this.assets = assets;

		completeSignal = new FlxSignal();

		progressBar = new FlxBar(0, 0, LEFT_TO_RIGHT, Math.floor(FlxG.width * 0.8), 32, this, 'progress', 0, 1);
		progressBar.screenCenter(X);
		progressBar.y = FlxG.height - (progressBar.height * 2);

		this.camera = camera ?? FlxG.camera ?? null;
	}

	override function toString():String
	{
		return 'Preloader(assets: $assets, progress: $progress, currentTask: $currentTask)';
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		draw();
	}

	public function preload() {}

	public function draw()
	{
		if (progressBar != null && progressBar.visible && progressBar.exists)
		{
			progressBar.camera = camera;
			progressBar.draw();
		}
	}
}
