package sxf.utils.image
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.SolidColor;
	
	import sxf.utils.image.CropperEvent;
	
	public class Cropper extends UIComponent
	{
		private var _rect:Rectangle = new Rectangle(0,0,0,0);
		
		private var defaultRestrainRect:Rectangle;
		private var customRestrainRect:Rectangle;
		private var _useCustomRestrainRect:Boolean = false;
		
		private var handles:Array;
		//private var handlePoints:Array;
		private var rectPoints:Array;
		
		private var handleWidth:Number = 7;
		private var handleHeight:Number = 7;
		private var handleBgColor:Number = 0xffffff;
		private var handleNum:Number = 8;
		
		private var borderThickness:Number = 1;
		private var borderWidth:Number = borderThickness/2;
		private var borderColor:Number = 0x03f731;
		
		private var scaleMode:String = LineScaleMode.NORMAL;//LineScaleMode.NORMAL、LineScaleMode.NONE、LineScaleMode.VERTICAL
		private var caps:String = CapsStyle.SQUARE;//CapsStyle.NONE、CapsStyle.ROUND、CapsStyle.SQUARE
		private var joints:String = JointStyle.MITER;//JointStyle.BEVEL、JointStyle.MITER 、JointStyle.ROUND
		
		private var rectBox:Sprite;
		private var rectBoxBgColor:Number = 0xffffff;
		
		private var rectBoxMinWidth:Number = 24;
		private var rectBoxMinHeight:Number = 24;
		
		private var maskColor:Number = 0x000000;//mask bg color
		private var maskOpacity:Number = 0.7;//mask bg opacity
		private var maskColor2:Number = 0xffffff;//rect bg color
		private var maskOpacity2:Number = 0;//rect bg opacity
		
		private var activeHandleIndex:Number = -1;
		
		private var _resizingRect:Boolean = false;
		private var _movingRect:Boolean = false;
		
		private var handleLocalOffsetX:Number;//小方块上的鼠标触点到方块中心的水平偏移量
		private var handleLocalOffsetY:Number;//小方块上的鼠标触点到方块中心的垂直偏移量
		
		private var resizeInitPoint:Point;
		private var resizeEndPoint:Point;
		
		private var dragInitPoint:Point;
		
		private var _keepRatio:Boolean = false;
		private var _ratio:Number; // abs(x/y)
		

		
		/**
		 * 
		 * 构造函数
		 * 
		 * @param initRect 初始截取范围，如未指定，则使用默认的Rectangle(100,100,100,100)。 Rectangle
		 * @param restrainRect 控制可截取范围，如未指定，则可截取范围为Rectangle(0,0,this.width,this.height),既是本控件的范围。 Rectangle
		 * 
		 * **/
		public function Cropper(initRect:Rectangle=null,restrainRect:Rectangle=null)
		{
			super();
			
			if(initRect) {
				
				this.rect = initRect;
				
			}
			
			if(restrainRect) {
				
				useCustomRestrainRect = true;
				this.restrainRect = restrainRect;
				
			}//else, set restrainRect to (0,0,this.width,this.height) when creationComplete
			
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			
			createView();

			addEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
			addEventListener(Event.RESIZE,onResize);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);

		}
		
		public function get rect():Rectangle{
		
			return this._rect;
		
		}
		
		public function set rect(value:Rectangle):void{
		
			this._rect = value;
		
		}
		
		/**
		 * 
		 * 获取选取限制对象
		 * 
		 * **/
		public function get restrainRect():Rectangle{
			
			if(useCustomRestrainRect){
				
				return customRestrainRect;
				
			}else{
				
				return defaultRestrainRect;
				
			}
			
		}
		
		/**
		 * 
		 * 设置选取限制对象
		 * 
		 * **/
		
		public function set restrainRect(rct:Rectangle):void{
			
			if(useCustomRestrainRect){
				
				customRestrainRect = rct;
				
			}else{
				
				defaultRestrainRect = rct;
				
			}
			
		}
		
		public function get useCustomRestrainRect():Boolean{
			
			return _useCustomRestrainRect;
			
		}
		
		public function set useCustomRestrainRect(value:Boolean):void{
			
			_useCustomRestrainRect = value;
			
		}
		
		/**
		 * 
		 * 获取、设置 是否比例
		 * 
		 * **/
		
		public function get keepRatio():Boolean{
		
			return _keepRatio;
		
		}
		
		public function set keepRatio(value:Boolean):void{
			
			_keepRatio = value;
			
			/*if(value){
			
				ratio = Math.abs(rect.width/rect.height);
			
			}*/
		
		}
		
		/**
		 * 
		 * 获取、设置比例
		 * 
		 * **/
		
		public function get ratio():Number{
			
			return _ratio;
			
		}
		
		public function set ratio(value:Number):void{
			
			_ratio = value;
			
		}
		
		public function get resizingRect():Boolean{
		
			return _resizingRect;
		
		}
		
		public function set resizingRect(value:Boolean):void{
		
			_resizingRect = value;
		
		}
		
		public function get movingRect():Boolean{
		
			return _movingRect;
		
		}
		
		public function set movingRect(value:Boolean):void{
		
			_movingRect = value;
		
		}
		
		/**
		 * 缩放
		 * **/
		
		/*public function drawCropper(rectangle:Rectangle):void{
			
			updateCropper(rectangle);
		
		}*/
		
		/**
		 * 
		 * 更新Cropper
		 * 
		 * **/
		
		public function updateCropper(rectangle:Rectangle):void{
		
			this.rect = rectangle;
			updateView();
			trace(rectangle);
		}
		
		/*public function zoomMove(oldScaleValue:Number,newScaleValue:Number,oldX:Number,newX:Number,oldY:Number,newY:Number):void{
		
			var scalevalue:Number = newScaleValue/oldScaleValue;
			var x:Number = Math.round((rect.x-oldX)*scalevalue + newX);
			var y:Number = Math.round((rect.y-oldY)*scalevalue + newY);
			
			
			
			var w:Number = Math.round(rect.width * scalevalue);
			var h:Number = Math.round(rect.height * scalevalue);
			
			var newRect:Rectangle = new Rectangle(x,y,w,h);

			updateCropper(newRect);
		}
		
		public function moveOnly(oldX:Number,newX:Number,oldY:Number,newY:Number):void{
			var offsetX:Number = newX - oldX;
			var offsetY:Number = newY - oldY;
			
		
		}*/
		
		public function moveBy(offsetX:Number,offsetY:Number):void{
		
			var x:Number = rect.x + offsetX;
			var y:Number = rect.y + offsetY;
			var w:Number = rect.width;
			var h:Number = rect.height;
			
			var newRect:Rectangle = new Rectangle(x,y,w,h);
			updateCropper(newRect);
		
		}
		

		
		public function zoomBy(scalevalue:Number):void{
		
			var x:Number = rect.x;
			var y:Number = rect.y;
			
			var w:Number = Math.round(rect.width * scalevalue);
			var h:Number = Math.round(rect.height * scalevalue);
			
			var newRect:Rectangle = new Rectangle(x,y,w,h);
			
			updateCropper(newRect);
		
		}
		
		/**
		 * 
		 * 设置宽高
		 * 
		 * **/
		
		public function setSize(width:Number,height:Number):void{
			
			/* 模式1
			rectPoints = calcRectPoints();
			var tempEndPoint:Point;
			if(activeHandleIndex == -1){activeHandleIndex = 7}
			
			switch (activeHandleIndex){
			
			case 0:
			
			resizeInitPoint = rectPoints[7];
			tempEndPoint = rectPoints[0];
			break;
			
			case 7:
			
			resizeInitPoint = rectPoints[0];
			tempEndPoint = rectPoints[7];
			break;
			
			case 2:
			
			resizeInitPoint = rectPoints[5];
			tempEndPoint = rectPoints[2];
			break;
			
			case 5:
			
			resizeInitPoint = rectPoints[2];
			tempEndPoint = rectPoints[5];
			break;
			
			case 1:
			
			resizeInitPoint = rectPoints[6];
			tempEndPoint = rectPoints[1];
			break;
			
			case 3:
			
			resizeInitPoint = rectPoints[4];
			tempEndPoint = rectPoints[3];
			break;
			
			case 4:
			
			resizeInitPoint = rectPoints[3];
			tempEndPoint = rectPoints[4];
			break;
			
			case 6:
			
			resizeInitPoint = rectPoints[1];
			tempEndPoint = rectPoints[6];
			break;
			
			}
			
			var initX:Number;
			var initY:Number;
			var endX:Number;
			var endY:Number;
			var newX:Number;
			var newY:Number;
			
			initX = resizeInitPoint.x;
			initY = resizeInitPoint.y;
			
			endX = tempEndPoint.x;
			endY = tempEndPoint.y;
			
			
			if(endX>initX){
			
			newX = initX + width;
			
			}else{
			
			newX = initX - width;
			
			}
			
			if(endY>initY){
			
			newY = initY + height;
			
			}else{
			
			newY = initY - height;
			
			}
			
			var crossPoint:Point = new Point(newX,newY);
			trace("resizeInitPoint"+resizeInitPoint);
			trace("tempEndPoint"+tempEndPoint);
			trace("crossPoint"+crossPoint);
			this.resizeEndPoint = getRestrainCrossPoint(crossPoint,this.restrainRect);
			
			trace("resizeEndPoint"+resizeEndPoint);
			var newRect:Rectangle = calcRectFromPoints(this.resizeInitPoint,this.resizeEndPoint);
			
			trace(newRect);
			updateCropper(newRect);
			
			*/
			
			//* 模式2
			rectPoints = calcRectPoints();
			
			var tempEndPoint:Point;
			
			resizeInitPoint = rectPoints[0];
			tempEndPoint = rectPoints[7];
			

			var initX:Number;
			var initY:Number;
			var endX:Number;
			var endY:Number;
			var newX:Number;
			var newY:Number;
			
			initX = resizeInitPoint.x;
			initY = resizeInitPoint.y;
			
			endX = tempEndPoint.x;
			endY = tempEndPoint.y;
			
			
			if(endX>initX){
			
			newX = initX + width;
			
			}else{
			
			newX = initX - width;
			
			}
			
			if(endY>initY){
			
			newY = initY + height;
			
			}else{
			
			newY = initY - height;
			
			}
			
			var crossPoint:Point = new Point(newX,newY);
			trace("resizeInitPoint"+resizeInitPoint);
			trace("tempEndPoint"+tempEndPoint);
			trace("crossPoint"+crossPoint);
			this.resizeEndPoint = getRestrainCrossPoint(crossPoint,this.restrainRect);
			
			trace("resizeEndPoint"+resizeEndPoint);
			var newRect:Rectangle = calcRectFromPoints(this.resizeInitPoint,this.resizeEndPoint);
			
			trace(newRect);
			updateCropper(newRect);
			
			//*/
			
		}
		
		/**
		 * 
		 * 创建选取方框
		 * 
		 * **/
		private function createRectBox():void{
			
			rectBox = new Sprite();
			addChild(rectBox);
			updateRectBox();

		}
		
		/**
		 * 
		 * 调整选取框的大小和位置
		 * 
		 * **/
		private function updateRectBox():void{
			
			drawBorderAndBg(rectBox,rect,borderThickness,borderColor,rectBoxBgColor,1,true,scaleMode,caps,joints);
			
		}
		
		/**
		 * 
		 * 创建8个调整按钮,初始化按钮位置
		 * 
		 * **/
		private function createHandles():void{
			
			handles = new Array();
			
			var handleRect:Rectangle = new Rectangle(0,0,handleWidth,handleHeight);
			
			for(var i:int = 0; i<handleNum; i++){
				
				var handle:Sprite = new Sprite();
				drawBorderAndBg(handle,handleRect,borderThickness,borderColor,handleBgColor,1,true,scaleMode,caps,joints);
				handles.push(handle);
				addChild(handle);
				
			}
			updateHandles();
			
		}
		
		
		
		/**
		 * 
		 * 调整8个按钮的位置
		 * 
		 * **/
		private function updateHandles():void{

			var handlePoints:Array = calHandlePoints();
			
			for(var i:int = 0; i<handles.length; i++){
				
				var point:Point = handlePoints[i] as Point;
				var handle:Sprite = handles[i] as Sprite;
				
				handle.x = Math.round(point.x - handle.width/2);
				handle.y = Math.round(point.y - handle.height/2);
				
			}
			
		}
		
		
		
		/**
		 * 
		 * 根据传入的Rectangle对象计算8个控制点的坐标位置。
		 * **/
		private function calHandlePoints():Array{
			
			var borderThicknessw:Number = rect.width<0?-borderThickness:borderThickness;
			var borderThicknessh:Number = rect.height<0?-borderThickness:borderThickness;
			var x:Number = this.rect.x - borderThicknessw;
			var y:Number = this.rect.y - borderThicknessh;
			var w:Number = this.rect.width + borderThicknessw;
			var h:Number = this.rect.height + borderThicknessh;
			
			var borderedRect:Rectangle = new Rectangle(x,y,w,h);
	
			return calcPoints(borderedRect);
			
		}
		
		private function calcRectPoints():Array{
			
			return calcPoints(this.rect);
		
		}
		
		
		/**
		 * 
		 * 创建遮罩
		 * 
		 * **/
		private function updateMask():void{

			var x:Number = (rect.width<0)?(rect.x + rect.width):rect.x;
			var y:Number = (rect.height<0)?(rect.y + rect.height):rect.y;
			var w:Number = Math.abs(rect.width);
			var h:Number = Math.abs(rect.height);
			graphics.clear();
			graphics.beginFill(maskColor,maskOpacity);
			graphics.drawRect(0,0,x,y);
			graphics.drawRect(x,0,w,y);
			graphics.drawRect(x+w,0,this.width-(x+w),y);
			
			graphics.drawRect(0,y,x,h);
			graphics.drawRect(x+w,y,this.width-(x+w),h);
			
			graphics.drawRect(0,y+h,x,this.height-(y+h));
			graphics.drawRect(x,y+h,w,this.height-(y+h));
			graphics.drawRect(x+w,y+h,this.width-(x+w),this.height-(y+h));
			
			graphics.beginFill(maskColor2,maskOpacity2);
			graphics.drawRect(x,y,w,h);
			
			graphics.endFill();
			
		}
		
		/**
		 * 
		 * 创建视图
		 * 
		 * **/
		private function createView():void{
			
			createRectBox();
			createHandles();
			
		}
		
		/**
		 * 
		 * 更新视图
		 * 
		 * **/
		private function updateView():void{


			updateRectBox();
			updateHandles();
			//updateMask();
			
		}
		
		/**
		 * 
		 * 更新选取区域数据
		 * 
		 * **/
		
		
		private function recalcRect():Rectangle{
			
			var newRect:Rectangle;
			
			rectPoints = calcRectPoints();

			// resize cropper
			if(resizingRect){
				
				var mousePoint:Point = new Point(this.mouseX + this.handleLocalOffsetX,this.mouseY + this.handleLocalOffsetY);
				this.resizeEndPoint = getRestrainCrossPoint(mousePoint,this.restrainRect);

				newRect = calcRectFromPoints(this.resizeInitPoint,this.resizeEndPoint);
				
			}else if(movingRect){//move cropper

				var offx:Number;
				var offy:Number;
				var offsetx:Number;
				var offsety:Number;
				
				var gInitPoint:Point = rectBox.localToGlobal(dragInitPoint);
				var lInitPont:Point = this.globalToLocal(gInitPoint);
				
				offx = this.mouseX - Math.round(lInitPont.x);
				offy = this.mouseY - Math.round(lInitPont.y);
				
				
				
				var moveBackx1:Number = dragInitPoint.x<0?((rectBox.width + dragInitPoint.x) - borderThickness):(dragInitPoint.x - borderThickness);
				var moveBackx2:Number = dragInitPoint.x<0?(-dragInitPoint.x - borderThickness):((rectBox.width - dragInitPoint.x) - borderThickness);
				
				if(offx<(restrainRect.x - lInitPont.x + moveBackx1)){
				
					offsetx = (restrainRect.x - lInitPont.x + moveBackx1);
					
				}else if(offx > (restrainRect.x + restrainRect.width - lInitPont.x - moveBackx2)){
				
					offsetx = (restrainRect.x + restrainRect.width - lInitPont.x - moveBackx2);
					
				}else{
				
					offsetx = offx;
					
				}
				
				var moveBacky1:Number = dragInitPoint.y<0?((rectBox.height + dragInitPoint.y) - borderThickness):(dragInitPoint.y - borderThickness);
				var moveBacky2:Number = dragInitPoint.y<0?(-dragInitPoint.y - borderThickness):((rectBox.height - dragInitPoint.y) - borderThickness);
				
				if(offy<(restrainRect.y - lInitPont.y + moveBacky1)){
					
					offsety = (restrainRect.y - lInitPont.y + moveBacky1);
					
				}else if(offy > (restrainRect.y + restrainRect.height - lInitPont.y - moveBacky2)){
					
					offsety = (restrainRect.y + restrainRect.height - lInitPont.y - moveBacky2);
					
				}else{
					
					offsety = offy;
					
				}
				
				newRect = new Rectangle((rect.x+offsetx),(rect.y+offsety),rect.width,rect.height);
			
			}
			
			return newRect;
		}

		
		///////////////////////////////////
		//
		//  util functions
		// 
		/////////////////////////////////////
			
		
		/**
		 * 
		 * 根据rectangle对象为Sprite画背景和边框
		 * 
		 * **/
		
		private function drawBorderAndBg(target:Sprite,rect:Rectangle,borderThickness:Number,borderColor:int,bgColor:int,alpha:Number=1.0, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String=null, joints:String=null):void{
			//宽高为正数和负数的算法不一样
			var borderThicknessw:Number = rect.width<0?-borderThickness:borderThickness;
			var borderThicknessh:Number = rect.height<0?-borderThickness:borderThickness;
			target.graphics.clear();
			target.graphics.moveTo(0,0);
			target.graphics.beginFill(bgColor,0);
			target.graphics.lineStyle(borderThickness,borderColor,1,pixelHinting,scaleMode,caps,joints);
			target.graphics.drawRect(borderThicknessw/2,borderThicknessh/2,rect.width+borderThicknessw,rect.height+borderThicknessh);
			target.graphics.endFill();
			target.x = rect.x - borderThicknessw;
			target.y = rect.y - borderThicknessh;
		}
		
		/**
		 * 
		 * 计算8个端点
		 * 
		 * **/
		
		private function calcPoints(rect:Rectangle):Array{
			
			var rectPoints:Array = new Array();
			
			rectPoints.push(new Point(rect.x,rect.y));
			rectPoints.push(new Point(Math.round(rect.x+rect.width/2),rect.y));
			rectPoints.push(new Point(rect.x+rect.width,rect.y));
			
			rectPoints.push(new Point(rect.x,rect.y+Math.round(rect.height/2)));
			rectPoints.push(new Point(rect.x+rect.width,rect.y+Math.round(rect.height/2)));
			
			rectPoints.push(new Point(rect.x,rect.y+rect.height));
			rectPoints.push(new Point(rect.x+Math.round(rect.width/2),rect.y+rect.height));
			rectPoints.push(new Point(rect.x+rect.width,rect.y+rect.height));
			
			return rectPoints;
			
		}
		
		/**
		 * 
		 * 重新计算限制框 在拖动上下左右把手时用到
		 * 
		 * **/
		
		private function recalcRestrainRect(restrainRect:Rectangle,initPoint:Point,direction:String="vertical"):Rectangle{
			
			var newRestrainRect:Rectangle;
			var vertical:Boolean = (direction == "vertical");
			
			var on:Number = vertical?restrainRect.x:restrainRect.y;
			var pn:Number = vertical?initPoint.x:initPoint.y;
			var rn:Number = vertical?restrainRect.width:restrainRect.height;
			var absn:Number;
			
			if((pn - on)/(on + rn - pn)<1){
				
				absn = Math.abs(pn - on);
				
			}else if((pn - on)/(on + rn - pn)>=1){
				
				absn = Math.abs(on + rn - pn);
				
			}

			newRestrainRect = vertical?new Rectangle(pn-absn,restrainRect.y,absn*2,restrainRect.height):new Rectangle(restrainRect.x,pn-absn,restrainRect.width,absn*2);

			return newRestrainRect;
			
		}

		
		
		/**
		 * 
		 * 获取过参照点并与斜线垂直的交点，返回受限制的交点
		 * 
		 * **/
		private function getRestrainCrossPoint(refPoint:Point,restrainRect:Rectangle):Point{
			
			var crossPoint:Point;
			var restrainCrossPoint:Point;
			var restrainRect:Rectangle;
			var rawRulePoints:Array;
			var rulePoints:Array;
			
			
			//y=ax+b and y=cx+d
			var a:Number;//斜率
			var b:Number;
			var c:Number;//斜率
			var d:Number;

			switch (activeHandleIndex){
				
				case 0:
				case 7:	
				case 2:
				case 5:
					
					if((refPoint.x>resizeInitPoint.x && refPoint.y>resizeInitPoint.y) || (refPoint.x<resizeInitPoint.x && refPoint.y<resizeInitPoint.y)){
						
						a = 1/ratio;
						c = -1/a;
						
					}else{
						
						a = -1/ratio;
						c = -1/a;
						
					}
					
					b = resizeInitPoint.y - a*resizeInitPoint.x;
					d = refPoint.y - c*refPoint.x;
					
					if(keepRatio){

						//模式1：
					 	crossPoint = new Point((d-b)/(a-c),(a*(d-b)/(a-c))+b);
				 		restrainRect = restrainRect;
						
						
						
						///*模式2：
							
						/*if(Math.abs((refPoint.x - resizeInitPoint.x)/(refPoint.y - resizeInitPoint.y))>ratio){
						
							crossPoint = new Point(Math.round((refPoint.y-b)/a),refPoint.y);
						
						}else{
						
							crossPoint = new Point(refPoint.x,Math.round(a*refPoint.x+b));
						
						}*/
						
						//模式2*/
						
						
					}else{
						
						crossPoint = refPoint;
						restrainRect = restrainRect;
						
						
					}
					
					break;
				
				case 1:
				case 6:	
					
					a = 2/ratio;
					b = resizeInitPoint.y - a*resizeInitPoint.x;
					
					crossPoint = new Point(rectPoints[1].x,refPoint.y);
					restrainRect = recalcRestrainRect(restrainRect,resizeInitPoint,"vertical");
					break;
				
				case 3:
				case 4:	
					
					a = 1/(ratio*2);
					b = resizeInitPoint.y - a*resizeInitPoint.x;
					
					crossPoint = new Point(refPoint.x,rectPoints[3].y);
					restrainRect = recalcRestrainRect(restrainRect,resizeInitPoint,"horizontal");

					break;
				
			}

			if(keepRatio){
				
				rawRulePoints = [];
				rawRulePoints.push(new Point((restrainRect.y-b)/a,restrainRect.y));
				rawRulePoints.push(new Point((restrainRect.y+restrainRect.height-b)/a,restrainRect.y+restrainRect.height));
				rawRulePoints.push(new Point(restrainRect.x,a*restrainRect.x+b));
				rawRulePoints.push(new Point(restrainRect.x+restrainRect.width,a*(restrainRect.x+restrainRect.width)+b));

				rulePoints = filterRulePoint(rawRulePoints,restrainRect);
			
			}else{
			
				rawRulePoints = [];
				rawRulePoints.push(new Point(restrainRect.x,restrainRect.y));
				rawRulePoints.push(new Point(restrainRect.x+restrainRect.width,restrainRect.y+restrainRect.height));
				
				rulePoints = filterRulePoint(rawRulePoints,restrainRect);
			
			}


			restrainCrossPoint = restrainPoint(crossPoint,rulePoints);

			return restrainCrossPoint;
			
			
		}
		
		/**
		 * 
		 * 过滤掉没有意义的限制参照点
		 * 
		 * **/
		
		private function filterRulePoint(rawRulePoints:Array,restrainRect:Rectangle):Array{
			
			var rulePoints:Array = [];
			
			for(var i:int=0; i<rawRulePoints.length; i++){
				
				var point:Point = rawRulePoints[i];
				
				if (point.x>=restrainRect.x && point.x<=restrainRect.x+restrainRect.width && point.y>=restrainRect.y && point.y<=restrainRect.y + restrainRect.height){
					
					rulePoints.push(point);
					
				}			
				
			}
			return rulePoints;
		
		}
		
		/**
		 * 
		 * 限制point对象的范围
		 * 
		 * **/
		private function restrainPoint(targetPoint:Point,rulePoints:Array):Point{

			var restrainedPoint:Point;
			
			var minx:Number = Math.round(Math.min(rulePoints[0].x,rulePoints[1].x));
			var maxx:Number = Math.round(Math.max(rulePoints[0].x,rulePoints[1].x));
			var miny:Number = Math.round(Math.min(rulePoints[0].y,rulePoints[1].y));
			var maxy:Number = Math.round(Math.max(rulePoints[0].y,rulePoints[1].y));
			
			var x:Number;
			var y:Number;
			
			if(targetPoint.x<minx){
				
				x = minx;
			
			}else if(targetPoint.x>maxx){
				
				x = maxx;
			
			}else{
				
				x = Math.round(targetPoint.x);
			}
			
			if(targetPoint.y<miny){
				
				y = miny;
				
			}else if(targetPoint.y>maxy){
				
				y = maxy;
				
			}else{
				
				y = Math.round(targetPoint.y);
			}
			
			restrainedPoint = new Point(x,y);

			return restrainedPoint;
		
		}
		
		/**
		 * 
		 * 根据两个点构造Rectangle对象
		 * 
		 * **/
		private function calcRectFromPoints(initPoint:Point,endPoint:Point):Rectangle{
			
			var rectangle:Rectangle;
			var x:Number;
			var y:Number;
			var w:Number;
			var h:Number;
			
			

			switch(activeHandleIndex){
			
				case 0:
				case 7:	
				case 2:
				case 5:
					
					x = Math.min(initPoint.x,endPoint.x);
					y = Math.min(initPoint.y,endPoint.y);
					w = Math.abs(endPoint.x - initPoint.x);
					h = Math.abs(endPoint.y - initPoint.y);
					break;
				
				case 1:
				case 6:
					
					h = Math.abs(endPoint.y - initPoint.y);
					y = Math.min(initPoint.y,endPoint.y);
					
					if(keepRatio){
						
						w = Math.abs(Math.round(h*ratio));
						x = initPoint.x - Math.round(w/2);
					
					}else{
					
						w = rect.width;
						x = rect.x;
					
					}
					break;
				
				case 3:
				case 4:
					w = Math.abs(endPoint.x - initPoint.x);
					x = Math.min(initPoint.x,endPoint.x);
					
					if(keepRatio){
						
						h = Math.abs(Math.round(w/ratio));
						y = initPoint.y - Math.round(h/2);
						
					}else{
						
						h = rect.height;
						y = rect.y;
						
					}
					break;
			
			}

			
			rectangle =  new Rectangle(x,y,w,h);
			return rectangle;
			
		}
		/////////////////////////////
		//
		//   handlers
		//
		///////////////////////////////
		
		private function onCreateComplete(e:FlexEvent):void{
			
			if(!useCustomRestrainRect) restrainRect = new Rectangle(0,0,this.width,this.height);
			
		}
		
		private function onResize(e:Event):void{
			
			if(!useCustomRestrainRect) restrainRect = new Rectangle(0,0,this.width,this.height);
		}
		
		private function onMouseDown(e:MouseEvent):void{
			
			var handle:Sprite = e.target as Sprite;
			var index:int = handles.indexOf(handle);
			
			
			if(index!=-1){

				activeHandleIndex = index;
				resizingRect = true;
				
				handleLocalOffsetX = Math.abs(Sprite(e.target).width/2) - e.localX;
				handleLocalOffsetY = Math.abs(Sprite(e.target).height/2) - e.localY;
				
				var rectPoints:Array = calcRectPoints();
				
				switch (activeHandleIndex){
					
					case 0:
						
						resizeInitPoint = rectPoints[7];
						break;
					
					case 7:
						
						resizeInitPoint = rectPoints[0];
						break;
					
					case 2:
						
						resizeInitPoint = rectPoints[5];
						break;
					
					case 5:
						
						resizeInitPoint = rectPoints[2];
						break;
					
					case 1:
						
						resizeInitPoint = rectPoints[6];
						break;
					
					case 3:
						
						resizeInitPoint = rectPoints[4];
						break;
					
					case 4:
						
						resizeInitPoint = rectPoints[3];
						break;
					
					
					
					case 6:
						
						resizeInitPoint = rectPoints[1];
						break;
				}
				
			}else if(handle == rectBox){

				movingRect = true;
				dragInitPoint = new Point(e.localX,e.localY);
			}
			
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
		}
		
		private function onMouseUp(e:MouseEvent):void{
			
			
			
			if(resizingRect){
				
				resizeInitPoint = null;
				resizeEndPoint = null;
				//activeHandleIndex = -1;
				resizingRect = false;
				
			}else if(movingRect){
				
				dragInitPoint = null;
				movingRect = false;
			}
			rectPoints = null;
			
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
		}
		
		private function onEnterFrame(e:Event):void{
			
			var newRect:Rectangle = recalcRect();
			
			updateCropper(newRect);
			
			dispatchEvent(new CropperEvent(CropperEvent.SELECTION_CHANGE,false,false,newRect));
						
		}
		
		private function onMouseMove(e:MouseEvent):void{
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		private function onStageMouseUp(e:MouseEvent):void{
			
			
			if(resizingRect){
				
				resizeInitPoint = null;
				resizeEndPoint = null;
				//activeHandleIndex = -1;
				resizingRect = false;
				
			}else if(movingRect){
				
				dragInitPoint = null;
				movingRect = false;
			}
			rectPoints = null;
			
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		

		
	}
}