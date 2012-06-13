package sxf.apps.imageeditor.mvc.model
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.valueobjects.ImageObject;
	
	public class ImageService extends Proxy
	{
		public static const NAME:String = "imageService";
		
		public function ImageService(data:Object=null)
		{
			super(NAME, data);
		}
		
		//API
		/**
		 * 加载外部图片
		 * @param url 图片url地址
		 */
		public function loadImage(url:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.OPEN,loadImageBeginHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadImageProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadImageFinishHandler);
			loader.contentLoaderInfo.addEventListener(Event.UNLOAD,loadImageUnloadHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imgLoadErrorHandler);
			loader.load(new URLRequest(url));
		}
		
		//事件监听函数
		
		//图片加载监听
		private function loadImageBeginHandler(e:Event):void
		{
			trace("开始加载外部图片");
			sendNotification(ImageEditorFacade.LOAD_IMAGE_BEGIN);
		}
		
		private function loadImageProgressHandler(e:ProgressEvent):void
		{
			trace("正在加载外部图片" + Math.round(e.bytesLoaded/e.bytesTotal*100) + "%");
			var percent:Number = e.bytesLoaded/e.bytesTotal;
			
			sendNotification(ImageEditorFacade.LOAD_IMAGE_PROGRESS,percent);
		}
		
		private function loadImageFinishHandler(e:Event):void
		{
			trace("加载外部图片完成");
			var loaderInfo:LoaderInfo = LoaderInfo(e.target);
			
			var name:String = getNameFromURL(loaderInfo.url);
			var type:String = loaderInfo.contentType;
			var bitmapData:BitmapData = Bitmap(loaderInfo.content).bitmapData;
			
			if(!bitmapData)
			{
				trace("不是有效的图片文件");
				return;
			}
			
			var imageObject:ImageObject = new ImageObject(name,type,bitmapData);
			loaderInfo.loader.unload();
			
			sendNotification(ImageEditorFacade.LOAD_IMAGE_FINISH,imageObject);
		}
		
		private function loadImageUnloadHandler(e:Event):void
		{
			trace("卸载外部图片");
			sendNotification(ImageEditorFacade.LOAD_IMAGE_UNLOAD);
		}
		
		private function imgLoadErrorHandler(e:IOErrorEvent):void
		{
			trace("加载外部图片错误");
			sendNotification(ImageEditorFacade.LOAD_IMAGE_ERROR);
		}
		
		//工具方法
		private function getNameFromURL(url:String):String
		{
			var name:String = "";
			if(url.indexOf("/")<0){
				name = url;
			}else{
				name = url.substring(url.lastIndexOf("/")+1);
			}
			return name;
		}



	}
}