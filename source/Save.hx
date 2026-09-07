import flixel.FlxG;

class Save
{
	public static var data:SaveData;

	public static final VERSION:Int = 1;

	public static function create()
	{
		FlxG.save.bind('contrast', '.M');

		if (FlxG.save.data.contrast != null) data = FlxG.save.data.contrast;

		data ??= {
			version: null
		};

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
}
