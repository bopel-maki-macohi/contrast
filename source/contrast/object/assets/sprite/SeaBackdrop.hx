package contrast.object.assets.sprite;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxObject;

class SeaBackdrop extends FlxObject
{
	public var colorBG(default, null):Sprite;

	public var sea1(default, null):FlxBackdrop;
	public var sea2(default, null):FlxBackdrop;

	override public function new(color:Color, ?sea1Velocity:FlxPoint, ?sea2Velocity:FlxPoint)
	{
		super();

		if (color != BLACK)
		{
			colorBG = new Sprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, color);
			colorBG.alpha = 0.25;
		}

		sea1 = new FlxBackdrop('image:sea-desat.png');
		sea1.blend = MULTIPLY;
		sea1.alpha = 0.5;
		sea1.velocity.set(20, 0);

		sea2 = new FlxBackdrop('image:sea-desat.png');
		sea2.blend = MULTIPLY;
		sea2.alpha = 0.5;
		sea2.velocity.set(-20, 0);
		sea2.y += sea2.height / 2;

		if (sea1Velocity != null) sea1.velocity.set(sea1Velocity.x, sea1Velocity.y);

		if (sea2Velocity != null) sea2.velocity.set(sea2Velocity.x, sea2Velocity.y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (colorBG != null) colorBG.update(elapsed);
		if (sea1 != null) sea1.update(elapsed);
		if (sea2 != null) sea2.update(elapsed);
	}

	override function draw()
	{
		super.draw();

		for (obj in [colorBG, sea1, sea2])
		{
			if (obj != null && obj.visible && obj.exists)
			{
				obj.camera = camera;
				obj.draw();
			}
		}
	}

	public function seas(method:FlxBackdrop->Int->Void)
	{
		method(sea1, 0);
		method(sea2, 1);
	}
}
