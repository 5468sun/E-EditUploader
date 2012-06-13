package sxf.apps.imageeditor.mvc.view{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.events.ImageDisplayEvent;
	import sxf.apps.imageeditor.events.ToolCropEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.valueobjects.ImageDisplayInfo;
	import sxf.utils.line.AntLineRectSelector;
	import sxf.utils.line.AntLineRectSelectorEvent;
	
	public class AntLineSelectorMediator extends Mediator implements IMediator{
		
		public static const NAME:String = "ANTLINE_SELECTOR_MEDIATOR";
		
		public function AntLineSelectorMediator(viewComponent:Object=null){
			
			super(NAME, viewComponent);
			anlineSelector.addEventListener(AntLineRectSelectorEvent.INIT,selectInitHandler);
			anlineSelector.addEventListener(AntLineRectSelectorEvent.INIT_END,selectInitEndHandler);
			anlineSelector.addEventListener(AntLineRectSelectorEvent.BEGIN,selectBeginHandler);
			anlineSelector.addEventListener(AntLineRectSelectorEvent.PROCCESS,selectProccessHandler);
			anlineSelector.addEventListener(AntLineRectSelectorEvent.FINISH,selectFinishHandler);
			anlineSelector.addEventListener(AntLineRectSelectorEvent.CANCEL,selectCancelHandler);
			
		}
		
		override public function listNotificationInterests():Array{
		
			return [ImageEditorFacade.IMAGE_DISPLAY_INITED,
				ImageEditorFacade.IMAGE_DISPLAY_ROTATED,
				ImageEditorFacade.IMAGE_DISPLAY_FLIPPED,
				ImageEditorFacade.IMAGE_DISPLAY_ZOOMED,
				ImageEditorFacade.IMAGE_DISPLAY_MAPPER_MOVED,
				ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED,
				ImageEditorFacade.TOOL_CROP_BEGIN,
				ImageEditorFacade.TOOL_CROP_CANCEL,
				ImageEditorFacade.TOOL_CROP_CONFIRM,
				ImageEditorFacade.TOOL_CROP_RATIO_STATUS_CHANGE,
				ImageEditorFacade.TOOL_ROTATE_BEGIN,
				ImageEditorFacade.TOOL_ROTATE_CANCEL,
				ImageEditorFacade.TOOL_RESIZE_BEGIN,
				ImageEditorFacade.TOOL_RESIZE_CANCEL];
		
		}
		
		override public function handleNotification(notification:INotification):void{
		
			switch (notification.getName()){
				
				case ImageEditorFacade.IMAGE_DISPLAY_INITED:
				case ImageEditorFacade.IMAGE_DISPLAY_ROTATED:
				case ImageEditorFacade.IMAGE_DISPLAY_FLIPPED:
				case ImageEditorFacade.IMAGE_DISPLAY_ZOOMED:
				case ImageEditorFacade.IMAGE_DISPLAY_MAPPER_MOVED:
				case ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED:
					
					updateAntLineRestrainRect(notification);
					break;
				
				case ImageEditorFacade.TOOL_CROP_BEGIN:
					
					showAnlineSolector();
					break;
				
				case ImageEditorFacade.TOOL_CROP_CANCEL:
					
					hideAnlineSolector();
					break;
				
				case ImageEditorFacade.TOOL_CROP_CONFIRM:
					
					hideAnlineSolector();
					break;
				
				case ImageEditorFacade.TOOL_CROP_RATIO_STATUS_CHANGE:
				
					updateAntLineRatioStatusAndValue(notification);
					break;
				
				case ImageEditorFacade.TOOL_ROTATE_BEGIN:
				case ImageEditorFacade.TOOL_ROTATE_CANCEL:
				case ImageEditorFacade.TOOL_RESIZE_BEGIN:
				case ImageEditorFacade.TOOL_RESIZE_CANCEL:
					
					hideAnlineSolector();
					break;
			}
		
		}
		
		private function showAnlineSolector():void{
			
			anlineSelector.visible = true;
		}
		
		private function hideAnlineSolector():void{
			
			anlineSelector.visible = false;
		}
		
		private function updateAntLineRestrainRect(notification:INotification):void{
		
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			anlineSelector.restrainRect = new Rectangle(infoObj.imgX,infoObj.imgY,infoObj.imgWidth,infoObj.imgHeight);
		
		}
		
		private function updateAntLineRatioStatusAndValue(notification:INotification):void{
		
			var e:ToolCropEvent = notification.getBody() as ToolCropEvent;
			
			anlineSelector.keepRatio = e.ratioStatus;
			anlineSelector.ratio = e.ratioValue;
		
		}
		
		//////////////////
		//
		// handler functions
		//
		//////////////////
		
		private function selectInitHandler(e:AntLineRectSelectorEvent):void{
		
			sendNotification(ImageEditorFacade.ANTLINE_SELECT_INIT,e);
		
		}
		
		private function selectInitEndHandler(e:AntLineRectSelectorEvent):void{
			
			sendNotification(ImageEditorFacade.ANTLINE_SELECT_INIT_END,e);
		
		}
		
		private function selectBeginHandler(e:AntLineRectSelectorEvent):void{
		
			sendNotification(ImageEditorFacade.ANTLINE_SELECT_BEGIN,e);
		
		}
		
		private function selectProccessHandler(e:AntLineRectSelectorEvent):void{
			
			sendNotification(ImageEditorFacade.ANTLINE_SELECT_PROCCESS,e);
			
		}
		
		private function selectFinishHandler(e:AntLineRectSelectorEvent):void{
			
			sendNotification(ImageEditorFacade.ANTLINE_SELECT_FINISH,e);
			
		}
		
		private function selectCancelHandler(e:AntLineRectSelectorEvent):void{
			
			sendNotification(ImageEditorFacade.ANTLINE_SELECT_CANCEL,e);
		
		}
		
		private function get anlineSelector():AntLineRectSelector{
		
			return viewComponent as AntLineRectSelector;
		}
	}
}