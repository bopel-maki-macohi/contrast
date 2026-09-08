package contrast.state;

import flixel.math.FlxPoint;
import flixel.FlxG;

typedef Option =
{
	id:String,
	getLabel:Bool->Void,
	onSelection:Void->Void,
}

class StateOptions extends State
{
	private var isBlue(default, null):Bool;

	private var seaBG(default, null):SeaBackdrop;

	private var options:Array<Option> = [
		// {
		// 	id: '',
		// 	getLabel: null,
		// 	onSelection: null,
		// }
	];

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

		if (options == null || options.length < 1)
		{
			var noOptionsText = new Text(0, 0, 0, 'NO OPTIONS PRESENT', 32);
			add(noOptionsText);

			noOptionsText.screenCenter();

			#if !debug
			leave();
			#end

			return;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) leave();
	}

	private function leave()
	{
		if (isBlue) FlxG.switchState(() -> new BlueMenu());
		else FlxG.switchState(() -> new BlueMenu());
	}
}
