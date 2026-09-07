package contrast.preloader;

import flixel.util.FlxBitmapDataUtil;
import haxe.io.Path;

class PreloaderAssetsVessel extends PreloaderAssets
{
	public var vesselAssets:Array<String> = ['vessel', 'ui/key-enter', 'ui/arrow'];

	override public function new()
	{
		super('Assets (Vessel)', Math.floor(vesselAssets.length * Color.table.length()));
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Caching Vessel Assets';
		for (asset in vesselAssets)
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
