package contrast.util.tool;

import flixel.FlxG;

class ArrayTool
{
	public static function random<A>(array:Array<A>):Null<A> return (array == null) ? null : array[FlxG.random.int(0, array.length - 1)];
}
