package sxf.apps.imageeditor.comps
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.NumericStepper;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.effects.Fade;
	
	import sxf.apps.imageeditor.events.CropToolEvent;
	
	public class CropTool extends SkinnableComponent
	{
		//private var _cropRectangle:Rectangle = new Rectangle();
		private var _restrainRectangle:Rectangle = new Rectangle();
		private var _realCropRectangle:Rectangle = new Rectangle();
		
		

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
			deActivate();
		}

		public function get restrainRectangle():Rectangle
		{
			return _restrainRectangle;
		}

		public function set restrainRectangle(value:Rectangle):void
		{
			if(!value.equals(_restrainRectangle))
			{
				_restrainRectangle = value;
				invalidateProperties();
				invalidateDisplayList();
			}
		}

		public function get realCropRectangle():Rectangle
		{
			return _realCropRectangle;
		}
		
		public function set realCropRectangle(value:Rectangle):void
		{
			if(!value.equals(_realCropRectangle))
			{
				_realCropRectangle = value;
				invalidateProperties();
				invalidateDisplayList();
			}
			
		}
		
		public function activate():void
		{
			this.visible = true;
			this.includeInLayout = true;
		}
		
		public function deActivate():void
		{
			this.visible = false;
			this.includeInLayout = false;
		}
		
		public function restrainStepper():void
		{
			_xInput.minimum = 0 ;
			_xInput.maximum = restrainRectangle.width - realCropRectangle.width;
			_yInput.minimum = 0 ;
			_yInput.maximum = restrainRectangle.height - realCropRectangle.height;
			_wInput.minimum = 0;
			_wInput.maximum = restrainRectangle.width - realCropRectangle.x;
			_hInput.minimum = 0;
			_hInput.maximum = restrainRectangle.height - realCropRectangle.y;
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
				
				case _confirmBtn:
					instance.removeEventListener(MouseEvent.CLICK,onCropConfirm);
					break;
				
				case _cancelBtn:
					instance.removeEventListener(MouseEvent.CLICK,onCropCancel);
					break;
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			restrainStepper();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			_wInput.value = realCropRectangle.width;
			_hInput.value = realCropRectangle.height;
			_xInput.value = realCropRectangle.x;
			_yInput.value = realCropRectangle.y;
			
			
			/*if(mouseLocation.x<0 || mouseLocation.y<0)
			{
				_xInput.value = rectangle.x;
				_yInput.value = rectangle.y;
			}
			else
			{
				
				_xInput.value = mouseLocation.x;
				_yInput.value = mouseLocation.y;
			}*/
			
			
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