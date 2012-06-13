package sxf.apps.imageeditor.mvc.view
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.ImageDisplay;
	import sxf.apps.imageeditor.events.ImageDisplayEvent;
	import sxf.apps.imageeditor.events.ImgMapperEvent;
	//import sxf.apps.imageeditor.events.ResizeEvent;
	import sxf.apps.imageeditor.events.ToolCropEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	import sxf.apps.imageeditor.valueobjects.ImageDisplayInfo;
	import sxf.apps.imageeditor.valueobjects.ImageObject;
	import sxf.apps.imageeditor.valueobjects.ImgMapperInfo;
	import sxf.utils.image.Cropper;
	import sxf.utils.image.CropperEvent;
	import sxf.utils.line.AntLineRectSelectorEvent;
	
	public class ImageDisplayMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "imageDisplayMediator";
		
		public function ImageDisplayMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);

			/*imageDisplay.addEventListener(ImageDisplayEvent.IMAGE_INITED,imageInitHandler);
			imageDisplay.addEventListener(ImageDisplayEvent.IMAGE_ZOOMED,imageZoomHandler);
			imageDisplay.addEventListener(ImageDisplayEvent.IMAGE_MAPPER_MOVED,imageMapperMoveHandler);
			imageDisplay.addEventListener(ImageDisplayEvent.IMAGE_DRAG_MOVED,imageDragMoveHandler);
			imageDisplay.addEventListener(ImageDisplayEvent.IMAGE_FLIPPED,imageFlipHandler);
			imageDisplay.addEventListener(ImageDisplayEvent.IMAGE_ROTATED,imageRotateHandler);*/
			
		}
		
		override public function onRegister():void
		{
			updateViewPortSize(imageDisplay.width,imageDisplay.height);
			imageDisplay.addEventListener(ResizeEvent.RESIZE,onResize);
		}

		/*override public function listNotificationInterests():Array
		{
			return [ImageEditorFacade.IMAGE_LOADED,
					ImageEditorFacade.ZOOM_IN_IMAGE,
					ImageEditorFacade.ZOOM_OUT_IMAGE,
					ImageEditorFacade.ROTATE_IMAGE_CLOCKWISE,
					ImageEditorFacade.ROTATE_IMAGE_COUNTER_CLOCKWISE,
					ImageEditorFacade.FLIP_IMAGE_HORIZONTAL,
					ImageEditorFacade.FLIP_IMAGE_VERTICAL,
					ImageEditorFacade.TOOL_CROP_CONFIRM,
					ImageEditorFacade.TOOL_RESIZE_BEGIN,
					ImageEditorFacade.TOOL_RESIZE_CANCEL,
					ImageEditorFacade.TOOL_RESIZE,
					ImageEditorFacade.TOOL_RECOVER_IMAGE,
					ImageEditorFacade.TOOL_EDIT_DONE,
					ImageEditorFacade.IMAGE_MAPPER_UPDATED,
					ImageEditorFacade.ANTLINE_SELECT_BEGIN,
					ImageEditorFacade.ANTLINE_SELECT_PROCCESS,
					ImageEditorFacade.ANTLINE_SELECT_FINISH,
					ImageEditorFacade.CROPPER_SELECTION_CHANGE];
		}*/
		
		override public function handleNotification(notification:INotification):void{
			
			switch(notification.getName()){
				
				
				////////////////////////////////////////////////////////

				////////////////////////////////////////////////////////
				
			
				
				/*case ImageEditorFacade.TOOL_EDIT_DONE:
					
					sendEditedBmpData();
					break;
				
				case ImageEditorFacade.IMAGE_MAPPER_UPDATED:
					
					
					moveImageByMapper(notification);
					break;*/
				
				/*case ImageEditorFacade.ANTLINE_SELECT_BEGIN:
				case ImageEditorFacade.ANTLINE_SELECT_PROCCESS:
				case ImageEditorFacade.ANTLINE_SELECT_FINISH:
					
					updateImageSelectionByAntLine(notification);
					break;
				
				case ImageEditorFacade.CROPPER_SELECTION_CHANGE:
					
					updateImageSelectionByCropper(notification);
					break;*/
			}
		}
		
		//new ///////////////////////////////////////////////////////////////////////////
		
		public function updateImageBmpData(newBmpData:BitmapData):void
		{
			imageDisplay.updateImageBmpData(newBmpData);
		}
		
		public function applyMatrix(matrix:Matrix):void
		{
			imageDisplay.applyMatrix(matrix);
		}
		
		//event handler
		private function onResize(e:ResizeEvent):void
		{
			var viewPort:ImageDisplay = e.currentTarget as ImageDisplay;
			updateViewPortSize(viewPort.width,viewPort.height);
		}
		
		private function updateViewPortSize(width:Number,height:Number):void
		{
			var imageEditorProxy:ImageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageEditorProxy.updateViewPortSize(width,height);
		}
		/////////////////////////////////////////////////////////////////////////////
		
		
		
		/*private function sendEditedBmpData():void{
		
			var editedBmpData:BitmapData = imageDisplay.bmpData;
			trace("sendEditedBmpData" + editedBmpData);
		
		}
		
		private function moveImageByMapper(notification:INotification):void{
		
			var e:ImgMapperEvent = notification.getBody() as ImgMapperEvent;
			var infoObj:ImgMapperInfo = e.infoObj;
			imageDisplay.moveImageByMapper(infoObj.viewPortX,infoObj.viewPortY,infoObj.viewPortWidth,infoObj.viewPortHeight,infoObj.imgWidth,infoObj.imgHeight);
		
		}*/
		
		/*private function updateImageSelectionByAntLine(notification:INotification):void{
		
			
			var e:AntLineRectSelectorEvent = notification.getBody() as AntLineRectSelectorEvent;
			trace(e.rect);
			imageDisplay.updateImageSelection(e.rect);
		
		}
		
		private function updateImageSelectionByCropper(notification:INotification):void{
		
			var e:CropperEvent = notification.getBody() as CropperEvent;
			imageDisplay.updateImageSelection(e.rect);
		
		}*/
		
		protected function get imageDisplay():ImageDisplay
		{
			return viewComponent as ImageDisplay;
		}
		
		///////////////////////////////////
		//
		// handler function
		//
		/////////////////////////////////////
		
		/*private function imageInitHandler(e:ImageDisplayEvent):void{
		
			var infoObj:ImageDisplayInfo = e.infoObj;
			sendNotification(ImageEditorFacade.IMAGE_DISPLAY_INITED,e);
		
		}
		
		private function imageZoomHandler(e:ImageDisplayEvent):void{
			
			var infoObj:ImageDisplayInfo = e.infoObj;
			sendNotification(ImageEditorFacade.IMAGE_DISPLAY_ZOOMED,e);
			
		}
		private function imageMapperMoveHandler(e:ImageDisplayEvent):void{
			
			var infoObj:ImageDisplayInfo = e.infoObj;
			sendNotification(ImageEditorFacade.IMAGE_DISPLAY_MAPPER_MOVED,e);
			
		}
		private function imageDragMoveHandler(e:ImageDisplayEvent):void{
			
			var infoObj:ImageDisplayInfo = e.infoObj;
			sendNotification(ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED,e);
			
		}
		private function imageFlipHandler(e:ImageDisplayEvent):void{
			
			var infoObj:ImageDisplayInfo = e.infoObj;
			sendNotification(ImageEditorFacade.IMAGE_DISPLAY_FLIPPED,e);
			
		}
		private function imageRotateHandler(e:ImageDisplayEvent):void{
			
			var infoObj:ImageDisplayInfo = e.infoObj;
			sendNotification(ImageEditorFacade.IMAGE_DISPLAY_ROTATED,e);
			
		}
*/
		
	}
}