package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ImageStageEvent extends Event
	{
		public static const DRAGE_IMAGE:String = "dragImage";
		
		private var _initPoint:Point;
		private var _endPoint:Point;
		
		public function ImageStageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, initPoint:Point=null, endPoint:Point=null)
		{
			super(type, bubbles, cancelable);
			this._initPoint = initPoint;
			this._endPoint = endPoint;
		}
		
		public function get initPoint():Point
		{
			return _initPoint;
		}
		
		public function get endPoint():Point
		{
			return _endPoint;
		}
		
		override public function clone():Event
		{
			return new ImageStageEvent(type, bubbles, cancelable,initPoint,endPoint);
		}
	}
}