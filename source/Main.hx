import flixel.FlxG;
import openfl.events.Event;
import flixel.FlxGame;
import preloader.*;
import state.*;

class Main extends FlxGame
{
	override public function new()
	{
		super(StatePreloader);
	}

	override function create(_:Event)
	{
		haxe.Log.trace = function(v:Dynamic, ?infos)
		{
			var str = '[ ${infos.fileName}:${infos.lineNumber} ] ${Std.string(v)}';

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
	}
}
