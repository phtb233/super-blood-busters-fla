package objects.color 
{
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class HyperColors 
	{
		private var _red:HyperColor;
		private var _green:HyperColor;
		private var _blue:HyperColor;
		private var _colors:Vector.<HyperColor>;
		private var _colorLength:uint;
		
		public function HyperColors() 
		{
			_red = new HyperColor();
			_green = new HyperColor();
			_blue = new HyperColor();
			_colors = new <HyperColor>[_red, _green, _blue];
			_colorLength = _colors.length;
			checkColors();
		}
		
		/**
		 * Make sure it won't end up being black or white.
		 */
		private function checkColors():void
		{
			var index:int = Math.random() * 2;
			var c:HyperColor;
			if (_red.bright && _green.bright && _blue.bright ) 
			{
				c = _colors[index];
				/*if (c) */	c.bright = false;
				
			} else if (!_red.bright && !_blue.bright && !_green.bright) 
			{
				c = _colors[index];
				/*if (c) */	c.bright = true;
			}
		}
		
		/**
		 * Reset the colors.
		 */
		public function resetColors():void
		{
			for (var i:int = 0; i < _colorLength; i++) 
			{
				_colors[i].resetBrightness();
			}
			checkColors();
			trace(_blue.bright)
			trace(_red.bright)
			trace(_green.bright)
		}
		
		public function get red():HyperColor 
		{
			return _red;
		}
		
		public function get green():HyperColor 
		{
			return _green;
		}
		
		public function get blue():HyperColor 
		{
			return _blue;
		}
		
	}

}