package objects 
{
	import starling.display.Sprite;
	
	/**
	 * This is where all germs and bullets are added.
	 * They are kept in separate sprites for easier collision detection.
	 * @author Stephen Oppong Beduh
	 */
	public class Layer extends Sprite 
	{
		/**
		 * Germs should be added to this sprite.
		 */
		public var germs:Sprite;
		/**
		 * Bullets should be added to this sprite
		 */
		public var bullets:Sprite;
		
		public var powerups:Sprite;
		
		public function Layer() 
		{
			super();
			germs = new Sprite();
			bullets = new Sprite();
			powerups = new Sprite();
			addChild(powerups);
			addChild(germs);
			addChild(bullets);
			touchable = false;
		}
		
	}

}