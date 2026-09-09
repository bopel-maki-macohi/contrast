package contrast.state.blue;

class BlueStart extends StateMovingUser
{
	private var point1:SpriteTargetPoint;

	override function create()
	{
		super.create();

		add(point1 = new SpriteTargetPoint('white', user));
		point1.screenCenter();
		point1.onSelection.add(function()
		{
			trace('Hello');
		});

		onSectorChange(location[0], location[1]);
	}

	override function onSectorChange(x:Int, y:Int)
	{
		super.onSectorChange(x, y);

		point1.visible = x == 0 && y == 0;
	}
}
