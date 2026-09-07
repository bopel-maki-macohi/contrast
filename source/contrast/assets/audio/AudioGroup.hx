package contrast.assets.audio;

class AudioGroup extends Group<Audio>
{
	public var volume(default, set):Float;

	private function set_volume(volume:Float):Float
	{
		this.volume = volume;

		for (audio in list) audio.volume = volume;

		return volume;
	}

	override public function new()
	{
		super();

		list = [];
	}

	override function toString():String
	{
		return 'AudioGroup(volume: $volume, length: $length)';
	}

	public function play(path:String, forceRestart = false, start = 0.0, ?end:Float)
	{
		for (audio in list)
		{
			if (audio.path == path) audio.play(forceRestart, start, end);
		}
	}

	public function add(...params:Any)
	{
		if (params.length == 1) addPotentialFile(params[0]);
	}

	public function remove(...params:Any)
	{
		if (params.length == 1) removePotentialFile(params[0]);
	}

	public function addPotentialFile(file:Any)
	{
		var audio:Audio = null;

		if (file is String) audio = new Audio(file);

		if (file is Audio) audio = file;

		if (audio == null || audio?.data == null || list.indexOf(audio) != -1) return false;

		var audioWithSamePath = false;

		for (subaudio in list)
		{
			if (subaudio.path == audio.path)
			{
				audioWithSamePath = true;
				break;
			}
		}

		if (audioWithSamePath) return false;

		list.push(audio);
		return true;
	}

	public function removePotentialFile(file:Any)
	{
		var audio:Audio = null;

		if (file is String)
		{
			for (subaudio in list) if (subaudio.path == file)
			{
				audio = subaudio;
				break;
			}
		}

		if (file is Audio) audio = file;

		if (list.indexOf(audio) == -1) return false;

		return list.remove(audio);
	}
}
