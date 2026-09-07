package contrast.util;

// import lime.utils.ArrayBuffer;
// import lime.utils.UInt8Array;
// import lime.graphics.ImageBuffer;
// import format.png.Tools;
// import bitmap.IOUtil;
// import bitmap.PNGBitmap;
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

		if (value is Image)
		{
			trace('Set Window Icon to : Lime Image');
			set(value);
		}
		else if (value is BitmapData)
		{
			trace('Set Window Icon to : BitmapData');
			setBitmapData(value);
		}
		else if (value is FlxGraphic)
		{
			trace('Set Window Icon to : FlxGraphic');
			setBitmapData(value.bitmap);
		}
		else if (value is String)
		{
			final exists = Assets.exists(value);
			final cached = FlxG.bitmap.get(value);

			if (cached != null)
			{
				trace('Set Window Icon to Cached Image Path : $value');
				setBitmapData(cached.bitmap);
			}
			else if (exists)
			{
				trace('Set Window Icon to Raw Image Path : $value');
				setBitmapData(FlxG.bitmap.add(value).bitmap);
			}
			else
			{
				final lime = Image.fromFile(value);
				if (lime != null)
				{
					trace('Set Window Icon to Lime-Received Asset Path : $value');
					set(lime);
				}
			}
		}
		else if (value is FlxSprite)
		{
			trace('Set Window Icon to : FlxSprite Graphic');
			setBitmapData(value.graphic.bitmap);
		}
		else
		{
			trace('Set Window Icon to : Blank Icon');
			setIcon('image:blankicon.png');
		}
	}
}
