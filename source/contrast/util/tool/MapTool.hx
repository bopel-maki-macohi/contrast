package contrast.util.tool;

class MapTool
{
	public static function length<A, B>(map:Map<A, B>):Int return map.identifiers().length;

	public static function identifiers<A, B>(map:Map<A, B>):Array<A> return [for (a => b in map) a];

	public static function values<A, B>(map:Map<A, B>):Array<B> return [for (a => b in map) b];
}
