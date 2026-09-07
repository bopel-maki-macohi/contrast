package contrast.assets.data;

import lime.utils.Assets;

using StringTools;

class DataLoaderStringArray extends DataLoader<Array<String>>
{
	override function load(path:String)
	{
		super.load(path);

		if (Assets.exists(path)) data = [for (line in Assets.getText(path).split('\n')) line.trim()];
	}
}
