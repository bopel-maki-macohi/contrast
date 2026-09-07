package contrast.object.assets.sprite;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxSprite;

class Sprite extends FlxSprite
{
	override function loadGraphic(graphic:FlxGraphicAsset, animated:Bool = false, frameWidth:Int = 0, frameHeight:Int = 0, unique:Bool = false,
			?key:String):Sprite
	{
		return cast(super.loadGraphic(graphic, animated, frameWidth, frameHeight, unique, key), Sprite);
	}

	override function makeGraphic(width:Int, height:Int, color:FlxColor = FlxColor.WHITE, unique:Bool = false, ?key:String):Sprite
	{
		return cast(super.makeGraphic(width, height, color, unique, key), Sprite);
	}

	override function toString():String
	{
		return 'Sprite(x: $x, y: $y, width: $width, height: $height, visible: $visible)';
	}

	public function scaleTo(scale:Float):Sprite
	{
		this.scale.set(scale, scale);
		updateHitbox();

		return this;
	}

	public function loadBitmapCacheGraphic(key:String, animated = false, frameWidth = 0, frameHeight = 0, unique = false):Sprite
	{
		if (FlxG.bitmap.get(key) == null)
		{
			trace('NO BITMAP CACHE GRAPHIC WITH KEY: $key');
			FlxG.log.warn('NO BITMAP CACHE GRAPHIC WITH KEY: $key');

			return this;
		}

		loadGraphic(FlxG.bitmap.get(key), animated, frameWidth, frameHeight, unique);

		return this;
	}

	overload public inline extern function shift(x = 0.0, y = 0.0)
	{
		this.x += x;
		this.y += y;
	}

	overload public inline extern function shift(x = 0.0, y = 0.0, ?useWidthAndHeight:Bool)
	{
		this.x += x * ((useWidthAndHeight) ? width : 1);
		this.y += y * ((useWidthAndHeight) ? height : 1);
	}
}
