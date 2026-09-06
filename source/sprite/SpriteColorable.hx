package sprite;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class SpriteColorable extends Sprite
{
	override function scaleTo(scale:Float):SpriteColorable
	{
		return cast(super.scaleTo(scale), SpriteColorable);
	}

	override function loadBitmapCacheGraphic(key:String, animated:Bool = true, frameWidth:Int = 0, frameHeight:Int = 0, unique:Bool = false):SpriteColorable
	{
		return cast(super.loadBitmapCacheGraphic(key, animated, frameWidth, frameHeight, unique), SpriteColorable);
	}
	override function loadGraphic(graphic:FlxGraphicAsset, animated:Bool = false, frameWidth:Int = 0, frameHeight:Int = 0, unique:Bool = false,
			?key:String):SpriteColorable
	{
		return cast(super.loadGraphic(graphic, animated, frameWidth, frameHeight, unique, key), SpriteColorable);
	}

	public function replace(_old:FlxColor, _new:FlxColor):SpriteColorable
	{
		if (graphic != null && graphic.bitmap != null)
			replaceColor(_old, _new);

		return this;
	}
}
