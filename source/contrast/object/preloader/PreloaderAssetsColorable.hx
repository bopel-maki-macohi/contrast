package contrast.object.preloader;

import flixel.util.FlxColor;
import flixel.util.FlxBitmapDataUtil;
import haxe.io.Path;

class PreloaderAssetsColorable extends PreloaderAssets
{
	public var images:Map<String, Array<String>> = [
		'vessel' => Color.tableRGB.identifiers(),
		'ui/box' => ['blue'],
		'iconVessel' => ['red', 'cyan'],
		'macadam/macadam_idle' => [],
		'macadam/macadam_masking' => [],
		'macadam/macadam_laugh' => [],
	];

	private var assetCount(get, null):Int;

	private function get_assetCount():Int
	{
		var count = 0;
		for (requiredColorsList in images.values()) count += requiredColorsList.length;
		return count;
	}

	override public function new()
	{
		super('Assets (Colorable)', assetCount);
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Creating and Caching Color Variation Assets';
		for (asset => colorList in images)
		{
			final noDir = new Path(asset).file;

			for (color in colorList)
			{
				if (!Color.tableRGB.exists(color)) continue;

				performTask(function()
				{
					var vesselGraphic = getGraphic('image:$asset.png');
					FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, Color.tableRGB.get(color));
					storeGraphic(vesselGraphic.bitmap, true, '${color}_${noDir}');
				});
			}
		}
		currentTask = 'Creating and Caching Special Color Variation Assets';
		performTask(function()
		{
			var vesselGraphic = getGraphic('image:iconVessel.png');
			FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, 0xFF00FFFF);
			storeGraphic(vesselGraphic.bitmap, true, 'cyan_iconVessel');
		});
	}
}
