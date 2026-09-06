package state;

import flixel.FlxState;
import sprite.*;

class StateStarting extends State
{
	private var blue:SpriteColorable;
	private var yellow:SpriteColorable;

	override public function create()
	{
		super.create();

		add(blue = new SpriteColorable().loadBitmapCacheGraphic('${Color.BLUE}_vessel').scaleTo(4));
		add(yellow = new SpriteColorable().loadBitmapCacheGraphic('${Color.YELLOW}_vessel').scaleTo(4));

		blue.screenCenter();
		yellow.screenCenter();

		blue.shift(-2, 0, true);
		yellow.shift(2, 0, true);
	}
}
