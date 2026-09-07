package contrast;

import lime.app.Application;
import flixel.FlxG;

class Save
{
	public static final VERSION:Int = 4;

	public static var data:SaveData;

	public static var contrast(get, never):Null<Int>;

	private static function get_contrast():Null<Int>
	{
		final oldContrast = data.contrast;

		data.contrast = FlxG.random.int(0, 255);

		return oldContrast ?? 0;
	}

	public static function create()
	{
		FlxG.save.bind('contrast', '.M');

		#if !SAVE_CLEAR
		if (FlxG.save.data.contrast != null) data = FlxG.save.data.contrast;
		#end

		data ??= {
			version: null,
			contrast: null,
			alliance: null,
			state: null,
		};

		if (data.contrast == null) contrast;

		FlxG.save.data.state ??= '';

		save();

		Application.current.onExit.add(function(a)
		{
			flush();
		});
	}

	public static function save()
	{
		data.version = VERSION;

		FlxG.save.data.contrast = data;
	}

	public static function flush()
	{
		save();

		FlxG.save.flush();
	}
}

typedef SaveData =
{
	var version:Null<Int>;
	var contrast:Null<Int>;

	var alliance:Null<Int>;
	var state:String;
}
