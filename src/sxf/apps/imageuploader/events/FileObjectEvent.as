package sxf.apps.imageuploader.events
{
	import flash.events.Event;
	
	public class FileObjectEvent extends Event
	{
		
		
		public function FileObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}