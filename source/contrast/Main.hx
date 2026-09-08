package contrast;

import flixel.FlxG;
import openfl.events.Event;
import flixel.FlxGame;

class Main extends FlxGame
{
	public static var mouseVisible:Bool = false;

	public static final whiteVersion = Macro.getDefineValue('whiteVersion');
	public static final blueVersion = Macro.getDefineValue('blueVersion');
	public static final yellowVersion = Macro.getDefineValue('yellowVersion');

	override public function new()
	{
		super(0, 0, StatePreloader, 60, 60, #if SKIP_SPLASH true #else false #end, false);
	}

	override function create(_:Event)
	{
		haxe.Log.trace = function(v:Dynamic, ?infos)
		{
			var str = '[ ${infos.fileName}:${infos.lineNumber} ] ${Std.string(v)}';

			#if js
			if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null) (untyped console).log(str);
			#elseif lua
			untyped __define_feature__("use._hx_print", _hx_print(str));
			#elseif sys
			Sys.println(str);
			#else
			throw new haxe.exceptions.NotImplementedException()
			#end
		}

		Save.create();

		#if TASK_MULTIPLIER
		preloader.Preloader.taskMultiplier = FlxG.random.int(1, 100);
		#end

		Window.setIcon();

		super.create(_);
	}

	override function update()
	{
		super.update();

		if (FlxG.mouse != null) FlxG.mouse.enabled = FlxG.mouse.visible = mouseVisible;
	}
}
