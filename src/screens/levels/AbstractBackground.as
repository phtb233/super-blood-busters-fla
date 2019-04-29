package screens.levels 
{
	import objects.AbstractObject;
	import starling.display.*;
	import starling.textures.Texture;
	
	/**
	 * Abstract class for game backgrounds.
	 * @author Stephen Oppong Beduh
	 */
	public class AbstractBackground extends AbstractObject 
	{
		
		public function AbstractBackground() 
		{
			super(0, 0);
			
		}
		
		/**
		 * Combine two copies of the same texture, and place them side by side to make a sprite.
		 * @param	texture		The texture to double and place side by side.
		 * @return				The sprite with the doubled texture.	
		 */
		protected function createParallaxSprite(texture:Texture, fixSplit:Boolean = false):Sprite
		{
			var sprite:Sprite = new Sprite();
			var img1:Image = new Image(texture);
			var img2:Image = new Image(texture);
			sprite.addChild(img1);
			sprite.addChild(img2);
			if (!fixSplit) 
			{
				img2.x = img2.width;
			} else 
			{
				img2.x = img2.width - 1;
			}
			
			return sprite;
		}
		
		protected function moveParallaxSprite(sprite:Sprite, speed:Number, passedTime:Number):void
		{
			if (sprite.numChildren < 1) 
			{
				throw new Error("Parallax Sprites need at least one child image.");
			}
			//var img:DisplayObject = sprite.getChildAt(1);
			var amount:Number = passedTime * speed;
			sprite.x += amount;
			if (sprite.x + amount >= 0) 
			{
				sprite.x = -sprite.getChildAt(1).width;
			}
		}
	}

}