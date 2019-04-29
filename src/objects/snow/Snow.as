package objects.snow 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class Snow
	{
		private var _angle:Number;
		private var _radians:Number;
		private var _xSpeed:Number;
		private var _ySpeed:Number;
		private var _size:uint;
		private var _colour:uint;
		private var _x:Number;
		private var _y:Number;
		
		public static const NEAR:String = "near";
		public static const MIDDLE:String = "middle";
		public static const FAR:String = "far";
		
		public function Snow(proximity:String) 
		{
			super();
			_angle = - Math.PI + (Math.random() * Math.PI);
			_xSpeed = 4;
			_ySpeed = 0;
			_radians = 0;
			switch (proximity) 
			{
				case NEAR:
					_ySpeed = Math.random() * 6 + 4;
					_xSpeed = 12;
					_colour = 0xFFFFFF;
					_size = 3;
				break;
				case MIDDLE:
					_ySpeed = Math.random() * 1 + 2;
					_xSpeed = 8;
					_colour = 0xFFE6FF;
					_size = 2;
				break;
				case FAR:
					_ySpeed = Math.random() * 1 + 0.5;
					_xSpeed = 4;
					_colour = 0xFFA6FF;
					_size = 1;
				break;
				default:
					throw ArgumentError("Use the class constants for the constructor");
			}

		}
		
		public function update(passedTime:Number):void
		{
			
			_radians += (_angle/180) * Math.PI;
			_x += - Math.cos(_radians) + (_xSpeed * 25) / 50;
			_y += _ySpeed;
			//_x += 0.3;
		}
		
		
		public function get colour():uint 
		{
			return _colour;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
		}
		
		public function get size():uint 
		{
			return _size;
		}
		
	}

}