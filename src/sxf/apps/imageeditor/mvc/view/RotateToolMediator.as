package sxf.apps.imageeditor.mvc.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.RotateTool;
	import sxf.apps.imageeditor.events.RotateToolEvent;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	
	public class RotateToolMediator extends Mediator
	{
		public static const NAME:String = "rotateToolMediator";
		
		public function RotateToolMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			rotateTool.addEventListener(RotateToolEvent.ROTATE_IMAGE,onRotateImage);
		}
		
		override public function onRemove():void
		{
			rotateTool.addEventListener(RotateToolEvent.ROTATE_IMAGE,onRotateImage);
		}
		
		private function get rotateTool():RotateTool
		{
			return viewComponent as RotateTool;
		}
		
		private function onRotateImage(e:RotateToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.rotateImage(e.angle);
		}
		
	}
}