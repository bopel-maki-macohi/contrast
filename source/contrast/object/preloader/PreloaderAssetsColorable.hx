package contrast.object.preloader;

import flixel.util.FlxBitmapDataUtil;
import haxe.io.Path;

class PreloaderAssetsColorable extends PreloaderAssets
{
	public var images:Array<String> = ['vessel', 'ui/box', 'macadam/macadam_idle', 'macadam/macadam_masking', 'macadam/macadam_laugh'];

	override public function new()
	{
		super('Assets (Colorable)', Math.floor(images.length * Color.table.length()));
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Creating and Caching Color Variation Assets';
		for (asset in images)
		{
			for (colorCODE => colorVALUE in Color.table)
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
