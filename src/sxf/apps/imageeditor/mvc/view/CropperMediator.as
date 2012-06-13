package sxf.apps.imageeditor.mvc.view
{
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.primitives.Rect;
	
	import sxf.apps.imageeditor.events.ImageDisplayEvent;
	import sxf.apps.imageeditor.events.ToolCropEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.valueobjects.ImageDisplayInfo;
	import sxf.utils.image.Cropper;
	import sxf.utils.image.CropperEvent;
	import sxf.utils.line.AntLineRectSelectorEvent;
	
	public class CropperMediator extends Mediator implements IMediator{
		
		public static const NAME:String = "CROPPER_MEDIATOR";
		
		
		public function CropperMediator(viewComponent:Object=null){
			
			super(NAME, viewComponent);
			
			cropper.addEventListener(CropperEvent.SELECTION_CHANGE,selectionChangeHandler);
		}
		
		override public function listNotificationInterests():Array{
		
			return [ImageEditorFacade.IMAGE_DISPLAY_INITED,
				ImageEditorFacade.IMAGE_DISPLAY_ZOOMED,
				ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED,
				ImageEditorFacade.IMAGE_DISPLAY_MAPPER_MOVED,
				ImageEditorFacade.IMAGE_DISPLAY_ROTATED,
				ImageEditorFacade.IMAGE_DISPLAY_FLIPPED,
				ImageEditorFacade.TOOL_ROTATE_BEGIN,
				ImageEditorFacade.TOOL_ROTATE_CANCEL,
				ImageEditorFacade.TOOL_CROP_BEGIN,
				ImageEditorFacade.TOOL_CROP_CANCEL,
				ImageEditorFacade.TOOL_CROP_CONFIRM,
				ImageEditorFacade.TOOL_CROP_RATIO_STATUS_CHANGE,
				ImageEditorFacade.TOOL_CROP_RECTANGLE_CHANGE,
				ImageEditorFacade.TOOL_RESIZE_BEGIN,
				ImageEditorFacade.TOOL_RESIZE_CANCEL,
				ImageEditorFacade.ANTLINE_SELECT_BEGIN,
				ImageEditorFacade.ANTLINE_SELECT_PROCCESS,
				ImageEditorFacade.ANTLINE_SELECT_CANCEL,
				ImageEditorFacade.ANTLINE_SELECT_FINISH];

		}
		
		override public function handleNotification(notification:INotification):void{
			
			switch (notification.getName()){
				
				case ImageEditorFacade.IMAGE_DISPLAY_INITED:
					
					updateCropperRestrainRect(notification);
					break;
				
				case ImageEditorFacade.IMAGE_DISPLAY_ZOOMED:
					
					updateCropperWhenImgZoomed(notification);
					updateCropperRestrainRect(notification);
					break;
				
				case ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED:
				case ImageEditorFacade.IMAGE_DISPLAY_MAPPER_MOVED:
					
					updateCropperWhenImgMoved(notification);
					updateCropperRestrainRect(notification);
					break;

				case ImageEditorFacade.IMAGE_DISPLAY_ROTATED:
				case ImageEditorFacade.IMAGE_DISPLAY_FLIPPED:
				case ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED:
					
					updateCropperRestrainRect(notification);
					
					break;
				
				case ImageEditorFacade.TOOL_ROTATE_BEGIN:
					
					hideCropper();
					break;
				
				case ImageEditorFacade.TOOL_ROTATE_CANCEL:
					
					hideCropper();
					break;
				
				case ImageEditorFacade.TOOL_CROP_BEGIN:
					
					hideCropper();
					break;
				
				case ImageEditorFacade.TOOL_CROP_CANCEL:
					
					hideCropper();
					break;
				
				case ImageEditorFacade.TOOL_CROP_CONFIRM:
					
					hideCropper();
					break;
				
				case ImageEditorFacade.TOOL_CROP_RATIO_STATUS_CHANGE:
					
					
					updateCropperRatioStatusAndValue(notification);
					break;
				
				case ImageEditorFacade.TOOL_CROP_RECTANGLE_CHANGE:
					
					updateCropperWithInputs(notification);
					break;
				
				case ImageEditorFacade.TOOL_RESIZE_BEGIN:
				case ImageEditorFacade.TOOL_RESIZE_CANCEL:
					
					hideCropper();
					break;
				
				case ImageEditorFacade.ANTLINE_SELECT_BEGIN:

					hideCropper();
					break;
				
				case ImageEditorFacade.ANTLINE_SELECT_PROCCESS:
				case ImageEditorFacade.ANTLINE_SELECT_CANCEL:
					
					// do nothing
					break;
					
				
				case ImageEditorFacade.ANTLINE_SELECT_FINISH:
					
					showCropper();
					initCropperWithAntLine(notification);
					break;
			}
		}
		
		private function updateCropperWhenImgZoomed(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			var scaleValue:Number = infoObj.currentZoomValue/infoObj.prevZoomValue;
			
			var offsetX:Number = Math.round((cropper.rect.x-infoObj.prevImgX)*scaleValue + infoObj.imgX - cropper.rect.x);
			var offsetY:Number = Math.round((cropper.rect.y-infoObj.prevImgY)*scaleValue + infoObj.imgY - cropper.rect.y);
			
			cropper.zoomBy(scaleValue);
			cropper.moveBy(offsetX,offsetY);
			
		}
		
		private function updateCropperWhenImgMoved(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			
			var offsetX:Number = infoObj.imgX - infoObj.prevImgX;
			var offsetY:Number = infoObj.imgY - infoObj.prevImgY;
			
			cropper.moveBy(offsetX,offsetY);
		
		}
	
		
		private function updateCropperRestrainRect(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			cropper.restrainRect = new Rectangle(infoObj.imgX,infoObj.imgY,infoObj.imgWidth,infoObj.imgHeight);
		
		}
		
		
		private function showCropper():void{
		
			cropper.visible = true;
		}
		
		private function hideCropper():void{
		
			cropper.visible = false;
		
		}
		
		private function updateCropperRatioStatusAndValue(notification:INotification):void{
		
			var infoObj:ToolCropEvent = notification.getBody() as ToolCropEvent;
			var status:Boolean = infoObj.ratioStatus;
			var value:Number = infoObj.ratioValue;
			
			cropper.keepRatio = status;
			cropper.ratio = value;
		
		}
		
		private function updateCropperWithInputs(notification:INotification):void{
		
			var rect:Rectangle = notification.getBody() as Rectangle;
		
			cropper.updateCropper(rect);
		
		}
		
		private function initCropperWithAntLine(notification:INotification):void{
		
			var infoObj:AntLineRectSelectorEvent = notification.getBody() as AntLineRectSelectorEvent;
			var rect:Rectangle = infoObj.rect;
			if(rect.width != 0 && rect.height !=0){
			
				cropper.visible = true;
				cropper.updateCropper(infoObj.rect);
			
			}
			
		
		}
		
		
		//////////////
		//
		// handler functions
		//
		/////////////////
		
		private function selectionChangeHandler(e:CropperEvent):void{
		
			sendNotification(ImageEditorFacade.CROPPER_SELECTION_CHANGE,e);
		
		}
		
		
		private function get cropper():Cropper{
		
			return viewComponent as Cropper;
		}
	}
}