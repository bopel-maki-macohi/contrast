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
				if (!blue) return 'Automatically leave Preloader when possible? : ${(!Save.data.options.stayInPreloader) ? 'Yes' : 'No'}';
				else return 'PROCEED AFTER COMPLETE LOADING : ' + '${!Save.data.options.stayInPreloader}'.toUpperCase();
			},
			onSelection: () -> Save.data.options.stayInPreloader = !Save.data.options.stayInPreloader,
		},
		{
			getLabel: (blue) ->
			{
				if (!blue) return 'Disable Extreme Flashing? : ${(!Save.data.options.flashing) ? 'Yes' : 'No'}';
				else return 'EPILEPSY SUPPORT : ${(!Save.data.options.flashing) ? 'ENABLED' : 'DISABLED'}';
			},
			onSelection: () -> Save.data.options.flashing = !Save.data.options.flashing,
		},
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

		options.push({
			getLabel: (blue) ->
			{
				if (!blue) return 'Clear Save?';
				else return 'CLEAR CONTRAST MEMORIES';
			},
			onSelection: () -> openSubState(new SubStateClearSave(optionsFollow, isBlue)),
		},);
	}

	override function create()
	{
		super.create();

		FlxG.cameras.reset(optionsCam = new FlxCamera());

		add(seaBG = new SeaBackdrop((isBlue) ? Color.BLUE : Color.YELLOW, FlxPoint.weak((isBlue) ? 100 : 0, (!isBlue) ? 2 : 0)));
		seaBG.scrollFactor.set();

		if (options == null || options.length < 1)
		{
			var noOptionsText = new Text(0, 0, 0, 'NO OPTIONS PRESENT', 32);
			add(noOptionsText);

			noOptionsText.screenCenter();

			return;
		}

		persistentUpdate = true;

		add(optionsFollow = new FlxObject());

		optionsCam.follow(optionsFollow, LOCKON, 0.04);

		add(optionsTextContainer = new FlxTypedSpriteContainer<Text>());

		for (i => option in options)
		{
			var optionText = new Text(0, 0, 0, option.getLabel(isBlue), 16);
			optionText.ID = i;

			optionText.alignment = CENTER;
			optionText.screenCenter(Y);

			optionText.y += i * (2 * optionText.size);
			optionsTextContainer.add(optionText);
		}

		changeSelection(0);

		optionsCam.focusOn(optionsFollow.getPosition());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ESCAPE && subState == null) leave();

		if (FlxG.keys.anyJustReleased([W, UP])) changeSelection(-1);
		if (FlxG.keys.anyJustReleased([S, DOWN])) changeSelection(1);

		if (FlxG.keys.justReleased.ENTER && options.length > 0 && subState == null)
		{
			if (options[selection] != null && options[selection].onSelection != null) options[selection].onSelection();
			changeSelection();
		}
	}

	override function closeSubState()
	{
		super.closeSubState();

		refresh();
	}

	private function leave()
	{
		visible = false;

		FlxG.cameras.reset();

		if (isBlue) FlxG.switchState(() -> new BlueMenu());
		else FlxG.switchState(() -> new BlueMenu());
	}

	private function changeSelection(amount = 0)
	{
		if (subState != null) return;

		selection += amount;

		if (selection < 0) selection = options.length - 1;
		if (selection > options.length - 1) selection = 0;

		refresh();
	}

	private function refresh()
	{
		var sT:Text = null;

		for (text in optionsTextContainer)
		{
			text.text = ((selection == text.ID) ? '> ' : '') + options[text.ID].getLabel(isBlue);
			text.color = (selection == text.ID) ? Color.WHITE : (isBlue ? Color.BLUE : Color.YELLOW);

			if (selection == text.ID) sT = text;
		}

		if (sT != null) optionsFollow.setPosition(sT.x + (FlxG.width / 4), sT.getGraphicMidpoint().y);
	}
}
