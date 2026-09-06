package preloader;

import lime.utils.Assets;
import flixel.util.FlxBitmapDataUtil;
import flixel.graphics.FlxGraphic;
import sprite.SpriteColorable;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
	private var colors = [
		Color.BLACK,
		Color.BLUE,
		Color.GRAY,
		Color.GREEN,
		Color.LIME,
		Color.ORANGE,
		Color.PURPLE,
		Color.RED,
		Color.SEA,
		Color.WHITE,
		Color.YELLOW,
	];

	private var libraries = [];

	override public function new()
	{
		@:privateAccess
		this.libraries = [for (library => lib in Assets.libraries) library];

		super(colors.length + libraries.length);
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

		for (i => color in colors)
		{
			final key = '${color}_vessel';
			var vesselGraphic = FlxGraphic.fromAssetKey('visual:white/vessel.png', false, '', false);
			FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, color);
			FlxG.bitmap.add(vesselGraphic.bitmap, true, key);
			FlxG.bitmap.get(key).persist = true;
			trace('Created Color Vessel #$i');

			done++;
		}
	}
}
