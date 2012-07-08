package sxf.apps.imageeditor.mvc.view
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	import sxf.utils.selector.cropselector.CropSelector;
	import sxf.utils.selector.cropselector.CropSelectorEvent;
	
	public class CropSelectorMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "cropSelectorMediator";
		
		public function CropSelectorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			cropSelector.addEventListener(CropSelectorEvent.SELECT_BEGIN,onCropSelect);
			cropSelector.addEventListener(CropSelectorEvent.SELECT_PROCCESS,onCropSelect);
			cropSelector.addEventListener(CropSelectorEvent.SELECT_FINISH,onCropSelect);
			cropSelector.addEventListener(CropSelectorEvent.SELECT_CANCEL,onCropSelect);
			
			cropSelector.addEventListener(CropSelectorEvent.RESIZE_BEGIN,onCropResize);
			cropSelector.addEventListener(CropSelectorEvent.RESIZE_PROCCESS,onCropResize);
			cropSelector.addEventListener(CropSelectorEvent.RESIZE_FINISH,onCropResize);
			cropSelector.addEventListener(CropSelectorEvent.RESIZE_CANCEL,onCropResize);
			
			cropSelector.addEventListener(CropSelectorEvent.MOVE_BEGIN,onCropMove);
			cropSelector.addEventListener(CropSelectorEvent.MOVE_PROCCESS,onCropMove);
			cropSelector.addEventListener(CropSelectorEvent.MOVE_FINISH,onCropMove);
			cropSelector.addEventListener(CropSelectorEvent.MOVE_CANCEL,onCropMove);
			
			cropSelector.addEventListener(CropSelectorEvent.MOUSE_LOCATION,onCropMouseMove);
		}
		
		override public function onRemove():void
		{
			cropSelector.removeEventListener(CropSelectorEvent.SELECT_BEGIN,onCropSelect);
			cropSelector.removeEventListener(CropSelectorEvent.SELECT_PROCCESS,onCropSelect);
			cropSelector.removeEventListener(CropSelectorEvent.SELECT_FINISH,onCropSelect);
			cropSelector.removeEventListener(CropSelectorEvent.SELECT_CANCEL,onCropSelect);
			
			cropSelector.removeEventListener(CropSelectorEvent.RESIZE_BEGIN,onCropResize);
			cropSelector.removeEventListener(CropSelectorEvent.RESIZE_PROCCESS,onCropResize);
			cropSelector.removeEventListener(CropSelectorEvent.RESIZE_FINISH,onCropResize);
			cropSelector.removeEventListener(CropSelectorEvent.RESIZE_CANCEL,onCropResize);
			
			cropSelector.removeEventListener(CropSelectorEvent.MOVE_BEGIN,onCropMove);
			cropSelector.removeEventListener(CropSelectorEvent.MOVE_PROCCESS,onCropMove);
			cropSelector.removeEventListener(CropSelectorEvent.MOVE_FINISH,onCropMove);
			cropSelector.removeEventListener(CropSelectorEvent.MOVE_CANCEL,onCropMove);
			
			cropSelector.removeEventListener(CropSelectorEvent.MOUSE_LOCATION,onCropMouseMove);
		}
		
		/*override public function listNotificationInterests():Array
		{
			return [ImageEditorFacade.CROP_RESTRAIN_CHANGE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ImageEditorFacade.CROP_RESTRAIN_CHANGE:

					var restrainRect:Rectangle = notification.getBody() as Rectangle;
					cropSelector.restrainRect = restrainRect;
					break;
			}
		}*/
		
		public function setRestrainRect(rectangle:Rectangle):void
		{
			cropSelector.restrainRect = rectangle;
		}
		
		public function setSelectRect(rectangle:Rectangle):void
		{
			cropSelector.cropRect = rectangle;

		}
		
		public function activateCropSelector():void
		{
			cropSelector.activate();
		}
		
		public function deActivateCropSelector():void
		{
			cropSelector.deActivate();
		}
		
		//  事件处理函数    //////////////////////////////////////////////////////////////
		
		
		
		private function onCropSelect(e:CropSelectorEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var newRect:Rectangle = cropSelector.cropRect;
			imageEditorProxy.setCropRectangle(newRect);
		}
		
		private function onCropResize(e:CropSelectorEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var newRect:Rectangle = cropSelector.cropRect;
			imageEditorProxy.setCropRectangle(newRect);
		}
		
		private function onCropMove(e:CropSelectorEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var newRect:Rectangle = cropSelector.cropRect;
			imageEditorProxy.setCropRectangle(newRect);
		}
		
		private function get cropSelector():CropSelector
		{
			return viewComponent as CropSelector;
		}
		
		private function onCropMouseMove(e:CropSelectorEvent):void
		{
			//sendNotification(ImageEditorFacade.CROP_MOUSE_LOCATION,e.initPoint);
		}
	}
}