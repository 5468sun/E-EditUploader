package sxf.apps.imageeditor.events{
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ToolCropEvent extends Event{
		
		public static const RATIO_STATUS_CHANGE:String = "RATIO_STATUS_CHANGE";
		//public static const RECTANGLE_CHANGE:String = "RECTANGLE_CHANGE";
		public static const RECTANGLE_XY_CHANGE:String = "RECTANGLE_XY_CHANGE";
		public static const RECTANGLE_WH_CHANGE:String = "RECTANGLE_WH_CHANGE";
		public static const BEGIN:String = "CROP_BEGIN";
		public static const CONFIRM:String = "CROP_CONFIRM";
		public static const CANCEL:String = "CROP_CANCEL";
		
		
		
		private var _ratioValue:Number;
		private var _ratioStatus:Boolean;
		private var _rect:Rectangle;
		
		//private var _newWidth:Number;
		//private var _newHeight:Number;
		
		public function ToolCropEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false, keepRatio:Boolean=false, ratio:Number=NaN,rectangle:Rectangle=null){
			
			super(type, bubbles, cancelable);
			this._ratioValue = ratio;
			this._ratioStatus = keepRatio;
			this._rect = rectangle;
			
			//this._newWidth = newWidth;
			//this._newHeight = newHeight;
		}
		
		public function get ratioValue():Number{
		
			return _ratioValue;
			
		}
		
		public function get ratioStatus():Boolean{
		
			return _ratioStatus;
		
		}
		
		public function get rect():Rectangle{
			
			return _rect;
			
		}
		
		/*public function get newWidth():Number{
		
			return _newWidth;
		
		}
		
		public function get newHeight():Number{
			
			return _newHeight;
			
		}*/
		
		override public function clone():Event{
			
			return new ToolCropEvent(type,bubbles,cancelable,ratioStatus,ratioValue,rect);
		}
	}
}

