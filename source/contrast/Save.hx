package contrast;

import lime.app.Application;
import flixel.FlxG;

class Save
{
	public static final VERSION:Int = 6;

	@:allow(contrast.state.SubStateClearSave)
	public static var data(default, null):SaveData;

	public static var bound(default, null):Bool = false;

	/**
	 * Use this to have `contrast` change afterwards
	 */
	public static var contrast(get, never):Null<Int>;

	private static function get_contrast():Null<Int>
	{
		final oldContrast = data.contrast;

		data.contrast = FlxG.random.int(0, 255);

		return oldContrast ?? 0;
	}

	public static function create()
	{
		if (!bound)
		{
			FlxG.save.bind('contrast', '.M');

			@:privateAccess
			FlxG.sound.loadSavedPrefs();

			if (!Macro.getDefined('SAVE_CLEAR')) if (FlxG.save.data.contrast != null) data = FlxG.save.data.contrast;

			bound = true;
		}

		data ??= {
			version: null,
			contrast: null,
			alliance: null,
			state: null,
			options: null,
		};

		save();

		Application.current.onExit.add((l) -> onExit);
		Application.current.window.onClose.add(onExit);
	}

	public static function save()
	{
		data.version = VERSION;

		final SAVE_CONTRAST = Macro.getDefineValue('SAVE_CONTRAST');
		if (data.contrast == null) contrast;
		if (SAVE_CONTRAST != null) data.contrast = Std.parseInt(SAVE_CONTRAST);

		data.state ??= '';
		data.options ??= {
			stayInPreloader: null,
			flashing: null,
		};
		data.options.stayInPreloader ??= true;
		data.options.flashing ??= true;

		FlxG.save.data.contrast = data;

		trace(data);
	}

	public static function flush()
	{
		save();

		trace('Flushing');
		FlxG.save.flush();
	}

	private static function onExit()
	{
		flush();
	}
}

typedef SaveData =
{
	var version:Null<Int>;
	var contrast:Null<Int>;

	var alliance:Null<Int>;
	var state:String;

	var options:OptionsData;
}

typedef OptionsData =
{
	var stayInPreloader:Null<Bool>;

	var flashing:Null<Bool>;
}
