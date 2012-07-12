package sxf.apps.imageeditor.comps
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Rect;
	
	import sxf.apps.imageeditor.events.ImageStageEvent;
	
	public class ImageStage extends SkinnableComponent
	{

		//private var _image:Image;
		private var _matrix:Matrix;
		private var _matrixChanged:Boolean = false;
		private var _bmpData:BitmapData;
		private var _bmpDataChanged:Boolean = false;
		//private var _fillingRect:UIComponent;
		private var _edge:Number = 50;
		private var _orgImgBounds:Rectangle;//origin image boundary when image dragged.
		private var _currentImgBounds:Rectangle;
		private var _currentImgBoundsChanged:Boolean = false;
		private var _mouseDownPoint:Point;
		private var _initPoint:Point;
		private var _endPoint:Point;
		
		
		[SkinPart(required="false")]
		public var _background:Rect;
		
		[SkinPart(required="true")]
		public var _fillingRect:Group;
		
		[SkinPart(required="true")]
		public var _image:Image;
		
		
		
		public function ImageStage()
		{
			super();
		}
		
		public function get bmpData():BitmapData
		{
			return _bmpData;
		}

		public function set bmpData(value:BitmapData):void
		{
			_bmpData = value;
			_bmpDataChanged = true;
			initCursorSys();
			initImageDrag();
			invalidateProperties();
		}

		public function get matrix():Matrix
		{
			return _matrix;
		}

		public function set matrix(value:Matrix):void
		{
			
			if(!isMatrixTheSame(value,_matrix))
			{
				_matrix = value;
				_matrixChanged = true;
				invalidateProperties();
			}
			
		}
		
		private function get currentImgBounds():Rectangle
		{
			return _currentImgBounds;
		}
		
		private function set currentImgBounds(value:Rectangle):void
		{
			_currentImgBounds = value;
			_currentImgBoundsChanged = true;
			invalidateDisplayList();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			switch(instance)
			{

				
				case _fillingRect:
					//do nothing
					break;
				
				case _image:
					//do nothing
					break;
				
				case _background:
					//do nothing
					break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch(instance)
			{

				case _fillingRect:
					destroyCursorSys();
					break;
				
				case _image:
					destroyImageDrag();
					break;
				
				case _background:
					//do nothing
					break;
			}
		}
		
		/*override protected function createChildren():void
		{
			super.createChildren();
			_fillingRect = new UIComponent();
			addElement(_fillingRect);
			_image = new Image();
			addElement(_image);
			
		}*/
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(_matrixChanged || _bmpDataChanged)
			{
				currentImgBounds = getBmpDataBoundary(_matrix);
			}
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			if(_matrixChanged)
			{
				_image.transform.matrix = _matrix;
				_matrixChanged = false;
			}
			if(_currentImgBoundsChanged)
			{
				drawFillingRect();
				_currentImgBoundsChanged = false;
			}
			if(_bmpDataChanged)
			{
				setImageBmpData();
				_bmpDataChanged = false;
			}
		}
		
		private function drawFillingRect():void
		{
			/*_fillingRect.graphics.clear();
			_fillingRect.graphics.beginFill(0xffffff,0.1);
			_fillingRect.graphics.drawRect(_currentImgBounds.x,_currentImgBounds.y,_currentImgBounds.width,_currentImgBounds.height);
			_fillingRect.graphics.endFill();*/
			_fillingRect.x = _currentImgBounds.x;
			_fillingRect.y = _currentImgBounds.y;
			_fillingRect.width = _currentImgBounds.width;
			_fillingRect.height = _currentImgBounds.height;
		}
		
		
		private function setImageBmpData():void
		{
			var bmp:BitmapAsset = new BitmapAsset(_bmpData);
			_image.source = bmp;
			
		}
		
		private function initImageDrag():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,onImageMouseDown);
		}
		
		private function destroyImageDrag():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,onImageMouseDown);
		}
		
		private function initCursorSys():void
		{
			/*addEventListener(Event.ENTER_FRAME,onCursorRelEnterFrame);
			addEventListener(MouseEvent.ROLL_OVER,onStageMouseRollOver);
			addEventListener(MouseEvent.ROLL_OUT,onStageMouseRollOut);*/
			
			//addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			//addEventListener(MouseEvent.MOUSE_OVER,onStageMouseOver);
			//addEventListener(MouseEvent.MOUSE_OUT,onStageMouseOut);
			
			_fillingRect.addEventListener(MouseEvent.ROLL_OVER,onImageMouseRollOver);
			_fillingRect.addEventListener(MouseEvent.ROLL_OUT,onImageMouseRollOut);
		}
		
		
		
		private function destroyCursorSys():void
		{
			_fillingRect.removeEventListener(MouseEvent.ROLL_OVER,onImageMouseRollOver);
			_fillingRect.removeEventListener(MouseEvent.ROLL_OUT,onImageMouseRollOut);
		}
		
		
		private function restrainMousePoint(mousePoint:Point):Point
		{
			var x:Number;
			var y:Number;

			var boundslocalPoint:Point = new Point(_mouseDownPoint.x-_orgImgBounds.x,_mouseDownPoint.y-_orgImgBounds.y);

			if(mousePoint.x < -(_orgImgBounds.width - _edge) + boundslocalPoint.x)
			{
				x = -(_orgImgBounds.width - _edge) + boundslocalPoint.x;
			}
			else if(mousePoint.x > this.width + (boundslocalPoint.x - _edge))
			{
				x = this.width + (boundslocalPoint.x - _edge)
			}
			else
			{
				x = mousePoint.x;
			}
			
			if(mousePoint.y < -(_orgImgBounds.height - _edge) + boundslocalPoint.y)
			{
				y = -(_orgImgBounds.height - _edge) + boundslocalPoint.y;
			}
			else if(mousePoint.y > this.height + (boundslocalPoint.y - _edge))
			{
				y = this.height + (boundslocalPoint.y - _edge)
			}
			else
			{
				y = mousePoint.y;
			}
			
			return new Point(x,y);
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
		
		private function parentPointToImageLocalPoint(parentPoint:Point):Point
		{
			var invertMatrix:Matrix = _image.transform.matrix.clone();
			invertMatrix.invert();
			var initPoint:Point = invertMatrix.transformPoint(parentPoint);
			return initPoint;
		}
		
		private function isMatrixTheSame(m1:Matrix,m2:Matrix):Boolean
		{
			if(m1 == null || m2 == null)
			{
				return false;
			}
			else
			{
				return (m1.a == m2.a && m1.b == m2.b && m1.c == m2.c && m1.d == m2.d && m1.tx == m2.tx && m1.ty == m2.ty);
			}
			
		}
		
		// 事件处理函数
		
		private function onImageMouseRollOver(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.HAND;
			trace("Mouse.cursor = MouseCursor.HAND");
		}
		
		private function onImageMouseRollOut(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.ARROW;
			trace("Mouse.cursor = MouseCursor.ARROW");
		}
		
		/*private function onStageMouseRollOver(e:MouseEvent):void
		{
			trace("onStageMouseRollOver");
			addEventListener(Event.ENTER_FRAME,onCursorRelEnterFrame);
		}
		
		private function onStageMouseRollOut(e:MouseEvent):void
		{
			trace("onStageMouseRollOut");
			Mouse.cursor = MouseCursor.ARROW;
			trace("Mouse.cursor = MouseCursor.ARROW;");
			removeEventListener(Event.ENTER_FRAME,onCursorRelEnterFrame);
			
			//trace("Mouse.cursor = MouseCursor.ARROW;");
			//Mouse.cursor = MouseCursor.ARROW;
		}*/
		
		/*private function onStageMouseOver(e:MouseEvent):void
		{
			trace("onStageMouseOver");
			addEventListener(Event.ENTER_FRAME,onCursorRelEnterFrame);
		}
		
		private function onStageMouseOut(e:MouseEvent):void
		{
			trace("onStageMouseOut");
			removeEventListener(Event.ENTER_FRAME,onCursorRelEnterFrame);
			trace("Mouse.cursor = MouseCursor.ARROW;");
		}*/
		
		/*private function onStageMouseMove(e:MouseEvent):void
		{
			trace("onStageMouseMove");
			var mousePoint:Point = new Point(this.mouseX,this.mouseY);
			if(_currentImgBounds.containsPoint(mousePoint))
			{
				trace("Mouse.cursor = MouseCursor.HAND;");
				Mouse.cursor = MouseCursor.HAND;
			}
			else
			{
				trace("Mouse.cursor = MouseCursor.ARROW;");
				Mouse.cursor = MouseCursor.ARROW;
			}
		}*/
		
		/*private function onCursorRelEnterFrame(e:Event):void
		{
			var mousePoint:Point = new Point(this.mouseX,this.mouseY);
			if(_currentImgBounds.containsPoint(mousePoint))
			{
				trace("Mouse.cursor = MouseCursor.HAND;");
				Mouse.cursor = MouseCursor.HAND;
			}
			else
			{
				trace("Mouse.cursor = MouseCursor.ARROW;");
				Mouse.cursor = MouseCursor.ARROW;
			}
		}*/
		
		private function onImageMouseDown(e:MouseEvent):void
		{	
			_orgImgBounds = getBmpDataBoundary(_matrix);
			_mouseDownPoint = new Point(this.mouseX,this.mouseY);
			_initPoint = parentPointToImageLocalPoint(_mouseDownPoint);
			
			if(_orgImgBounds.containsPoint(_mouseDownPoint))
			{
				addEventListener(MouseEvent.MOUSE_MOVE,onImageMouseDownMove);
				addEventListener(MouseEvent.MOUSE_UP,onImageMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			}
		}
		
		private function onImageMouseUp(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME,onDragRelEnterFrame);
			removeEventListener(MouseEvent.MOUSE_MOVE,onImageMouseDownMove);
			removeEventListener(MouseEvent.MOUSE_UP,onImageMouseUp);
		}
		
		private function onStageMouseUp(e:MouseEvent):void
		{
			onImageMouseUp(e);
		}
			
		private function onImageMouseDownMove(e:MouseEvent):void
		{
			
			addEventListener(Event.ENTER_FRAME,onDragRelEnterFrame);
			removeEventListener(MouseEvent.MOUSE_MOVE,onImageMouseDownMove);
		}
		
		private function onDragRelEnterFrame(e:Event):void
		{
			var mousePoint:Point = new Point(this.mouseX,this.mouseY);
			_endPoint = restrainMousePoint(mousePoint);
			trace(_endPoint);
			dispatchEvent(new ImageStageEvent(ImageStageEvent.DRAGE_IMAGE,false,false,_initPoint,_endPoint));
		}
	}
}