package contrast.util;

import lime.utils.Assets;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import lime.graphics.Image;
import lime.app.Application;

class Window
{
	public static var title(get, set):String;

	private static function get_title():String return Application.current.window.title;

	private static function set_title(title:String):String return Application.current.window.title = title;

	public static function setIcon(?value:Dynamic)
	{
		var set = (_value:Image) -> Application.current.window.setIcon(_value);
		var setBitmapData = (_value:BitmapData) -> set(_value.image);

		if (value is Image) set(value);
		else if (value is BitmapData) setBitmapData(value);
		else if (value is FlxGraphic) setBitmapData(value.bitmap);
		else if (value is String)
		{
			final exists = Assets.exists(value);
			final cached = FlxG.bitmap.get(value);

			if (cached != null) setBitmapData(cached.bitmap);
			else if (exists) setBitmapData(FlxG.bitmap.add(value).bitmap);
			else
			{
				final lime = Image.fromFile(value);
				if (lime != null) set(lime);
			}
		}
		else if (value is FlxSprite) setBitmapData(value.graphic.bitmap);
		else setIcon('image:blankicon.png');
	}
}
