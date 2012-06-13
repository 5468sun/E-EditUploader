// 某人的作品，使用了不同的算法。

package sxf.utils.line
{
	import mx.core.UIComponent;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Point;
	
	public class AntLine2 extends UIComponent
	{
		private const antLineTimerDelay:Number = 50;
		
		/* ****************** Constructor  ***************** */
		/* ************************************************* */
		public function AntLine2()
		{
			super();
			antLineTimer = new Timer(antLineTimerDelay);
			antLineTimer.addEventListener(TimerEvent.TIMER,antTravel);
			g = this.graphics;
		}
		/* ******************   Fields  ******************** */
		/* ************************************************* */
		private var antLineTimer:Timer;
		
		private var gap:Number = 0;
		
		private var g:Graphics;
		
		private var size:Size;
		
		private var tail:Number = 0;
		
		private var xCoe:Number = 1;
		
		private var yCoe:Number = 1;
		
		private var antLength:Number = 4;
		private var initAntLength:Number = 10;
		
		private var antGap:Number = 4;
		private var initAntGap:Number = 10;
		
		/*------------- Change  parameters  below -------------------*/
		public var lineThickness:Number = 1;
		public var lineColor:Number = 0x000000;//0xc63030;// 0x75b924; 
		public var lineAlpha:Number = 1.0;
		
		public var caps:String = CapsStyle.NONE;
		
		public var joint:String = JointStyle.ROUND;
		/*--------------  Change  parameters  above --------------*/
		
		/* **************** EventHandler  ****************** */
		/* ************************************************* */
		private function antTravel(e:TimerEvent):void
		{
			
			reDraw();
			gap +=  2;
			if (gap >= antLength + antGap)
			{
				gap = 0;
			}
		}
		
		private function reDraw():void
		{
			g.clear();
			g.lineStyle(lineThickness,lineColor,lineAlpha,false,"normal",caps,joint);
			xCoe = size.width < 0 ? -1:1;
			yCoe = size.height < 0 ? -1:1;
			drawTop();
			drawRight();
			drawBottom();
			drawLeft();
		}
		private function drawTop():void
		{
			
			if (antLength + antGap > Math.abs(size.width))
			{
				g.moveTo(0,0);
				g.lineTo(size.width,0);
				return;
			}
			
			var i:int = 0;
			while (true)
			{
				var offset:Number =  ( gap+ i*(antLength+antGap) );
				with (Math)
				{
					if (offset + antLength + antGap > abs(size.width))
					{
						
						if (offset + antLength > abs(size.width))
						{
							g.moveTo(offset*xCoe,0);
							g.lineTo(size.width,0);
							g.moveTo(size.width,0);
							g.lineTo(size.width, (offset+antLength- abs(size.width))*yCoe);
						}
						else
						{
							g.moveTo(offset*xCoe,0);
							g.lineTo((offset+antLength)*xCoe,0);
						}
						tail = offset + antLength + antGap - abs(size.width);
						return;
					}
					g.moveTo( offset*xCoe,0);
					g.lineTo( (offset+antLength)*xCoe,0);
					i++;
				}
			}
		}
		private function drawRight():void
		{
			
			var i:int = 0;
			if (antLength + antGap >  Math.abs(size.height))
			{
				g.moveTo(size.width,0);
				g.lineTo(size.width,size.height);
				return;
			}
			
			while (true)
			{
				var offset:Number = tail+i*(antLength+antGap);
				with (Math)
				{
					if (offset + antLength + antGap > abs(size.height))
					{
						if (offset + antLength > abs(size.height))
						{
							g.moveTo(size.width,offset*yCoe);
							g.lineTo(size.width,size.height);
							g.moveTo(size.width,size.height);
							g.lineTo(size.width- (offset+antLength- abs(size.height) )*xCoe ,size.height);
						}
						else
						{
							g.moveTo(size.width,offset*yCoe);
							g.lineTo(size.width, (offset+antLength)*yCoe );
						}
						tail = offset + antLength + antGap - abs(size.height);
						return;
					}
					g.moveTo(size.width,offset*yCoe);
					g.lineTo(size.width, (offset+antLength)*yCoe );
					i++;
				}
			}
		}
		private function drawBottom():void
		{
			if (antLength + antGap >  Math.abs(size.width))
			{
				g.moveTo(size.width,size.height);
				g.lineTo(0,size.height);
				return;
			}
			var i:int = 0;
			while (true)
			{
				var offset:Number = tail+i*(antLength+antGap);
				with (Math)
				{
					
					
					if (offset + antLength + antGap > abs(size.width))
					{
						if (offset + antLength > abs(size.width))
						{
							g.moveTo(size.width-offset*xCoe,size.height);
							g.lineTo(0,size.height);
							g.moveTo(0,size.height);
							g.lineTo(0,size.height- (offset+antLength- abs(size.width) )*yCoe );
						}
						else
						{
							g.moveTo(size.width-offset*xCoe,size.height);
							g.lineTo(size.width - (offset+antLength)*xCoe,size.height);
							
						}
						tail = offset + antLength + antGap - abs(size.width);
						return;
					}
					g.moveTo(size.width-offset*xCoe,size.height);
					g.lineTo(size.width - (offset+antLength)*xCoe,size.height);
					i++;
				}
			}
		}
		private function drawLeft():void
		{
			if (antLength + antGap >  Math.abs(size.height))
			{
				g.moveTo(0,0);
				g.lineTo(0,size.height);
				return;
			}
			
			var i:int = 0;
			while (true)
			{
				var offset:Number = tail+i*(antLength+antGap);
				with (Math)
				{
					
					
					if (offset + antLength + antGap > abs(size.height))
					{
						if (offset + antLength > abs(size.height))
						{
							g.moveTo(0,size.height - offset*yCoe);
							g.lineTo(0,0);
							g.moveTo(0,0);
							g.lineTo( (offset+antLength- abs(size.height))*xCoe, 0);
						}
						else
						{
							g.moveTo(0,size.height -offset*yCoe);
							g.lineTo(0,size.height - (offset+antLength)*yCoe );
							
						}
						tail = offset + antLength + antGap - abs(size.height);
						return;
					}
					g.moveTo(0,size.height -offset*yCoe);
					g.lineTo(0,size.height - (offset+antLength)*yCoe );
					i++;
				}
			}
		}
		
		/* *******************  Communication ******************** */
		/* ******************************************************* */
		/**
		 * 调用这个方法更改矩形的宽高
		 */
		public function setSize(w:Number,h:Number):void
		{
			size = new Size(w,h);
			
			if (! isRunning())
			{
				reDraw();
			}
		}
		public function start():void
		{
			antLineTimer.start();
		}
		public function stop():void
		{
			antLineTimer.stop();
		}
		public function isRunning():Boolean
		{
			return antLineTimer.running;
		}
	}
}

class Size{
	public function Size(_w:Number=0,_h:Number=0)
	{
		width = _w;
		height = _h;
	}
	public var width:Number;
	public var height:Number;
}