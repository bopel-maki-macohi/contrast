package contrast.state.white;

import flixel.FlxG;

class StateStart extends State
{
	private var start(default, null):Audio;

	private var news(default, null):DataLoaderString = new DataLoaderString('data:news/09-11-16c.txt');
	private var newsText(default, null):Text;

	override function create()
	{
		super.create();

		start = new Audio('sound:easteregg/Start.ogg');
		start.play();
		start.onComplete.add(function()
		{
			StatePreloader.moveToNextState();
		});

		add(newsText = new Text(0, 0, FlxG.width / 2, news.data));
		newsText.alignment = CENTER;
		newsText.screenCenter();
	}
}
