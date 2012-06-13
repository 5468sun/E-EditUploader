package sxf.apps.imageeditor.mvc.view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.RotateFlipTool;
	import sxf.apps.imageeditor.events.RotateFlipToolEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	
	public class RotateFlipToolMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "rotateFlipToolMediator";
		
		public function RotateFlipToolMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			rotateFlipTool.addEventListener(RotateFlipToolEvent.ROTATE_IMAGE,onRotateImage);
			rotateFlipTool.addEventListener(RotateFlipToolEvent.FLIP_IMAGE_HORIZONTAL,onFlipImageHorizontal);
			rotateFlipTool.addEventListener(RotateFlipToolEvent.FLIP_IMAGE_VERICAL,onFlipImageVertical);
			rotateFlipTool.addEventListener(RotateFlipToolEvent.ROTATE_FLIP_CANCEL,onRotateFlipCancel);
		}
		
		override public function onRemove():void
		{
			
		}

		private function get rotateFlipTool():RotateFlipTool
		{
			return viewComponent as RotateFlipTool;
		}
		
		// 事件监听
		
		private function onRotateImage(e:RotateFlipToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.rotateImage(e.angle);
		}
		
		private function onFlipImageHorizontal(e:RotateFlipToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.flipImageHorizontal();
		}
		
		private function onFlipImageVertical(e:RotateFlipToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.flipImageVertical();
		}
		
		private function onRotateFlipCancel(e:RotateFlipToolEvent):void
		{
			//  do nothing
		}
	}
}