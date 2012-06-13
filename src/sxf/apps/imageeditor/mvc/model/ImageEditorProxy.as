package sxf.apps.imageeditor.mvc.model
{
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.utils.image.ImageFlipper;
	import sxf.utils.image.ImageResizer;
	import sxf.utils.image.ResizeMath;
	
	public class ImageEditorProxy extends Proxy
	{
		public static const NAME:String = "imageEditorProxy";
		private static const CHANGE_FROM_CROPER:String = "changeFromCroper";
		private static const CHANGE_FROM_CROPTOOL:String = "changeFromCropTool";
		
		private var _imageName:String;
		private var _imageType:String;
		private var _orgBmpData:BitmapData;
		private var _bmpData:BitmapData;
		
		private var _matrix:Matrix = new Matrix();
		private var _restrainRect:Rectangle;
		private var _cropRectangle:Rectangle;
		private var _selectRectangle:Rectangle;

		private var _padding:Number;

		private var _viewPortWidth:Number;
		private var _viewPortHeight:Number;
		
		private var _imageWidth:Number;
		private var _imageHeight:Number;
		
		private var _bmpDataWidth:Number;
		private var _bmpDataHeight:Number;
		
		private var _fitZoomValue:Number;
		private var _minZoomValue:Number;
		private var _maxZoomValue:Number = 8;
		
		private var _zoomStep:Number = 0.5;
		
		private var _currentZoomValue:Number = 1;
		private var _changeFlag:String;
		
		public function ImageEditorProxy(data:Object=null)
		{
			super(NAME, data);
			_restrainRect = new Rectangle();
			_cropRectangle = new Rectangle();
			_selectRectangle = new Rectangle();
			padding = 10;
		}
		
		
		public function get imageWidth():Number
		{
			return _imageWidth;
		}

		public function set imageWidth(value:Number):void
		{
			_imageWidth = value;
		}

		public function get imageName():String
		{
			return _imageName;
		}
		
		public function set imageName(value:String):void
		{
			_imageName = value;
		}
		
		public function get imageType():String
		{
			return _imageType;
		}
		
		public function set imageType(value:String):void
		{
			_imageType = value;
		}
		
		public function get bmpData():BitmapData
		{
			return _bmpData;
		}
		
		public function set bmpData(value:BitmapData):void
		{
			_bmpData = value;
			_bmpDataWidth = _bmpData.width;
			_bmpDataHeight = _bmpData.height;
		}
		
		public function get orgBmpData():BitmapData
		{
			return _orgBmpData;
		}
		
		public function set orgBmpData(value:BitmapData):void
		{
			_orgBmpData = value;
		}

		
		public function get matrix():Matrix
		{
			return _matrix;
		}
		
		public function set matrix(value:Matrix):void
		{}
		
		public function get restrainRect():Rectangle
		{
			return _restrainRect;
		}
		
		public function set restrainRect(value:Rectangle):void
		{
			if(!value.equals(_restrainRect))
			{
				_restrainRect = value;
				sendNotification(ImageEditorFacade.CROP_RESTRAIN_CHANGE,restrainRect);
			}
		}
		
		public function get cropRectangle():Rectangle
		{
			return _cropRectangle;
		}
		
		public function set cropRectangle(value:Rectangle):void
		{
			if(!value.equals(_cropRectangle))
			{
				_cropRectangle = value;
				sendNotification(ImageEditorFacade.CROP_RECTANGLE_CHANGE,cropRectangle);
			}
		}
		
		public function setCropRectangle(value:Rectangle):void
		{
			cropRectangle = value;
			selectRectangle = rectConvertCropToImage(cropRectangle);
		}
		
		public function get selectRectangle():Rectangle
		{
			return _selectRectangle;
		}
		
		public function set selectRectangle(value:Rectangle):void
		{
			if(!value.equals(_selectRectangle))
			{
				_selectRectangle = value;
				sendNotification(ImageEditorFacade.SELECT_RECTANGLE_CHANGE,selectRectangle);
			}
		}
		
		public function setSelectRectangle(value:Rectangle):void
		{
			selectRectangle = value;
			cropRectangle = rectConvertImageToCrop(selectRectangle);
		}

		
		private function rectConvertCropToImage(rectangle:Rectangle):Rectangle
		{
			var x:Number = Math.round((rectangle.x - matrix.tx)/matrix.a);
			var y:Number = Math.round((rectangle.y - matrix.ty)/matrix.d);
			var w:Number = Math.round(rectangle.width/matrix.a);
			var h:Number = Math.round(rectangle.height/matrix.d);
			return new Rectangle(x,y,w,h);
		}
		
		private function rectConvertImageToCrop(rectangle:Rectangle):Rectangle
		{
			var x:Number = Math.round(rectangle.x*matrix.a + matrix.tx);
			var y:Number = Math.round(rectangle.y*matrix.d + matrix.ty);
			var w:Number = Math.round(rectangle.width*matrix.a);
			var h:Number = Math.round(rectangle.height*matrix.d);
			return new Rectangle(x,y,w,h);
		}
		
		public function get padding():Number
		{
			return _padding;
		}
		
		public function set padding(value:Number):void
		{
			if(value != _padding)
			{
				_padding = value;
				sendNotification(ImageEditorFacade.PADDING_CHANGE,_padding);
			}
			
		}
		
		public function get bmpDataWidth():Number
		{
			return _bmpDataWidth;
		}

		public function set bmpDataWidth(value:Number):void
		{
			_bmpDataWidth = value;
		}

		public function get bmpDataHeight():Number
		{
			return _bmpDataHeight;
		}

		public function set bmpDataHeight(value:Number):void
		{
			_bmpDataHeight = value;
		}
		
		public function get imageHeight():Number
		{
			return _imageHeight;
		}
		
		public function set imageHeight(value:Number):void
		{
			_imageHeight = value;
		}

		
		public function updateViewPortSize(width:Number,height:Number):void
		{
			_viewPortWidth = width;
			_viewPortHeight = height;
			
			if(_bmpDataWidth && _bmpDataHeight)
			{
				calcZoomKeyValue();
			}
			
		}
		
		public function initImage():void
		{
			initTransform();
		}
		
		//放大时以视窗的中心点为中心
		public function zoomInImage():void
		{
			if(_zoomStep<0)_zoomStep = -_zoomStep;
			var zoomValue:Number = calcTargetZoomValue();
			var anchor:Point = new Point(_viewPortWidth/2,_viewPortHeight/2);
			zoomAroundExternalPoint(zoomValue,anchor);
			moveImageToCenter();
		}
		
		//缩小时以图片的中心点为中心
		public function zoomOutImage():void
		{
			if(_zoomStep>0)_zoomStep = -_zoomStep;

			var zoomValue:Number = calcTargetZoomValue();
			var anchor:Point = new Point(_imageWidth/2,_imageHeight/2);
			zoomAroundInternalPoint(zoomValue,anchor);
			moveImageToCenter();
		}
			
		public function flipImageHorizontal():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(-1,1);
			matrix.translate(_bmpDataWidth,0);
			var bmpData:BitmapData = new BitmapData(_bmpDataWidth,_bmpDataHeight);
			bmpData.draw(_bmpData,matrix);
			_bmpData = bmpData;
			sendNotification(ImageEditorFacade.IMAGE_FLIP);
		}
		
		public function flipImageVertical():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(1,-1);
			matrix.translate(0,_bmpDataHeight);
			var bmpData:BitmapData = new BitmapData(_bmpDataWidth,_bmpDataHeight);
			bmpData.draw(_bmpData,matrix);
			_bmpData = bmpData;
			sendNotification(ImageEditorFacade.IMAGE_FLIP);
		}
		
		public function rotateImage(angle:Number):void
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(-_bmpDataWidth/2,-_bmpDataHeight/2);
			matrix.rotate(angle);
			matrix.translate(_bmpDataWidth/2,_bmpDataHeight/2);
			var bmpDataBoundary:Rectangle = new Rectangle(0,0,_bmpDataWidth,_bmpDataHeight);
			var newBmpDataBoundray:Rectangle = transformRectangle(bmpDataBoundary,matrix);
			var newWidth:Number = newBmpDataBoundray.width;
			var newHeight:Number = newBmpDataBoundray.height;
			var bmpData:BitmapData = new BitmapData(_bmpDataWidth,_bmpDataHeight);
			//bmpData.draw(_bmpData,matrix);
			bmpData.draw(_bmpData);
			_bmpData = bmpData;
			sendNotification(ImageEditorFacade.IMAGE_ROTATE);
		}
		
		public function cropImage(cropRect:Rectangle):void
		{
			var newBmpData:BitmapData = new BitmapData(cropRect.width,cropRect.height);
			newBmpData.copyPixels(_bmpData,cropRect,new Point(0,0));
			_bmpData = newBmpData;
			_bmpDataWidth = _bmpData.width;
			_bmpDataHeight = _bmpData.height;
			_imageWidth = _bmpDataWidth;
			_imageHeight = _bmpDataHeight;
			_matrix = new Matrix();
			initTransform();
			sendNotification(ImageEditorFacade.IMAGE_CROP);
		}
		
		public function resizeImage(width:Number,height:Number):void
		{
			var newBmpData:BitmapData = ImageResizer.bilinearIterative(_bmpData,width,height,ResizeMath.METHOD_PAN_AND_SCAN);
			_bmpData = newBmpData;
			_bmpDataWidth = _bmpData.width;
			_bmpDataHeight = _bmpData.height;
			_imageWidth = _bmpDataWidth;
			_imageHeight = _bmpDataHeight;
			_matrix = new Matrix();
			initTransform();
			sendNotification(ImageEditorFacade.IMAGE_RESIZE);
			
		}
		
		public function resetImage():void
		{
			var newBmpData:BitmapData = _orgBmpData.clone();
			_bmpData = newBmpData;
			_bmpDataWidth = _bmpData.width;
			_bmpDataHeight = _bmpData.height;
			_imageWidth = _bmpDataWidth;
			_imageHeight = _bmpDataHeight;
			_matrix = new Matrix();
			initTransform();
			sendNotification(ImageEditorFacade.IMAGE_RESET);
		}
		
		public function dragImage(initPoint:Point,endPoint:Point):void
		{
			var newInitPoint:Point = new Point(initPoint.x+matrix.tx,initPoint.y+matrix.ty);
			matrix.translate(endPoint.x - newInitPoint.x,endPoint.y - newInitPoint.y);
			sendNotification(ImageEditorFacade.IMAGE_DRAG);
			updateRestrainRect();
		}
		
		//计算缩放关键值
		private function calcZoomKeyValue():void
		{
			_fitZoomValue = calcFitZoomValue(_bmpDataWidth,_bmpDataHeight,_viewPortWidth-2*_padding,_viewPortHeight-2*_padding);

			if(isImageLargerThanViewPort())//图片超出视窗范围
			{
				_minZoomValue = _fitZoomValue;
			}
			else//图片不超出视窗范围
			{
				_minZoomValue = 1;
			}
		}
		
		//计算合适缩放关键值
		private function calcFitZoomValue(contentWidth:Number,contentHeight:Number,containerWidth:Number,containerHeight:Number):Number
		{
			var scaleValue:Number;
			
			if(contentWidth/contentHeight >= containerWidth/containerHeight)
			{
				scaleValue = containerWidth/contentWidth;
			}
			else
			{
				scaleValue = containerHeight/contentHeight;
			}
			
			return scaleValue;
		}
		
		private function calcInitZoomValue():Number
		{
			var targetZoomValue:Number;
			if(isImageLargerThanViewPort())
			{
				targetZoomValue = _fitZoomValue;
			}else
			{
				targetZoomValue = _minZoomValue;
			}

			return targetZoomValue;
		}
		
		private function calcTargetZoomValue():Number
		{
			var targetZoomValue:Number = _currentZoomValue + _zoomStep;
			if(_currentZoomValue<_fitZoomValue && targetZoomValue>_fitZoomValue)
			{
				targetZoomValue = _fitZoomValue;
			}
			else if(_currentZoomValue>_fitZoomValue && targetZoomValue<_fitZoomValue)
			{
				targetZoomValue = _fitZoomValue;
			}
			else if(_currentZoomValue<=_maxZoomValue && targetZoomValue>_maxZoomValue)
			{
				targetZoomValue = _maxZoomValue;
			}
			else if(_currentZoomValue>=_minZoomValue && targetZoomValue<_minZoomValue)
			{
				targetZoomValue = _minZoomValue;
			}
			else if(_currentZoomValue<1 && targetZoomValue>1)
			{
				targetZoomValue = 1;
			}
			return targetZoomValue;
		}
		
		//以图片外部的点为中心缩放图片，在放大图片时用到
		private function zoomAroundExternalPoint(zoomValue:Number,point:Point):void
		{
			var anchor:Point = point;
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.scale(zoomValue/_currentZoomValue,zoomValue/_currentZoomValue);
			_matrix.translate(anchor.x,anchor.y);
			_currentZoomValue = zoomValue;
			_imageWidth = Math.round(_bmpDataWidth * zoomValue);
			_imageHeight = Math.round(_bmpDataHeight * zoomValue);
			sendNotification(ImageEditorFacade.IMAGE_ZOOM,zoomValue);
			//checkForDrag();
		}
		
		//以图片内部的点为中心缩放图片，在缩小图片时用到
		private function zoomAroundInternalPoint(zoomValue:Number,point:Point):void
		{
			var anchor:Point = _matrix.transformPoint(point);
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.scale(zoomValue/_matrix.a,zoomValue/_matrix.d);
			_matrix.translate(anchor.x,anchor.y);
			_currentZoomValue = zoomValue;
			_imageWidth = Math.round(_bmpDataWidth * zoomValue);
			_imageHeight = Math.round(_bmpDataHeight * zoomValue);
			sendNotification(ImageEditorFacade.IMAGE_ZOOM,zoomValue);
			//checkForDrag();
		}
		
		
		
		//以图片内部的点为中心旋转图片
		private function rotateAroundInternalPoint(angle:Number,point:Point):void
		{
			var anchor:Point = _matrix.transformPoint(point);
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.rotate(angle);
			_matrix.translate(anchor.x,anchor.y);
		}
		
		private function rotateAroundExternalPoint(angle:Number,point:Point):void
		{
			var anchor:Point = point;
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.rotate(angle);
			_matrix.translate(anchor.x,anchor.y);
		}
		
		private function initTransform():void
		{
			_imageWidth = bmpDataWidth;
			_imageHeight = bmpDataHeight;
			calcZoomKeyValue();
			var zoomValue:Number = calcInitZoomValue();
			var originImgCenterPoint:Point = new Point(_bmpDataWidth/2,_bmpDataHeight/2);
			zoomAroundInternalPoint(zoomValue,originImgCenterPoint);
			moveImageToCenter();
			sendNotification(ImageEditorFacade.IMAGE_INIT);
		}
		
		private function moveImageToCenter():void
		{
			var parentPoint:Point = new Point(_matrix.tx + _imageWidth/2,_matrix.ty + _imageHeight/2);
			_matrix.translate(-parentPoint.x,-parentPoint.y);
			_matrix.translate(_viewPortWidth/2,_viewPortHeight/2);
			sendNotification(ImageEditorFacade.IMAGE_CENTER);
			updateRestrainRect();
		}
		
		private function checkForDrag():void
		{
			/*if(_currentZoomValue>_fitZoomValue)
			{
				sendNotification(ImageEditorFacade.INIT_IMAGE_DRAG);
			}
			else
			{
				sendNotification(ImageEditorFacade.DESTROY_IMAGE_DRAG);
			}*/
		}
		
		private function isImageLargerThanViewPort():Boolean
		{
			return (_imageWidth>_viewPortWidth-2*_padding || _imageHeight>_viewPortHeight-2*_padding);
		}

		private function updateRestrainRect():void
		{
			restrainRect = new Rectangle(Math.floor(matrix.tx),Math.floor(matrix.ty),imageWidth,imageHeight);
		}
		
		private function transformRectangle(targetRect:Rectangle,matrix:Matrix):Rectangle
		{
			var point1:Point = new Point(targetRect.x,targetRect.y);
			var newPoint1:Point = matrix.transformPoint(point1);
			var point2:Point = new Point(targetRect.x+targetRect.width,targetRect.y);
			var newPoint2:Point = matrix.transformPoint(point2);
			var point3:Point = new Point(targetRect.x,targetRect.y+targetRect.height);
			var newPoint3:Point = matrix.transformPoint(point3);
			var point4:Point = new Point(targetRect.x+targetRect.width,targetRect.y+targetRect.height);
			var newPoint4:Point = matrix.transformPoint(point4);
			var minx:Number = Math.min(newPoint1.x,newPoint2.x,newPoint3.x,newPoint4.x);
			var maxx:Number = Math.max(newPoint1.x,newPoint2.x,newPoint3.x,newPoint4.x);
			var miny:Number = Math.min(newPoint1.y,newPoint2.y,newPoint3.y,newPoint4.y);
			var maxy:Number = Math.max(newPoint1.y,newPoint2.y,newPoint3.y,newPoint4.y);
			return new Rectangle(minx,miny,maxx-minx,maxy-miny);
		}

	}
}