package objects.stars 
{
	import objects.AbstractObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.deg2rad;
	/**
	 * A star in the starfield, that flies outward, towards the edges of the screen.
	 * @author Stephen Oppong Beduh
	 */
	public class Star extends AbstractObject 
	{
		private var _theta:Number;
		private var _rotation:int;
		private var _graphic:Quad;
		
		public function Star(x:Number, y:Number) 
		{
			super(x, y);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_graphic = new Quad(1, 6);
			addChild(_graphic);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		/**
		 * Set up the star's position, at the centre of the screen.
		 */
		private function init():void 
		{
			this.x = stage.stageWidth / 2;
			this.y = stage.stageHeight / 2;
			this.alpha = 0;
			this.scaleX = this.scaleY = 0;
			this.rotation = Math.random() * 360;
			_speed = (Math.random() * 5) + 5;
			_theta = this.rotation;
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			init();
		}
		
		override public function update(passedTime:Number):void 
		{
			this.x += Math.sin(_theta) * _speed;
			this.y += -Math.cos(_theta) * _speed;
			
			scaleX = scaleY += _speed / 100;
			this.alpha += _speed / 300;
		}
		
	}

}