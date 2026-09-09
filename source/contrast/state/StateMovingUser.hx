package contrast.state;

import flixel.FlxG;

class StateMovingUser extends State
{
	private var user(default, null):SpriteVessel;
	private var userSpeed(default, null):Float = 4.0;

	private var location(default, null):Array<Int> = [0, 0];
	private var maxLocation(default, null):Array<Int> = [1, 1];

	override function create()
	{
		super.create();

		add(user = new SpriteVessel('white'));
		user.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		applyUserControls();
	}

	private function applyUserControls()
	{
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
			if (user.state != WALK) user.state = WALK_SIDE;
			user.x -= userSpeed;
		}
		else if (FlxG.keys.anyPressed([D, RIGHT]))
		{
			if (user.state != WALK) user.state = WALK_SIDE;
			user.x += userSpeed;
		}

		if (FlxG.keys.anyJustReleased([W, UP, S, DOWN])) user.state = IDLE;
		if (FlxG.keys.anyJustReleased([A, LEFT, D, RIGHT])) user.state = IDLE_SIDE;

		applyUserBoundaries();
	}

	private function applyUserBoundaries()
	{
		if (user.x < 0)
		{
			if (location[0] - 1 < -maxLocation[0]) user.x = 0;
			else if (user.x < -user.width)
			{
				location[0]--;
				user.x = FlxG.width + user.width;

				onSectorChange(location[0], location[1]);
			}
		}

		if (user.x > FlxG.width)
		{
			if (location[0] + 1 > maxLocation[0]) user.x = FlxG.width;
			else if (user.x > FlxG.width + user.width)
			{
				location[0]++;
				user.x = -user.width;

				onSectorChange(location[0], location[1]);
			}
		}
		if (user.y < 0)
		{
			if (location[1] - 1 < -maxLocation[1]) user.y = 0;
			else if (user.y < -user.height)
			{
				location[1]--;
				user.y = FlxG.height + user.height;

				onSectorChange(location[0], location[1]);
			}
		}

		if (user.y > FlxG.height)
		{
			if (location[1] + 1 > maxLocation[1]) user.y = FlxG.height;
			else if (user.y > FlxG.height + user.height)
			{
				location[1]++;
				user.y = -user.height;

				onSectorChange(location[0], location[1]);
			}
		}
	}

	private function onSectorChange(x:Int, y:Int) {}
}
