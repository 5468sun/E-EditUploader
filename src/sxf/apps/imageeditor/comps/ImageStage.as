package sxf.apps.imageeditor.comps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.core.BitmapAsset;
	
	import spark.components.Group;
	import spark.components.Image;
	
	import sxf.apps.imageeditor.events.ImageStageEvent;
	
	public class ImageStage extends Group
	{

		private var _image:Image;
		
		private var _padding:Number;
		private var _edge:Number = 50;
		//private var _localPoint:Point;
		private var _initPoint:Point;
		private var _endPoint:Point;
		
		public function ImageStage()
		{
			super();
			this.clipAndEnableScrolling = true;
			padding = 10;
		}
		
		public function get padding():Number
		{
			return _padding;
		}
		
		public function set padding(value:Number):void
		{
			_padding = value;
		}
		
		public function updateImageBmpData(bmpData:BitmapData):void
		{
			var bmp:BitmapAsset = new BitmapAsset(bmpData);
			_image.source = bmp;
		}
		
		public function applyMatrix(matrix:Matrix):void
		{
			_image.transform.matrix = matrix;
			/*if(_image.source)
			{
				var bmp:BitmapAsset = _image.source as BitmapAsset;
				trace(bmp.bitmapData);
				trace(bmp.bitmapData.width);
				trace(bmp.bitmapData.height);
				trace(_image.transform.matrix);
				_image.width = bmp.bitmapData.width*_image.transform.matrix.a;
				_image.height = bmp.bitmapData.height*_image.transform.matrix.d;
			}*/
			
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			_image = new Image();
			addElement(_image);
			initImageDrag();
		}
		
		private function initImageDrag():void
		{
			_image.addEventListener(MouseEvent.MOUSE_DOWN,onImageMouseDown);
		}
		
		private function destroyImageDrag():void
		{
			_image.removeEventListener(MouseEvent.MOUSE_DOWN,onImageMouseDown);
		}
		
		private function localPointToParent(localPoint:Point):Point
		{
			var x:Number = localPoint.x - _image.x;
			var y:Number = localPoint.y - _image.y;
			
			/*var bmpData:BitmapData = Bitmap(_image.source).bitmapData;
			var bmpDataWidth:Number = bmpData.width;
			var bmpDataHeight:Number = bmpData.height;*/
			
			return new Point(x,y);
		}
		
		private function restrainMousePoint(mousePoint:Point):Point
		{
			var x:Number;
			var y:Number;
			var localPoint:Point = _initPoint;
			var bmpData:BitmapData = BitmapAsset(_image.source).bitmapData;
			var imageOriginWidth:Number = bmpData.width;
			var imageOriginHeight:Number = bmpData.height;
			var imageWidth:Number = imageOriginWidth * _image.scaleX;
			var imageHeight:Number = imageOriginHeight * _image.scaleY;
			
			if(mousePoint.x < -(imageWidth - _edge) + localPoint.x)
			{
				x = -(imageWidth - _edge) + localPoint.x;
			}
			else if(mousePoint.x > this.width + (localPoint.x - _edge))
			{
				x = this.width + (localPoint.x - _edge)
			}
			else
			{
				x = mousePoint.x;
			}
			
			if(mousePoint.y < -(imageHeight - _edge) + localPoint.y)
			{
				y = -(imageHeight - _edge) + localPoint.y;
			}
			else if(mousePoint.y > this.height + (localPoint.y - _edge))
			{
				y = this.height + (localPoint.y - _edge)
			}
			else
			{
				y = mousePoint.y;
			}
			
			return new Point(x,y);
		}
		
		// 事件处理函数
		private function onImageMouseDown(e:MouseEvent):void
		{
			_initPoint = new Point(Math.round(e.localX*_image.scaleX),Math.round(e.localY*_image.scaleY));
			_image.addEventListener(MouseEvent.MOUSE_MOVE,onImageMouseDownMove);
			_image.addEventListener(MouseEvent.MOUSE_UP,onImageMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		private function onImageMouseUp(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			_image.removeEventListener(MouseEvent.MOUSE_MOVE,onImageMouseDownMove);
			_image.removeEventListener(MouseEvent.MOUSE_UP,onImageMouseUp);
		}
		
		private function onStageMouseUp(e:MouseEvent):void
		{
			onImageMouseUp(e);
		}
			
		private function onImageMouseDownMove(e:MouseEvent):void
		{
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			_image.removeEventListener(MouseEvent.MOUSE_MOVE,onImageMouseDownMove);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var mousePoint:Point = new Point(this.mouseX,this.mouseY);
			_endPoint = restrainMousePoint(mousePoint);
			dispatchEvent(new ImageStageEvent(ImageStageEvent.DRAGE_IMAGE,false,false,_initPoint,_endPoint));
		}
	}
}