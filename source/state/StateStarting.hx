package state;

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

	private var base(default, null):DataLoaderStringArray = new DataLoaderStringArray('data:starting-base.txt');
	private var buildfiles(default, null):DataLoaderStringArray = new DataLoaderStringArray('data:starting-buildfiles.txt');

	private var lines(default, null):Array<String> = [];
	private var renderLines(default, null):Array<String> = [];
	private var endingLines(default, null):Array<String> = [];

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

		function obfuscate(thing:String, state:String)
		{
			var obfuse = '${Base64.encode(Bytes.ofString('${thing}'))}';

			if (state == null)
				return obfuse;

			return '$obfuse : [[${state.toUpperCase()}]]';
		}

		for (line in base.data)
		{
			if (line.startsWith('%'))
			{
				switch (line.substr('%'.length))
				{
					case 'os':
						lines.push('* ${obfuscate('Readers', 'INITALIZED')}');
						lines.push('* ${obfuscate('Drivers', 'PREPARING')}');

					case 'drivers':
						lines.push('* ${obfuscate('Drive "A"', 'STABLE')}');
						lines.push('* ${obfuscate('Drive "B"', 'STABLE')}');
						lines.push('* ${obfuscate('Drive "C"', 'STABLE')}');
						lines.push('* ${obfuscate('Drive "D"', 'STABLE')}');
						lines.push('* ${obfuscate('Drive "E"', 'STABLE')}');
						lines.push('* ${obfuscate('Drive "F"', 'UNSTABLE')}');

					case 'defaultPrgm':
						lines.push(obfuscate('Cool as fuck scene?', 'CREATED'));
						lines.push(obfuscate('Vessel Selector State Initalization', 'COMPLETE'));
						lines.push(obfuscate('Inversion System', 'ACTIVATED'));
						lines.push(obfuscate('Vessel Freewill', 'TERMINATED'));

					case 'building':
						for (line in [for (line in buildfiles.data) line])
						{
							line = line.substr('./'.length);
							var path = new Path(line);

							switch (path.ext)
							{
								case 'hx':
									lines.push(' * ' + obfuscate(path.toString(), 'COMPILED'));

								case 'md':
									lines.push(' * ' + obfuscate(path.toString(), 'EXCLUDED'));

								default:
									lines.push(' * ' + obfuscate(path.toString(), 'EMBEDDED'));
							}
						}

					case 'libraries':
						for (library in Main.assetsPreloader.libraries)
							lines.push('* ${obfuscate(library, 'LOADED')}');

					case 'graphics':
						@:privateAccess
						for (id => sprite in FlxG.bitmap._cache)
							lines.push('* ${obfuscate(id, 'LOADED')}');
				}

				continue;
			}

			lines.push(line);
		}

		for (x in 0...FlxG.random.int(3, 4))
		{
			for (y in 1...100)
			{
				final randomThing = 'randomThing$x : ${x * x} : $x^2';

				addEndingLine(obfuscate(randomThing, '${y / 100}%'));
			}
		}

		endingLines.sort((a, b) ->
		{
			return FlxG.random.int(-1, 1);
		});

		lineText = new FlxText(0, 0, 0, '', 16);
		add(lineText);
		lineText.font = 'font:ARIAL.TTF';
		lineText.color = Color.SEA;

		lineText.setPosition(lineText.size, lineText.size);

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

				FlxTimer.wait(finalTime * 0.75, function()
				{
					nextLine('COMPLETE!');
					nextLine('');

					var t = 0.0;

					soundscape.loadAndPlay('sound:terminal/soundscape1.ogg');

					for (endingLine in endingLines)
					{
						t += FlxG.random.float(0, 0.05);
						FlxTimer.wait(t, () -> nextLine(endingLine));
					}
				});

				FlxTimer.wait(finalTime, () -> FlxG.switchState(() -> new StateFirstChoice()));
			});
			timerOffset += FlxG.random.float(0.01, 0.25) * ((line.length < 1) ? 0.25 : 1.0);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (lineText != null && renderLines != null)
			lineText.text = renderLines.join('\n');
	}

	private function nextLine(line:String)
	{
		addRenderLine(line);
	}

	private function addLine(line:String)
	{
		lines.insert(lines.length, line);
	}

	private function addEndingLine(line:String)
	{
		endingLines.insert(endingLines.length, line);
	}

	private function addRenderLine(line:String)
	{
		renderLines.insert(renderLines.length, line);

		if (renderLines.length > maxRenderLines)
			renderLines.shift();
	}
}
