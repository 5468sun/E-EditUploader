////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011-2012 5468sun
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package sxf.utils.line
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	public class AntLine extends UIComponent{
		private var rect:Rectangle = new Rectangle(0,0,0,0);
		
		
		
		private var gap1:int;
		private var gap2:int;
		private var gap:int;
		
		private var color1:int;
		private var color2:int;
		
		private var thickness:int;
		
		private var interval:Number = 100;
		
		
		private var initColorFlag:Boolean = true;
		private var InitColorChangeFlag:Boolean = false;
		private var scaleMode:String = LineScaleMode.NORMAL;//LineScaleMode.NORMAL、LineScaleMode.NONE、LineScaleMode.VERTICAL
		private var caps:String = CapsStyle.SQUARE;//CapsStyle.NONE、CapsStyle.ROUND、CapsStyle.SQUARE
		private var joints:String = JointStyle.MITER;//JointStyle.BEVEL、JointStyle.MITER 、JointStyle.ROUND
		
		private var timer:Timer;
		
		/**
		 * Constructor.
		 * 
		 * @param gap1 蚂蚁线段1的长度，整数
		 * @param gap2 蚂蚁线段2的长度，整数
		 * @param color1 蚂蚁线段1的颜色，整数
		 * @param color2 蚂蚁线段2的颜色，整数
		 * @param thickness 蚂蚁线的粗细，整数
		 * 
		 * **/
		public function AntLine(gap1:int=4,gap2:int=4,color1:int=0x000000,color2:int=0xffffff,thickness:int=1)
		{
			super();
			
			this.gap1 = gap1;
			this.gap2 = gap2;
			this.color1 = color1;
			this.color2 = color2;
			this.thickness = thickness;
			
			timer = new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			
			addEventListener(Event.ADDED,addedHandler);
			addEventListener(Event.REMOVED,removededHandler);
			
		}
		/**
		 * 
		 * 更新蚂蚁线，一般在MouseEvent.MOUSE_MOVE事件或Event.ENTER_FRAME事件中调用。
		 * @param rect 绘制蚂蚁线所需要的数据，以Rectangle的形式传递。
		 * 
		 * **/
		public function update(rect:Rectangle):void{
			
			this.rect = rect;
			//trace(rect);
			
		}
			
		private function draw(offset:Number):void{
			this.graphics.clear();
			drawLB(offset);
			drawTR(offset);
			
		}
		private function drawTR(offset:Number):void{
			
			var lineLen:int = 0;
			var flag:Boolean = initColorFlag;
			var graphics:Graphics = this.graphics;
			
			var rect_x:Number = rect.x - (rect.width>0?thickness/2:-thickness/2);
			var rect_y:Number = rect.y - (rect.height>0?thickness/2:-thickness/2);
			var rect_w:Number = rect.width + (rect.width>0?thickness:-thickness);
			var rect_h:Number = rect.height + (rect.height>0?thickness:-thickness);
			
			var rect_absw:Number = Math.abs(rect_w);
			var rect_absh:Number = Math.abs(rect_h);
			
			graphics.moveTo(rect_x,rect_y);
			graphics.lineStyle(thickness,flag?color1:color2,1,true,scaleMode,caps,joints);
			
			graphics.lineTo(rect_x+(rect.width>0?offset:-offset),rect_y);
			
			lineLen += offset;
			flag = !flag;
			
			while(lineLen<=(rect_absw+rect_absh)){
				
				graphics.lineStyle(thickness,flag?color1:color2,1,true,scaleMode,caps,joints);
				gap = flag?gap1:gap2;
				var targetLineLen:Number;
				
				if(lineLen<rect_absw && lineLen+gap<=rect_absw){
					
					targetLineLen = rect.width>0?(lineLen+gap):-(lineLen+gap);
					
					graphics.lineTo(rect_x+targetLineLen,rect_y);
					
				}
					
				else if(lineLen<rect_absw && lineLen+gap>rect_absw){
					
					targetLineLen = rect.height>0?(lineLen+gap-rect_absw):-(lineLen+gap-rect_absw);
					
					graphics.lineTo(rect_x+rect_w,rect_y);
					graphics.lineTo(rect_x+rect_w,rect_y+targetLineLen);
					
				}
				else if(lineLen>=rect_absw && lineLen+gap<=(rect_absw+rect_absh)){
					
					targetLineLen = rect.height>0?(lineLen+gap-rect_absw):-(lineLen+gap-rect_absw);
					
					graphics.lineTo(rect_x+rect_w,rect_y+targetLineLen);
					
					
				}
				else if(lineLen>=rect_absw && lineLen+gap>(rect_absw+rect_absh)){
					
					graphics.lineTo(rect_x+rect_w,rect_y+rect_h);
					
				}
				
				lineLen += gap;
				flag = !flag;
				
			}
		}
		private function drawLB(offset:Number):void{
					
			var lineLen:int = 0;
			var flag:Boolean = initColorFlag;
			var graphics:Graphics = this.graphics;
			
			var rect_x:Number = rect.x - (rect.width>0?thickness/2:-thickness/2);
			var rect_y:Number = rect.y - (rect.height>0?thickness/2:-thickness/2);
			var rect_w:Number = rect.width + (rect.width>0?thickness:-thickness);
			var rect_h:Number = rect.height + (rect.height>0?thickness:-thickness);
			
			var rect_absw:Number = Math.abs(rect_w);
			var rect_absh:Number = Math.abs(rect_h);
			
			graphics.moveTo(rect_x,rect_y);
			graphics.lineStyle(thickness,flag?color1:color2,1,true,scaleMode,caps,joints);
			graphics.lineTo(rect_x,rect_y+(rect.height>0?offset:-offset));
			
			lineLen += offset;
			flag = !flag;
			
			while(lineLen<=(rect_absw+rect_absh)){
				graphics.lineStyle(thickness,flag?color1:color2,1,true,scaleMode,caps,joints);
				gap = flag?gap1:gap2;
				var targetLineLen:Number;
				
				
				
				if(lineLen<rect_absh && lineLen+gap<=rect_absh){
					
					targetLineLen = rect.height>0?(lineLen+gap):-(lineLen+gap);
					graphics.lineTo(rect_x,rect_y+targetLineLen);
					
				}
				else if(lineLen<rect_absh && lineLen+gap>rect_absh){
					
					targetLineLen = rect.width>0?(lineLen+gap-rect_absh):-(lineLen+gap-rect_absh);
					
					graphics.lineTo(rect_x,rect_y+rect_h);
					
					graphics.lineTo(rect_x+targetLineLen,rect_y+rect_h);
					
					
				}
				else if(lineLen>=rect_absh && lineLen+gap<=(rect_absw+rect_absh)){
					
					targetLineLen = rect.width>0?(lineLen+gap-rect_absh):-(lineLen+gap-rect_absh);
					graphics.lineTo(rect_x+targetLineLen,rect_y+rect_h);

				}
				else if(lineLen>=rect_absh && lineLen+gap>(rect_absw+rect_absh)){
					
					graphics.lineTo(rect_x+rect_w,rect_y+rect_h);
					
				}
				
				lineLen += gap;
				flag = !flag;
				
			}
		}
		
		
		private function timerHandler(e:TimerEvent):void{
			if(rect.width == 0 || rect.height == 0){
				this.graphics.clear();
				return;
			}
			var timer:Timer = e.target as Timer;
			var count:Number = timer.currentCount;
			
			var offset1:Number = (count-1)%(gap1+gap2)+1;
			
			if(InitColorChangeFlag){
				
				InitColorChangeFlag = false;
				initColorFlag = !initColorFlag;
			} 
			
			if(offset1 == gap1 || offset1 == (gap1+gap2) ) InitColorChangeFlag = true;
			
			var offset2:Number = (offset1-1)%gap1 + 1;
			

			draw(offset2);
		}
		
		private function addedHandler(e:Event):void{
		
			timer.start();
			
		}
		private function removededHandler(e:Event):void{
			
			timer.stop();
			
		}
		
	}
}