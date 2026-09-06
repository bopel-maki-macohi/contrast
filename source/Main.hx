import openfl.events.Event;
import flixel.FlxGame;

class Main extends FlxGame
{
	public function new()
	{
		super(0, 0, StartingState);
	}

	override function create(_:Event)
	{
		Save.create();

		super.create(_);
	}
}
