package tool;

class GeneralTool
{
	public static function repeat(method:Int->Void, ?amount:Null<Int>)
	{
		if (amount == null || method == null) return;

		for (i in 0...amount) method(i);
	}
}
