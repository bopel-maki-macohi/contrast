package preloader;

import openfl.display.BitmapData;
import lime.utils.Assets;
import flixel.util.FlxBitmapDataUtil;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
	public var colorables:Array<String> = ['arrow', 'vessel'];

	public var colors(default, null):Map<String, Color> = [
		'black' => BLACK,
		'blue' => BLUE,
		'gray' => GRAY,
		'green' => GREEN,
		'lime' => LIME,
		'orange' => ORANGE,
		'purple' => PURPLE,
		'red' => RED,
		'sea' => SEA,
		'white' => WHITE,
		'yellow' => YELLOW,
	];

	public var libraries(default, null):Array<String> = [];

	override public function new()
	{
		@:privateAccess
		this.libraries = [for (library => lib in Assets.libraries) library];

		super(([for (color in colors) color].length * colorables.length) + libraries.length);
	}

	override function preload()
	{
		super.preload();

		for (library in libraries)
		{
			Assets.loadLibrary(library);
			trace('Loaded Library: $library');

			done++;
		}

		for (colorable in colorables)
		{
			for (colorCODE => colorVALUE in colors)
			{
				final key = '${colorCODE}_${colorable}';
				var vesselGraphic = FlxGraphic.fromAssetKey('image:white/$colorable.png', false, '', false);
				FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, colorVALUE);
				storeGraphic(vesselGraphic.bitmap, true, key);
				trace('Created Color ${colorable.substr(0, 1).toUpperCase()}${colorable.substr(1).toLowerCase()} : $colorCODE');
				done++;
			}
		}
	}

	private function storeGraphic(bitmap:BitmapData, unique:Bool, key:String)
	{
		FlxG.bitmap.add(bitmap, unique, key);
		FlxG.bitmap.get(key).persist = true;
	}
}
