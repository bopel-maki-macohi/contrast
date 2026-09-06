import flixel.util.FlxColor;

enum abstract Color(FlxColor) from FlxColor to FlxColor
{
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
}
