package contrast.object.preloader;

import haxe.io.Path;

class PreloaderAssetsRegular extends PreloaderAssets
{
	public var images:Array<String> = ['blankicon', 'c-wheel', 'sea', 'sea-desat', 'ui/key-enter', 'ui/arrow'];

	override public function new(assetCount = 0)
	{
		super('Assets (Regular)', images.length);
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Caching Regular Assets';
		for (asset in images)
		{
			performTask(function()
			{
				storeGraphic(getGraphic('image:$asset.png').bitmap, true, new Path(asset).file);
			});
		}
	}
}
