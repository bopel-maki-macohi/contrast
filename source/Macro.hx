import haxe.macro.Context;

class Macro
{
	public static macro function getDefined(s:String)
	{
		return macro $v{Context.defined(s)};
	}

	public static macro function getDefineValue(s:String)
	{
		return macro $v{Context.definedValue(s)};
	}

	public static macro function getDefinesMap()
	{
		return macro $v{Context.getDefines()};
	}

	public static macro function getDefines()
	{
		return macro $v{[for (define => value in Context.getDefines()) '$define=$value']};
	}

	public static macro function getDefinesAndValue()
	{
		return macro $v{[for (define => value in Context.getDefines()) '$define=$value']};
	}
}
