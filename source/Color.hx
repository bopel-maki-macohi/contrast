import flixel.util.FlxColor;

enum abstract Color(Int) from Int from FlxColor to Int to FlxColor
{
	public static var table(default, null):Map<String, Color> = [
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

	public var WHITE = 0xFFFFFFFF;
	public var GRAY = 0xFF7F7F7F;
	public var BLACK = 0xFF000000;

	public var RED = 0xFFFF0000;
	public var ORANGE = 0xFFFF7F00;
	public var YELLOW = 0xFFFFFF00;
	public var LIME = 0xFF7FFF00;
	public var GREEN = 0xFF00FF00;
	public var SEA = 0xFF007FFF;
	public var BLUE = 0xFF0000FF;
	public var PURPLE = 0xFF7F00FF;
}
