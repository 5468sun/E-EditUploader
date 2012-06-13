package sxf.apps.imageeditor.mvc.view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.comps.ImgMapper;
	import sxf.apps.imageeditor.events.ImageDisplayEvent;
	import sxf.apps.imageeditor.events.ImgMapperEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.valueobjects.ImageDisplayInfo;
	import sxf.utils.image.ImageResizer;
	
	public class ImgMapperMediator extends Mediator implements IMediator{
		
		public static const NAME:String = "IMG_MAPPER_MEDIATOR";
		
		public function ImgMapperMediator(viewComponent:Object=null){
			super(mediatorName, viewComponent);
			imgMapper.addEventListener(ImgMapperEvent.IMAGE_MAPPER_UPDATE,imgMapperUpdateHandler);
			
		}
		
		override public function listNotificationInterests():Array{
		
			return [ImageEditorFacade.IMAGE_DISPLAY_INITED,
				ImageEditorFacade.IMAGE_DISPLAY_ZOOMED,
				ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED,
				ImageEditorFacade.IMAGE_DISPLAY_FLIPPED,
				ImageEditorFacade.IMAGE_DISPLAY_ROTATED];
			
		}
		
		override public function handleNotification(notification:INotification):void{
		
			switch (notification.getName()){
			
				case ImageEditorFacade.IMAGE_DISPLAY_INITED:
				case ImageEditorFacade.IMAGE_DISPLAY_ZOOMED:
				case ImageEditorFacade.IMAGE_DISPLAY_DRAG_MOVED:
				case ImageEditorFacade.IMAGE_DISPLAY_FLIPPED:
				case ImageEditorFacade.IMAGE_DISPLAY_ROTATED:
					
					updateView(notification);
					break;
			
			}
		
		}
		
		private function updateView(notification:INotification):void{
			
			var e:ImageDisplayEvent = notification.getBody() as ImageDisplayEvent;
			var infoObj:ImageDisplayInfo = e.infoObj;
			imgMapper.updateView(infoObj.imgWidth,infoObj.imgHeight,infoObj.imgX,infoObj.imgY,infoObj.viewPortWidth,infoObj.viewPortHeight,infoObj.bmpData);
		
		}
		
		private function imgMapperUpdateHandler(e:ImgMapperEvent):void{
		
			sendNotification(ImageEditorFacade.IMAGE_MAPPER_UPDATED,e);
		
		}
		
		protected function get imgMapper():ImgMapper{
		
			return this.viewComponent as ImgMapper;
		
		}
	}
}