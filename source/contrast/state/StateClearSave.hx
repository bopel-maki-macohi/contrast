package contrast.state;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class StateClearSave extends SubState
{
	private var isBlue(default, null):Bool;

	private var seaBG(default, null):SeaBackdrop;

	/**
	 * Are you sure?
	 */
	private var omniMan(default, null):Text;

	private var omniManCentered(default, null):FlxPoint;

	private var tick(default, null):Int = 0;

	private var camFollow(default, null):FlxObject;

	private var startInput(default, null):Bool = true;

	override public function new(camFollow:FlxObject, ?forceBlue:Null<Bool>)
	{
		super();

		isBlue = Save.data.alliance == 0;
		if (forceBlue != null) isBlue = forceBlue;

		this.camFollow = camFollow;
	}

	override function create()
	{
		super.create();

		add(seaBG = new SeaBackdrop(Color.BLACK, FlxPoint.weak(isBlue ? -800 : 0, isBlue ? 0 : 800)));

		seaBG.seas(function(s, i)
		{
			s.blend = NORMAL;
			s.alpha = 0;

			FlxTween.tween(s, {alpha: 0.1}, 1, {ease: FlxEase.quintOut});
		});

		add(omniMan = new Text(0, 0, 0,
			(isBlue) ? 'IS THIS THE FINAL DECISION?\n\nESCAPE : NO\nENTER : YES' : 'Are you sure?\n\nEscape for No and Enter for Yes.', 32));
		omniMan.screenCenter();

		omniManCentered = omniMan.getPosition();
		if (camFollow != null) camFollow.setPosition(omniManCentered.x, omniManCentered.y);

		startInput = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		tick++;

		omniMan.setPosition(omniManCentered.x + (Math.sin(tick * 0.025) * 15), omniManCentered.y + (Math.cos(tick * 0.00425) * 15));

		if (FlxG.keys.justReleased.ANY)
		{
			if (startInput)
			{
				startInput = FlxG.keys.pressed.ANY;
				return;
			}

			if (FlxG.keys.justReleased.ESCAPE || FlxG.keys.justReleased.ENTER)
			{
				if (FlxG.keys.justReleased.ENTER)
				{
					Save.data = null;
					Save.create();
				}

				close();
			}
		}
	}
}
