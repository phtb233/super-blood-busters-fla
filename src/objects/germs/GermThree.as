package objects.germs 
{
	import starling.display.Quad;
	
	/**
	 * 
	 * The third basic enemy type. 
	 * It waves up and down in larger curves than GermTwo.
	 * @author Stephen Oppong Beduh
	 */
	public class GermThree extends AbstractGerm 
	{
		private var _angle:Number;
		
		public function GermThree(x:Number, y:Number, speed:Number = 2) 
		{
			super(x, y, Assets.Manager.getTextures("germThree_"), 24);
			_speed = speed;
			_type = Utility.GERM_THREE;
			_angle = 0;
			_score = 400;
			_meter = 0.09;
		}
		
		override protected function createGraphic():void 
		{
			super.createGraphic();
			_graphic.scaleX = _graphic.scaleY = 0.35;
		}
		
		override protected function move(passedTime:Number):void 
		{
			_angle += passedTime * 1.3;
			var theta:Number = Math.cos(_angle) * 0.7;
			this.rotation = theta * 0.5;
			this.x -= _speed * passedTime * Utility.SPEED_FACTOR;
			this.y += -theta * 1.8;
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			super.reset(x, y);
		}
		
		override public function playSound():void 
		{
			Assets.SoundEffects.playSound("germThreeHit");
		}
		
	}

}