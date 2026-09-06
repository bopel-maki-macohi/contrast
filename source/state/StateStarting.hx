package state;

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
	private var intro = new DataLoaderStringArray('data:starting-intro.txt');
	private var buildfiles = new DataLoaderStringArray('data:starting-buildfiles.txt');

	private var lines:Array<String> = [];

	private var lineText:FlxText;

	override function create()
	{
		super.create();

		function obfuscate(thing:String, state:String)
		{
			return '${Base64.encode(Bytes.ofString('${thing}'))} : [[${state.toUpperCase()}]]';
		}

		lines = [for (line in intro.data) line];

		lines.push('Building...');
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

		lineText = new FlxText(0, 0, 0, '', 8);
		add(lineText);

		lineText.setPosition(lineText.size, lineText.size);

		var timerOffset = 0.05;

		for (i => line in lines)
		{
			FlxTimer.wait(timerOffset, function()
			{
				lineText.text += '${line}\n';

				if (i == lines.length - 1)
				{
					FlxTimer.wait(timerOffset * FlxG.random.float(0.35, 0.45), function()
					{
						FlxG.switchState(() -> new StateFirstChoice());
					});
				}
			});
			timerOffset += FlxG.random.float(0.01, 0.25) * ((line.length < 1) ? 0.25 : 1.0);
		}
	}
}
