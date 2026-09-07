package preloader;

import openfl.display.BitmapData;
import lime.utils.Assets;
import flixel.util.FlxBitmapDataUtil;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
	public var noncolorables:Array<String> = ['c-wheel', 'sea'];
	public var colorables:Array<String> = ['arrow', 'vessel', 'sea-desat'];

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

		super(([for (color in colors) color].length * colorables.length) + libraries.length + noncolorables.length);
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
				var vesselGraphic = getGraphic('image:c/$colorable.png');
				FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, colorVALUE);
				storeGraphic(vesselGraphic.bitmap, true, key);
				trace('Cached Colorable ${colorable.substr(0, 1).toUpperCase()}${colorable.substr(1).toLowerCase()} : $colorCODE');
				done++;
			}
		}

		for (noncolorable in noncolorables)
		{
			storeGraphic(getGraphic('image:nc/$noncolorable.png').bitmap, true, noncolorable);
			trace('Cached ${noncolorable.substr(0, 1).toUpperCase()}${noncolorable.substr(1).toLowerCase()}');
			done++;
		}
	}

	private function getGraphic(path:String)
	{
		return FlxGraphic.fromAssetKey(path, false, '', false);
	}

	private function storeGraphic(bitmap:BitmapData, unique:Bool, key:String)
	{
		FlxG.bitmap.add(bitmap, unique, key);
		FlxG.bitmap.get(key).persist = true;
	}
}
