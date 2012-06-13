package sxf.apps.imageeditor.comps
{
	import flash.events.MouseEvent;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	import sxf.apps.imageeditor.events.ZoomToolEvent;
	
	public class ZoomTool extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var _zoomInBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _zoomOutBtn:SkinnableComponent;
		
		[SkinPart(required="false")]
		public var _zoomValueDisplay:Label;
		
		private var _zoomValue:Number;
		
		public function ZoomTool()
		{
			super();
		}
		
		public function get zoomValue():Number
		{
			return _zoomValue;
		}
		
		public function set zoomValue(value:Number):void
		{
			if(value != _zoomValue)
			{
				_zoomValue = value;
				invalidateDisplayList();
			}
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case _zoomInBtn:
					_zoomInBtn.addEventListener(MouseEvent.CLICK,onZoomIn);
					break;
				
				case _zoomOutBtn:
					_zoomOutBtn.addEventListener(MouseEvent.CLICK,onZoomOut);
					break;
				
				case _zoomValueDisplay:
					// do nothing
					break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case _zoomInBtn:
					_zoomInBtn.removeEventListener(MouseEvent.CLICK,onZoomIn);
					break;
				
				case _zoomOutBtn:
					_zoomOutBtn.removeEventListener(MouseEvent.CLICK,onZoomOut);
					break;
				
				case _zoomValueDisplay:
					// do nothing
					break;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			_zoomValueDisplay.text = Math.round(zoomValue*100) + "%";
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		private function onZoomIn(e:MouseEvent):void
		{
			dispatchEvent(new ZoomToolEvent(ZoomToolEvent.ZOOM_IN));
		}
		
		private function onZoomOut(e:MouseEvent):void
		{
			dispatchEvent(new ZoomToolEvent(ZoomToolEvent.ZOOM_OUT));
		}
	}
}