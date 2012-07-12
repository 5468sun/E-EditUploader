package sxf.apps.imageeditor.mvc.view
{
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Button;
	
	import sxf.apps.imageeditor.comps.CropTool;
	import sxf.apps.imageeditor.events.CropToolEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	
	public class CropToolMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "cropToolMediator";
		private var _cropBtn:Object;
		
		public function CropToolMediator(viewComponent:Object=null,viewComponent2:Object=null)
		{
			super(NAME, viewComponent);
			_cropBtn = viewComponent2;
		}
		
		public function setRealCropRectangle(rectangle:Rectangle):void
		{
			cropTool.realCropRectangle = rectangle;
		}
		
		public function setRestrainRectangle(rectangle:Rectangle):void
		{
			cropTool.restrainRectangle = rectangle;
		}
		
		public function activateTool():void
		{
			cropTool.activate();
		}
		
		public function deActivateTool():void
		{
			cropTool.deActivate();
		}
		
		override public function onRegister():void
		{
			cropBtn.addEventListener(MouseEvent.CLICK,cropBtnClick);
			cropTool.addEventListener(CropToolEvent.CHANGE_X,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CHANGE_Y,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CHANGE_W,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CHANGE_H,cropChangeHandler);
			cropTool.addEventListener(CropToolEvent.CONFIRM,cropConfirmHandler);
			cropTool.addEventListener(CropToolEvent.CANCEL,cropCancelHandler);
		}
		
		override public function onRemove():void
		{
			cropBtn.removeEventListener(MouseEvent.CLICK,cropBtnClick);
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
		
		private function get cropBtn():Button
		{
			return _cropBtn as Button;
		}
		
		private function restrainValue(value:Number,type:String):Number
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var restrainRect:Rectangle = imageEditorProxy.restrainRectangle;
			var cropRect:Rectangle = imageEditorProxy.cropRectangle;
			var matrix:Matrix = imageEditorProxy.matrix;

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

			return value;
		}
		
		
		private function switchCropTool():void
		{
			if(cropTool.visible)
			{
				sendNotification(ImageEditorFacade.DEACTIVATE_CROPPER);
			}
			else
			{
				sendNotification(ImageEditorFacade.ACTIVATE_CROPPER);
			}
		}
		
		// 事件监听函数      ///////////////////////////////
		
		private function cropBtnClick(e:MouseEvent):void
		{
			switchCropTool();
		}
		
		private function cropChangeHandler(e:CropToolEvent):void
		{
			var value:Number;
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var newRect:Rectangle = imageEditorProxy.realCropRectangle.clone();

			switch(e.type)
			{
				case CropToolEvent.CHANGE_X:
					newRect.x = e.value;
					break;
				
				case CropToolEvent.CHANGE_Y:
					newRect.y = e.value;
					break;
				
				case CropToolEvent.CHANGE_W:
					newRect.width = e.value;
					break;
				
				case CropToolEvent.CHANGE_H:
					newRect.height = e.value;
					break;
			}
			imageEditorProxy.setRealCropRectangle(newRect);
			
		}
		
		private function cropConfirmHandler(e:CropToolEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.cropImage();
		}
		
		private function cropCancelHandler(e:CropToolEvent):void
		{
			cropTool.visible = false;
			sendNotification(ImageEditorFacade.DEACTIVATE_CROPPER);
		}
	}
}