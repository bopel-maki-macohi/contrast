package text;

import flixel.math.FlxPoint;
import flixel.FlxSprite;

class TextGlow extends Text
{
	private var glowSprite(default, null):FlxSprite;

	public var glowGeneralStrength = 25;
	
	public var glowStrength = FlxPoint.get(10, 10);

	public var glowPadding = FlxPoint.get(10.0, 10.0);

	public var glowTick = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		glowTick++;
	}

	override function draw()
	{
		if (glowSprite == null)
		{
			glowSprite = new FlxSprite();
			glowSprite.blend = ADD;
		}
		glowSprite.loadGraphicFromSprite(this);
		glowSprite.camera = camera;

		{
			glowSprite.alpha = glowGeneralStrength / 100;
			glowSprite.x = this.x + glowPadding.x + Math.sin(glowTick * glowPadding.x);
			glowSprite.y = this.y + glowPadding.y + Math.cos(glowTick * glowPadding.y);

			if (glowSprite.alpha > 0) glowSprite.draw();
		}

		super.draw();
	}
}
