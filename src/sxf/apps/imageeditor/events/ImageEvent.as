package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	import sxf.apps.imageeditor.valueobjects.ImageObject;
	
	public class ImageEvent extends Event
	{
		private var _image:ImageObject;
		
		public function ImageEvent(image:ImageObject,type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_image = image;
		}
		
		public function get image():ImageObject
		{
			return _image;
		}
		
		override public function clone():Event
		{
			return new ImageEvent(image, type);
		}
	}
}