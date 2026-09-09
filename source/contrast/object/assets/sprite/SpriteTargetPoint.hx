package contrast.object.assets.sprite;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSignal;

class SpriteTargetPoint extends Sprite
{
	public var onSelection(default, null):FlxSignal = new FlxSignal();

	public var vessel(default, null):FlxObject;

	override public function new(color:String, vessel:FlxObject, x = 0.0, y = 0.0)
	{
		super();

		loadBitmapCacheGraphic('${color}_targetpoint');
		scaleTo(2);

		this.vessel = vessel;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (vessel != null) if (vessel.overlaps(this) && FlxG.keys.justPressed.ENTER) onSelection.dispatch();
	}
}
