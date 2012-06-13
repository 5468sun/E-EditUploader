package sxf.apps.imageeditor.mvc.view
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.EditorTools;
	import sxf.apps.imageeditor.events.ImageDisplayEvent;
	import sxf.apps.imageeditor.events.ResizeEvent;
	import sxf.apps.imageeditor.events.ToolCropEvent;
	import sxf.apps.imageeditor.events.ToolEvent;
	import sxf.apps.imageeditor.events.ToolRotateFlipEvent;
	import sxf.apps.imageeditor.events.ToolZoomEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.valueobjects.ImageDisplayInfo;
	import sxf.utils.image.CropperEvent;
	import sxf.utils.line.AntLineRectSelectorEvent;
	
	public class EditorToolsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "EDITOR_TOOLS_MEDIATOR";
		
		private var _zoomValue:Number;
		private var _restrainRect:Rectangle;
		private var keepRatio:Boolean;
		private var cropRatioValue:Number;
		
		public function EditorToolsMediator(viewComponent:Object=null){
			
			super(NAME, viewComponent);
			editorTools.addEventListener(ToolZoomEvent.ZOOM_IN_IMAGE,zoomHandler);
			editorTools.addEventListener(ToolZoomEvent.ZOOM_OUT_IMAGE,zoomHandler);
			
			editorTools.addEventListener(ToolRotateFlipEvent.BEGIN,rotationBeginHandler);
			editorTools.addEventListener(ToolRotateFlipEvent.CANCEL,rotationCancelHandler);
			editorTools.addEventListener(ToolRotateFlipEvent.ROTATE_IMAGE_CLOCKWISE,rotationHandler);
			editorTools.addEventListener(ToolRotateFlipEvent.ROTATE_IMAGE_COUNTER_CLOCKWISE,rotationHandler);
			editorTools.addEventListener(ToolRotateFlipEvent.FLIP_IMAGE_HORIZONTAL,flipImageHandler);
			editorTools.addEventListener(ToolRotateFlipEvent.FLIP_IMAGE_VERTICAL,flipImageHandler);
			
			editorTools.addEventListener(ToolCropEvent.BEGIN,cropBeginHandler);
			editorTools.addEventListener(ToolCropEvent.CANCEL,cropCancelHandler);
			editorTools.addEventListener(ToolCropEvent.CONFIRM,cropConfirmHandler);
			editorTools.addEventListener(ToolCropEvent.RATIO_STATUS_CHANGE,cropRatioStatusChangeHandler);
			editorTools.addEventListener(ToolCropEvent.RECTANGLE_XY_CHANGE,cropRectXYChangeHandler);
			editorTools.addEventListener(ToolCropEvent.RECTANGLE_WH_CHANGE,cropRectWHChangeHandler);
			
			editorTools.addEventListener(ResizeEvent.BEGIN,resizeImageBeginHandler);
			editorTools.addEventListener(ResizeEvent.CANCLE,resizeImageCancelHandler);
			editorTools.addEventListener(ResizeEvent.RESIZE,resizeImageHandler);
			
			editorTools.addEventListener(ToolEvent.RECOVER_IMAGE,recoverImageHanlder);
			editorTools.addEventListener(ToolEvent.IMAGE_EDIT_DONE,editDoneHandler);
			
		}
		
		public function get zoomValue():Number{
			
			return _zoomValue;
			
		}
		
		public function set zoomValue(value:Number):void{
			
			this._zoomValue = value;
			
		}
		
		public function get restrainRect():Rectangle{
			
			return this._restrainRect;
			
		}
		
		public function set restrainRect(rectangle:Rectangle):void{
			
			this._restrainRect = rectangle;
			
		}
		
		override public function listNotificationInterests():Array{
		
		
			return [ImageEditorFacade.ANTLINE_SELECT_INIT,
				ImageEditorFacade.ANTLINE_SELECT_INIT_END,
				ImageEditorFacade.ANTLINE_SELECT_BEGIN,
				ImageEditorFacade.ANTLINE_SELECT_PROCCESS,
				ImageEditorFacade.ANTLINE_SELECT_FINISH,
				ImageEditorFacade.ANTLINE_SELECT_CANCEL,
				ImageEditorFacade.IMAGE_DISPLAY_INITED,
				ImageEditorFacade.IMAGE_DISPLAY_ZOOMED,
				ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED,
				ImageEditorFacade.IMAGE_DISPLAY_MAPPER_MOVED,
				ImageEditorFacade.IMAGE_DISPLAY_ROTATED,
				ImageEditorFacade.IMAGE_DISPLAY_FLIPPED,
				ImageEditorFacade.CROPPER_SELECTION_CHANGE];

		
		}
		
		override public function handleNotification(notification:INotification):void{
			
			
			
			switch (notification.getName()){
				
				case ImageEditorFacade.ANTLINE_SELECT_INIT:
					
					showMousePosition(notification);
					break;
				
				case ImageEditorFacade.ANTLINE_SELECT_INIT_END:
					
					resumeCropperPosition(notification);
					break;
				
				case ImageEditorFacade.ANTLINE_SELECT_BEGIN:
					
					editorTools.disableCropInputs();
					break;
			
				case ImageEditorFacade.ANTLINE_SELECT_PROCCESS:
					
					updateCropInputsByAnt(notification);
					break;
				
				case ImageEditorFacade.ANTLINE_SELECT_FINISH:
					
					editorTools.enableCropInputs();
					break;
				
				case ImageEditorFacade.ANTLINE_SELECT_CANCEL:
					
					updateCropInputsByAnt(notification);
					break;
				
				case ImageEditorFacade.IMAGE_DISPLAY_INITED:
					
					updateImageRatio(notification);
					updateRestrainRect(notification);
					updateZoomValue(notification);
					updateResizeInputs(notification);
					break;
				case ImageEditorFacade.IMAGE_DISPLAY_ZOOMED:
					
					updateRestrainRect(notification);
					updateZoomValue(notification);
					break;
				
				case ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED:
				case ImageEditorFacade.IMAGE_DISPLAY_MAPPER_MOVED:
					
					updateRestrainRect(notification);
					break;
				
				case ImageEditorFacade.IMAGE_DISPLAY_ROTATED:
				case ImageEditorFacade.IMAGE_DISPLAY_FLIPPED:
					
					updateResizeInputs(notification);
					updateZoomValue(notification);
					updateRestrainRect(notification);
					break;
				
				case ImageEditorFacade.CROPPER_SELECTION_CHANGE:
					
					updateCropInputsByCropper(notification);
					break;
			
			}
		
		}
		
		private function updateResizeInputs(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			
			editorTools.updateResizeInputs(infoObj.bmpData.width,infoObj.bmpData.height);
			editorTools.updateActualSize(infoObj.bmpData.width,infoObj.bmpData.height);
		}
		

		private function showMousePosition(notification:INotification):void{
		
			var e:AntLineRectSelectorEvent = notification.getBody() as AntLineRectSelectorEvent;
			var initPoint:Point = e.initPoint;
			var newInitPoint:Point = new Point(Math.round((initPoint.x-restrainRect.x)/zoomValue),Math.round((initPoint.y-restrainRect.y)/zoomValue));

			editorTools.showMousePosition(newInitPoint);
		
		}
		
		private function resumeCropperPosition(notification:INotification):void{
			
			editorTools.resumeCropperPosition();
		
		}
		
		private function updateCropInputsByAnt(notification:INotification):void{
		
			var e:AntLineRectSelectorEvent = notification.getBody() as AntLineRectSelectorEvent;
			var rect:Rectangle = e.rect;
			var scaledRect:Rectangle = new Rectangle(Math.round((rect.x-restrainRect.x)/zoomValue),Math.round((rect.y-restrainRect.y)/zoomValue),Math.round(rect.width/zoomValue),Math.round(rect.height/zoomValue));
			
			editorTools.updateCropInputs(scaledRect);
		
		}
		
		private function updateCropInputsByCropper(notification:INotification):void{
		
			var e:CropperEvent = notification.getBody() as CropperEvent;
			var rect:Rectangle = e.rect;
			var scaledRect:Rectangle = new Rectangle(Math.round((rect.x-restrainRect.x)/zoomValue),Math.round((rect.y-restrainRect.y)/zoomValue),Math.round(rect.width/zoomValue),Math.round(rect.height/zoomValue));
			
			editorTools.updateCropInputs(scaledRect);
		
		}
		
		private function updateRestrainRect(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			
			restrainRect = new Rectangle(infoObj.imgX,infoObj.imgY,infoObj.imgWidth,infoObj.imgHeight);
		
		}
		
		private function updateZoomValue(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			
			zoomValue = infoObj.currentZoomValue;
			
			editorTools.updateZoomValue(zoomValue);
		
		}
		
		private function updateImageRatio(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			
			editorTools.imageRatioValue = infoObj.imgWidth/infoObj.imgHeight;
		
		}
		
		/////////////////
		//
		// handler function
		//
		/////////////////
		
		private function zoomHandler(e:Event):void
		{
			switch (e.type) {
				
				case ToolZoomEvent.ZOOM_IN_IMAGE:
					sendNotification(ImageEditorFacade.ZOOM_IN_IMAGE);
					break;
				
				case ToolZoomEvent.ZOOM_OUT_IMAGE:
					sendNotification(ImageEditorFacade.ZOOM_OUT_IMAGE);
					break;
			
			}
			
		}
		
		private function rotationBeginHandler(e:ToolRotateFlipEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_ROTATE_BEGIN);
		
		}
		
		private function rotationCancelHandler(e:ToolRotateFlipEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_ROTATE_CANCEL);
		
		}

		private function rotationHandler(e:Event):void
		{
			switch (e.type){
			
				case ToolRotateFlipEvent.ROTATE_IMAGE_CLOCKWISE:
					
					sendNotification(ImageEditorFacade.ROTATE_IMAGE_CLOCKWISE);
					break;
				
				case ToolRotateFlipEvent.ROTATE_IMAGE_COUNTER_CLOCKWISE:
					
					sendNotification(ImageEditorFacade.ROTATE_IMAGE_COUNTER_CLOCKWISE);
					break;
			
			}
		}
		
		private function flipImageHandler(e:Event):void{
		
			switch (e.type){
			
				case ToolRotateFlipEvent.FLIP_IMAGE_HORIZONTAL:
					
					sendNotification(ImageEditorFacade.FLIP_IMAGE_HORIZONTAL);
					break;
				
				case ToolRotateFlipEvent.FLIP_IMAGE_VERTICAL:
					
					sendNotification(ImageEditorFacade.FLIP_IMAGE_VERTICAL);
					break;
			
			}
		
		}
		
		private function cropBeginHandler(e:ToolCropEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_CROP_BEGIN);
		
		}
		private function cropCancelHandler(e:ToolCropEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_CROP_CANCEL);
			
		}
		private function cropConfirmHandler(e:ToolCropEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_CROP_CONFIRM,e);
		
		}
		private function cropRatioStatusChangeHandler(e:ToolCropEvent):void{
		
			this.keepRatio = e.ratioStatus;
			this.cropRatioValue = e.ratioValue;
			sendNotification(ImageEditorFacade.TOOL_CROP_RATIO_STATUS_CHANGE,e);
		
		}
		private function cropRectXYChangeHandler(e:ToolCropEvent):void{
			
			var rect:Rectangle = e.rect;
			
			var x:Number = rect.x*zoomValue + restrainRect.x;
			var y:Number = rect.y*zoomValue + restrainRect.y;
			var w:Number = rect.width*zoomValue;
			var h:Number = rect.height*zoomValue;

			if(x<restrainRect.x){
			
				x = restrainRect.x;
				rect.x = 0;
				
			}else if(x+w> restrainRect.x+restrainRect.width){

				x = restrainRect.x+restrainRect.width-w;
				rect.x = Math.round((restrainRect.width-w)/zoomValue);
			
			}
			
			if(y<restrainRect.y){
				
				y = restrainRect.y;
				rect.y = 0;
				
			}else if(y+h>restrainRect.y+restrainRect.height){
				
				y = restrainRect.y+restrainRect.height-h;
				rect.y = Math.round((restrainRect.height-h)/zoomValue);
				
			}
			
			
			editorTools.updateCropInputs(rect);
			var scaleRect:Rectangle = new Rectangle(Math.round(x),Math.round(y),Math.round(w),Math.round(h));
			sendNotification(ImageEditorFacade.TOOL_CROP_RECTANGLE_CHANGE,scaleRect);
		
		}
		
		private function cropRectWHChangeHandler(e:ToolCropEvent):void{
			
			var rect:Rectangle = e.rect;
			
			var x:Number = rect.x*zoomValue + restrainRect.x;
			var y:Number = rect.y*zoomValue + restrainRect.y;
			var w:Number = rect.width*zoomValue;
			var h:Number = rect.height*zoomValue;
			
			if(!keepRatio){
				
				if(w<0){
					
					w = 0;
					rect.width = 0;
					
				}else if(x + w > restrainRect.x + restrainRect.width){
					
					w = restrainRect.x + restrainRect.width - x;
					rect.width = Math.round((restrainRect.x + restrainRect.width - x)/zoomValue);
					
				}
				
				if(h<0){
					
					h = 0;
					rect.height = 0;
					
				}else if(y + h > restrainRect.y + restrainRect.height){
					
					h = restrainRect.y + restrainRect.height - y;
					rect.height = Math.round((restrainRect.y + restrainRect.height - y)/zoomValue);
					
				}
				
			}else{
				
				var rectRatioValue:Number = Math.abs(restrainRect.width-rect.x)/Math.abs(restrainRect.height-rect.y);
				
				if(w<0 || h<0){
					
					w = 0;
					h = 0;
					rect.width = 0;
					rect.height = 0;
					
				}else if(w>restrainRect.x + restrainRect.width - x || h>restrainRect.y + restrainRect.height - y){
					
					if(rectRatioValue<cropRatioValue){
						
						//以w为准
						w = restrainRect.width-rect.x;
						h = w/cropRatioValue;
						
					}else{
						
						//以h为准
						h = restrainRect.height-rect.y;
						w = h*cropRatioValue;
					}
					
					rect.width = Math.round(w/zoomValue);
					rect.height = Math.round(h/zoomValue);
					
				}
			}
			
			editorTools.updateCropInputs(rect);
			var scaleRect:Rectangle = new Rectangle(Math.round(x),Math.round(y),Math.round(w),Math.round(h));
			sendNotification(ImageEditorFacade.TOOL_CROP_RECTANGLE_CHANGE,scaleRect);
		
		}
		
		private function resizeImageBeginHandler(e:ResizeEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_RESIZE_BEGIN,e);
		
		}
		
		private function resizeImageCancelHandler(e:ResizeEvent):void{
			
			sendNotification(ImageEditorFacade.TOOL_RESIZE_CANCEL,e);
			
		}
		
		private function resizeImageHandler(e:ResizeEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_RESIZE,e);
		
		}
		
		private function recoverImageHanlder(e:ToolEvent):void{
		
			sendNotification(ImageEditorFacade.TOOL_RECOVER_IMAGE,e);
		
		}
		
		private function editDoneHandler(e:ToolEvent):void{
			
			sendNotification(ImageEditorFacade.TOOL_EDIT_DONE,e);
		
		}
		
		protected function get editorTools():EditorTools{
			
			return viewComponent as EditorTools;
		}
	}
}