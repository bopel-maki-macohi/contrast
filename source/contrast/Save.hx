package contrast;

import flixel.FlxG;

class Save
{
	public static final VERSION:Int = 2;

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

		if (FlxG.save.data.contrast != null) data = FlxG.save.data.contrast;

		data ??= {
			version: null,
			contrast: null,
		};

		if (data.contrast == null) contrast;

		save();
	}

	public static function save()
	{
		data.version = VERSION;

		FlxG.save.data.contrast = data;
	}
}

typedef SaveData =
{
	var version:Null<Int>;
	var contrast:Null<Int>;
}
