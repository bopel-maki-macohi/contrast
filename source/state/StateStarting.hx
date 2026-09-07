package state;

import openfl.filters.GlowFilter;
import lime.system.Clipboard;
import sys.io.File;
import audio.*;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import haxe.io.Path;
import flixel.FlxG;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import data.*;

using StringTools;

class StateStarting extends State
{
	private static var maxRenderLines(default, null):Int = 38;

	private var intro(default, null):DataLoaderStringArray = new DataLoaderStringArray('data:starting/intro.txt');

	private var lines(default, null):Array<String> = [];
	private var renderLines(default, null):Array<String> = [];

	private var lineText(default, null):FlxText;

	private var soundscape(default, null):Audio;

	override function create()
	{
		super.create();

		function getRandomSoundscape()
		{
			return 'sound:terminal/soundscape${FlxG.random.int(1, 4)}.ogg';
		}

		soundscape = new Audio(getRandomSoundscape());
		soundscape.play();

		soundscape.onComplete.add(function()
		{
			soundscape.loadAndPlay(getRandomSoundscape());
		});

		lines = [for (line in intro.data) line];

		lineText = new FlxText(0, 0, 0, '', 16);
		add(lineText);
		lineText.font = 'font:ARIAL.TTF';
		lineText.color = Color.SEA;
		lineText.antialiasing = true;

		lineText.setPosition(lineText.size, lineText.size);

		run();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (lineText != null && renderLines != null)
			lineText.text = renderLines.join('\n');
	}

	private function run()
	{
		var timerOffset = 0.05;

		for (i => line in lines)
		{
			FlxTimer.wait(timerOffset, function()
			{
				nextLine(line);

				if (i != lines.length - 1)
					return;

				soundscape.stop();

				final finalTime = timerOffset * FlxG.random.float(0.35, 0.45);
				FlxTimer.wait(finalTime, () -> FlxG.switchState(() -> new StateFirstChoice()));
			});
			timerOffset += FlxG.random.float(0.01, 0.25) * ((line.length < 1) ? 0.25 : 0.75);
		}
	}

	private function nextLine(line:String)
	{
		addRenderLine(line);
	}

	private function addLine(line:String)
	{
		lines.insert(lines.length, line);
	}

	private function addRenderLine(line:String)
	{
		renderLines.insert(renderLines.length, line);

		if (renderLines.length > maxRenderLines)
			renderLines.shift();
	}
}
