package data;

import lime.utils.Assets;

class DataLoader<T> extends Data<T>
{
	public var path(default, null):String = null;

	override public function new(?path:String)
	{
		super(null);

		if (path != null) load(path);
	}

	override function toString():String
	{
		return 'DataLoader(path: $path, data: $data)';
	}

	public function load(path:String)
	{
		if (!Assets.exists(path))
		{
			trace('Non-existant asset : $path');
			return;
		}
	}

	override function reset()
	{
		super.reset();
		path = null;
	}
}
