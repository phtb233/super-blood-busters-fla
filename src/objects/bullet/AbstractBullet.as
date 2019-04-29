package objects.bullet 
{
	import flash.geom.Rectangle;
	import objects.AbstractObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.MovieClip;
	import starling.core.Starling;
	
	/**
	 * Main game ammunition.
	 * @author Stephen Oppong Beduh
	 */
	public class AbstractBullet extends AbstractObject
	{
		private var _graphic:MovieClip;
		/**
		 * Track which layer the bullet is in, to prevent needless updating.
		 */
		protected var _depth:String;
		public static const LAYER_ONE:String = "one";
		public static const LAYER_TWO:String = "two";
		public static const LAYER_THREE:String = "three";
		public static const LAYER_FOUR:String = "four";
			
		public function AbstractBullet(x:Number, y:Number, graphic:MovieClip) 
		{
			super(x, y);
			depth = LAYER_ONE;
			_graphic = graphic;
			//_graphic = new MovieClip(Assets.Manager.getTexture("bullet/"), 60);
			pivotX = _graphic.width / 2;
			pivotY = _graphic.height / 2;
			Starling.juggler.add(_graphic);
			addChild(_graphic);
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			this.scaleX = this.scaleY = 1;
			depth = LAYER_ONE;
			super.reset(x, y);
			_graphic.stop(); _graphic.play();
		}
		
		public function get depth():String 
		{
			return _depth;
		}
		
		/**
		 * Use one of the class constants, or "one" "two" "three" or "four".
		 */
		public function set depth(value:String):void 
		{
			_depth = value;
		}

		override public function set scaleX(value:Number):void 
		{
			super.scaleX = value;
		}
		
		override public function set scaleY(value:Number):void 
		{
			super.scaleY = value;
		}
		
		override public function get bounds():Rectangle
		{
			var rect:Rectangle = new Rectangle(this.x, this.y, _graphic.width * this.scaleX, _graphic.height * this.scaleY);
			return rect;
		}
		
	}

}