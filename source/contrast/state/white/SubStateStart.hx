package contrast.state.white;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;

class SubStateStart extends SubState
{
	private var start(default, null):Audio;

	private var news(default, null):DataLoaderString = new DataLoaderString('data:news/09-11-16c.txt');
	private var newsText(default, null):Text;

	private var background(default, null):Sprite;

	override function create()
	{
		super.create();

		start = new Audio('sound:easteregg/Start.ogg');
		start.onComplete.add(function()
		{
			StatePreloader.moveToNextState();
		});

		add(background = new Sprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, Color.BLACK));
		background.alpha = 0;
		FlxTween.tween(background, {alpha: 1}, start.length / 1000, {ease: FlxEase.quintInOut});

		add(newsText = new Text(0, 0, FlxG.width / 2, news.data));
		newsText.alignment = CENTER;
		newsText.screenCenter();
		newsText.alpha = 0;
		FlxTween.tween(newsText, {alpha: 1}, start.length / 1000, {ease: FlxEase.quintInOut});

		start.play();
	}
}
