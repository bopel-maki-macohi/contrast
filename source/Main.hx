import flixel.FlxG;
import openfl.events.Event;
import flixel.FlxGame;
import preloader.*;
import state.*;

class Main extends FlxGame
{
	public function new()
	{
		super(0, 0, null);
	}

	override function create(_:Event)
	{
		Save.create();

		super.create(_);

		new PreloaderAssets().preload();

		FlxG.switchState(() -> new StateStarting());
	}
}
