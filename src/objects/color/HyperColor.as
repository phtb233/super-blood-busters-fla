package objects.color 
{
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class HyperColor 
	{
		public var bright:Boolean;
		
		public function HyperColor() 
		{
			resetBrightness();
		}
		
		/**
		 * Generate an RGB value (between 0 - 255), using a factor between 0 and 1.
		 * @param	factor 	A fraction which determines the brightness.
		 * @return
		 */
		public function generateColor(factor:Number):int
		{
			return bright ?
			200 + (factor * 45) :
				(factor * 245);
		}
		
		public function resetBrightness():void
		{
			bright = Math.random() > 0.5;
		}
		
	}

}