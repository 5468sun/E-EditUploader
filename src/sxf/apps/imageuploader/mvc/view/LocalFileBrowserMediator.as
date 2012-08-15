package sxf.apps.imageuploader.mvc.view{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReferenceList;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Button;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.comps.localfileloader.LocalFileBrowseEvent;
	import sxf.comps.localfileloader.LocalFileBrowseType;
	import sxf.comps.localfileloader.LocalFileBrowser;
	
	public class LocalFileBrowserMediator extends Mediator implements IMediator{
		
		public static const NAME:String = "localFileBrowserMediator";
		
		private var fileRefList:FileReferenceList;
		
		public function LocalFileBrowserMediator(viewComponent:Object=null){
			
			super(NAME, viewComponent);
		}
		
		private function get browseBtn():Button{
			
			return this.viewComponent as Button;
			
		}
		
		override public function onRegister():void
		{
			browseBtn.addEventListener(MouseEvent.CLICK,onBrowseBtnClick);
		}
		
		override public function onRemove():void
		{
			browseBtn.removeEventListener(MouseEvent.CLICK,onBrowseBtnClick);
		}
		
		private function onBrowseBtnClick(e:MouseEvent):void
		{
			sendNotification(UploaderFacade.BROWSE_FILE_INIT);
			fileRefList = new FileReferenceList();
			fileRefList.addEventListener(Event.SELECT,onBrowseSelect);
			fileRefList.addEventListener(Event.CANCEL,onBrowseCancel);
			fileRefList.browse(LocalFileBrowseType.IMAGE);
		}
		
		private function onBrowseSelect(e:Event):void{
			var fileRefList:FileReferenceList = FileReferenceList(e.currentTarget);
			var fileList:Array = fileRefList.fileList;
			sendNotification(UploaderFacade.BROWSE_FILE_SELECT,fileList);
			fileRefList.removeEventListener(Event.SELECT,onBrowseSelect);
			fileRefList.removeEventListener(Event.CANCEL,onBrowseCancel);
		}
		
		private function onBrowseCancel(e:Event):void{
			var fileRefList:FileReferenceList = FileReferenceList(e.currentTarget);
			sendNotification(UploaderFacade.BROWSE_FILE_CANCEL);
			fileRefList.removeEventListener(Event.SELECT,onBrowseSelect);
			fileRefList.removeEventListener(Event.CANCEL,onBrowseCancel);
		}
	}
}