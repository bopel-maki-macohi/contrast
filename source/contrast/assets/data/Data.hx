package contrast.assets.data;

class Data<T> extends Obj
{
	public var data(default, null):T;

	override public function new(data:T)
	{
		super();

		this.data = data;
	}

	override function toString():String
	{
		return 'Data($data)';
	}

	public function reset()
	{
		data = null;
	}
}
