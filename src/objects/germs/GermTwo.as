package objects.germs 
{
	import starling.display.Quad;
	import starling.textures.Texture;
	/**
	 * The second basic enemy, that bobs up and down.
	 * @author Stephen Oppong Beduh
	 */
	public class GermTwo extends AbstractGerm 
	{
		private var _angle:Number;
		
		public function GermTwo(x:Number, y:Number, speed:Number = 3) 
		{
			super(x, y, Assets.Manager.getTextures("germTwo_"), 20);
			_angle = 0;
			_type = Utility.GERM_TWO;
			_speed = speed;
			_score = 200;
			_meter = 0.06;
		}
		
		override protected function move(passedTime:Number):void 
		{
			_angle += passedTime;
			var theta:Number = Math.cos(_angle) * 0.5;
			this.rotation = theta;
			this.x -= _speed * passedTime * Utility.SPEED_FACTOR;
			this.y += -theta
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			super.reset(x, y);
		}
		
		override public function playSound():void 
		{
			Assets.SoundEffects.playSound("germTwoHit");
		}
	}

}