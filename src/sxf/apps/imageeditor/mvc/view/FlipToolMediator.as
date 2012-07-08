package sxf.apps.imageeditor.mvc.view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.FlipTool;
	import sxf.apps.imageeditor.events.FlipToolEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	
	public class FlipToolMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "flipToolMediator";
		
		public function FlipToolMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			flipTool.addEventListener(FlipToolEvent.FLIP_IMAGE_HORIZONTAL,onFlipImageHorizontal);
			flipTool.addEventListener(FlipToolEvent.FLIP_IMAGE_VERICAL,onFlipImageVertical);
		}
		
		override public function onRemove():void
		{
			flipTool.removeEventListener(FlipToolEvent.FLIP_IMAGE_HORIZONTAL,onFlipImageHorizontal);
			flipTool.removeEventListener(FlipToolEvent.FLIP_IMAGE_VERICAL,onFlipImageVertical);

		}

		private function get flipTool():FlipTool
		{
			return viewComponent as FlipTool;
		}
		
		// 事件监听
		
		
		private function onFlipImageHorizontal(e:FlipToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.flipImageHorizontal();
		}
		
		private function onFlipImageVertical(e:FlipToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.flipImageVertical();
		}
		
	}
}