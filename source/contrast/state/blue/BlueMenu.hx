package contrast.state.blue;

import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class BlueMenu extends State
{
	private var introComplete(default, set) = false;

	private function set_introComplete(introComplete:Bool):Bool
	{
		title.visible = introComplete;
		optionsContainer.visible = introComplete;

		return this.introComplete = introComplete;
	}

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

	override function create()
	{
		super.create();

		Window.title = 'DEVICE_BLUE';
		Window.setIcon('red_iconVessel'); // fuck you .ico (thats what im blaming)

		DEVICE_SOUL_TRANSFER = new Audio('sound:DEVICE_SOUL_TRANSFER.ogg');
		DEVICE_SOUL_TRANSFER.play();

		add(user = new SpriteVessel('white'));
		user.screenCenter();
		user.state = SPIN;

		add(transferMask = new SeaBackdrop(Color.BLACK, FlxPoint.weak(0, -20), FlxPoint.weak(0, 20)));
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

		FlxTween.num(0, 1, 17.5, {
			ease: FlxEase.quintIn,
			onComplete: function(t)
			{
				introComplete = true;
			},
			onUpdate: function(t)
			{
				if (FlxG.keys.justPressed.ENTER)
				{
					DEVICE_SOUL_TRANSFER.time = t.duration * 1000;
					t.percent = 99;
				}
			},
			onStart: function(t)
			{
				introComplete = false;
			},
		}, function(t)
		{
			prisonScaleLerpValue = t;
			user.alpha = t;
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		prison.scaleTo(prisonSize = FlxMath.lerp(prisonSize, prisonSizeTarget, prisonScaleLerpValue));
		prison.screenCenter();
	}
}
