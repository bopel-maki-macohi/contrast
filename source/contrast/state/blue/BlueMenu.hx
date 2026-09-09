package contrast.state.blue;

import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class BlueMenu extends State
{
	private static var seenIntro(default, null):Bool = false;

	private var prison(default, null):Sprite;
	private var prisonSize(default, null):Float = 40.0;
	private var prisonSizeTarget(default, null):Float = 2.0;
	private var prisonScaleLerpValue(default, null):Float = 0.0;

	private var DEVICE_SOUL_TRANSFER(default, null):Audio;

	private var transferMask(default, null):SeaBackdrop;

	private var user(default, null):SpriteVessel;

	private var title(default, null):Text;

	private var options(default, null) = ['JOIN', 'MODIFY', 'LEAVE'];
	private var optionsContainer(default, null):FlxTypedSpriteContainer<Text>;

	private var selection(default, null):Int = 0;

	private var terminal(default, null):DataLoaderString = new DataLoaderString('data:terminal/blue.txt');
	private var terminalText(default, null):Text;
	private var terminalBackdrop(default, null):FlxBackdrop;

	private var introComplete(default, set) = false;

	private function set_introComplete(introComplete:Bool):Bool
	{
		title.visible = optionsContainer.visible = introComplete && seenIntro;
		terminalBackdrop.visible = !introComplete && !seenIntro;

		return this.introComplete = introComplete;
	}

	override function create()
	{
		super.create();

		Window.title = 'DEVICE_BLUE';
		Window.setIcon('red_iconVessel'); // fuck you .ico (thats what im blaming)

		add(user = new SpriteVessel('white'));
		user.screenCenter();
		user.state = SPIN;

		terminalText = new Text(0, 0, user.width, terminal.data);
		terminalText.alignment = CENTER;

		add(terminalBackdrop = new FlxBackdrop(terminalText.graphic));
		terminalBackdrop.velocity.set(0, (Save.data.options.flashing) ? 800 : 100);
		terminalBackdrop.screenCenter();

		add(transferMask = new SeaBackdrop(Color.BLACK, FlxPoint.weak(0, -20)));
		transferMask.seas(function(s, i)
		{
			s.alpha = 1;
		});

		add(prison = new Sprite().loadBitmapCacheGraphic('blue_box').scaleTo(prisonSize));

		add(title = new Text(0, 0, 0, 'CONTRAST v${Main.blueVersion}', 32));
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

		optionsContainer.y = FlxG.height - optionsContainer.height * 2;

		introComplete = seenIntro;

		if (introComplete) prisonSize = prisonSizeTarget;
		else FlxTween.num(0, 1, 17.5, {
			ease: FlxEase.quintIn,
			onComplete: function(t)
			{
				seenIntro = true;
				introComplete = true;
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
			prisonScaleLerpValue = t;
			user.alpha = t;
			terminalBackdrop.alpha = 1 - t;
		});

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		prison.scaleTo(prisonSize = FlxMath.lerp(prisonSize, prisonSizeTarget, prisonScaleLerpValue));
		prison.screenCenter();

		if (seenIntro)
		{
			user.scaleTo(prisonSize);
			user.screenCenter();
		}

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

		for (text in optionsContainer) text.color = (selection == text.ID) ? Color.WHITE : Color.BLUE;
	}

	private function select()
	{
		if (!introComplete) return;

		switch (options[selection].toLowerCase())
		{
			case 'join':
				introComplete = false;
				user.state = SHOCKED;

				DEVICE_SOUL_TRANSFER.play(true);
				FlxTween.tween(user, {alpha: 0}, 4, {ease: FlxEase.sineOut});
				FlxTimer.wait(1, () ->
				{
					moveToBlueTargetState();
				});

			case 'modify': FlxG.switchState(() -> new StateOptions());
			case 'leave': Application.current.window.close();
		}
	}

	public static function moveToBlueTargetState()
	{
		FlxG.switchState(() -> new BlueStart());
	}
}
