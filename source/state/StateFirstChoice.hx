package state;

import sprite.*;

class StateFirstChoice extends State
{
	private var blue:Sprite;
	private var yellow:Sprite;

	private var arrow:Sprite;

	override public function create()
	{
		super.create();

		add(blue = new Sprite().loadBitmapCacheGraphic('blue_vessel').scaleTo(4));
		add(yellow = new Sprite().loadBitmapCacheGraphic('yellow_vessel').scaleTo(4));
		add(arrow = new Sprite().loadBitmapCacheGraphic('white_arrow').scaleTo(4));

		blue.screenCenter();
		yellow.screenCenter();
		arrow.screenCenter();

		blue.shift(-2, 0, true);
		yellow.shift(2, 0, true);
		arrow.shift(0, -2, true);
	}
}
