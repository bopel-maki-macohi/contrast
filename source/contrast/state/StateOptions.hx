package contrast.state;

import flixel.math.FlxPoint;
import flixel.FlxG;

class StateOptions extends State
{
	private var isBlue(default, null):Bool;

	private var seaBG(default, null):SeaBackdrop;

	override public function new(?forceBlue:Null<Bool>)
	{
		super();

		isBlue = Save.data.alliance == 0;
		if (forceBlue != null) isBlue = forceBlue;
	}

	override function create()
	{
		super.create();

		add(seaBG = new SeaBackdrop((isBlue) ? Color.BLUE : Color.YELLOW, FlxPoint.weak((isBlue) ? 100 : 0, (!isBlue) ? 2 : 0)));
	}

	private function leave()
	{
		if (isBlue) FlxG.switchState(() -> new BlueMenu());
		else FlxG.switchState(() -> new BlueMenu());
	}
}
