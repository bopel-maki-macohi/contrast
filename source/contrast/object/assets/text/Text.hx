package contrast.object.assets.text;

import flixel.text.FlxText;

class Text extends FlxText
{
	override public function new(x = 0.0, y = 0.0, fieldWidth = 0.0, ?text:String, size = 18, embeddedFont = true)
	{
		super(x, y, fieldWidth, text, size, embeddedFont);

        font = 'font:DOSAPP.ttf';
	}
}
