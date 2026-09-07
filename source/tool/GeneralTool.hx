package tool;

class GeneralTool
{
	public static function multiply(value:Null<Float>, ?amount:Null<Int>)
	{
		if (amount == null || value == null) return value;

		return value * amount;
	}

	public static function repeat(method:Null<Dynamic>, ?amount:Null<Int>)
	{
		if (amount == null || method == null) return;

		for (i in 0...amount) method();
	}
}
