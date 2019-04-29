package objects.germs 
{
	import flash.geom.Rectangle;
	/**
	 * 
	 * The third basic enemy type. 
	 * It waves up and down in larger curves than GermTwo.
	 * @author Stephen Oppong Beduh
	 */
	public class GermFour extends AbstractGerm 
	{
		
		public function GermFour(x:Number, y:Number, speed:Number = 1) 
		{
			super(x, y, Assets.Manager.getTextures("germFour_"), 60);
			_speed = speed;
			_type = Utility.GERM_FOUR;
			_score = 1000;
			_meter = 0.12;
		}
		
		override protected function move(passedTime:Number):void 
		{
			this.x -= _speed * Utility.SPEED_FACTOR * passedTime;
		}
		
		override public function playSound():void 
		{
			Assets.SoundEffects.playSound("germFourHit");
		}
		
		override public function get bounds():Rectangle 
		{
			var rect:Rectangle = new Rectangle(this.x - _graphic.width / 2, this.y - _graphic.height / 2, _graphic.width * 0.9, _graphic.height * 0.9);
			return rect;
		}
		
	}

}