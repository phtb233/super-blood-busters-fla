package  
{
	import flash.utils.getQualifiedClassName;
	import starling.display.*;
	import starling.textures.Texture;
	/**
	 * Static class that contains useful properties for instantiating objects etc.
	 * @author Stephen Oppong Beduh
	 */
	public class Utility 
	{
		public static const BULLET:			String = 		"objects.bullet::Bullet";
		public static const HYPER_BULLET:	String = 		"objects.bullet::HyperBullet";
		public static const GERM_ONE:		String = 		"objects.germs::GermOne";
		public static const GERM_TWO:		String = 		"objects.germs::GermTwo";
		public static const GERM_THREE:		String = 		"objects.germs::GermThree";
		public static const GERM_FOUR:		String = 		"objects.germs::GermFour";
		public static const POWERUP:        String = 		"objects::Powerup";
		
		public static const FIREWORKS:      String =        "objects.fireworks::Fireworks";
		
		public static const FLASH:          String = 		"screens.subscreens::Flash";
		
		public static const STAR:			String = 		"objects.stars::Star";
		public static const SPARK:          String = 		"objects.fireworks::Spark";
		
		public static const BACKGROUND_ONE:		 String =  		"screens.levels::BackgroundOne";
		public static const BACKGROUND_TWO:		 String =  		"screens.levels::BackgroundTwo";
		public static const BACKGROUND_THREE: 	 String =  		"screens.levels::BackgroundThree";
		public static const BACKGROUND_FOUR: 	 String =  		"screens.levels::BackgroundFour";
		
		public static const HYPER_MODE:          String =       "screens.subscreens::Hypermode"; 
		
		public static const SPEED_FACTOR:	Number = 		20;
		
		public static const RAINBOW_VECTOR:	Vector.<uint> = new <uint>[0xFF5353, 0xFFA74F, 0xFFFF5E, 0x6FFF6F, 0x75BAFF, 0x6464FF, 0xFF37FF];
		
		/**
		 * Round a number to the specified decimal place.
		 * @param	number		The number to round.
		 * @param	dp			The decimal places to round to.
		 * @return				The rounded number.
		 */
		public static function round(number:Number, dp:uint):Number
		{
			var factor:int = Math.pow(10, dp);
			
			return (Math.round(number * factor)) / factor;
		}
		
	}

}