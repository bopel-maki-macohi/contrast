package contrast.object.assets.sprite;

enum abstract VesselState(String) from String to String
{
	var IDLE = 'IDLE';
	var IDLE_SIDE = 'IDLE_SIDE';

	var SPIN = 'SPIN';

	var SHOCKED = 'SHOCKED';

	var WALK = 'WALK';
	var WALK_SIDE = 'WALK_SIDE';
}

class SpriteVessel extends Sprite
{
	public var state(default, set):VesselState;

	private function set_state(state:VesselState):VesselState
	{
		this.state = state;

		animation.play(state);

		return state;
	}

	override public function new(colorCode:String, x = 0.0, y = 0.0)
	{
		super(x, y);

		loadBitmapCacheGraphic('${colorCode}_vessel', true, 8, 8);

		animation.add(IDLE, [0]);
		animation.add(IDLE_SIDE, [1]);
		animation.add(SPIN, [0, 1], 4);
		animation.add(SHOCKED, [2], 4);
		animation.add(WALK, [3, 0, 4, 0], 8);
		animation.add(WALK_SIDE, [5, 1, 5, 1], 8);

		state = IDLE;

		scaleTo(4);
	}

	override function loadBitmapCacheGraphic(key:String, animated:Bool = false, frameWidth:Int = 0, frameHeight:Int = 0,
			unique:Bool = false):SpriteVessel return cast super.loadBitmapCacheGraphic(key, animated, frameWidth, frameHeight, unique);
}
