package contrast.state.blue;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class BlueStart extends State
{
	private var prison:Sprite;
	private var prisonSize:Float = 100.0;
	private var prisonSizeTarget:Float = 2.0;
	private var prisonScaleLerpValue:Float = 0.0;

	override function create()
	{
		super.create();

		new Audio('sound:DEVICE_SOUL_TRANSFER.ogg').play();

		add(prison = new Sprite().loadBitmapCacheGraphic('blue_box').scaleTo(prisonSize));

		FlxTween.num(0, 1, 30, {ease: FlxEase.quintIn}, (t) -> prisonScaleLerpValue = t);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		prison.scaleTo(prisonSize = FlxMath.lerp(prisonSize, prisonSizeTarget, prisonScaleLerpValue));
		prison.screenCenter();
	}
}
