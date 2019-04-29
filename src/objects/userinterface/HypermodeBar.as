package objects.userinterface 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.Color;
	
	/**
	 * A small rectangular bar that represents hypermode energy.
	 * When it's filled, the hypermode button appears.
	 * @author Stephen Oppong Beduh
	 */
	public class HypermodeBar extends Sprite 
	{
		private var _bar:Quad;
		private var _barBg:Quad;
		private var _width:Number;
		private var _color:uint;
		private var _r:int;
		private var _g:int;
		private var _b:int;
		private var _targetR:int;
		private var _targetG:int;
		private var _targetB:int;
		private var _targetColor:uint;
		private var _energy:Number;
		
		private const _EASE:Number = 0.07;

		
		public function HypermodeBar(width:Number) 
		{
			super();
			_width = width;
			_barBg = new Quad(_width, 3, 0x2B0003);
			addChild(_barBg);
			_r = 0;
			_g = 255;
			_b = 0;
			_targetR = 0;
			_targetG = 0;
			_targetB = 0;
			
			var color:uint = Color.rgb(_r, _g, _b);
			_targetColor = color;
			_energy = 0;
			_bar = new Quad(_width, 3, color);
			_bar.scaleX = 0;
			addChild(_bar);
		}
		
		public function update(passedTime:Number):void
		{
			if (_bar.scaleX != _energy) 
			{
				_bar.scaleX += (_energy - _bar.scaleX) * _EASE;
			}
			
			if (_r !== _targetR || _g !== _targetG || _b !== _targetB) 
			{
				if (_r !== _targetR) 
				{
					_r += ease(_targetR, _r);
				}
				
				if (_g !== _targetG) 
				{
					_g += ease(_targetG, _g);
				}
				
				if (_b !== _targetB) 
				{
					_b += ease(_targetB, _b);
				}
				_bar.color = Color.rgb(_r, _g, _b);
			}
		}
		
		/**
		 * Change the target color so the bar can tween towards it.
		 */
		private function changeColor():void
		{
			if (_energy <= 0.5) 
			{
				_targetG = 255;
				_targetR = (_energy / 0.5) * 255;
			} else if (_energy > 0.5) 
			{
				_targetR = 255;
				_targetG = 255 - (((_energy - 0.5) / 0.5) * 255);
			}
			_targetColor = _targetR << 16 | _targetG << 8 | _targetB;
		}
		
		private function ease(target:Number, current:Number):Number
		{
			return (target - current) * _EASE;
		}
		
		public function get energy():Number 
		{
			return _energy;
		}
		
		public function set energy(value:Number):void 
		{
			_energy = value;
			_energy = Math.max(0, Math.min(1, _energy));
			changeColor();
		}
		
	}

}