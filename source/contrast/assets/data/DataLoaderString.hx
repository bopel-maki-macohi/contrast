package contrast.assets.data;

import lime.utils.Assets;

class DataLoaderString extends DataLoader<String>
{
	override function load(path:String)
	{
		super.load(path);

		if (Assets.exists(path)) data = Assets.getText(path);
	}
}
