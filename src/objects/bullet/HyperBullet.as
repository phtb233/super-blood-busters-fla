package objects.bullet 
{
	import starling.display.*;
	
	/**
	 * Main game ammunition.
	 * @author Stephen Oppong Beduh
	 */
	public class HyperBullet extends AbstractBullet
	{
		public function HyperBullet(x:Number, y:Number) 
		{
			super(x, y, new MovieClip(Assets.Manager.getTextures("redBullet_"), 60));
		}
		
		
		override public function update(passedTime:Number):void
		{
			if (scaleX > 0) 
			{
				scaleX = scaleY -= passedTime * 2;
			}
		}
		
	}

}