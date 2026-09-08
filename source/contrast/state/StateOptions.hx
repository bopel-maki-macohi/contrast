package contrast.state;

import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.math.FlxPoint;
import flixel.FlxG;

typedef Option =
{
	getLabel:Bool->String,
	onSelection:Void->Void,
}

class StateOptions extends State
{
	private var isBlue(default, null):Bool;

	private var seaBG(default, null):SeaBackdrop;

	private var options(default, null):Array<Option> = [
		{
			getLabel: (blue) ->
			{
				if (!blue) return 'Automatically leave Preloader when possible? : ${(Save.data.options.stayInPreloader) ? 'Yes' : 'No'}';
				else return 'PROCEED AFTER COMPLETE LOADING : ' + '${Save.data.options.stayInPreloader}'.toUpperCase();
			},
			onSelection: () -> Save.data.options.stayInPreloader = !Save.data.options.stayInPreloader,
		}
	];
	private var optionsTextContainer(default, null):FlxTypedSpriteContainer<Text>;

	private var optionsCam(default, null):FlxCamera;
	private var optionsFollow(default, null):FlxObject;

	private var selection(default, null):Int = 0;

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

			return;
		}

		FlxG.cameras.reset(optionsCam = new FlxCamera());
		add(optionsFollow = new FlxObject());

		optionsCam.follow(optionsFollow, LOCKON, 0.04);

		add(optionsTextContainer = new FlxTypedSpriteContainer<Text>());

		for (i => option in options)
		{
			var optionText = new Text(0, 0, 0, option.getLabel(isBlue), 16);
			optionText.ID = i;
			optionText.y = i * (2 * optionText.size);
			optionsTextContainer.add(optionText);
		}

		optionsTextContainer.screenCenter();

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) leave();
		if (FlxG.keys.justPressed.ENTER && options.length > 0)
		{
			if (options[selection] != null && options[selection].onSelection != null) options[selection].onSelection();
			changeSelection();
		}
	}

	private function leave()
	{
		FlxG.cameras.reset();

		if (isBlue) FlxG.switchState(() -> new BlueMenu());
		else FlxG.switchState(() -> new BlueMenu());
	}

	private function changeSelection(amount = 0)
	{
		selection += amount;

		if (selection < 0) selection = options.length - 1;
		if (selection > options.length - 1) selection = 0;

		for (text in optionsTextContainer)
		{
			text.text = options[text.ID].getLabel(isBlue);
			text.color = (selection == text.ID) ? Color.WHITE : (isBlue ? Color.BLUE : Color.YELLOW);
		}
		optionsTextContainer.screenCenter();
		optionsFollow.setPosition(optionsTextContainer.members[selection].getGraphicMidpoint().x,
			optionsTextContainer.members[selection].getGraphicMidpoint().y);
	}
}
