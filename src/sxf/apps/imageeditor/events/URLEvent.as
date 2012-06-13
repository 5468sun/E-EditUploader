package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	public class URLEvent extends Event
	{
		private var _url:String;
		
		public function URLEvent(url:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new URLEvent(url,type);
		}
	}
}