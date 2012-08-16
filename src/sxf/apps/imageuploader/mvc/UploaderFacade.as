package sxf.apps.imageuploader.mvc{
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class UploaderFacade extends Facade implements IFacade{
		
		public static const NAME:String = "imageUploaderFacade";
		
		public static const START_UP:String = "startUp";
		
		public static const BROWSE_FILE_INIT:String = "browseFileInit";
		public static const BROWSE_FILE_SELECT:String = "browseFileSelect";
		public static const BROWSE_FILE_CANCEL:String = "browseFileCancel";
		
		public static const FILE_ADDED_TO_LIST:String = "fileAddedToList";
		public static const FILE_REMOVED_FROM_LIST:String = "fileRemovedFromList";
		public static const FILE_EDIT:String = "fileEdit";
		public static const FILE_RELOAD:String = "fileReload";
		public static const FILE_UPLOAD:String = "fileUpload";
		public static const FILE_REUPLOAD:String = "fileReUpload";
		public static const FILE_UPLOAD_CANCEL:String = "fileUploadCancel";
		
		public static const FILE_STATE_CHANGE:String = "fileStateChange";
		public static const FILE_PHASE_CHANGE:String = "filePhaseChange";
		
		public static const FILE_LOAD_BEGIN:String = "fileLoadBegin";
		public static const FILE_LOAD_PROGRESS:String = "fileLoadProgress";
		public static const FILE_LOAD_COMPLETE:String = "fileLoadComplete";
		public static const FILE_LOAD_ERROR:String = "fileLoadError";
		
		public static const FILE_PARSE_BEGIN:String = "fileParseBegin";
		public static const FILE_PARSE_PROGRESS:String = "fileParseProgress";
		public static const FILE_PARSE_COMPLETE:String = "fileParseComplete";
		public static const FILE_PARSE_ERROR:String = "fileParseError";
		
		public static const FILE_UPLOAD_BEGIN:String = "fileUploadBegin";
		public static const FILE_UPLOAD_PROGRESS:String = "fileUploadProgress";
		public static const FILE_UPLOAD_COMPLETE:String = "fileUploadComplete";
		public static const FILE_UPLOAD_ERROR:String = "fileUploadError";
		
		public static const FILE_LIST_UPLOAD:String = "fileListUpload";
		public static const FILE_LIST_CLEAR_UPLOADED:String = "fileListClearUploaded";
		public static const FILE_LIST_CLEAR_ERRORED:String = "fileListClearErrored";
		
		public function UploaderFacade(){}
		
		public static function getInstance():UploaderFacade{
		
			if(instance == null){
			
				instance = new UploaderFacade();

			}
			return instance as UploaderFacade;
		}
	}
}