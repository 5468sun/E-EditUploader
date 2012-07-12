package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	public class ImageEditorEvent extends Event
	{
		public static const LOAD_IMAGE:String = "loadImage";
		public static const RESET_IMAGE:String = "resetImage";
		
		private var _url:String;
		
		public function ImageEditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, url:String=null)
		{
			super(type, bubbles, cancelable);
			_url = url;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		override public function clone():Event
		{
			return new ImageEditorEvent(type,bubbles,cancelable,url);
		}
	}
}