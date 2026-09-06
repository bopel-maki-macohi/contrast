package preloader;

import lime.utils.Assets;
import flixel.util.FlxBitmapDataUtil;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
	private var colors = [
		'black' => Color.BLACK,
		'blue' => Color.BLUE,
		'gray' => Color.GRAY,
		'green' => Color.GREEN,
		'lime' => Color.LIME,
		'orange' => Color.ORANGE,
		'purple' => Color.PURPLE,
		'red' => Color.RED,
		'sea' => Color.SEA,
		'white' => Color.WHITE,
		'yellow' => Color.YELLOW,
	];

	private var libraries = [];

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
			var vesselGraphic = FlxGraphic.fromAssetKey('visual:white/vessel.png', false, '', false);
			FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, colorVALUE);
			FlxG.bitmap.add(vesselGraphic.bitmap, true, key);
			FlxG.bitmap.get(key).persist = true;
			trace('Created Color Vessel : $colorCODE');

			done++;
		}
	}
}
