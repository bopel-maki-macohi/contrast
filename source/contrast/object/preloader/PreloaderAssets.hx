package contrast.object.preloader;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
	override public function new(label = 'Assets', assetCount = 0)
	{
		super(label, assetCount);
	}

	private function getGraphic(path:String)
	{
		return FlxGraphic.fromAssetKey(path, false, '', false);
	}

	private function storeGraphic(bitmap:BitmapData, unique:Bool, key:String)
	{
		FlxG.bitmap.add(bitmap, unique, key);

		if (FlxG.bitmap.get(key) == null) trace('$key cannot be set to persistant');
		else FlxG.bitmap.get(key).persist = true;
	}
}
