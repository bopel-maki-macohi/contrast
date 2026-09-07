package preloader;

import lime.utils.Assets;

class PreloaderLibraries extends Preloader
{
	public var libraries(default, null):Array<String> = [];

	override public function new()
	{
		@:privateAccess
		this.libraries = [for (library => lib in Assets.libraries) library];

		super('Assets (Libraries)', libraries.length);
	}

	override function preload()
	{
		super.preload();

		currentTask = 'Loading Libraries';

		for (library in libraries)
		{
			#if !TASK_MULTIPLIER
			trace('Loading Library : $library');
			#end
			
			performTask(function()
			{
				Assets.loadLibrary(library);
			});
		}
	}
}
