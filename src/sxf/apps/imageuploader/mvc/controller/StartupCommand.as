package sxf.apps.imageuploader.mvc.controller
{
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.model.UploaderProxy;
	import sxf.apps.imageuploader.mvc.view.ImageUploaderMediator;
	import sxf.apps.imageuploader.mvc.view.LocalFileBrowserMediator;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class StartupCommand extends SimpleCommand
	{
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			startUpConfig(notification);
		}
		
		private function startUpConfig(notification:INotification):void
		{
			var imageUploader:ImageUploader = notification.getBody() as ImageUploader;

			facade.registerProxy(new UploaderProxy());
			
			facade.registerMediator(new ImageUploaderMediator(imageUploader));
			facade.registerMediator(new LocalFileBrowserMediator(imageUploader.browseBtn));
			facade.registerMediator(new UploadFileListMediator(imageUploader.uploadFileList));
			
			facade.registerCommand(UploaderFacade.FILE_ADDED_TO_LIST,FileListCommand);
			facade.registerCommand(UploaderFacade.FILE_REMOVED_FROM_LIST,FileListCommand);
			
			facade.registerCommand(UploaderFacade.FILE_RELOAD,FileListCommand);
			facade.registerCommand(UploaderFacade.FILE_UPLOAD,FileListCommand);
			facade.registerCommand(UploaderFacade.FILE_REUPLOAD,FileListCommand);
			
			facade.registerCommand(UploaderFacade.FILE_LIST_UPLOAD,FileListCommand);
			facade.registerCommand(UploaderFacade.FILE_LIST_CLEAR_UPLOADED,FileListCommand);
			facade.registerCommand(UploaderFacade.FILE_LIST_CLEAR_ERRORED,FileListCommand);
			
			facade.registerCommand(UploaderFacade.BROWSE_FILE_INIT,FileBrowseCommand);
			facade.registerCommand(UploaderFacade.BROWSE_FILE_SELECT,FileBrowseCommand);
			facade.registerCommand(UploaderFacade.BROWSE_FILE_CANCEL,FileBrowseCommand);
			
			facade.registerCommand(UploaderFacade.FILE_LOAD_BEGIN,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_LOAD_PROGRESS,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_LOAD_COMPLETE,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_LOAD_ERROR,FileOperateCommand);
			
			facade.registerCommand(UploaderFacade.FILE_PARSE_BEGIN,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_PARSE_PROGRESS,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_PARSE_COMPLETE,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_PARSE_ERROR,FileOperateCommand);
			
			facade.registerCommand(UploaderFacade.FILE_UPLOAD_BEGIN,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_UPLOAD_PROGRESS,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_UPLOAD_COMPLETE,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_UPLOAD_ERROR,FileOperateCommand);
			
			facade.registerCommand(UploaderFacade.FILE_STATE_CHANGE,FileOperateCommand);
			facade.registerCommand(UploaderFacade.FILE_PHASE_CHANGE,FileOperateCommand);
		}
	}
}