package sxf.apps.imageuploader.mvc.view{
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.BitmapAsset;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageuploader.comps.UploadFileList;
	import sxf.apps.imageuploader.comps.UploadFileListItemRenderer;
	import sxf.apps.imageuploader.events.ItemHandleEvent;
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.valueobjects.FileObject;
	
	public class UploadFileListMediator extends Mediator implements IMediator{
		
		public static const NAME:String = "uploadFileListMediator";
		
		public function UploadFileListMediator(viewComponent:Object=null){
			
			super(NAME, viewComponent);
			uploadFileList.addEventListener(ItemHandleEvent.DELETE_ITEM,onUploadItemDelete);
			uploadFileList.addEventListener(ItemHandleEvent.EDIT_ITEM,onUploadItemEdit);
			uploadFileList.addEventListener(ItemHandleEvent.RELOAD_ITEM,onUploadItemReload);
			uploadFileList.addEventListener(ItemHandleEvent.UPLOAD_ITEM,onUploadItemUpload);
			uploadFileList.addEventListener(ItemHandleEvent.REUPLOAD_ITEM,onUploadItemReUpload);
			uploadFileList.addEventListener(ItemHandleEvent.CANCEL_UPLOAD_ITEM,onUploadItemCancel);
			
		}
		
		// API functions/////////////////////////
		
		public function addItemAt(item:FileObject,index:int):void{
		
			uploadFileList.addItemAt(item,index);
			
		
		}
		
		public function removeItemAt(index:int):void{
		
			uploadFileList.removeItemAt(index);
		
		}
		
		public function updateStateAt(state:String,index:int):void
		{
			uploadFileList.updateStateAt(state,index);
		}
		
		public function updatePhaseAt(phase:String,index:int):void
		{
			uploadFileList.updatePhaseAt(phase,index);
		}
		
		public function updateProgressBarAt(percent:Number,index:int):void
		{
			uploadFileList.updateProgressBarAt(percent,index);
		}
		
		/*public function disable():void{
		
			uploadFileList.disableInteraction();
		
		}
		
		public function enable():void{
		
			uploadFileList.enableInteraction();
		
		}
		
		public function getListLength():int{
			
			return uploadFileList.dataLength;
			
		}*/
		
		/*public function getEditingIndex():int{
		
			return uploadFileList.editingIndex;
		
		}
		
		public function setEditingIndex(index:int):void{
		
			uploadFileList.editingIndex = index;
		
		}*/
		
		////////////////////////
		// getter setter functions
		///////////////////////////
		
		private function get uploadFileList():UploadFileList{
			
			return this.viewComponent as UploadFileList;
			
		}
		
		/*private function get listData():ArrayCollection{
			
			return uploadFileList.listData;
			
		}*/
		
		/*public function setCurrentStateAt(state:String,index:int):void{
		
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setCurrentState(state);
			
		}
		

		public function onItemLoadBegin(percent:Number,index:int):void{
			
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			var LoadingImage:Class = uploadFileList.LoadingThumb;
			uploadFileItem.showThumb(new LoadingImage());
			uploadFileItem.setProgressBarLabel("开始读取 0%");
			uploadFileItem.setItemProgress(percent);

		}
		
		public function onItemLoadProgress(percent:Number,index:int):void{
			
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);		
			uploadFileItem.setProgressBarLabel("正在读取 %3%%");
			uploadFileItem.setItemProgress(percent);
		
		}
		
		
		public function onItemLoadComplete(percent:Number,index:int):void{
			
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("读取完成");
			uploadFileItem.setItemProgress(percent);
			
		}
		
		
		public function onItemLoadError(index:int):void{
		
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			var ErrorImage:Class = uploadFileList.ErrorThumb;
			uploadFileItem.showThumb(new ErrorImage());
			uploadFileItem.setProgressBarLabel("加载失败");
		
		}
		
		
		public function onImageParseBegin(index:int):void{
		
			trace("onImageParseBegin");
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("开始解析");

		}
		
		public function onImageParseProgress(index:int):void{
		
			trace("onImageParseProgress");
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("正在解析");
		}
		
		public function onImageParseComplete(bmpData:BitmapData,index:int):void{
		
			trace("onImageParseComplete");
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.showThumb(new BitmapAsset(bmpData,"auto",true));
			uploadFileItem.setProgressBarLabel("解析成功");

		
		}
		
		public function onImageParseError(index:int):void{
		
			trace("onImageParseError");
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("无效图片");

		
		}
		
		public function onItemUploadWait(index:int):void{
			
			trace("uploadWaiting");
		}
		
		public function onItemUploadBegin(percent:Number,index:int):void{
		
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("开始上传 0%");
			uploadFileItem.setItemProgress(percent);
			trace("onItemUploadBegin");

		}
		
		public function onItemUploadProgress(percent:Number,index:int):void{
			
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("正在上传 " + Math.ceil(percent*100) + "%");
			uploadFileItem.setItemProgress(percent);
			
		}
		
		
		public function onItemUploadComplete(percent:Number,index:int):void{
			
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("上传完成");
			uploadFileItem.setItemProgress(percent);

		}
		
		public function onItemUploadCancel(index:int):void{
		
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("解析成功");
			uploadFileItem.setItemProgress(0);
		
		}
		
		public function onItemUploadError(index:int):void{
			
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("上传错误");
			
		}
		
		
		public function onItemUploadTimeout(index:int):void{
		
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);
			uploadFileItem.setProgressBarLabel("上传超时");

		}
		*/
		
		/////////////////////////////////
		
		private function onUploadItemDelete(e:ItemHandleEvent):void{
			
			trace("onUploadItemDelete");
			var index:int = e.index;
			sendNotification(UploaderFacade.FILE_REMOVED_FROM_LIST,index);
			
		}
		private function onUploadItemEdit(e:ItemHandleEvent):void{
			var index:int = e.index;
			sendNotification(UploaderFacade.FILE_EDIT,index);
			/*trace("onUploadItemEdit");
			
			var uploadFileItem:UploadFileListItemRenderer = uploadFileList.getUploadFileListItem(index);

			uploadFileItem.setProgressBarLabel("正在编辑");	
			uploadFileList.editingIndex = index;
			disable();
			
			sendNotification(UploaderFacade.LIST_ITEM_EDIT,index);*/
			
		}
		private function onUploadItemReload(e:ItemHandleEvent):void{
			
			trace("onUploadItemReload");
			var index:int = e.index;
			sendNotification(UploaderFacade.FILE_RELOAD,index);
			
		}
		
		private function onUploadItemUpload(e:ItemHandleEvent):void{
			
			trace("onUploadItemUpload");
			var index:int = e.index;
			sendNotification(UploaderFacade.FILE_UPLOAD,index);
		}
		private function onUploadItemReUpload(e:ItemHandleEvent):void{
			
			trace("onUploadItemReupload");
			var index:int = e.index;
			sendNotification(UploaderFacade.FILE_REUPLOAD,index);
		}
		
		private function onUploadItemCancel(e:ItemHandleEvent):void{
		
			trace("onUploadItemCancel");
			var index:int = e.index;
			sendNotification(UploaderFacade.FILE_UPLOAD_CANCEL,index);
		
		}
	}
}