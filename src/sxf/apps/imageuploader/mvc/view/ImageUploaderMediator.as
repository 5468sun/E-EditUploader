package sxf.apps.imageuploader.mvc.view{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Button;
	
	import sxf.apps.imageuploader.events.ImageUploaderEvent;
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.comps.localfileloader.LocalFileBrowseEvent;
	import sxf.comps.localfileloader.LocalFileBrowser;
	
	public class ImageUploaderMediator extends Mediator implements IMediator{
		
		public static const NAME:String = "imageUploaderMediator";
		
		public function ImageUploaderMediator(viewComponent:Object=null){
			
			super(NAME, viewComponent);


		}
		
		override public function onRegister():void
		{
			var uploadBtn:EventDispatcher = imageUploader.uploadBtn;
			var clearUploadedBtn:EventDispatcher = imageUploader.clearUploadedBtn;
			var clearErroredBtn:EventDispatcher = imageUploader.clearErroredBtn;
			uploadBtn.addEventListener(MouseEvent.CLICK,onUploadBtnClick);
			clearUploadedBtn.addEventListener(MouseEvent.CLICK,onclearUploadedBtnClick);
			clearErroredBtn.addEventListener(MouseEvent.CLICK,onclearErroredBtnClick);
		}
		
		override public function onRemove():void
		{
			var uploadBtn:EventDispatcher = imageUploader.uploadBtn;
			var clearUploadedBtn:EventDispatcher = imageUploader.clearUploadedBtn;
			var clearErroredBtn:EventDispatcher = imageUploader.clearErroredBtn;
			uploadBtn.removeEventListener(MouseEvent.CLICK,onUploadBtnClick);
			clearUploadedBtn.removeEventListener(MouseEvent.CLICK,onclearUploadedBtnClick);
			clearErroredBtn.removeEventListener(MouseEvent.CLICK,onclearErroredBtnClick);
		}
		// setter getter functions////////////
		
		public function get imageUploader():ImageUploader{
		
			return this.viewComponent as ImageUploader;
		}
		
		// API functions //////////////////
		
		
		
		///////////////////
		// event handler
		//////////////////

		private function onUploadBtnClick(e:MouseEvent):void
		{
			sendNotification(UploaderFacade.FILE_LIST_UPLOAD);
		}
		
		private function onclearUploadedBtnClick(e:MouseEvent):void
		{
			sendNotification(UploaderFacade.FILE_LIST_CLEAR_UPLOADED);
		}
		
		private function onclearErroredBtnClick(e:MouseEvent):void
		{
			sendNotification(UploaderFacade.FILE_LIST_CLEAR_ERRORED);
		}
	}
}