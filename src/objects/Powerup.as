package objects 
{
	import objects.fireworks.Fireworks;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.utils.deg2rad;
	/**
	 * A powerup with 3 faces, which can clear all enemies, offer a quiz 
	 * question or cause the player damage.
	 * @author Stephen Oppong Beduh
	 */
	public class Powerup extends AbstractObject 
	{
		private var _graphic:MovieClip;
		private var _yDir:int;
		private var _spinning:Boolean;
		private var _angle:Number;
		
		/**
		 * Hit all the germs onscreen in one go.
		 */
		public static const CLEAR_SCREEN:	String = "clear-screen";
		/**
		 * The player is given a multiple choice question.
		 * If answered correctly, screen is cleared.
		 * If not, player takes one point of damage.
		 */
		public static const QUESTION:		String = "question";
		/**
		 * Player takes one point of damage.
		 */
		public static const DAMAGE:			String = "damage";
		/**
		 * The player's meter is instantly maxed out.
		 */
		public static const METER:			String = "meter";
		
		public function Powerup(x:Number, y:Number) 
		{
			super(x, y);
			createGraphic();
			pivotX = _graphic.width / 2;
			pivotY = _graphic.height / 2;
			_yDir = Math.random() > 0.5 ? 1 : -1;
			_spinning = false;
			_angle = 0;
		}
		
		private function createGraphic():void 
		{
			_graphic = new MovieClip(Assets.Manager.getTextures("powerup_"), 2);
			Starling.juggler.add(_graphic);
			//_graphic.currentFrame = 1;
			addChild(_graphic);
		}
		
		public function vanish():void
		{
			_spinning = true;
			_graphic.pause();
		}
		
		override public function update(passedTime:Number):void 
		{
			if (_spinning) 
			{
				this.rotation += Math.cos(deg2rad(_angle)) * 0.2;
				this.scaleX = this.scaleY -= passedTime * 1.4;
				_angle += passedTime;
			} else {
				this.x -= passedTime * 50;
				this.y += passedTime * 50 * _yDir;
			}
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			super.reset(x, y);
			scaleX = scaleY = 1;
			_yDir = Math.random() > 0.5 ? 1 : -1;
			_spinning = false;
			_angle = this.rotation = 0;
			_graphic.currentFrame = 0;
			_graphic.play();
		}
		
		public function get value():String
		{
			switch (_graphic.currentFrame) 
			{
				case 0:
					return CLEAR_SCREEN;
				break;
				case 1:
					return QUESTION;
				break;
				case 2:			// In case anything goes wrong, just damage the player.
					return DAMAGE;
				break;
				case 3:
					return METER;
				break;
				default:
					return null;
			}
		}
		
		public function get yDir():int 
		{
			return _yDir;
		}
		
		public function set yDir(value:int):void 
		{
			_yDir = value;
		}
		
		public function get spinning():Boolean 
		{
			return _spinning;
		}
		
		public function set spinning(value:Boolean):void 
		{
			_spinning = value;
		}
		
	}

}