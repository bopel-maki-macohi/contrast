package preloader;

import flixel.util.FlxBitmapDataUtil;
import flixel.graphics.FlxGraphic;
import sprite.SpriteColorable;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
	private var nonWhiteColors = [
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

	override public function new()
	{
		super(nonWhiteColors.length);
	}

	override function preload()
	{
		super.preload();

		for (color in nonWhiteColors)
		{
            final key = '${color}_vessel';
			var vesselGraphic = FlxGraphic.fromAssetKey('white/vessel.png',false,'',false);
            FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, color);
            FlxG.bitmap.add(vesselGraphic.bitmap, true, key);
            FlxG.bitmap.get(key).persist = true;

			done++;
		}
	}
}
