package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	public class CropToolEvent extends Event
	{
		public static const CHANGE_X:String = "cropToolChangeX";
		public static const CHANGE_Y:String = "cropToolChangeY";
		public static const CHANGE_W:String = "cropToolChangeW";
		public static const CHANGE_H:String = "cropToolChangeH";
		public static const CONFIRM:String = "cropToolConfirm";
		public static const CANCEL:String = "cropToolCancel";
		
		private var _value:Number;
		public function CropToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,value:Number=NaN)
		{
			super(type, bubbles, cancelable);
			this._value = value;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		override public function clone():Event{
			return new CropToolEvent(type,false,false,value);
		}
	}
}