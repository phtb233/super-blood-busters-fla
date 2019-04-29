package objects.userinterface 
{
	import starling.text.TextField;
	import interfaces.IUpdateable;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class ComboText extends TextField implements IUpdateable
	{
		private var _amount:uint;
		private var _index:uint;
		private var _counter:int;
		
		public function ComboText(width:int, height:int, fontName:String="Verdana", fontSize:Number=12, color:uint=0x0, bold:Boolean=false) 
		{
			_amount = 0;
			_index = 0;
			super(width, height, "COMBO : " + _amount, "pressStart80", 10, 0xFFFFFF);
			this.pivotX = width / 2;
			this.pivotY = height / 2;
		}
		
		public function get amount():uint 
		{
			return _amount;
		}
		
		public function update(passedTime:Number):void
		{
			if (_counter++ === 2) 
			{
				_counter = 0;
				this.color = Utility.RAINBOW_VECTOR[int(_index++ % 7)];
			}
			
		}
		
		public function set amount(value:uint):void 
		{
			_amount = value;
			this.text = "COMBO : " + _amount;
		}
		
	}

}