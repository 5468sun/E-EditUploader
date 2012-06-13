package sxf.apps.imageeditor.comps
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Image;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	
	import spark.primitives.Graphic;
	
	import sxf.apps.imageeditor.events.ImgMapperEvent;
	import sxf.apps.imageeditor.valueobjects.ImgMapperInfo;
	import sxf.utils.image.ImageResizer;
	import sxf.utils.image.ResizeMath;
	
	public class ImgMapper extends UIComponent{
		
		private var bmpData:BitmapData;
		
		private var bigViewPortWidth:Number;
		private var bigViewPortHeight:Number;
		
		private var bigImgWidth:Number;
		private var bigImgHeight:Number;
		
		private var bigImgX:Number;
		private var bigImgY:Number;
		
		private var smallImg:Image;
		private var borderSprite:Sprite;
		private var maskSprite:Sprite;
		private var smallImgViewPort:Sprite;
		
		private var smallImgWidth:Number;
		private var smallImgHeight:Number;
		
		private var smallViewPortWidth:Number;
		private var smallViewPortHeight:Number;
		
		private var smallImgMaxWidth:Number = 150;
		private var smallImgMaxHeight:Number = 150;
		
		private var dragInitPoint:Point;
		private var dragEndPoint:Point;
		private var mouseHeldDown:Boolean = false;
		
		private var maskColor:int = 0x000000;
		private var maskOpacity:Number = 0.2;
		
		private var smallImgBorderColor:int = 0x000000;
		private var smallImgBorderThick:int = 1;
		private var smallImgBorderOpacity:Number = 0.5;
		
		private var smallViewPortBorderColor:int = 0xffffff;
		private var smallViewPortBorderThick:int = 1;
		private var smallViewPortBorderOpacity:Number = 0.8;
		
		private var scaleMode:String = LineScaleMode.NORMAL;//LineScaleMode.NORMAL、LineScaleMode.NONE、LineScaleMode.VERTICAL
		private var caps:String = CapsStyle.SQUARE;//CapsStyle.NONE、CapsStyle.ROUND、CapsStyle.SQUARE
		private var joints:String = JointStyle.MITER;//JointStyle.BEVEL、JointStyle.MITER 、JointStyle.ROUND
		
		private var safePadding:Number = 10;//此值要与ImageDisplay中的 safePadding 相等
		
		public function ImgMapper(){
			super();
			createView();
		}
		
		public function updateView(imgWidth:Number,imgHeight:Number,imgX:Number,imgY:Number,viewPortWidth:Number,viewPortHeight:Number,bmpData:BitmapData=null):void{
		
			this.bigImgWidth = imgWidth;
			this.bigImgHeight = imgHeight;
			this.bigImgX = imgX - safePadding;
			this.bigImgY = imgY - safePadding;
			this.bigViewPortWidth = viewPortWidth;
			this.bigViewPortHeight = viewPortHeight;
			
			calcSmallImgSize();
			calcSmallViewPortSize();
			
			trace(bigImgWidth+"|"+bigImgHeight+"|"+bigImgX+"|"+bigImgY+"|"+bigViewPortWidth+"|"+bigViewPortHeight+"+"+smallImgWidth+"|"+smallImgHeight+"|"+smallViewPortWidth+"|"+smallViewPortHeight);
			
			resizeSmallViewPort(smallViewPortWidth,smallViewPortHeight);
			posSmallViewPort(new Point(bigImgX,bigImgY));
			updateMask();
			
			if(bmpData){
				
				updateSmallImg(bmpData);
				
			}
			
			if(viewPortWidth>=imgWidth && viewPortHeight>=imgHeight){
			
				this.visible = false;
			
			}else{
			
				this.visible = true;
				
			}
			
		
		}
		
		private function createView():void{
			
			createSmallImg();
			createMask();
			createSmallViewPort();
		}
		
		private function createSmallImg():void{
				
			smallImg = new Image();
			borderSprite = new Sprite();
			addChild(smallImg);
			addChild(borderSprite);
			
			//updateSmallImg(sourceBmpData);
		
		}
		
		private function createMask():void{
			
			maskSprite = new Sprite();
			addChild(maskSprite);
			//updateMask();
			
		}
		
		private function createSmallViewPort():void{
			
			smallImgViewPort = new Sprite();
			addChild(smallImgViewPort);
			
			//resizeSmallViewPort(w,h);
			//posSmallViewPort(p);
			
			smallImgViewPort.addEventListener(MouseEvent.MOUSE_DOWN,onSmallViewPortMouseDown);
			
		}
		
		private function updateSmallImg(sourceBmpData:BitmapData):void{
			
			var bmpData:BitmapData = ImageResizer.bilinearIterative(sourceBmpData,smallImgWidth,smallImgHeight,ResizeMath.METHOD_LETTERBOX);
			this.bmpData = bmpData;
			
			var bmpAsset:BitmapAsset = new BitmapAsset(bmpData,"auto",true);
			smallImg.source = bmpAsset;
			smallImg.width = smallImgWidth;
			smallImg.height = smallImgHeight;

			var graphics:Graphics = borderSprite.graphics;
			graphics.clear();
			graphics.lineStyle(smallImgBorderThick,smallImgBorderColor,smallImgBorderOpacity,true,scaleMode,caps,joints);
			graphics.beginFill(0xffffff,0);
			graphics.drawRect(0,0,smallImgWidth-smallImgBorderThick,smallImgHeight-smallImgBorderThick);
			graphics.endFill();
		
		}
		
		
		
		private function resizeSmallViewPort(width:Number,height:Number):void{
		
			var graphics:Graphics = smallImgViewPort.graphics;
			graphics.clear();
			graphics.moveTo(0,0);
			graphics.lineStyle(smallViewPortBorderThick,smallViewPortBorderColor,smallViewPortBorderOpacity,true,scaleMode,caps,joints);
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,width-smallViewPortBorderThick,height-smallViewPortBorderThick);
			graphics.endFill();
		
		}
		
		private function posSmallViewPort(bigPosition:Point):void{
			
			var smallPosition:Point = calcSmallViewPortPos(bigPosition);
			smallImgViewPort.x = smallPosition.x;
			smallImgViewPort.y = smallPosition.y;
		
		}
		
		
		
		private function updateMask():void{
		
			var x:Number = smallImgViewPort.x;
			var y:Number = smallImgViewPort.y;
			var w:Number = smallImgViewPort.width;
			var h:Number = smallImgViewPort.height;
			var boxw:Number = smallImgWidth;
			var boxh:Number = smallImgHeight;
			
			
			var graphics:Graphics = maskSprite.graphics;
		
			graphics.clear();
			graphics.beginFill(maskColor,maskOpacity);
			graphics.drawRect(0,0,x,y);
			graphics.drawRect(x,0,w,y);
			graphics.drawRect(x+w,0,boxw-(x+w),y);
			
			graphics.drawRect(0,y,x,h);
			graphics.drawRect(x+w,y,boxw-(x+w),h);
			
			graphics.drawRect(0,y+h,x,boxh-(y+h));
			graphics.drawRect(x,y+h,w,boxh-(y+h));
			graphics.drawRect(x+w,y+h,boxw-(x+w),boxh-(y+h));

			
			graphics.endFill();
		
		}
		
		
		///////////////////////////////
		//
		// util function
		//
		/////////////////////////////////
		private function calcSmallImgSize():void{
		
			if(bigImgWidth>bigImgHeight){
				
				this.smallImgWidth = Math.round(smallImgMaxWidth);
				this.smallImgHeight = Math.round(smallImgMaxWidth*(bigImgHeight/bigImgWidth));
				
			}else{
				
				this.smallImgHeight = Math.round(smallImgMaxHeight);
				this.smallImgWidth = Math.round(smallImgMaxHeight*(bigImgWidth/bigImgHeight));
			
			}
			
		}
		
		private function calcSmallViewPortSize():void{
		
			if(bigImgWidth>bigViewPortWidth){
				
				this.smallViewPortWidth = Math.round((smallImgWidth/bigImgWidth)*bigViewPortWidth);
			
			}else{
				
				this.smallViewPortWidth = smallImgWidth;
			
			}
			
			if(bigImgHeight>bigViewPortHeight){
				
				this.smallViewPortHeight = Math.round((smallImgHeight/bigImgHeight)*bigViewPortHeight);
			
			}else{
				
				this.smallViewPortHeight = smallImgHeight;
			
			}
		
		}
		
		private function calcSmallViewPortPos(bigPosition:Point):Point{
		
			var smallPosX:Number;
			var smallPosY:Number;
			
			if(bigPosition.x>=0){
			
				smallPosX = 0;
			
			}else if(bigPosition.x <= (bigViewPortWidth - bigImgWidth)){
				
				smallPosX = smallImgWidth - smallViewPortWidth;
				
			}else{
				smallPosX = Math.round(-bigPosition.x*(smallImgWidth/bigImgWidth));
			}
			
			if(bigPosition.y>=0){
				
				smallPosY = 0;
				
			}else if(bigPosition.y <= (bigViewPortHeight - bigImgHeight)){
				
				smallPosY = smallImgHeight - smallViewPortHeight;
				
			}else{
				
				smallPosY = Math.round(-bigPosition.y*(smallImgHeight/bigImgHeight));
			}
				
			return new Point(smallPosX,smallPosY);
			
		}
		
		private function dragSmallViewPort():void{
			
			/*var dragEndPoint:Point = new Point(this.mouseX,this.mouseY);
			var dragOffsetX:Number = dragEndPoint.x - dragInitPoint.x;
			var dragOffsetY:Number = dragEndPoint.y - dragInitPoint.y;*/

			var gDragInitPoint:Point = smallImgViewPort.localToGlobal(this.dragInitPoint);
			var dragInitPoint:Point = this.globalToLocal(gDragInitPoint);
			var dragEndPoint:Point = new Point(this.mouseX,this.mouseY);
			var dragOffsetX:Number = dragEndPoint.x - Math.round(dragInitPoint.x);
			var dragOffsetY:Number = dragEndPoint.y - Math.round(dragInitPoint.y);
			
			
			if((smallImgViewPort.x + dragOffsetX)<0){
				
				dragOffsetX = -smallImgViewPort.x;
				
			}else if((smallImgViewPort.x + dragOffsetX)>(smallImgWidth - smallViewPortWidth)){
			
				dragOffsetX = (smallImgWidth - smallViewPortWidth) - smallImgViewPort.x;
			}
			
			if((smallImgViewPort.y + dragOffsetY)<0){
				
				dragOffsetY = -smallImgViewPort.y;
				
			}else if((smallImgViewPort.y + dragOffsetY)>(smallImgHeight - smallViewPortHeight)){
				
				dragOffsetY = (smallImgHeight - smallViewPortHeight) - smallImgViewPort.y;
				trace(smallImgHeight +"+"+ smallViewPortHeight+"+"+smallImgViewPort.y +"+");
			
			}
			
			trace(dragOffsetX);
			trace(dragOffsetY);
			
			smallImgViewPort.x += dragOffsetX;
			smallImgViewPort.y += dragOffsetY;
			
			trace(smallImgViewPort.x);
			trace(smallImgViewPort.y);
			trace("++++++++++++++++++++++++++++++++++");
			
			
			updateMask();
			

			var infoObj:ImgMapperInfo = new ImgMapperInfo(smallImgWidth,smallImgHeight,smallImgViewPort.x,smallImgViewPort.y,smallViewPortWidth,smallViewPortHeight);
			dispatchEvent(new ImgMapperEvent(ImgMapperEvent.IMAGE_MAPPER_UPDATE,false,false,infoObj));
			
			//dispatch Event with x y data; 
			
		}
		
		///////////////////////////////
		//
		// handler function
		//
		/////////////////////////////////
		
		private function onSmallViewPortMouseDown(e:MouseEvent):void{
			
			mouseHeldDown = true;
			dragInitPoint = new Point(e.localX,e.localY);
			trace("=======================");
			trace(dragInitPoint);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			smallImgViewPort.addEventListener(MouseEvent.MOUSE_UP,onSmallViewPortMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		
		}
		
		private function onMouseMove(e:MouseEvent):void{
			
			if(mouseHeldDown){
				
				this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				
			}
			
		
		}
		
		private function onSmallViewPortMouseUp(e:MouseEvent):void{
		
			mouseHeldDown = false;
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			smallImgViewPort.removeEventListener(MouseEvent.MOUSE_UP,onSmallViewPortMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		
		}
		
		private function onStageMouseUp(e:MouseEvent):void{
		
			mouseHeldDown = false;
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			smallImgViewPort.removeEventListener(MouseEvent.MOUSE_UP,onSmallViewPortMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		
		}
		
		private function onEnterFrame(e:Event):void{
		
			dragSmallViewPort();
		
		}
		
		override protected function measure():void{
			super.measure();
			measuredWidth = smallImg.getExplicitOrMeasuredWidth();
			measuredHeight = smallImg.getExplicitOrMeasuredHeight();
			measuredMinWidth = 5;
			measuredMinHeight = 5; 
			
		}
		
	}
}