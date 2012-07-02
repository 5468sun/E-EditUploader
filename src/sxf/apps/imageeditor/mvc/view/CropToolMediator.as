package sxf.apps.imageeditor.mvc.view
{
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.CropTool;
	import sxf.apps.imageeditor.events.CropToolEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	
	public class CropToolMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "cropToolMediator";
		
		public function CropToolMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function setSelectRect(rectangle:Rectangle):void
		{
			cropTool.rectangle = rectangle;
		}
		
		/*public function setMouseLocaion(location:Point):void
		{
			
		}
		*/
		override public function onRegister():void
		{
			cropTool.addEventListener(CropToolEvent.CHANGE_X,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CHANGE_Y,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CHANGE_W,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CHANGE_H,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CONFIRM,cropConfirmHandler);
			cropTool.addEventListener(CropToolEvent.CANCEL,cropCancelHandler);
		}
		
		override public function onRemove():void
		{
			cropTool.removeEventListener(CropToolEvent.CHANGE_X,cropChangeHandler);
			cropTool.removeEventListener(CropToolEvent.CHANGE_Y,cropChangeHandler);
			cropTool.removeEventListener(CropToolEvent.CHANGE_W,cropChangeHandler);
			cropTool.removeEventListener(CropToolEvent.CHANGE_H,cropChangeHandler);
			cropTool.removeEventListener(CropToolEvent.CONFIRM,cropConfirmHandler);
			cropTool.removeEventListener(CropToolEvent.CANCEL,cropCancelHandler);
		}
		
		private function get cropTool():CropTool
		{
			return viewComponent as CropTool;
		}
		
		public function setRestrainRect(restrainRect:Rectangle):void
		{
			cropTool.restrainStepper(restrainRect);
		}
		
		private function restrainValue(value:Number,type:String):Number
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var restrainRect:Rectangle = imageEditorProxy.restrainRectangle;
			var cropRect:Rectangle = imageEditorProxy.cropRectangle;
			var matrix:Matrix = imageEditorProxy.matrix;
			trace("restrainRect:"+restrainRect);
			trace("cropRect:"+cropRect);
			switch(type)
			{
				case CropToolEvent.CHANGE_X:
					if(value<0)
					{
						value = 0;
					}
					else if(value>Math.round((restrainRect.width - cropRect.width)/matrix.a))
					{
						value = Math.round((restrainRect.width - cropRect.width)/matrix.a);
					}
					break;
				
				case CropToolEvent.CHANGE_Y:
					if(value<0)
					{
						value = 0;
					}
					else if(value>Math.round((restrainRect.height - cropRect.height)/matrix.d))
					{
						value = Math.round((restrainRect.height - cropRect.height)/matrix.d);
					}
					break;
				
				case CropToolEvent.CHANGE_W:
					if(value<0)
					{
						value = 0;
					}
					else if(value>Math.round((restrainRect.width - cropRect.x)/matrix.a))
					{
						value = Math.round((restrainRect.width - cropRect.x)/matrix.a);
					}
					break;
				
				case CropToolEvent.CHANGE_H:
					if(value<0)
					{
						value = 0;
					}
					else if(value>Math.round((restrainRect.height - cropRect.y)/matrix.d))
					{
						value = Math.round((restrainRect.height - cropRect.y)/matrix.d);
					}
					break;
			}
			trace("value:"+value);
			return value;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				//ImageEditorFacade.CROP_MOUSE_LOCATION
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				/*case ImageEditorFacade.CROP_MOUSE_LOCATION:
					var mouseLocation:Point = notification.getBody() as Point;
					cropTool.mouseLocation = mouseLocation;
					break;*/
			}
		}
		
		// 事件监听函数      ///////////////////////////////
		private function cropChangeHandler(e:CropToolEvent):void
		{
			var value:Number;
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var newRect:Rectangle = imageEditorProxy.selectRectangle.clone();

			switch(e.type)
			{
				case CropToolEvent.CHANGE_X:
					value = restrainValue(e.value,CropToolEvent.CHANGE_X);
					newRect.x = value;
					break;
				
				case CropToolEvent.CHANGE_Y:
					value = restrainValue(e.value,CropToolEvent.CHANGE_Y);
					newRect.y = value;
					break;
				
				case CropToolEvent.CHANGE_W:
					value = restrainValue(e.value,CropToolEvent.CHANGE_W);
					newRect.width = value;
					break;
				
				case CropToolEvent.CHANGE_H:
					value = restrainValue(e.value,CropToolEvent.CHANGE_H);
					newRect.height = value;
					break;
			}
			imageEditorProxy.setSelectRectangle(newRect);
			
		}
		
		private function cropConfirmHandler(e:CropToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.cropImage(imageEditorProxy.selectRectangle);
		}
		
		private function cropCancelHandler(e:CropToolEvent):void
		{
			//do nothing
		}
	}
}