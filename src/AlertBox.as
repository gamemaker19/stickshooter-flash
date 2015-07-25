package 
{
	//Imports
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

	//Class
	public class AlertBox extends Sprite {

		//Vars
		protected var box:Shape;
		protected var yesBtn:Sprite;

		//Constructor
		public function AlertBox($:Rectangle):void {

			//Initialise
			box = new Shape()
			yesBtn = new Sprite()
			addChild(box)
			addChild(yesBtn)

			//Render
			with (box.graphics) {
				lineStyle(1)
				beginFill(0, 0.4)
				drawRect($.x, $.y, $.width, $.height)
				endFill()
			}

			with (yesBtn.graphics) {
				lineStyle(1, 0x00FF00)
				beginFill(0x00FF00, 0.4)
				drawRect($.x+$.width-100, $.y$.height-40, 80, 20)
				endFill()
			}

			//Events
			yesBtn.addEventListener(MouseEvent.CLICK, yesClickHandler, false, 0, true) 
			yesBtn.addEventListener(MouseEvent.MOUSE_OVER, yesOverHandler, false, 0, true) 

		}

		//Handlers
		protected function yesClickHandler($):void { }
		protected function yesOverHandler($):void { }
		
	}

}