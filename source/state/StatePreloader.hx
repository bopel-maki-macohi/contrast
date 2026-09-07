package state;

import data.DataLoaderString;
#if sys
import sys.thread.Thread;
#end
import sprite.Sprite;
import sprite.SeaBackdrop;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import preloader.*;
import flixel.FlxG;

class StatePreloader extends State
{
	private var assetsPreloader(default, null):PreloaderAssets;
	private var done(default, null):Int = 0;

	private var tasksText(default, null):FlxText;

	private var reminder(default, null):DataLoaderString = new DataLoaderString('debug:REMINDER.txt');
	private var reminderText(default, null):FlxText;

	private var pressEnter(default, null):Sprite;

	private var currentTasks(get, never):Array<String>;

	private function get_currentTasks():Array<String>
	{
		return [
			for (preloader in preloaders)
				if (preloader != null) '${preloader.label} : ${preloader.currentTask} ( ${preloader.done} / ${preloader.assets} )'
		];
	}

	private var preloaders(get, never):Array<Preloader>;

	private function get_preloaders():Array<Preloader>
	{
		return [assetsPreloader];
	}

	override public function new()
	{
		super();

		assetsPreloader = new PreloaderAssets();
	}

	override function create()
	{
		super.create();

		var seaBG:SeaBackdrop;
		add(seaBG = new SeaBackdrop(Color.GRAY, FlxPoint.weak(-10, 0), FlxPoint.weak(10, 0)));

		add(tasksText = new FlxText(0, 0, FlxG.width, '', 16));

		if (reminder.data != null)
		{
			add(reminderText = new FlxText(0, 0, FlxG.width, reminder.data, 8));
			reminderText.alignment = RIGHT;
			reminderText.x = FlxG.width - reminderText.width;
		}

		add(pressEnter = new Sprite().loadGraphic('image:ui/key-enter.png'));
		pressEnter.setPosition(FlxG.width - pressEnter.width, FlxG.height - pressEnter.height);
		pressEnter.visible = false;

		for (preloader in preloaders)
		{
			preloader.completeSignal.add(onPreloaderComplete);

			preloader.preload();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		tasksText.text = 'Progress : ${done} / ${preloaders.length}\n\nPreloaders:\n\n${currentTasks.join('\n')}';

		if (#if debug FlxG.keys.justPressed.ENTER && #end pressEnter.visible)
			moveToStartState();
	}

	private function onPreloaderComplete()
	{
		done++;

		if (done == preloaders.length)
			pressEnter.visible = true;
	}

	private function moveToStartState()
	{
		FlxG.switchState(() -> new StateFirstChoice());
	}
}
