package sxf.utils.line
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class AntLineRectSelector extends UIComponent{
		
		private var _rect:Rectangle;
		
		private var defaultRestrainRect:Rectangle;
		private var customRestrainRect:Rectangle;
		private var _useCustomRestrainRect:Boolean = false;
		
		private var _keepRatio:Boolean = false;
		private var _ratio:Number; // abs(x/y)
		
		private var antLineRectBox:AntLine;
		
		private var mouseHeldDown:Boolean = false;
		
		private var initPoint:Point;
		private var endPoint:Point;
		
		
		public function AntLineRectSelector(restrainRect:Rectangle = null){
			
			super();
			
			if(restrainRect){
				
				useCustomRestrainRect = true;
				this.restrainRect = restrainRect;
				
			}//else, set restrainRect to (0,0,this.width,this.height) when creationComplete
			
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			
			
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
			addEventListener(Event.RESIZE,onResize);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseShowMousePosition);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseShowMousePositionEnd);
			
		}
		
		public function get rect():Rectangle{
		
			return _rect;
		
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
		 * 获取、设置比例
		 * 
		 * **/
		
		public function get ratio():Number{
			
			return _ratio;
			
		}
		
		public function set ratio(value:Number):void{
			
			_ratio = value;
			
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
			
		}
		
		/**
		 * 
		 * create antLine Rect
		 * 
		 * **/
		
		private function createAntLineRect():void{

			antLineRectBox = new AntLine();
			addChild(antLineRectBox);
		
		}
		
		private function drawBg():void{
			
			this.graphics.clear();
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
			
		}
		
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
			
			
			if((refPoint.x>initPoint.x && refPoint.y>initPoint.y) || (refPoint.x<initPoint.x && refPoint.y<initPoint.y)){
				
				a = 1/ratio;
				c = -1/a;
				
			}else{
				
				a = -1/ratio;
				c = -1/a;
				
			}
			
			b = initPoint.y - a*initPoint.x;
			d = refPoint.y - c*refPoint.x;
			
			if(keepRatio){
				
				//模式1：
				crossPoint = new Point((d-b)/(a-c),(a*(d-b)/(a-c))+b);
				
				
				
				
				/*模式2：
				
				if(Math.abs((refPoint.x - initPoint.x)/(refPoint.y - initPoint.y))>ratio){
				
				crossPoint = new Point(Math.round((refPoint.y-b)/a),refPoint.y);
				
				}else{
				
				crossPoint = new Point(refPoint.x,Math.round(a*refPoint.x+b));
				
				}
				
				模式2*/
				
				
				rawRulePoints = [];
				rawRulePoints.push(new Point((restrainRect.y-b)/a,restrainRect.y));
				rawRulePoints.push(new Point((restrainRect.y+restrainRect.height-b)/a,restrainRect.y+restrainRect.height));
				rawRulePoints.push(new Point(restrainRect.x,a*restrainRect.x+b));
				rawRulePoints.push(new Point(restrainRect.x+restrainRect.width,a*(restrainRect.x+restrainRect.width)+b));
				
				rulePoints = filterRulePoint(rawRulePoints,restrainRect);
				
				
			}else{
				
				crossPoint = refPoint;
				
				rawRulePoints = [];
				rawRulePoints.push(new Point(restrainRect.x,restrainRect.y));
				rawRulePoints.push(new Point(restrainRect.x+restrainRect.width,restrainRect.y+restrainRect.height));
				
				rulePoints = filterRulePoint(rawRulePoints,restrainRect);

			}
			
			restrainRect = restrainRect;
			


			
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
		
		
		private function restrainInitPoint(initPoint:Point,restrainRect:Rectangle):Point{
		
			var newPoint:Point;
			var x:Number;
			var y:Number;
			
			if(initPoint.x<restrainRect.x){
				
				x = restrainRect.x;
				
			}else if(initPoint.x>restrainRect.x+restrainRect.width){
				
				x = restrainRect.x+restrainRect.width;
				
			}else{
				
				x = initPoint.x;
			
			}
			
			if(initPoint.y<restrainRect.y){
				
				y = restrainRect.y;
				
			}else if(initPoint.y>restrainRect.y+restrainRect.height){
				
				y = restrainRect.y+restrainRect.height;
				
			}else{
				
				y = initPoint.y;
				
			}
			
			newPoint = new Point(x,y);
			return newPoint;
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
			
			
			
			x = Math.min(initPoint.x,endPoint.x);
			y = Math.min(initPoint.y,endPoint.y);
			w = Math.abs(endPoint.x - initPoint.x);
			h = Math.abs(endPoint.y - initPoint.y);
			
			
			rectangle =  new Rectangle(x,y,w,h);
			return rectangle;
			
		}
		
		/////////////////////////////
		//
		//   handlers
		//
		///////////////////////////////
		
		private function onCreateComplete(e:FlexEvent):void{
			
			drawBg();
			if(!useCustomRestrainRect) restrainRect = new Rectangle(0,0,this.width,this.height);
			
			
			
		}
		
		private function onResize(e:Event):void{
			
			drawBg();
			if(!useCustomRestrainRect) restrainRect = new Rectangle(0,0,this.width,this.height);

		}
		
		private function onMouseDown(e:MouseEvent):void{
			
			trace("antline mouse down");
			createAntLineRect();
			
			mouseHeldDown = true;
			initPoint = restrainInitPoint(new Point(e.localX,e.localY),restrainRect);
			
			
			dragBegin();
			
			
		}
		
		private function onMouseUp(e:MouseEvent):void{
			
			dragFinish();
			
		}
		
		private function onEnterFrame(e:Event):void{
			
			dragproccess();

		}
		
		private function onMouseMove(e:MouseEvent):void{
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		

		private function onStageMouseUp(e:MouseEvent):void{
			
			dragFinish();
			
		}
		
		private function onMouseShowMousePosition(e:MouseEvent):void{
		
			trace(e.localX +"|"+ e.localY);
			var initPoint:Point = new Point(e.localX,e.localY);
			dispatchEvent(new AntLineRectSelectorEvent(AntLineRectSelectorEvent.INIT,false,false,initPoint));
		
		}
		private function onMouseShowMousePositionEnd(e:MouseEvent):void{
		
			dispatchEvent(new AntLineRectSelectorEvent(AntLineRectSelectorEvent.INIT_END,false,false));
		
		}
		private function dragBegin():void{
			trace("ant line drag begin");
			removeEventListener(MouseEvent.MOUSE_MOVE,onMouseShowMousePosition);
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			var mousePoint:Point = new Point(this.mouseX,this.mouseY);
			endPoint = getRestrainCrossPoint(mousePoint,restrainRect);
			rect = calcRectFromPoints(initPoint,endPoint);
			trace(rect);
			dispatchEvent(new AntLineRectSelectorEvent(AntLineRectSelectorEvent.BEGIN,false,false,initPoint,endPoint,rect));
		
		}
		
		private function dragproccess():void{
			
			var mousePoint:Point = new Point(this.mouseX,this.mouseY);
			endPoint = getRestrainCrossPoint(mousePoint,restrainRect);
			rect = calcRectFromPoints(initPoint,endPoint);
			trace(rect);
			antLineRectBox.update(rect);
			dispatchEvent(new AntLineRectSelectorEvent(AntLineRectSelectorEvent.PROCCESS,false,false,initPoint,endPoint,rect));
			
		}
		
		private function dragFinish():void{
			
			if(mouseHeldDown){
				removeChild(antLineRectBox);
				mouseHeldDown = false;
				endPoint = null;

				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				addEventListener(MouseEvent.MOUSE_MOVE,onMouseShowMousePosition);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
				
				if(rect.width ==0 && rect.height ==0){
					
					dispatchEvent(new AntLineRectSelectorEvent(AntLineRectSelectorEvent.CANCEL,false,false,initPoint,endPoint,rect));
					
				}else{
					
					dispatchEvent(new AntLineRectSelectorEvent(AntLineRectSelectorEvent.FINISH,false,false,initPoint,endPoint,rect));
					
				}
			}
			
		
		}
	}
}