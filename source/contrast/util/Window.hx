package contrast.util;

import lime.ui.WindowAttributes;
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

	public static function createWindow(title = 'DEVICE'):lime.ui.Window
	{
		var attributes:WindowAttributes = {
			allowHighDPI: true,
			alwaysOnTop: false,
			borderless: false,
			// display: 0,
			element: null,
			frameRate: 60,
			#if !web
			fullscreen: false,
			#end
			height: 720,
			hidden: #if munit true #else false #end,
			maximized: false,
			minimized: false,
			parameters: {},
			resizable: true,
			title: title,
			width: 1280,
			x: null,
			y: null,
		};

		attributes.context = {
			antialiasing: 0,
			background: 0,
			colorDepth: 32,
			depth: true,
			hardware: true,
			stencil: true,
			type: null,
			vsync: false
		};

		return Application.current.createWindow(attributes);
	}
}
