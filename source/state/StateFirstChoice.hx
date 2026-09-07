package state;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import sprite.*;

class StateFirstChoice extends State
{
	private var colorBG:Sprite;

	private var sea1:FlxBackdrop;
	private var sea2:FlxBackdrop;

	private var blue:Sprite;
	private var yellow:Sprite;

	private var arrow:Sprite;

	private var selection:Int = 0;

	override public function create()
	{
		super.create();

		add(colorBG = new Sprite().makeGraphic(FlxG.width * 2,FlxG.height * 2, Color.SEA));
		colorBG.alpha = 0.25;

		add(sea1 = new FlxBackdrop('gray_sea-desat'));
		sea1.blend = MULTIPLY;
		sea1.alpha = 0.5;
		sea1.velocity.set(20, 0);

		add(sea2 = new FlxBackdrop('gray_sea-desat'));
		sea2.blend = MULTIPLY;
		sea2.alpha = 0.5;
		sea2.velocity.set(-20, 0);
		sea2.y += sea2.height / 2;


		add(blue = new Sprite().loadBitmapCacheGraphic('blue_vessel').scaleTo(4));
		add(yellow = new Sprite().loadBitmapCacheGraphic('yellow_vessel').scaleTo(4));
		add(arrow = new Sprite().loadBitmapCacheGraphic('white_arrow').scaleTo(4));

		blue.screenCenter();
		yellow.screenCenter();

		blue.shift(-2, 0, true);
		yellow.shift(2, 0, true);

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([A, LEFT]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			changeSelection(1);
	}

	private function changeSelection(amount = 0)
	{
		selection += amount;

		if (selection < 0)
			selection = 1;
		if (selection > 1)
			selection = 0;

		arrow.screenCenter();
		arrow.shift(0, -2, true);

		if (selection == 0)
			arrow.shift(-2, 0, true);
		else
			arrow.shift(2, 0, true);
	}
}
