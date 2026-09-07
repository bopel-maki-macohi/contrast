package contrast.object.preloader;

import flixel.util.FlxBitmapDataUtil;
import haxe.io.Path;

class PreloaderAssetsColorable extends PreloaderAssets
{
	public var images:Array<String> = [
		'vessel',
		'ui/box',
		'iconVessel',
		'macadam/macadam_idle',
		'macadam/macadam_masking',
		'macadam/macadam_laugh'
	];

	public var special:Array<String> = ['iconVessel',];

	override public function new()
	{
		super('Assets (Colorable)', Math.floor((images.length) * Color.tableRGB.length()));
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Creating and Caching Color Variation Assets';
		for (asset in images)
		{
			for (colorCODE => colorVALUE in Color.tableRGB)
			{
				final noDir = new Path(asset).file;

				performTask(function()
				{
					var vesselGraphic = getGraphic('image:$asset.png');
					FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, colorVALUE);
					storeGraphic(vesselGraphic.bitmap, true, '${colorCODE}_${noDir}');
				});
			}
		}
	}
}
