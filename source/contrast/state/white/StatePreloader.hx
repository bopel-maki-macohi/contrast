package contrast.state.white;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
#if sys
import sys.thread.Thread;
#end
import flixel.math.FlxPoint;
import flixel.FlxG;

class StatePreloader extends State
{
	private var librariesPreloader(default, null):PreloaderLibraries = new PreloaderLibraries();
	private var assetsColPreloader(default, null):PreloaderAssetsColorable = new PreloaderAssetsColorable();
	private var assetsRegPreloader(default, null):PreloaderAssetsRegular = new PreloaderAssetsRegular();

	private var totalTasks(default, null):Int = 0;
	private var done(default, null):Int = 0;

	private var tasksText(default, null):Text;

	private var reminder(default, null):DataLoaderString = new DataLoaderString('debug:REMINDER.txt');
	private var reminderText(default, null):Text;

	private var progressBar(default, null):FlxBar;

	private var seaBG(default, null):SeaBackdrop;

	private var canContinue(default, null):Bool = false;

	private var UI(get, never):Array<FlxSprite>;

	private function get_UI():Array<FlxSprite> return [tasksText, reminderText, progressBar];

	private var currentTasks(get, never):Array<String>;

	private function get_currentTasks():Array<String> return [
		for (preloader in preloaders) if (preloader != null) '${preloader.label} : ${preloader.currentTask} ( ${preloader.done} / ${preloader.assets} )'
	];

	private var preloaders(get, never):Array<Preloader>;

	private function get_preloaders():Array<Preloader> return [librariesPreloader, assetsColPreloader, assetsRegPreloader];

	override function create()
	{
		super.create();

		Window.title = 'DEVICE';

		for (preloader in preloaders) totalTasks += preloader.assets;

		var DEVICE_COMPILING:Audio = new Audio('sound:DEVICE_COMPILING.ogg');

		DEVICE_COMPILING.looped = true;
		DEVICE_COMPILING.volume = 0.125;
		DEVICE_COMPILING.play();

		add(seaBG = new SeaBackdrop(Color.WHITE, FlxPoint.weak(-10, 0), FlxPoint.weak(10, 0)));

		seaBG.colorBG.alpha = 0.125;

		if (!Main.debug)
		{
			seaBG.colorBG.visible = false;
			seaBG.seas(function(s, i)
			{
				s.blend = NORMAL;
				s.alpha = 0.05;
			});
		}
		else seaBG.colorBG.color = Color.GRAY;

		add(tasksText = new Text(0, 0, FlxG.width, ''));

		if (reminder.data != null && reminder.data.length > 0 && Macro.getDefined('debug'))
		{
			add(reminderText = new Text(0, 0, FlxG.width, reminder.data));
			reminderText.alignment = RIGHT;
			reminderText.x = FlxG.width - reminderText.width;
		}

		add(progressBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, 16, this, 'done', 0, totalTasks));
		progressBar.createFilledBar(Color.RED, Color.LIME);
		progressBar.screenCenter();
		progressBar.y = FlxG.height - progressBar.height;

		for (preloader in preloaders)
		{
			preloader.tickSignal.add(onPreloaderTick);

			#if sys
			Thread.create(function()
			{
			#end
				GeneralTool.repeat(function(i)
				{
					if (Preloader.taskMultiplier > 1) trace('${preloader.label} : Loop $i');
					preloader.preload();
				}, Preloader.taskMultiplier);
			#if sys
			});
			#end
		}

		if (!Main.debug) hideUIInstant();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (tasksText.visible)
			tasksText.text = 'Progress : ${done} / ${totalTasks}\n\nTask Multiplier: ${Preloader.taskMultiplier}\nPreloaders:\n\n${currentTasks.join('\n')}';

