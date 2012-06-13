package sxf.apps.imageeditor.comps
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.NumericStepper;
	import spark.components.supportClasses.SkinnableComponent;
	
	import sxf.apps.imageeditor.events.CropToolEvent;
	
	public class CropTool extends SkinnableComponent
	{
		private var _rectangle:Rectangle = new Rectangle();
		private var _mouseLocation:Point;

		[SkinPart(required="true")]
		public var _xInput:NumericStepper;
		
		[SkinPart(required="true")]
		public var _yInput:NumericStepper;
		
		[SkinPart(required="true")]
		public var _wInput:NumericStepper;
		
		[SkinPart(required="true")]
		public var _hInput:NumericStepper;
		
		[SkinPart(required="true")]
		public var _confirmBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _cancelBtn:SkinnableComponent;
	
		public function CropTool()
		{
			super();
			_mouseLocation = new Point(-1,-1);
		}
		public function get rectangle():Rectangle
		{
			return _rectangle;
		}
		
		public function set rectangle(value:Rectangle):void
		{
			if(!value.equals(_rectangle))
			{
				_rectangle = value;
				invalidateDisplayList();
			}
			
		}
		
		public function get mouseLocation():Point
		{
			return _mouseLocation;
		}
		
		public function set mouseLocation(value:Point):void
		{
			if(!value.equals(_mouseLocation))
			{
				_mouseLocation = value;
				invalidateDisplayList();
			}
		}
		
		public function restrainStepper(restrainRect:Rectangle):void
		{
			/*trace(restrainRect);
			_xInput.minimum = restrainRect.x ;
			_xInput.maximum = restrainRect.width - rectangle.width;
			_yInput.minimum = restrainRect.y ;
			_yInput.maximum = restrainRect.width - rectangle.y;
			_wInput.minimum = 0;
			_wInput.maximum = restrainRect.width - rectangle.x;
			_wInput.minimum = 0;
			_wInput.maximum = restrainRect.height - rectangle.y;*/
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case _xInput:
					instance.addEventListener(Event.CHANGE,onCropValueChange);
					break;
				
				case _yInput:
					instance.addEventListener(Event.CHANGE,onCropValueChange);
					break;
				
				case _wInput:
					instance.addEventListener(Event.CHANGE,onCropValueChange);
					break;
				
				case _hInput:
					instance.addEventListener(Event.CHANGE,onCropValueChange);
					break;
				
				case _confirmBtn:
					instance.addEventListener(MouseEvent.CLICK,onCropConfirm);
					break;
				
				case _cancelBtn:
					instance.addEventListener(MouseEvent.CLICK,onCropCancel);
					break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case _xInput:
					_xInput.removeEventListener(Event.CHANGE,onCropValueChange);
					break;
				
				case _yInput:
					_yInput.removeEventListener(Event.CHANGE,onCropValueChange);
					break;
				
				case _wInput:
					_wInput.removeEventListener(Event.CHANGE,onCropValueChange);
					break;
				
				case _hInput:
					_hInput.removeEventListener(Event.CHANGE,onCropValueChange);
					break;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			_wInput.value = rectangle.width;
			_hInput.value = rectangle.height;

			if(mouseLocation.x<0 || mouseLocation.y<0)
			{
				_xInput.value = rectangle.x;
				_yInput.value = rectangle.y;
			}
			else
			{
				
				_xInput.value = mouseLocation.x;
				_yInput.value = mouseLocation.y;
			}
			
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		//   事件监听函数   ///////////////////////////////////////////////////////////////
		
		private function onCropValueChange(e:Event):void
		{
			var value:Number = NumericStepper(e.currentTarget).value;

			switch(e.currentTarget)
			{
				case _xInput:
					dispatchEvent(new CropToolEvent(CropToolEvent.CHANGE_X,false,false,value));
					break;
				
				case _yInput:
					dispatchEvent(new CropToolEvent(CropToolEvent.CHANGE_Y,false,false,value));
					break;
				
				case _wInput:
					dispatchEvent(new CropToolEvent(CropToolEvent.CHANGE_W,false,false,value));
					break;
				
				case _hInput:
					dispatchEvent(new CropToolEvent(CropToolEvent.CHANGE_H,false,false,value));
					break;
			}
		}
		
		private function onCropConfirm(e:MouseEvent):void
		{
			dispatchEvent(new CropToolEvent(CropToolEvent.CONFIRM,false,false));
		}
		
		private function onCropCancel(e:MouseEvent):void
		{
			dispatchEvent(new CropToolEvent(CropToolEvent.CANCEL,false,false));
		}
	}
}