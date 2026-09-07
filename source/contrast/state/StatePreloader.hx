package contrast.state;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
#if sys
import sys.thread.Thread;
#end
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.FlxG;

class StatePreloader extends State
{
	private var librariesPreloader(default, null):PreloaderLibraries = new PreloaderLibraries();
	private var assetsColPreloader(default, null):PreloaderAssetsColorable = new PreloaderAssetsColorable();
	private var assetsRegPreloader(default, null):PreloaderAssetsRegular = new PreloaderAssetsRegular();

	private var totalTasks(default, null):Int = 0;
	private var done(default, null):Int = 0;

	private var tasksText(default, null):FlxText;

	private var reminder(default, null):DataLoaderString = new DataLoaderString('debug:REMINDER.txt');
	private var reminderText(default, null):FlxText;

	private var progressBar:FlxBar;

	private var pressEnter(default, null):Sprite;

	private var seaBG:SeaBackdrop;

	private var currentTasks(get, never):Array<String>;

	private function get_currentTasks():Array<String>
	{
		return [
			for (preloader in preloaders) if (preloader != null) '${preloader.label} : ${preloader.currentTask} ( ${preloader.done} / ${preloader.assets} )'
		];
	}

	private var preloaders(get, never):Array<Preloader>;

	private function get_preloaders():Array<Preloader>
	{
		return [librariesPreloader, assetsColPreloader, assetsRegPreloader];
	}

	override function create()
	{
		super.create();

		for (preloader in preloaders) totalTasks += preloader.assets;

		add(seaBG = new SeaBackdrop(#if !debug Color.BLACK #else Color.GRAY #end, FlxPoint.weak(-10, 0), FlxPoint.weak(10, 0)));

		#if !debug
		var DEVICE_COMPILING:Audio = new Audio('sound:DEVICE_COMPILING.ogg');

		DEVICE_COMPILING.looped = true;
		DEVICE_COMPILING.volume = 0.125;
		DEVICE_COMPILING.play();

		seaBG.sea1.blend = NORMAL;
		seaBG.sea2.blend = NORMAL;

		seaBG.sea1.alpha = 0.05;
		seaBG.sea2.alpha = 0.05;
		#end

		#if debug
		add(tasksText = new FlxText(0, 0, FlxG.width, '', 16));

		if (reminder.data != null)
		{
			add(reminderText = new FlxText(0, 0, FlxG.width, reminder.data, 8));
			reminderText.alignment = RIGHT;
			reminderText.x = FlxG.width - reminderText.width;
		}

		add(progressBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width, 16, this, 'done', 0, totalTasks));
		progressBar.createFilledBar(Color.RED, Color.LIME);
		progressBar.screenCenter();
		progressBar.y = FlxG.height - progressBar.height;
		#end

		pressEnter = new Sprite().loadGraphic('image:ui/key-enter.png');

		#if debug
		add(pressEnter);
		pressEnter.setPosition(FlxG.width - pressEnter.width, FlxG.height - progressBar.height - pressEnter.height);
		#end

		pressEnter.visible = false;

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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if debug
		tasksText.text = 'Progress : ${done} / ${totalTasks}\n\nTask Multiplier: ${Preloader.taskMultiplier}\nPreloaders:\n\n${currentTasks.join('\n')}';
		#end

		if (FlxG.keys.justPressed.ENTER && pressEnter.visible) moveToStartState();
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
			#end
		}
	}

	private function moveToStartState()
	{
		FlxG.switchState(() -> new StateFirstChoice());
	}
}
