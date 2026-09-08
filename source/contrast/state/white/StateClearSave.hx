package contrast.state.white; // TODO: MOVE THIS OUT OF WHITE
//									   WHY IS OPTIONS NOT IN WHITE BUT THIS IS?

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

	override public function new(?forceBlue:Null<Bool>)
	{
		super();

		isBlue = Save.data.alliance == 0;
		if (forceBlue != null) isBlue = forceBlue;
	}

	override function create()
	{
		super.create();

		add(seaBG = new SeaBackdrop(Color.BLACK, FlxPoint.weak(isBlue ? -10 : 0, isBlue ? 0 : 10)));

		seaBG.seas(function(s, i)
		{
			s.blend = NORMAL;
			s.alpha = 0;

			FlxTween.tween(s, {alpha: 0.1}, 1, {ease: FlxEase.quintOut});
		});

		add(omniMan = new Text(0, 0, 0, (isBlue) ? 'IS THIS THE FINAL DECISION?' : 'Are you sure?', 32));
		omniMan.screenCenter();

		omniManCentered = omniMan.getPosition();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		tick++;

		omniMan.setPosition(omniManCentered.x + (Math.sin(tick * 0.025) * 15), omniManCentered.y + (Math.cos(tick * 0.00425) * 15));
	}
}
