package sxf.apps.imageeditor.mvc.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.ZoomTool;
	import sxf.apps.imageeditor.events.ZoomToolEvent;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	
	public class ZoomToolMediator extends Mediator
	{
		
		public static const NAME:String = "zoomToolMediator";
		
		public function ZoomToolMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function setZoomValue(value:Number):void
		{
			zoomTool.zoomValue = value;
		}
		
		override public function onRegister():void
		{
			zoomTool.addEventListener(ZoomToolEvent.ZOOM_IN,onZoomIn);
			zoomTool.addEventListener(ZoomToolEvent.ZOOM_OUT,onZoomOut);
		}
		
		override public function onRemove():void
		{
			zoomTool.removeEventListener(ZoomToolEvent.ZOOM_IN,onZoomIn);
			zoomTool.removeEventListener(ZoomToolEvent.ZOOM_OUT,onZoomOut);
		}
		
		private function get zoomTool():ZoomTool
		{
			return viewComponent as ZoomTool;
		}
		
		private function onZoomIn(e:ZoomToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.zoomInImage();
		}
		
		private function onZoomOut(e:ZoomToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.zoomOutImage();
		}
	}
}