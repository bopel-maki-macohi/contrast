package contrast.state.blue;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class BlueMenu extends State
{
	private var introComplete = false;

	private var prison:Sprite;
	private var prisonSize:Float = 100.0;
	private var prisonSizeTarget:Float = 2.0;
	private var prisonScaleLerpValue:Float = 0.0;

	private var user:SpriteVessel;

	private var DEVICE_SOUL_TRANSFER:Audio;

	override function create()
	{
		super.create();

		DEVICE_SOUL_TRANSFER = new Audio('sound:DEVICE_SOUL_TRANSFER.ogg');
		DEVICE_SOUL_TRANSFER.play();

		add(user = new SpriteVessel('white'));
		user.screenCenter();
		user.state = SPIN;

		add(prison = new Sprite().loadBitmapCacheGraphic('blue_box').scaleTo(prisonSize));

		FlxTween.num(0, 1, 20, {
			ease: FlxEase.quintIn,
			onComplete: function(t)
			{
				introComplete = true;
			},
			onUpdate: function(t)
			{
				if (FlxG.keys.justPressed.ENTER)
				{
					DEVICE_SOUL_TRANSFER.time = DEVICE_SOUL_TRANSFER.length * 0.99;
					t.percent = 99;
				}
			},
		}, function(t)
		{
			prisonScaleLerpValue = t;
			user.alpha = t;
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		prison.scaleTo(prisonSize = FlxMath.lerp(prisonSize, prisonSizeTarget, prisonScaleLerpValue));
		prison.screenCenter();

		if (introComplete) {}
	}
}
