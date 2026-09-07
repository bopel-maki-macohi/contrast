package contrast.state;

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

	private var progressBar:FlxBar;

	private var pressEnter(default, null):Sprite;

	private var seaBG:SeaBackdrop;

	private var UI(get, never):Array<FlxSprite>;

	private function get_UI():Array<FlxSprite> return [tasksText, reminderText, progressBar, pressEnter];

	private var currentTasks(get, never):Array<String>;

	private function get_currentTasks():Array<String> return [
		for (preloader in preloaders) if (preloader != null) '${preloader.label} : ${preloader.currentTask} ( ${preloader.done} / ${preloader.assets} )'
	];

	private var preloaders(get, never):Array<Preloader>;

	private function get_preloaders():Array<Preloader> return [librariesPreloader, assetsColPreloader, assetsRegPreloader];

	override function create()
	{
		super.create();

		for (preloader in preloaders) totalTasks += preloader.assets;

		var DEVICE_COMPILING:Audio = new Audio('sound:DEVICE_COMPILING.ogg');

		DEVICE_COMPILING.looped = true;
		DEVICE_COMPILING.volume = 0.125;
		DEVICE_COMPILING.play();

		add(seaBG = new SeaBackdrop(#if !debug Color.BLACK #else Color.GRAY #end, FlxPoint.weak(-10, 0), FlxPoint.weak(10, 0)));

		#if !debug
		seaBG.sea1.blend = NORMAL;
		seaBG.sea2.blend = NORMAL;

		seaBG.sea1.alpha = 0.05;
		seaBG.sea2.alpha = 0.05;
		#else
		seaBG.colorBG.alpha = 0.125;
		#end

		add(tasksText = new Text(0, 0, FlxG.width, '', 16));

		if (reminder.data != null)
		{
			add(reminderText = new Text(0, 0, FlxG.width, reminder.data, 8));
			reminderText.alignment = RIGHT;
			reminderText.x = FlxG.width - reminderText.width;
		}

		add(progressBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, 16, this, 'done', 0, totalTasks));
		progressBar.createFilledBar(Color.RED, Color.LIME);
		progressBar.screenCenter();
		progressBar.y = FlxG.height - progressBar.height;

		pressEnter = new Sprite().loadGraphic('image:ui/key-enter.png');
		pressEnter.setPosition(FlxG.width - pressEnter.width, FlxG.height - progressBar.height - pressEnter.height);
		pressEnter.visible = false;

		#if !debug
		add(pressEnter);
		#end

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

		#if !debug
		hideUIInstant();
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (tasksText.visible)
			tasksText.text = 'Progress : ${done} / ${totalTasks}\n\nTask Multiplier: ${Preloader.taskMultiplier}\nPreloaders:\n\n${currentTasks.join('\n')}';

		if ((FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed) && pressEnter.visible) moveToStartState();
	}

	private function onPreloaderTick()
	{
		done++;

		if (done == totalTasks)
		{
			pressEnter.visible = true;

			#if !debug
			FlxTween.tween(seaBG.sea1, {alpha: 0.1}, 2, {ease: FlxEase.quintOut});
			FlxTween.tween(seaBG.sea2, {alpha: 0.1}, 2, {ease: FlxEase.quintOut});
			#else
			FlxTween.tween(seaBG.colorBG, {alpha: 0.25}, 2, {ease: FlxEase.quintOut});
			#end

			FlxTimer.wait(1, potentialEasterEgg);
		}
	}

	private function potentialEasterEgg()
	{
		return;

		switch (Save.contrast)
		{
			// The start
			case 0: hideUITransition();

			// Abnormal
			// Only liked by certain people
			// Blue
			case 67: hideUITransition();

			// Do you know what it's like to be right inbetween 2 worlds?
			// 2 Communities?
			// 2 Personalities?
			// White
			case 68: hideUITransition();

			// A Classic
			// The one everyone loves
			// Yellow
			case 69: hideUITransition();

			//
			//
			// PEOPLE
			//
			//

			// Macadam (Earth Clone)
			// Side: Yellow
			case 5: hideUITransition();

			// Macadam (Mask Clone)
			// Side: Blue
			// But isn't joy supposed to be Yellow
			case 64: hideUITransition();

			// Rustty
			// Side: Blue
			// Booze
			case 30: hideUITransition();

			// Requavar
			// Side: Yellow
			case 107: hideUITransition();
		}
	}

	private function moveToStartState()
	{
		if (Save.data.alliance == 0)
		{
			FlxG.switchState(() -> new BlueStart());
			return;
		}

		// if (Save.data.alliance == 1) {FlxG.switchState(() -> new YellowStart()); return;}

		FlxG.switchState(() -> new StateFirstChoice());
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
