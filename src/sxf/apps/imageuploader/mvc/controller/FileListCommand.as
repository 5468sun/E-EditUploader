package sxf.apps.imageuploader.mvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.model.UploaderProxy;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	import sxf.apps.imageuploader.valueobjects.FileObject;
	
	public class FileListCommand extends SimpleCommand
	{
		public function FileListCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			switch(notification.getName())
			{
				case UploaderFacade.FILE_ADDED_TO_LIST:
					
					addFileToList(notification);
					break;
				
				case UploaderFacade.FILE_REMOVED_FROM_LIST:
					removeFileFromList(notification);
					break;
				
				
				case UploaderFacade.FILE_EDIT:
					
					editFile(notification);
					break;
				
				case UploaderFacade.FILE_RELOAD:
					
					reloadFile(notification);
					break;
				
				case UploaderFacade.FILE_UPLOAD:
					
					uploadFile(notification);
					break;
				
				case UploaderFacade.FILE_REUPLOAD:
					
					reUploadFile(notification);
					break;
				
				case UploaderFacade.FILE_UPLOAD_CANCEL:
					
					uploadFileCancel(notification);
					break;
				
				case UploaderFacade.FILE_LIST_UPLOAD:
					
					uploadFileList();
					break;
				
				case UploaderFacade.FILE_LIST_CLEAR_UPLOADED:
					
					clearFileListUploaded();
					break;
				
				case UploaderFacade.FILE_LIST_CLEAR_ERRORED:
					
					clearFileListErrored();
					break;
			}
		}
		
		private function addFileToList(notification:INotification):void
		{
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			var uploadFileListMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var data:Object = notification.getBody();
			var file:FileObject = data.file as FileObject;
			var index:int = int(data.index);
			uploaderProxy.addFileAt(file,index);
			uploadFileListMediator.addItemAt(file,index);
		}
		
		private function removeFileFromList(notification:INotification):void
		{
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			var uploadFileListMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var index:int = int(notification.getBody());
			uploaderProxy.removeFileAt(index);
			uploadFileListMediator.removeItemAt(index);
		}
		
		private function editFile(notification:INotification):void
		{
			
			/*trace("editItem");
			var index:int = int(notification.getBody());
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			var imageData:ByteArray = proxy.getItemDataAt(index);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var uploaderMediator:ImageUploaderMediator = facade.retrieveMediator(ImageUploaderMediator.NAME) as ImageUploaderMediator;
			uploaderMediator.disable();
			
			var timer:Timer = new Timer(2000,1);
			timer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{listMediator.enable();uploaderMediator.enable();trace("timer trigger");});
			timer.start();*/
		}

		
		private function reloadFile(notification:INotification):void
		{
			
			var index:int = int(notification.getBody());
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			uploaderProxy.reloadFileAt(index);
			
		}
		
		private function uploadFile(notification:INotification):void
		{
			var index:int = int(notification.getBody());
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			uploaderProxy.uploadFileAt(index);
		}
		
		
		
		private function reUploadFile(notification:INotification):void
		{
			uploadFile(notification);
		}
		
		private function uploadFileCancel(notification:INotification):void{
			
			var index:int = int(notification.getBody());
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			uploaderProxy.cancelUploadAt(index);
		}
		
		private function uploadFileList():void
		{
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			uploaderProxy.uploadFileList();
		}
		
		private function clearFileListUploaded():void
		{
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			uploaderProxy.clearFileListUploaded();
		}
		
		private function clearFileListErrored():void
		{
			var uploaderProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			uploaderProxy.clearFileListErrored();
		}
	}
}