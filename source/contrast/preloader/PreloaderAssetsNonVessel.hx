package contrast.preloader;

import haxe.io.Path;

class PreloaderAssetsNonVessel extends PreloaderAssets
{
	public var otherAssets:Array<String> = ['c-wheel', 'sea', 'sea-desat', 'ui/key-enter', 'ui/arrow'];

	override public function new(assetCount = 0)
	{
		super('Assets (NonVessel)', otherAssets.length);
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Caching Other Assets';
		for (asset in otherAssets)
		{
			performTask(function()
			{
				storeGraphic(getGraphic('image:$asset.png').bitmap, true, new Path(asset).file);
			});
		}
	}
}
