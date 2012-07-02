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
		private var _restrainRectangle:Rectangle;
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
		private var _currentRotateAngle:Number = 0;
		private var _changeFlag:String;
		
		public function ImageEditorProxy(data:Object=null)
		{
			super(NAME, data);
			_restrainRectangle = new Rectangle();
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
				//sendNotification(ImageEditorFacade.PADDING_CHANGE,_padding);
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
			sendNotification(ImageEditorFacade.IMAGE_INIT);
			initTransform();
		}
		
		//放大时以视窗的中心点为中心
		public function zoomInImage():void
		{
			if(_zoomStep<0) _zoomStep = -_zoomStep;
			var zoomValue:Number = calcTargetZoomValue();
			var anchor:Point = new Point(_bmpDataWidth/2,_bmpDataHeight/2);
			zoomAroundInternalPoint(zoomValue,anchor);
			//moveImageToCenter();
		}
		
		//缩小时以图片的中心点为中心
		public function zoomOutImage():void
		{
			if(_zoomStep>0) _zoomStep = -_zoomStep;

			var zoomValue:Number = calcTargetZoomValue();
			var anchor:Point = new Point(_bmpDataWidth/2,_bmpDataHeight/2);
			zoomAroundInternalPoint(zoomValue,anchor);
			//moveImageToCenter();
		}
			
		public function flipImageHorizontal():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(-1,1);
			matrix.translate(_bmpDataWidth,0);
			matrix.concat(_matrix);
			_matrix = matrix;
			updateRestrainRect();
			sendNotification(ImageEditorFacade.IMAGE_FLIP);
		}
		
		public function flipImageVertical():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(1,-1);
			matrix.translate(0,_bmpDataHeight);
			matrix.concat(_matrix);
			_matrix = matrix;
			updateRestrainRect();
			sendNotification(ImageEditorFacade.IMAGE_FLIP);
		}
		
		public function rotateImage(angle:Number):void
		{
			var imageCenterPoint:Point = new Point(_bmpDataWidth/2,_bmpDataHeight/2);
			rotateAroundInternalPoint(angle,imageCenterPoint);
			sendNotification(ImageEditorFacade.IMAGE_ROTATE);
		}
		
		public function cropImage(cropRect:Rectangle):void
		{
			_matrix.scale(1/_currentZoomValue,1/_currentZoomValue);
			//var emptyMatrix:Matrix = new Matrix();
			//emptyMatrix.scale();
			//var anchor:Point = new Point(_bmpDataWidth/2,_bmpDataHeight/2);
			//anchor = _matrix.transformPoint(anchor);
			//zoomAroundInternalPoint(1,anchor);
			/*var tempMatrix:Matrix = _matrix.clone();
			var anchor:Point = new Point(_bmpDataWidth/2,_bmpDataHeight/2);
			anchor = _matrix.transformPoint(anchor);
			trace(_matrix);
			tempMatrix.translate(-anchor.x,-anchor.y);
			tempMatrix.scale(1/_matrix.a,1/_matrix.d);
			tempMatrix.translate(anchor.x,anchor.y);
			var noScaleMatrix:Matrix = tempMatrix;
			_matrix = noScaleMatrix;
			trace(_matrix);*/
			/*var newImgBoundray:Rectangle = transformRectangle(_bmpData.rect,noScaleMatrix);
			var tempMatrix2:Matrix = noScaleMatrix.clone();
			tempMatrix2.translate(-newImgBoundray.x,-newImgBoundray.y);
			var tanslateMatrix:Matrix = tempMatrix2;
			
			var totalMatrix:Matrix = noScaleMatrix.clone();
			totalMatrix.concat(tanslateMatrix);
			var tempBmpData:BitmapData = drawTempRotatedNoScaleBmpData(2800,2800,totalMatrix);
			var newCropBoundary:Rectangle = transformRectangle(cropRect,totalMatrix);
			
			var newBmpData:BitmapData = new BitmapData(newCropBoundary.width,newCropBoundary.height);
			var drawMatrix:Matrix = new Matrix();
			drawMatrix.translate(-newCropBoundary.x,-newCropBoundary.y);
			newBmpData.draw(tempBmpData,drawMatrix);

			_bmpData = newBmpData;*/
			/*var nonScaleMatrix:Matrix = calcNonScaleMatrix();
			var newImgBoundray:Rectangle = transformRectangle(_bmpData.rect,_matrix);
			
			var tempBmpData:BitmapData = drawTempRotatedNoScaleBmpData(2800,2800,nonScaleMatrix);
 			var newCropBoundary:Rectangle = transformRectangle(cropRect,nonScaleMatrix);
			var newBmpData:BitmapData = new BitmapData(newCropBoundary.width,newCropBoundary.height);
			newBmpData.copyPixels(tempBmpData,newCropBoundary,new Point(0,0));
			tempBmpData.dispose();
			_bmpData = newBmpData;*/
			/*var orginBmpDataBoundary:Rectangle = new Rectangle(0,0,_bmpDataWidth,_bmpDataHeight);
			var newBmpDataBoundray:Rectangle = transformRectangle(orginBmpDataBoundary,matrix);
			var newBmpData:BitmapData = new BitmapData(newBmpDataBoundray.width,newBmpDataBoundray.height);
			newBmpData.draw(_bmpData,_matrix);
			
			var newBmpData:BitmapData = new BitmapData(cropRect.width,cropRect.height);
			newBmpData.copyPixels(_bmpData,cropRect,new Point(0,0));
			_bmpData = newBmpData;
			*/
			//initTransform();
			sendNotification(ImageEditorFacade.IMAGE_CROP);
		}
		
		public function resizeImage(width:Number,height:Number):void
		{
			var newBmpData:BitmapData = ImageResizer.bilinearIterative(_bmpData,width,height,ResizeMath.METHOD_PAN_AND_SCAN);
			_bmpData = newBmpData;
			initTransform();
			sendNotification(ImageEditorFacade.IMAGE_RESIZE);
			
		}
		
		public function resetImage():void
		{
			var newBmpData:BitmapData = _orgBmpData.clone();
			_bmpData = newBmpData;
			initTransform();
			sendNotification(ImageEditorFacade.IMAGE_RESET);
		}
		
		public function dragImage(initPoint:Point,endPoint:Point):void
		{
			var currentInitPoint:Point = _matrix.transformPoint(initPoint);
			matrix.translate(endPoint.x - currentInitPoint.x,endPoint.y - currentInitPoint.y);
			sendNotification(ImageEditorFacade.IMAGE_DRAG);
			updateRestrainRect();
		}
		
		//计算缩放关键值
		private function calcZoomKeyValue():void
		{
			var bmpDataBounds:Rectangle = getBmpDataBoundary(calcNoScaleMatrix());
			_fitZoomValue = calcFitZoomValue(bmpDataBounds.width,bmpDataBounds.height,_viewPortWidth-2*_padding,_viewPortHeight-2*_padding);

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
			var anchor:Point = point;
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.scale(zoomValue/_currentZoomValue,zoomValue/_currentZoomValue);
			_matrix.translate(anchor.x,anchor.y);
			_currentZoomValue = zoomValue;
			var bounds:Rectangle = getBmpDataBoundary(_matrix);
			_imageWidth = bounds.width;
			_imageHeight = bounds.height;
			
			sendNotification(ImageEditorFacade.IMAGE_ZOOM,zoomValue);
			updateRestrainRect();
			//checkForDrag();
		}
		
		//以图片内部的点为中心缩放图片，在缩小图片时用到
		private function zoomAroundInternalPoint(zoomValue:Number,point:Point):void
		{
			var anchor:Point = _matrix.transformPoint(point);
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.scale(zoomValue/_currentZoomValue,zoomValue/_currentZoomValue);
			_matrix.translate(anchor.x,anchor.y);
			_currentZoomValue = zoomValue;
			var bounds:Rectangle = getBmpDataBoundary(_matrix);
			_imageWidth = bounds.width;
			_imageHeight = bounds.height;
			
			sendNotification(ImageEditorFacade.IMAGE_ZOOM,zoomValue);
			updateRestrainRect();
			//checkForDrag();
		}
		
		
		
		//以图片内部的点为中心旋转图片
		private function rotateAroundInternalPoint(angle:Number,point:Point):void
		{
			var anchor:Point = _matrix.transformPoint(point);
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.rotate(angle);
			_currentRotateAngle = (_currentRotateAngle+angle)%360;
			_matrix.translate(anchor.x,anchor.y);
			var bounds:Rectangle = getBmpDataBoundary(_matrix);
			_imageWidth = bounds.width;
			_imageHeight = bounds.height;
			calcZoomKeyValue();
			updateRestrainRect();
		}
		
		private function rotateAroundExternalPoint(angle:Number,point:Point):void
		{
			var anchor:Point = point;
			_matrix.translate(-anchor.x,-anchor.y);
			_matrix.rotate(angle);
			_currentRotateAngle = (_currentRotateAngle+angle)%360;
			_matrix.translate(anchor.x,anchor.y);
			var bounds:Rectangle = getBmpDataBoundary(_matrix);
			_imageWidth = bounds.width;
			_imageHeight = bounds.height;
			calcZoomKeyValue();
			updateRestrainRect();
		}
		
		private function initTransform():void
		{
			_matrix = new Matrix();
			_bmpDataWidth = _bmpData.width;
			_bmpDataHeight = _bmpData.height;
			_imageWidth = _bmpDataWidth;
			_imageHeight = _bmpDataHeight;
			calcZoomKeyValue();
			moveImageToCenter();
			var zoomValue:Number = calcInitTargetZoomValue();
			var anchor:Point = new Point(_bmpDataWidth/2,_bmpDataHeight/2);
			zoomAroundInternalPoint(zoomValue,anchor);
		}
		
		private function moveImageToCenter():void
		{
			var parentPoint:Point = new Point(_matrix.tx + _imageWidth/2,_matrix.ty + _imageHeight/2);
			_matrix.translate(-parentPoint.x,-parentPoint.y);
			_matrix.translate(_viewPortWidth/2,_viewPortHeight/2);
			sendNotification(ImageEditorFacade.IMAGE_CENTER);
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
			return (_bmpDataWidth>_viewPortWidth-2*_padding || _bmpDataHeight>_viewPortHeight-2*_padding);
		}

		private function updateRestrainRect():void
		{
			restrainRectangle = getBmpDataBoundary(_matrix);
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
			return transformRectangle(_bmpData.rect,matrix);
		}
		
		private function calcNoScaleMatrix():Matrix
		{
			var matrix:Matrix = new Matrix;
			matrix.rotate(_currentRotateAngle);
			return matrix;
		}
		
		private function drawTempRotatedNoScaleBmpData(width:Number,height:Number,matrix:Matrix):BitmapData
		{
			var tempBmpData:BitmapData = new BitmapData(width,height);
			tempBmpData.draw(_bmpData,matrix);
			return tempBmpData;
		}
	}
}