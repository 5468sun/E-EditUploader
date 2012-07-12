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
		
		
		private var _zoomValue:Number;
		
		public function ZoomTool()
		{
			super();
			deActivate();
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
				
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
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