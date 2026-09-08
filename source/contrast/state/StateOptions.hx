package contrast.state;

class StateOptions extends State
{
	public var isBlue(default, null):Bool;

	override public function new(?forceBlue:Null<Bool>)
	{
		super();

		isBlue = Save.data.alliance == 1;
		if (forceBlue != null) isBlue = forceBlue;
	}
}
