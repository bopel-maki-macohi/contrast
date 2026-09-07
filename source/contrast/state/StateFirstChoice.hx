package contrast.state;

import flixel.FlxG;

class StateFirstChoice extends State
{
	private var seaBG:SeaBackdrop;

	private var blue:Sprite;
	private var yellow:Sprite;

	private var arrow:Sprite;

	private var selection:Int = 0;

	private var DEVICE_COMPILING:Audio = new Audio('sound:DEVICE_COMPILING.ogg');
	private var DEVICE_PROCESSING:Audio = new Audio('sound:DEVICE_PROCESSING.ogg');

	override public function create()
	{
		super.create();

		DEVICE_COMPILING.looped = true;
		DEVICE_COMPILING.volume = 0.125;
		DEVICE_COMPILING.play();

		DEVICE_PROCESSING.looped = true;
		DEVICE_PROCESSING.volume = 0.25;
		DEVICE_PROCESSING.play();

		add(seaBG = new SeaBackdrop(Color.SEA));

		add(blue = new Sprite().loadBitmapCacheGraphic('blue_vessel').scaleTo(4));
		add(yellow = new Sprite().loadBitmapCacheGraphic('yellow_vessel').scaleTo(4));
		add(arrow = new Sprite().loadBitmapCacheGraphic('arrow').scaleTo(4));

		blue.screenCenter();
		yellow.screenCenter();

		blue.shift(-2, 0, true);
		yellow.shift(2, 0, true);

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([A, LEFT])) changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT])) changeSelection(1);
	}

	private function changeSelection(amount = 0)
	{
		selection += amount;

		if (selection < 0) selection = 1;
		if (selection > 1) selection = 0;

		arrow.screenCenter();
		arrow.shift(0, -2, true);

		if (selection == 0) arrow.shift(-2, 0, true);
		else arrow.shift(2, 0, true);
	}
}
