package objects.stars 
{
	/**
	 * For background three.
	 * @author Stephen Oppong Beduh
	 */
	public class FlickeringStar 
	{
		
		private static const _FLICKER_COLOURS: Vector.<uint> = new <uint>[0xFFFFFF, 0xFC7878, 0xFBA85E, 0xFCF358, 0x85F878, 0xC19EF1, 0x8D66F7, 0xEE99F0];
		private const _FLICKER_RATE:int = (Math.random() * _FLICKER_COLOURS.length - 1) + 1;
		
		private var _counter:int;
		private var _ticker:int;
		public var color:uint;
		private var _direction: int;
		public var x:Number;
		public var y:Number;
		
		
		public function FlickeringStar() 
		{
			_direction = 1;
			_counter = Math.random() * _FLICKER_COLOURS.length;
			_ticker = 0;
			color = _FLICKER_COLOURS[_counter];
		}
		
		public function update():void
		{
			_ticker++;
			var len:int = _FLICKER_COLOURS.length
			if (_ticker > _FLICKER_RATE) 
			{
				_ticker = 0;
				//_counter += _direction;
				_counter++;
			}
			
			//if (_counter > len - 1) 
			//{
				//_direction = -1;
				//_counter = len - 1;
			//}else if(_counter < 0)
			//{
				//_direction = 1;
				//_counter = 0;
			//}
			color = _FLICKER_COLOURS[_counter % len];
		}
		
	}

}