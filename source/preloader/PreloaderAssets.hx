package preloader;

import lime.utils.Assets;
import flixel.util.FlxBitmapDataUtil;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
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

		super([for (color in colors) color].length + libraries.length);
	}

	override function preload()
	{
		super.preload();

		for (library in libraries)
		{
			Assets.loadLibrary(library);
			trace('Loaded library: $library');

			done++;
		}

		for (colorCODE => colorVALUE in colors)
		{
			final key = '${colorCODE}_vessel';
			var vesselGraphic = FlxGraphic.fromAssetKey('image:white/vessel.png', false, '', false);
			FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, colorVALUE);
			FlxG.bitmap.add(vesselGraphic.bitmap, true, key);
			FlxG.bitmap.get(key).persist = true;
			trace('Created Color Vessel : $colorCODE');

			done++;
		}
	}
}
