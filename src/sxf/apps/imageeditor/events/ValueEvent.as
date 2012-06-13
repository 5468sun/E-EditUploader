package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	public class ValueEvent extends Event
	{
		private var _value:Number;
		
		public function ValueEvent(value:Number,type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._value = value;
		}
		public function get value():Number
		{
			return _value;
		}
		
		override public function clone():Event
		{
			return new ValueEvent(value,type);
		}
	}
}