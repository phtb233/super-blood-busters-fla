package objects.userinterface 
{
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import interfaces.IUpdateable;
	
	/**
	 * Text that animates while it catches up to the player's score.
	 * @author Stephen Oppong Beduh
	 */
	public class ScoreText extends TextField implements IUpdateable
	{
		private var _amount:uint;
		private var _currentAmount:uint;
		private var _angle:Number;
		private var _index:uint;
		private var _rattle:Boolean;
		private var _prefix:String;
		static private const _EASE:Number = 0.1;
		private var _counter:int;
		
		public function ScoreText(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0x0, bold:Boolean=false) 
		{
			_amount = _currentAmount = _index = _angle = _counter = 0;
			_rattle = false;
			_prefix = text;
			super(width, height, _prefix + " : " + _currentAmount, "pressStart80", 10, 0xFFFFFF, bold);
			this.pivotX = width / 2;
			this.pivotY = height / 2;
			//this.hAlign = HAlign.LEFT;
		}
		
		private function checkScore():void
		{
			if (_currentAmount !== _amount) 
			{
				_rattle = true;
			} else 
			{
				_rattle = false;
			}
		}
		
		public function update(passedTime:Number):void
		{
			if (_rattle) 
			{
				if (_counter++ === 2) 
				{
					_counter = 0;
					this.color = Utility.RAINBOW_VECTOR[int(_index++ % 7)];
				}
				this.rotation += Math.cos(deg2rad(_angle)) * 0.06;
				_angle += 14;
				var dif:uint = amount - _currentAmount;
				if (dif >= 1000) 
				{
					currentAmount += 1000
				} else if (dif >= 100 && dif < 1000) 
				{
					currentAmount += 100;
				} else if (dif >= 10 && dif < 100) 
				{
					currentAmount += 10;
				} else if (dif < 10 && dif > 0) 
				{
					currentAmount += 1;
				}
				this.text = _prefix + " : " + _currentAmount;
			} else 
			{
				if (Utility.round(this.rotation, 2) !== 0) 
				{
					this.rotation += 0 - this.rotation * _EASE;
				}
				
				if (this.color !== 0xFFFFFF) 
				{
					this.color = 0xFFFFFF;
				}
			}
		}
		
		public function get rattle():Boolean 
		{
			return _rattle;
		}
		
		public function set rattle(value:Boolean):void 
		{
			_rattle = value;
		}
		
		public function get amount():uint 
		{
			return _amount;
		}
		
		public function set amount(value:uint):void 
		{
			_amount = value;
			checkScore();
		}
		
		private function set currentAmount(value:uint):void
		{
			_currentAmount = value;
			checkScore();
		}
		
		private function get currentAmount():uint
		{
			return _currentAmount;
		}
		
	}

}