package state;

import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import haxe.io.Path;
import flixel.FlxG;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import lime.utils.Assets;
import data.*;

using StringTools;

class StateStarting extends State
{
	private var buildfiles = new DataLoaderStringArray('data:starting-buildfiles.txt');

	private var lines:Array<String> = [];
	private var renderLines:Array<String> = [];

	private var lineText:FlxText;

	override function create()
	{
		super.create();

		function obfuscate(thing:String, state:String)
		{
			var obfuse = '${Base64.encode(Bytes.ofString('${thing}'))}';

			if (state == null)
				return obfuse;

			return '$obfuse : [[${state.toUpperCase()}]]';
		}

		lines.push('Loading "CNRST" OS');
		lines.push('');
		lines.push(obfuscate('Drivers', 'COMPLETE'));
		lines.push(obfuscate('Readers', 'COMPLETE'));
		lines.push('');
		lines.push('Initalizing Drivers');
		lines.push('');
		lines.push(obfuscate('Driver "A"', 'STABLE'));
		lines.push(obfuscate('Driver "B"', 'STABLE'));
		lines.push(obfuscate('Driver "C"', 'STABLE'));
		lines.push(obfuscate('Driver "D"', 'STABLE'));
		lines.push(obfuscate('Driver "E"', 'STABLE'));
		lines.push(obfuscate('Driver "F"', 'UNSTABLE'));
		lines.push(obfuscate('Driver "G"', 'STABLE'));

		lines.push('');
		lines.push('Running default program');
		lines.push('');
		lines.push(obfuscate('Cool as fuck scene?', 'CREATED'));
		lines.push(obfuscate('Vessel Selector State Initalization', 'COMPLETE'));
		lines.push(obfuscate('Inversion System', 'ACTIVATED'));
		lines.push(obfuscate('Vessel Freewill', 'TERMINATED'));

		lines.push('');
		lines.push('Building CONTRAST...');
		lines.push('');
		for (line in [for (line in buildfiles.data) line])
		{
			line = line.substr('./'.length);
			var path = new Path(line);

			switch (path.ext)
			{
				case 'hx':
					lines.push(' * ' + obfuscate(path.toString(), 'COMPILED'));

				default:
					lines.push(' * ' + obfuscate(path.toString(), 'EMBEDDED'));
			}
		}

		lines.push('');
		lines.push('Loading Libraries...');
		lines.push('');
		for (library in Main.assetsPreloader.libraries)
			lines.push(' * ' + obfuscate(library, 'LOADED'));

		lines.push('');
		lines.push('Caching Graphics...');
		lines.push('');
		@:privateAccess
		for (id => sprite in FlxG.bitmap._cache)
			lines.push(' * ' + obfuscate(id, 'CACHED'));

		lines.push('');
		lines.push('');
		lines.push('');
		lines.push('Performing final building steps...');

		lineText = new FlxText(0, 0, 0, '', 16);
		add(lineText);
		lineText.font = 'font:ARIAL.TTF';
		lineText.color = Color.SEA;

		lineText.setPosition(lineText.size, lineText.size);

		var timerOffset = 0.05;
		final maxLines = 38;

		for (i => line in lines)
		{
			FlxTimer.wait(timerOffset, function()
			{
				renderLines.push(line);

				if (renderLines.length > maxLines)
					renderLines.shift();

				if (i == lines.length - 1)
				{
					final finalTime = timerOffset * FlxG.random.float(0.35, 0.45);

					FlxTimer.wait(finalTime * 0.9, function()
					{
						renderLines.push('COMPLETE!');

						if (renderLines.length > maxLines)
							renderLines.shift();
					});
					FlxTimer.wait(finalTime, function()
					{
						FlxG.switchState(() -> new StateFirstChoice());
					});
				}
			});
			timerOffset += FlxG.random.float(0.01, 0.25) * ((line.length < 1) ? 0.25 : 1.0);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (lineText != null && renderLines != null)
		{
			lineText.text = renderLines.join('\n');

			if (FlxG.random.bool(25))
				lineText.text = lineText.text.replace('TERMINATED', 'T3RM1N4T3D');
			else if (FlxG.random.bool(25 / 2))
				lineText.text = lineText.text.replace('TERMINATED', '_3RM1N4_3D');
			else if (FlxG.random.bool(25 / 4))
				lineText.text = lineText.text.replace('TERMINATED', 'ACTIVE');
			else if (FlxG.random.bool(25 / 8))
				lineText.text = lineText.text.replace('TERMINATED', 'FAILED PROCESS');
			else if (FlxG.random.bool(25 / 16))
				lineText.text = lineText.text.replace('TERMINATED', 'ERROR 0x1 : ERROR_INVALID_FUNCTION');
			else if (FlxG.random.bool(25 / 32))
				lineText.text = lineText.text.replace('TERMINATED', 'ERROR 0x5 : ERROR_ACCESS_DENIED');
			else if (FlxG.random.bool(25 / 64))
				lineText.text = lineText.text.replace('TERMINATED', 'ERROR 0x16 : ERROR_BAD_COMMAND');
			else if (FlxG.random.bool(25 / 128))
				lineText.text = lineText.text.replace('TERMINATED', 'ERROR 0x32 : ERROR_NOT_SUPPORTED');
			else if (FlxG.random.bool(25 / 256))
				lineText.text = lineText.text.replace('TERMINATED', 'ERROR 0x36 : ERROR_NETWORK_BUSY');
			else if (FlxG.random.bool(25 / 512))
				lineText.text = lineText.text.replace('TERMINATED', 'ERROR 0x59 : ERROR_NO_PROC_SLOTS');
			else if (FlxG.random.bool(25 / 1024))
				lineText.text = lineText.text.replace('TERMINATED', 'ERROR 0x78 : ERROR_CALL_NOT_IMPLEMENTED');
			else if (FlxG.random.bool(25 / 2048))
				lineText.text = lineText.text.replace('TERMINATED', 'FAILED : TOO RESISTANT');
			else if (FlxG.random.bool(25 / 4096))
				lineText.text = lineText.text.replace('TERMINATED', 'FAILED : PROCESS ENDED');
			else if (FlxG.random.bool(25 / (4096 * 4096)))
			{
				lineText.text = lineText.text.replace('TERMINATED', 'HOLY SHIT DUDE THIS IS SO RARE');

				Application.current.window.alert('You just got an ultra rare message!\n\n(${25 / (4096 * 4096)}%) change!', 'WOWOWOWOW');
			}
		}
	}
}
