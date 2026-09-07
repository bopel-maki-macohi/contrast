package contrast.util;

import lime.app.Application;

class Window
{
	public static var title(get, set):String;

	private static function get_title():String return Application.current.window.title;

	private static function set_title(title:String):String return Application.current.window.title = title;
}
