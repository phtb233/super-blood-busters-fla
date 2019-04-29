package objects.bullet 
{
	import starling.display.*;
	
	/**
	 * Main game ammunition.
	 * @author Stephen Oppong Beduh
	 */
	public class Bullet extends AbstractBullet
	{
		/**
		 * Track which layer the bullet is in, to prevent needless updating.
		 */
			
		public function Bullet(x:Number, y:Number) 
		{
			super(x, y, new MovieClip(Assets.Manager.getTextures("bullet/"), 60));
		}
		
		override public function update(passedTime:Number):void
		{
			if (scaleX > 0) 
			{
				scaleX = scaleY -= passedTime / 2;
			}
		}
		
	}

}