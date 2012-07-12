package sxf.apps.imageeditor.mvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	import sxf.apps.imageeditor.mvc.model.ImageService;
	import sxf.apps.imageeditor.valueobjects.ImageObject;
	
	public class LoadImageCommand extends SimpleCommand
	{
		private var imageService:ImageService;
		private var imageEditorProxy:ImageEditorProxy;

		public function LoadImageCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			imageService = facade.retrieveProxy(ImageService.NAME) as ImageService;
			imageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			
			switch(notification.getName())
			{
				case ImageEditorFacade.LOAD_IMAGE:
					beginToLoadImage(notification);
					break;
				
				case ImageEditorFacade.LOAD_IMAGE_BEGIN:
					initLoadProgress(notification);
					break;
				
				case ImageEditorFacade.LOAD_IMAGE_PROGRESS:
					showLoadProgress(notification);
					break;
				
				case ImageEditorFacade.LOAD_IMAGE_FINISH:
					clearLoadProgress(notification);
					initImageEditor(notification);
					break;
				
				case ImageEditorFacade.LOAD_IMAGE_UNLOAD:
					//do nothing
					break;
				
				case ImageEditorFacade.LOAD_IMAGE_ERROR:
					showLoadError(notification);
					break;
				
				default:
					break;
			}
		}
		
		private function beginToLoadImage(notification:INotification):void
		{
			var url:String = notification.getBody() as String;
			imageService.loadImage(url);
		}
		
		private function initLoadProgress(notification:INotification):void
		{
			// 初始化加载进度
		}
		
		private function showLoadProgress(notification:INotification):void
		{
			//显示加载进度
			var percent:Number = notification.getBody() as Number;
			//trace(Math.round(percent*100)+"%");
		}
		
		private function clearLoadProgress(notification:INotification):void
		{
			//清除加载进度
		}
		
		private function showLoadError(notification:INotification):void
		{
			//显示加载错误信息
		}
		
		private function initImageEditor(notification:INotification):void
		{
			var imageObject:ImageObject = notification.getBody() as ImageObject;
			storeImageObject(imageObject);
		}
		
		private function storeImageObject(imgObject:ImageObject):void
		{
			imageEditorProxy.imageName = imgObject.name;
			imageEditorProxy.imageType = imgObject.type;
			imageEditorProxy.orgBmpData = imgObject.bmpData;
			imageEditorProxy.initImage(imgObject.bmpData.clone());
		}
		
	}
}