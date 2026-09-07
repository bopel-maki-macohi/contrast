package contrast.object.group;

/**
	`add` AND `remove` DO NOT EXIST BY DEFAULT

	YOU MUST PROVIDE ONE
**/
class Group<T> extends Obj
{
	public var length(get, null):Int;

	private function get_length():Int
	{
		return list?.length ?? 0;
	}

	private var list(default, null):Array<T>;

	override public function new()
	{
		super();

		list = [];
	}

	override function toString():String
	{
		return 'Group(length: $length)';
	}

	public function iterator()
	{
		return list.iterator();
	}
}
