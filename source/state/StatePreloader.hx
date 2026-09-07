package state;

import flixel.ui.FlxBar;
import data.DataLoaderString;
#if sys
import sys.thread.Thread;
#end
import sprite.Sprite;
import sprite.SeaBackdrop;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import preloader.*;
import flixel.FlxG;

class StatePreloader extends State
{
	private var librariesPreloader(default, null):PreloaderLibraries = new PreloaderLibraries();
	private var assetsNVPreloader(default, null):PreloaderAssetsNonVessel = new PreloaderAssetsNonVessel();
	private var assetsVPreloader(default, null):PreloaderAssetsVessel = new PreloaderAssetsVessel();

	private var totalTasks(default, null):Int = 0;
	private var done(default, null):Int = 0;

	private var tasksText(default, null):FlxText;

	private var reminder(default, null):DataLoaderString = new DataLoaderString('debug:REMINDER.txt');
	private var reminderText(default, null):FlxText;

	private var progressBar:FlxBar;

	private var pressEnter(default, null):Sprite;

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
		return [librariesPreloader, assetsNVPreloader, assetsVPreloader];
	}

	override function create()
	{
		super.create();

		for (preloader in preloaders) totalTasks += preloader.assets;

		var seaBG:SeaBackdrop;
		add(seaBG = new SeaBackdrop(Color.GRAY, FlxPoint.weak(-10, 0), FlxPoint.weak(10, 0)));

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

		add(pressEnter = new Sprite().loadGraphic('image:ui/key-enter.png'));
		pressEnter.setPosition(FlxG.width - pressEnter.width, FlxG.height - progressBar.height - pressEnter.height);
		pressEnter.visible = false;

		for (preloader in preloaders)
		{
			preloader.tickSignal.add(onPreloaderTick);

			#if sys
			Thread.create(function()
			{
			#end
				GeneralTool.repeat(function()
				{
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

		tasksText.text = 'Progress : ${done} / ${totalTasks}\n\nPreloaders:\n\n${currentTasks.join('\n')}';

		if (#if debug FlxG.keys.justPressed.ENTER && #end pressEnter.visible) moveToStartState();
	}

	private function onPreloaderTick()
	{
		done++;

		if (done == totalTasks) pressEnter.visible = true;
	}

	private function moveToStartState()
	{
		FlxG.switchState(() -> new StateFirstChoice());
	}
}
