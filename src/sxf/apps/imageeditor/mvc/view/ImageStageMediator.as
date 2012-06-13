package sxf.apps.imageeditor.mvc.view
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.events.ResizeEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.ImageStage;
	import sxf.apps.imageeditor.events.ImageStageEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	
	public class ImageStageMediator extends Mediator
	{
		public static const NAME:String = "imageStageMediator";
		
		public function ImageStageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		private function get imageStage():ImageStage
		{
			return viewComponent as ImageStage;
		}
		
		public function updateImageBmpData(newBmpData:BitmapData):void
		{
			imageStage.updateImageBmpData(newBmpData);
		}
		
		public function applyMatrix(matrix:Matrix):void
		{
			imageStage.applyMatrix(matrix);
		}
		
		override public function onRegister():void
		{
			updateViewPortSize(imageStage.width,imageStage.height);
			imageStage.addEventListener(ResizeEvent.RESIZE,onResize);
			imageStage.addEventListener(ImageStageEvent.DRAGE_IMAGE,onDrageImage);
		}
		
		override public function onRemove():void
		{
			imageStage.removeEventListener(ImageStageEvent.DRAGE_IMAGE,onDrageImage);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ImageEditorFacade.PADDING_CHANGE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ImageEditorFacade.PADDING_CHANGE:
					imageStage.padding = notification.getBody() as Number;
					break;
			}
		}
		
		
		
		private function updateViewPortSize(width:Number,height:Number):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.updateViewPortSize(width,height);
		}
		
		private function onResize(e:ResizeEvent):void
		{
			var viewPort:ImageStage = e.currentTarget as ImageStage;
			updateViewPortSize(viewPort.width,viewPort.height);
		}
		
		private function onDrageImage(e:ImageStageEvent):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			var initPoint:Point = e.initPoint;
			var endPoint:Point = e.endPoint;
			imageEditorProxy.dragImage(initPoint,endPoint);
		}
	}
}