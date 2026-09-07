package contrast.util;

import flixel.util.FlxColor;

enum abstract Color(Int) from FlxColor from Int to FlxColor to Int
{
	public static var tableRGB(default, null):Map<String, Color> = [
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

	var WHITE = 0xFFFFFFFF;
	var GRAY = 0xFF7F7F7F;
	var BLACK = 0xFF000000;

	var RED = 0xFFFF0000;
	var ORANGE = 0xFFFF7F00;
	var YELLOW = 0xFFFFFF00;
	var LIME = 0xFF7FFF00;
	var GREEN = 0xFF00FF00;
	var SEA = 0xFF007FFF;
	var BLUE = 0xFF0000FF;
	var PURPLE = 0xFF7F00FF;

	public function toBGR()
	{
		var replacement:FlxColor = this;
		var current:FlxColor = this;

		replacement.blue = current.red;
		replacement.red = current.blue;

		return replacement;
	}
}
