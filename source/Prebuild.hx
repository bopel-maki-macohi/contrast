package source;

import sys.io.File;
import haxe.io.Path;

class Prebuild
{
	static function main()
	{
		#if sys
		var list = readDirectory('.', true, [
			'./.gitignore',
			'./.DS_Store',
			'./.git',
			'./hxformat.json',
			'./Project.xml',
			'./export',
			'./dump',
			'./haxelib',
			'./assets/.DS_Store'
		]);

		File.saveContent('assets/data/starting-buildfiles.txt', list.join('\n'));
		#end
	}

	public static function readDirectory(directory:String, recursive:Bool, ?exclude:Array<String>):Array<Path>
	{
		var dir:Array<Path> = [];

		if (exclude != null && exclude.contains(directory))
			return [];

		#if sys
		for (file in sys.FileSystem.readDirectory(directory))
		{
			final path = '${Path.removeTrailingSlashes(directory)}/$file';

			if (exclude != null && exclude.contains(path))
				continue;

			if (sys.FileSystem.isDirectory(path) && recursive)
			{
				for (filepath in readDirectory(path, recursive))
				{
					if (exclude != null && exclude.contains(filepath.toString()))
						continue;

					dir.push(filepath);
				}
			}
			else
				dir.push(new Path(path));
		}
		#end

		return dir;
	}
}
