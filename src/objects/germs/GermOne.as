package objects.germs 
{
	import starling.display.Quad;
	import objects.AbstractObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.MovieClip;
	import starling.core.Starling;
	
	/**
	 * Main game ammunition.
	 * @author Stephen Oppong Beduh
	 */
	public class GermOne extends AbstractGerm
	{
		/**
		 * Track which layer the bullet is in, to prevent needless updating.
		 */
		public function GermOne(x:Number, y:Number, speed:Number = 5) 
		{
			super(x, y, Assets.Manager.getTextures("germOne_"), 20);
			_speed = speed;
			_type = Utility.GERM_ONE;
			_score = 100;
			_meter = 0.03;
		}
		
		override protected function move(passedTime:Number):void 
		{
			this.x -= _speed * Utility.SPEED_FACTOR * passedTime;
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			super.reset(x, y);
		}
		
		override public function playSound():void 
		{
			Assets.SoundEffects.playSound("germOneHit");
		}
	}

}