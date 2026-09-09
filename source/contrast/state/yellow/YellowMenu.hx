package contrast.state.yellow;

import flixel.addons.display.FlxBackdrop;
import lime.app.Application;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class YellowMenu extends State
{
	private static var seenIntro(default, null):Bool = false;

	private var DEVICE_SOUL_TRANSFER(default, null):Audio;

	private var transferMask(default, null):SeaBackdrop;

	private var user(default, null):SpriteVessel;

	private var vesselGroup(default, null):FlxTypedSpriteContainer<SpriteVessel>;

	private var title(default, null):Text;

	private var options(default, null) = ['Join', 'Options', 'Exit'];
	private var optionsContainer(default, null):FlxTypedSpriteContainer<Text>;

	private var selection(default, null):Int = 0;

	private var terminal(default, null):DataLoaderString = new DataLoaderString('data:terminal/yellow.txt');
	private var terminalText(default, null):Text;
	private var terminalBackdrop(default, null):FlxBackdrop;

	private var introComplete(default, set) = false;

	private function set_introComplete(introComplete:Bool):Bool
	{
		title.visible = introComplete;
		optionsContainer.visible = introComplete;

		terminalBackdrop.visible = !introComplete;

		return this.introComplete = introComplete;
	}

	override function create()
	{
		super.create();

		Window.title = 'DEVICE_YELLOW';
		Window.setIcon('cyan_iconVessel'); // fuck you .ico (thats what im blaming)

		add(user = new SpriteVessel('white'));
		user.screenCenter();
		user.state = SPIN;

		vesselGroup = new FlxTypedSpriteContainer<SpriteVessel>();

		var colorList = Color.tableRGB.identifiers();
		colorList.remove('blue');
		colorList.remove('white');
		colorList.remove('black');

		for (i in 1...11)
		{
			var vessel = new SpriteVessel(colorList.random());
			vessel.ID = i;
			vessel.state = SPIN;
			vessel.animation.frameIndex = FlxG.random.int(0, vessel.frames.frames.length - 1);
			vesselGroup.add(vessel);

			vessel.alpha = 0.5;

			vessel.screenCenter();
			vessel.x = (vessel.width * 4) + i * vessel.width;

			if (i > 5)
			{
				vessel.x += FlxG.width / 2;
				vessel.flipX = true;
			}
		}

		terminalText = new Text(0, 0, user.width, terminal.data);
		terminalText.alignment = CENTER;

		add(terminalBackdrop = new FlxBackdrop(terminalText.graphic));
		terminalBackdrop.velocity.set(0, (Save.data.options.flashing) ? 800 : 100);
		terminalBackdrop.screenCenter();

		add(transferMask = new SeaBackdrop(Color.BLACK, FlxPoint.weak(-20, 0), null, 'sea-fulldesat'));
		transferMask.seas(function(s, i)
		{
			s.blend = ADD;
			s.alpha = 0.125;
			s.color = Color.YELLOW;
		});

		add(vesselGroup);

		add(title = new Text(0, 0, 0, 'CONTRAST v${Main.yellowVersion}', 32));
		title.screenCenter(X);
		title.y = title.height * 2;

		add(optionsContainer = new FlxTypedSpriteContainer<Text>());

		for (i => option in options)
		{
			var optionText = new Text(0, 0, 0, option, 16);
			optionText.ID = i;
			optionText.screenCenter(X);
			optionText.y = i * (optionText.size * 2);
			optionsContainer.add(optionText);
		}

		optionsContainer.y = FlxG.height - optionsContainer.height * 3;

		introComplete = seenIntro;

		if (!introComplete) FlxTween.num(0, 1, 17.5, {
			ease: FlxEase.sineInOut,
			onComplete: function(t)
			{
				seenIntro = introComplete = true;
			},
			onUpdate: function(t)
			{
				if (FlxG.keys.justReleased.ENTER)
				{
					DEVICE_SOUL_TRANSFER.time = t.duration * 1000;
					t.percent = 99;
				}
			},
			onStart: function(t)
			{
				DEVICE_SOUL_TRANSFER = new Audio('sound:DEVICE_SOUL_TRANSFER.ogg');
				DEVICE_SOUL_TRANSFER.play();

				introComplete = false;
			},
		}, function(t)
		{
			user.alpha = t;
			terminalBackdrop.alpha = 1 - t;
		});

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustReleased([W, UP])) changeSelection(-1);
		if (FlxG.keys.anyJustReleased([S, DOWN])) changeSelection(1);
		if (FlxG.keys.anyJustReleased([ENTER])) select();
	}

	private function changeSelection(amount = 0)
	{
		if (!introComplete) amount = 0;

		selection += amount;

		if (selection < 0) selection = options.length - 1;
		if (selection > options.length - 1) selection = 0;

		for (text in optionsContainer) text.color = (selection == text.ID) ? Color.WHITE : Color.YELLOW;
	}

	private function select()
	{
		if (!introComplete) return;

		switch (options[selection].toLowerCase())
		{
			case 'join':
			case 'options': FlxG.switchState(() -> new StateOptions());
			case 'exit': Application.current.window.close();
		}
	}
}
