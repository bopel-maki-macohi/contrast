package contrast.state;

import flixel.FlxG;

class StateMovingUser extends State
{
	private var user(default, null):SpriteVessel;
	private var userSpeed(default, null):Float = 4.0;

	override function create()
	{
		super.create();

		add(user = new SpriteVessel('white'));
		user.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyPressed([W, UP]))
		{
			user.state = WALK;
			user.y -= userSpeed;
		}
		else if (FlxG.keys.anyPressed([S, DOWN]))
		{
			user.state = WALK;
			user.y += userSpeed;
		}

		if (FlxG.keys.anyPressed([A, LEFT]))
		{
			user.state = WALK_SIDE;
			user.x -= userSpeed;
		}
		else if (FlxG.keys.anyPressed([D, RIGHT]))
		{
			user.state = WALK_SIDE;
			user.x += userSpeed;
		}

		if (FlxG.keys.anyJustReleased([W, UP, S, DOWN])) user.state = IDLE;
		if (FlxG.keys.anyJustReleased([A, LEFT, D, RIGHT])) user.state = IDLE_SIDE;
	}
}
