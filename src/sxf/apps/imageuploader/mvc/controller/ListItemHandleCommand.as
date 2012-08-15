package sxf.apps.imageuploader.mvc.controller{
	
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.model.ImgUploaderProxy;
	import sxf.apps.imageuploader.mvc.view.ImageUploaderMediator;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	import sxf.comps.localfileloader.LocalFileLoader;
	
	public class ListItemHandleCommand extends SimpleCommand implements ICommand{
		
		public function ListItemHandleCommand(){
			
			super();
		}
		
		override public function execute(notification:INotification):void{
		
			switch (notification.getName()){
				
				case UploaderFacade.LIST_ITEM_DELETE:
					
					delItem(notification);
					break;
				
				case UploaderFacade.LIST_ITEM_EDIT:
					
					editItem(notification);
					break;
				
				case UploaderFacade.LIST_ITEM_RELOAD:
					
					reloadItem(notification);
					break;
				
				case UploaderFacade.LIST_ITEM_REUPLOAD:
					
					reuploadItem(notification);
					break;
				
				case UploaderFacade.LIST_ITEM_CANCEL_UPLOAD:
					
					cancelUploadItem(notification);
					break;
			}
		
		}
		
		private function editItem(notification:INotification):void{
		
			trace("editItem");
			var index:int = int(notification.getBody());
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			var imageData:ByteArray = proxy.getItemDataAt(index);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var uploaderMediator:ImageUploaderMediator = facade.retrieveMediator(ImageUploaderMediator.NAME) as ImageUploaderMediator;
			uploaderMediator.disable();
			
			var timer:Timer = new Timer(2000,1);
			timer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{listMediator.enable();uploaderMediator.enable();trace("timer trigger");});
			timer.start();
		}
		
		private function delItem(notification:INotification):void{
			
			var index:int = int(notification.getBody());
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			proxy.removeItemAt(index);
			
		}
		
		private function reloadItem(notification:INotification):void{
		
			var index:int = int(notification.getBody());
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			proxy.reloadFileAt(index);
		
		}
		
		private function reuploadItem(notification:INotification):void{}
		
		private function cancelUploadItem(notification:INotification):void{
		
			var index:int = int(notification.getBody());
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			proxy.cancelUploadItemAt(index);
		}
	}
}