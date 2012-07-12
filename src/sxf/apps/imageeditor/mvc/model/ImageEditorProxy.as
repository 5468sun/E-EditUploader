package sxf.apps.imageeditor.mvc.model
{
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.utils.image.ImageFlipper;
	import sxf.utils.image.ImageResizer;
	import sxf.utils.image.ImageResizeMath;
	
	public class ImageEditorProxy extends Proxy
	{
		public static const NAME:String = "imageEditorProxy";
		
		private var _imageName:String;
		private var _imageType:String;
		private var _orgBmpData:BitmapData;
		private var _bmpData:BitmapData;
		
		private var _matrix:Matrix;
		private var _restrainRectangle:Rectangle;
		private var _cropRectangle:Rectangle;
		private var _realCropRectangle:Rectangle;
		private var _bmpDataBoundary:Rectangle;
		private var _bmpDataNoScaleBoundary:Rectangle;

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
		
		private var _zoomStep:Number = 0.2;
		
		private var _currentZoomValue:Number = 1;
		private var _currentRotateAngle:Number = 0;
		private var _changeFlag:String;
		
		public function ImageEditorProxy(data:Object=null)
		{
			super(NAME, data);
			_matrix = new Matrix();
			_restrainRectangle = new Rectangle();
			_cropRectangle = new Rectangle();
			_realCropRectangle = new Rectangle();
			_bmpDataBoundary = new Rectangle();
			_bmpDataNoScaleBoundary =  new Rectangle();
			_padding = 10;
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
			bmpDataWidth = bmpData.width;
			bmpDataHeight = bmpData.height;
		}
		
		public function get orgBmpData():BitmapData
		{
			return _orgBmpData;
		}
		
		public function set orgBmpData(value:BitmapData):void
		{
			_orgBmpData = value;
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
			}
			
		}
		
		public function get viewPortHeight():Number
		{
			return _viewPortHeight;
		}
		
		public function set viewPortHeight(value:Number):void
		{
			_viewPortHeight = value;
		}
		
		public function get viewPortWidth():Number
		{
			return _viewPortWidth;
		}
		
		public function set viewPortWidth(value:Number):void
		{
			_viewPortWidth = value;
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
		
		public function get matrix():Matrix
		{
			return _matrix;
		}
		
		public function set matrix(value:Matrix):void
		{
			_matrix = value;
			bmpDataBoundary = getBmpDataBoundary(matrix);
			realCropRectangle = convertCropToRealCrop(cropRectangle);
			imageWidth = bmpDataBoundary.width;
			imageHeight = bmpDataBoundary.height;
			calcZoomKeyValue();
		}
		
		public function get restrainRectangle():Rectangle
		{
			return _restrainRectangle;
		}
		
		public function set restrainRectangle(value:Rectangle):void
		{
			if(!value.equals(_restrainRectangle))
			{
				_restrainRectangle = value;
				sendNotification(ImageEditorFacade.CROP_RESTRAIN_CHANGE,restrainRectangle);
				sendNotification(ImageEditorFacade.STEPPER_RESTRAIN_CHANGE,bmpDataNoScaleBoundary);
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
		
		public function get realCropRectangle():Rectangle
		{
			return _realCropRectangle;
		}
		
		public function set realCropRectangle(value:Rectangle):void
		{
			if(!value.equals(_realCropRectangle))
			{
				_realCropRectangle = value;
				sendNotification(ImageEditorFacade.REAL_CROP_RECTANGLE_CHANGE,realCropRectangle);
			}
		}
		
		public function get bmpDataBoundary():Rectangle
		{
			return _bmpDataBoundary;
		}
		
		public function set bmpDataBoundary(value:Rectangle):void
		{
			_bmpDataBoundary = value;
			bmpDataNoScaleBoundary = new Rectangle(bmpDataBoundary.x,bmpDataBoundary.y,Math.round(bmpDataBoundary.width/_currentZoomValue),Math.round(bmpDataBoundary.height/_currentZoomValue));
			updateRestrainRect();
		}
		
		public function get bmpDataNoScaleBoundary():Rectangle
		{
			return _bmpDataNoScaleBoundary;
		}
		
		public function set bmpDataNoScaleBoundary(value:Rectangle):void
		{
			_bmpDataNoScaleBoundary = value;
		}
		
		
		public function setCropRectangle(value:Rectangle):void
		{
			cropRectangle = value;
			realCropRectangle = convertCropToRealCrop(cropRectangle);
		}
		
		public function setRealCropRectangle(value:Rectangle):void
		{
			realCropRectangle = value;
			cropRectangle = convertRealCropToCrop(realCropRectangle);
		}

		public function updateViewPortSize(width:Number,height:Number):void
		{
			viewPortWidth = width;
			viewPortHeight = height;
			
			if(bmpDataWidth && bmpDataHeight)
			{
				calcZoomKeyValue();
			}
			
		}
		
		public function initImage(bitmapData:BitmapData):void
		{
			bmpData = bitmapData;
			_currentZoomValue = 1;
			_currentRotateAngle = 0;
			
			var mtx:Matrix = new Matrix();
			matrix = mtx;
			
			fitZoomImage();
			moveImageToCenter();
			sendNotification(ImageEditorFacade.IMAGE_INIT);
			sendNotification(ImageEditorFacade.IMAGE_ZOOM,_currentZoomValue);
		}
		
		//放大时以视窗的中心点为中心
		public function zoomInImage():void
		{
			if(_zoomStep<0) _zoomStep = -_zoomStep;
			var zoomValue:Number = calcTargetZoomValue();
			var anchor:Point = new Point(bmpDataWidth/2,bmpDataHeight/2);
			if(zoomValue != _currentZoomValue) 
			{
				zoomAroundInternalPoint(zoomValue,anchor);
				sendNotification(ImageEditorFacade.IMAGE_ZOOM,zoomValue);
			}
		}
		
		//缩小时以图片的中心点为中心
		public function zoomOutImage():void
		{
			if(_zoomStep>0) _zoomStep = -_zoomStep;

			var zoomValue:Number = calcTargetZoomValue();
			var anchor:Point = new Point(bmpDataWidth/2,bmpDataHeight/2);
			if(zoomValue != _currentZoomValue) 
			{
				zoomAroundInternalPoint(zoomValue,anchor);
				sendNotification(ImageEditorFacade.IMAGE_ZOOM,zoomValue);
			}
		}
			
		public function flipImageHorizontal():void
		{
			var mtx:Matrix = new Matrix();
			mtx.scale(-1,1);
			mtx.translate(bmpDataWidth,0);
			mtx.concat(matrix);
			matrix = mtx;
			sendNotification(ImageEditorFacade.IMAGE_FLIP);
		}
		
		public function flipImageVertical():void
		{
			var mtx:Matrix = new Matrix();
			mtx.scale(1,-1);
			mtx.translate(0,bmpDataHeight);
			mtx.concat(matrix);
			matrix = mtx;
			sendNotification(ImageEditorFacade.IMAGE_FLIP);
		}
		
		public function rotateImage(angle:Number):void
		{
			var imageCenterPoint:Point = new Point(bmpDataWidth/2,bmpDataHeight/2);
			rotateAroundInternalPoint(angle,imageCenterPoint);
			sendNotification(ImageEditorFacade.IMAGE_ROTATE);
		}
		
		public function cropImage():void
		{
			//var newBmpData:BitmapData = new BitmapData(realCropRectangle.width,realCropRectangle.height,false,0xff0000);
			//trace(newBmpData.rect);
			/*initPoint = concatScaleMtx.transformPoint(initPoint);
			endPoint = concatScaleMtx.transformPoint(endPoint);
			trace(initPoint + endPoint);*/
			
			var initPoint:Point = new Point(cropRectangle.x,cropRectangle.y);
			var endPoint:Point = new Point(cropRectangle.x+cropRectangle.width,cropRectangle.y+cropRectangle.height);
			//trace(initPoint + endPoint);
			var scaleValue:Number = 1/_currentZoomValue;
			var cropMatrix:Matrix = matrix.clone();
			var concatScaleMtx:Matrix = new Matrix(scaleValue,0,0,scaleValue,0,0);
			
			initPoint = parentPointToImageLocalPoint(initPoint,cropMatrix);
			endPoint = parentPointToImageLocalPoint(endPoint,cropMatrix);
			//trace(initPoint + endPoint);
			cropMatrix.concat(concatScaleMtx);
			
			initPoint = imageLocalPointToParentPoint(initPoint,cropMatrix);
			endPoint = imageLocalPointToParentPoint(endPoint,cropMatrix);
			//trace(initPoint + endPoint);
			var cropRect:Rectangle = new Rectangle(Math.round(initPoint.x),Math.round(initPoint.y),Math.round(endPoint.x-initPoint.x),Math.round(endPoint.y-initPoint.y));
			cropMatrix.translate(-cropRect.x,-cropRect.y);
			var newBmpData:BitmapData = new BitmapData(realCropRectangle.width,realCropRectangle.height,true,0x000000);
			newBmpData.draw(bmpData,cropMatrix,null,null);

			bmpData = newBmpData;
			
			/*_currentZoomValue = 1;
			_currentRotateAngle = 0;
			
			var mtx:Matrix = new Matrix();
			matrix = mtx;
			
			fitZoomImage();*/
			
			var mtx:Matrix = new Matrix();
			mtx.scale(_currentZoomValue,_currentZoomValue);
			matrix = mtx;

			moveImageToCenter();
			
			sendNotification(ImageEditorFacade.IMAGE_CROP);
			sendNotification(ImageEditorFacade.IMAGE_ZOOM,_currentZoomValue);
		}
		
		public function resizeImage(width:Number,height:Number):void
		{
			var newBmpData:BitmapData = ImageResizer.bilinearIterative(bmpData,width,height,ImageResizeMath.METHOD_PAN_AND_SCAN);
			bmpData = newBmpData;
			sendNotification(ImageEditorFacade.IMAGE_RESIZE);
			
		}
		
		public function resetImage():void
		{
			var newBmpData:BitmapData = orgBmpData.clone();
			bmpData = newBmpData;
			sendNotification(ImageEditorFacade.IMAGE_RESET);
		}
		
		public function dragImage(initPoint:Point,endPoint:Point):void
		{
			var mtx:Matrix = matrix.clone();
			
			var currentInitPoint:Point = mtx.transformPoint(initPoint);
			mtx.translate(endPoint.x - currentInitPoint.x,endPoint.y - currentInitPoint.y);
			matrix = mtx;
			sendNotification(ImageEditorFacade.IMAGE_DRAG);
		}
		
		
		//计算缩放关键值
		private function calcZoomKeyValue():void
		{
			_fitZoomValue = calcFitZoomValue(bmpDataNoScaleBoundary.width,bmpDataNoScaleBoundary.height,viewPortWidth-2*_padding,viewPortHeight-2*_padding);

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
		
		private function calcInitTargetZoomValue():Number
		{
			var targetZoomValue:Number = _minZoomValue;
			return targetZoomValue;
		}
		
		private function calcTargetZoomValue():Number
		{
			var targetZoomValue:Number = _currentZoomValue + _zoomStep;
			var middleZoomvalue:Number = isImageLargerThanViewPort()?1:_fitZoomValue;
			
			if(_currentZoomValue<middleZoomvalue)
			{
				if(targetZoomValue > middleZoomvalue)
				{
					targetZoomValue = middleZoomvalue;
				}
				else if(targetZoomValue < _minZoomValue)
				{
					targetZoomValue = _minZoomValue;
				}
			}
			else if(_currentZoomValue>middleZoomvalue)
			{
				if(targetZoomValue < middleZoomvalue)
				{
					targetZoomValue = middleZoomvalue;
				}
				else if(targetZoomValue > _maxZoomValue)
				{
					targetZoomValue = _maxZoomValue;
				}
			}
			else if(_currentZoomValue == middleZoomvalue)
			{
				if(targetZoomValue < _minZoomValue)
				{
					targetZoomValue = _minZoomValue;
				}
				else if(targetZoomValue > _maxZoomValue)
				{
					targetZoomValue = _maxZoomValue;
				}
			}
			
			return targetZoomValue;
		}
		
		//以图片外部的点为中心缩放图片，在放大图片时用到
		private function zoomAroundExternalPoint(zoomValue:Number,point:Point):void
		{
			var mtx:Matrix = matrix.clone();
			var anchor:Point = point;
			mtx.translate(-anchor.x,-anchor.y);
			mtx.scale(zoomValue/_currentZoomValue,zoomValue/_currentZoomValue);
			mtx.translate(anchor.x,anchor.y);
			_currentZoomValue = zoomValue;
			matrix = mtx;
		}
		
		//以图片内部的点为中心缩放图片，在缩小图片时用到
		private function zoomAroundInternalPoint(zoomValue:Number,point:Point):void
		{
			var mtx:Matrix = matrix.clone();
			var anchor:Point = matrix.transformPoint(point);
			mtx.translate(-anchor.x,-anchor.y);
			mtx.scale(zoomValue/_currentZoomValue,zoomValue/_currentZoomValue);
			mtx.translate(anchor.x,anchor.y);
			_currentZoomValue = zoomValue;
			matrix = mtx;
		}
		
		
		
		//以图片内部的点为中心旋转图片
		private function rotateAroundInternalPoint(angle:Number,point:Point):void
		{
			var mtx:Matrix = matrix.clone();
			var anchor:Point = matrix.transformPoint(point);
			mtx.translate(-anchor.x,-anchor.y);
			mtx.rotate(angle);
			mtx.translate(anchor.x,anchor.y);
			_currentRotateAngle = (_currentRotateAngle+angle)%360;
			matrix = mtx;
		}
		
		private function rotateAroundExternalPoint(angle:Number,point:Point):void
		{
			var mtx:Matrix = matrix.clone();
			var anchor:Point = point;
			mtx.translate(-anchor.x,-anchor.y);
			mtx.rotate(angle);
			mtx.translate(anchor.x,anchor.y);
			_currentRotateAngle = (_currentRotateAngle+angle)%360;
			matrix = mtx;
		}
		
		private function fitZoomImage():void
		{
			var zoomValue:Number = calcInitTargetZoomValue();
			var anchor:Point = new Point(bmpDataWidth/2,bmpDataHeight/2);
			zoomAroundInternalPoint(zoomValue,anchor);
		}
		
		private function moveImageToCenter():void
		{
			var mtx:Matrix = matrix.clone();
			var parentPoint:Point = new Point(bmpDataBoundary.x + bmpDataBoundary.width/2,bmpDataBoundary.y + bmpDataBoundary.height/2);
			
			mtx.translate(-parentPoint.x,-parentPoint.y);
			mtx.translate(viewPortWidth/2,viewPortHeight/2);
			matrix = mtx;

		}
		
		private function isImageLargerThanViewPort():Boolean
		{
			return (_bmpDataWidth>_viewPortWidth-2*_padding || _bmpDataHeight>_viewPortHeight-2*_padding);
		}

		private function updateRestrainRect():void
		{
			restrainRectangle = bmpDataBoundary;
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

			var minx:Number = Math.round(Math.min(newPoint1.x,newPoint2.x,newPoint3.x,newPoint4.x));
			var maxx:Number = Math.round(Math.max(newPoint1.x,newPoint2.x,newPoint3.x,newPoint4.x));
			var miny:Number = Math.round(Math.min(newPoint1.y,newPoint2.y,newPoint3.y,newPoint4.y));
			var maxy:Number = Math.round(Math.max(newPoint1.y,newPoint2.y,newPoint3.y,newPoint4.y));

			return new Rectangle(minx,miny,maxx-minx,maxy-miny);
		}
		
		private function getBmpDataBoundary(matrix:Matrix):Rectangle
		{
			
			return transformRectangle(bmpData.rect,matrix);
		}
		
		private function getNoScaleMatrix():Matrix
		{
			var matrix:Matrix = new Matrix;
			matrix.rotate(_currentRotateAngle);
			return matrix;
		}
		
		private function drawTempRotatedNoScaleBmpData(width:Number,height:Number,matrix:Matrix):BitmapData
		{
			var tempBmpData:BitmapData = new BitmapData(width,height);
			tempBmpData.draw(bmpData,matrix);
			return tempBmpData;
		}
		
		private function convertCropToRealCrop(rectangle:Rectangle):Rectangle
		{
			var x:Number = Math.round((rectangle.x - bmpDataBoundary.x)/_currentZoomValue);
			var y:Number = Math.round((rectangle.y - bmpDataBoundary.y)/_currentZoomValue);
			var w:Number = Math.round(rectangle.width/_currentZoomValue);
			var h:Number = Math.round(rectangle.height/_currentZoomValue);
			return new Rectangle(x,y,w,h);
		}
		
		
		private function convertRealCropToCrop(rectangle:Rectangle):Rectangle
		{
			var x:Number = Math.round(rectangle.x*_currentZoomValue + bmpDataBoundary.x);
			var y:Number = Math.round(rectangle.y*_currentZoomValue + bmpDataBoundary.y);
			var w:Number = Math.round(rectangle.width*_currentZoomValue);
			var h:Number = Math.round(rectangle.height*_currentZoomValue);
			return new Rectangle(x,y,w,h);
			
		}
		

		private function parentPointToImageLocalPoint(parentPoint:Point,matrix:Matrix):Point
		{
			var invertMatrix:Matrix = matrix.clone();
			invertMatrix.invert();
			var p:Point = invertMatrix.transformPoint(parentPoint);
			return p;
		}
		private function imageLocalPointToParentPoint(localPoint:Point,matrix:Matrix):Point
		{
			var p:Point = matrix.transformPoint(localPoint);
			return p;
		}
	}
}