		if (canContinue && subState == null)
		{
			if (Save.data.options?.stayInPreloader && !FlxG.keys.justReleased.ANY) return;

			if (FlxG.keys.justReleased.PRINTSCREEN) return;

			moveToNextState();
		}
	}

	private function onPreloaderTick()
	{
		done++;

		if (done == totalTasks)
		{
			canContinue = true;

			if (!Main.debug) seaBG.seas(function(s, i)
			{
				FlxTween.tween(s, {alpha: 0.1}, 2, {ease: FlxEase.quintOut});
			});

			FlxTween.tween(seaBG.colorBG, {alpha: 0.25}, 2, {ease: FlxEase.quintOut});

			FlxTimer.wait(Macro.getDefined('EASTER_EGG_AINSTANT') ? 1 : 10 + Save.data.contrast, potentialEasterEgg);
		}
	}

	private function potentialEasterEgg()
	{
		trace('Potential Easter Weg : ${Save.data.contrast}');

		final tweenDuration = 12.0;

		function tweenColorBG(newColor:FlxColor)
		{
			seaBG.colorBG.visible = true;

			var currentColorBGColor = seaBG.colorBG.color;
			currentColorBGColor.alphaFloat = seaBG.colorBG.alpha;

			var targetColor:FlxColor = newColor;
			targetColor.alphaFloat = currentColorBGColor.alphaFloat;

			FlxTween.color(seaBG.colorBG, tweenDuration, currentColorBGColor, targetColor, {ease: FlxEase.sineInOut});
		}

		function addTheText(t:String)
		{
			var text:Text;
			add(text = new Text(0, 0, 0, t, 32));

			text.alignment = CENTER;
			text.screenCenter();
			text.alpha = 0;

			FlxTween.tween(text, {alpha: 1}, tweenDuration, {ease: FlxEase.sineInOut});
		}

		switch (Save.contrast)
		{
			case 0:
				hideUITransition();
				openSubState(new SubStateStart());

			case 67:
				hideUITransition();
				tweenColorBG(Color.BLUE);
				addTheText('Abnormal\nOnly liked by certain people.');

			case 68:
				hideUITransition();
				tweenColorBG(Color.WHITE);
				addTheText('Do you know what it\'s like to be right inbetween 2 worlds?\n2 Communities?\n2 Personalities?');

			case 69:
				hideUITransition();
				tweenColorBG(Color.YELLOW);
				addTheText('A Classic\nThe one that everyone loves');

			//
			//
			// PEOPLE
			//
			//

			case 5:
				hideUITransition();
				trace('Macadam (Earth Clone)');
				trace('Side: Yellow');

			case 64:
				hideUITransition();
				trace('Macadam (Mask Clone)');
				trace('Side: Blue');
				trace('But isn\'t joy supposed to be Yellow?');

			case 30:
				hideUITransition();
				trace('Rustty');
				trace('Side: Blue');
				trace('Booze');

			case 107:
				hideUITransition();
				trace('Requavar');
				trace('Side: Yellow');

			case 176:
				hideUIInstant();
				trace('TracedInPurple');
				trace('Side: Blue');
		}
	}

	public static function moveToNextState()
	{
		final STATE_NEXT:String = Macro.getDefineValue('STATE_NEXT')?.toLowerCase();

		if (STATE_NEXT == 'first_choice') FlxG.switchState(() -> new StateFirstChoice());
		else if (STATE_NEXT == 'blue_options_menu') FlxG.switchState(() -> new StateOptions(true));
		else if (STATE_NEXT == 'yellow_options_menu') FlxG.switchState(() -> new StateOptions(false));
		else if (STATE_NEXT == 'blue_menu' || Save.data.alliance == 0) FlxG.switchState(() -> new BlueMenu());
		else if (STATE_NEXT == 'yellow_menu' || Save.data.alliance == 1) FlxG.switchState(() -> new BlueMenu());
		else FlxG.switchState(() -> new StateFirstChoice());
	}

	private function showUIInstant()
	{
		for (obj in UI)
		{
			if (obj == null || !members.contains(obj)) continue;
			obj.visible = true;
		}
	}

	private function hideUIInstant()
	{
		for (obj in UI)
		{
			if (obj == null || !members.contains(obj)) continue;
			obj.visible = false;
		}
	}

	private function showUITransition()
	{
		for (obj in UI)
		{
			if (obj == null || !members.contains(obj) || !obj.visible) continue;
			FlxTween.cancelTweensOf(obj);
			FlxTween.tween(obj, {alpha: 1}, 1, {ease: FlxEase.quintOut});
		}
	}

	private function hideUITransition()
	{
		for (obj in UI)
		{
			if (obj == null || !members.contains(obj) || !obj.visible) continue;
			FlxTween.cancelTweensOf(obj);
			FlxTween.tween(obj, {alpha: 0}, 1, {ease: FlxEase.quintOut});
		}
	}
}
