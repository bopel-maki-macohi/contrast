package contrast.state;

import flixel.FlxSubState;

class SubState extends FlxSubState
{
	public var objectMembers(default, null):GroupObj;

	override public function new()
	{
		super();

		objectMembers = new GroupObj();
	}

	public function addObj(obj:Obj)
	{
		if (obj != null) objectMembers.add(obj);
	}

	public function removeObj(obj:Obj)
	{
		if (obj != null) objectMembers.remove(obj);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (objectMembers != null) for (object in objectMembers) object.update(elapsed);
	}
}
