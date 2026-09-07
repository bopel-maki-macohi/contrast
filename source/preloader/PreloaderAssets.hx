package preloader;

import haxe.io.Path;
import openfl.display.BitmapData;
import lime.utils.Assets;
import flixel.util.FlxBitmapDataUtil;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;

class PreloaderAssets extends Preloader
{
	public var otherAssets:Array<String> = ['c-wheel', 'sea', 'sea-desat', 'ui/key-enter', 'ui/arrow'];
	public var vesselAsset:Array<String> = ['vessel', 'ui/key-enter', 'ui/arrow'];

	public var colors(default, null):Map<String, Color> = [
		'black' => BLACK,
		'blue' => BLUE,
		'gray' => GRAY,
		'green' => GREEN,
		'lime' => LIME,
		'orange' => ORANGE,
		'purple' => PURPLE,
		'red' => RED,
		'sea' => SEA,
		'white' => WHITE,
		'yellow' => YELLOW,
	];

	public var libraries(default, null):Array<String> = [];

	override public function new()
	{
		@:privateAccess
		this.libraries = [for (library => lib in Assets.libraries) library];

		super('Assets', ([for (color in colors) color].length * vesselAsset.length) + libraries.length + otherAssets.length);
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Loading Libraries';

		for (library in libraries)
		{
			trace('Loading Library : $library');
			performTask(function()
			{
				Assets.loadLibrary(library);
			});
		}

		currentTask = 'Caching Vessel Assets';
		for (asset in vesselAsset)
		{
			for (colorCODE => colorVALUE in colors)
			{
				final noDir = new Path(asset).file;
				trace('About to Cache Vessel Asset : "${colorCODE}_$noDir"');

				performTask(function()
				{
					var vesselGraphic = getGraphic('image:$asset.png');
					FlxBitmapDataUtil.replaceColor(vesselGraphic.bitmap, Color.WHITE, colorVALUE);
					storeGraphic(vesselGraphic.bitmap, true, '${colorCODE}_${noDir}');
				});
			}
		}

		currentTask = 'Caching Other Assets';
		for (asset in otherAssets)
		{
			trace('About to Cache Asset : $asset');
			performTask(function()
			{
				storeGraphic(getGraphic('image:$asset.png').bitmap, true, new Path(asset).file);
			});
		}

		currentTask = 'Done!';
	}

	private function getGraphic(path:String)
	{
		return FlxGraphic.fromAssetKey(path, false, '', false);
	}

	private function storeGraphic(bitmap:BitmapData, unique:Bool, key:String)
	{
		FlxG.bitmap.add(bitmap, unique, key);
		FlxG.bitmap.get(key).persist = true;
	}
}
