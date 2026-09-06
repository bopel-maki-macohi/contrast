import flixel.FlxG;
import openfl.events.Event;
import flixel.FlxGame;
import preloader.*;
import state.*;

class Main extends FlxGame
{
	public function new()
	{
		super(0, 0, null);
	}

	override function create(_:Event)
	{
		haxe.Log.trace = function(v, ?infos)
		{
			var str = '[ ${infos.fileName}:${infos.lineNumber} ] $v';

			#if js
			if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
				(untyped console).log(str);
			#elseif lua
			untyped __define_feature__("use._hx_print", _hx_print(str));
			#elseif sys
			Sys.println(str);
			#else
			throw new haxe.exceptions.NotImplementedException()
			#end
		}

		Save.create();

		super.create(_);

		new PreloaderAssets().preload();

		FlxG.switchState(() -> new StateStarting());
	}
}
