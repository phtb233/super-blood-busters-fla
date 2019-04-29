package screens.subscreens 
{
	import objects.AbstractObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	/**
	 * A bright flash.
	 * @author Stephen Oppong Beduh
	 */
	public class Flash extends AbstractObject 
	{
		private var _q:Quad;
		private var _brighten:Boolean;
		private var _callbackCalled:Boolean;
		private var _riseRate:Number;
		private var _fallRate:Number;
		private var _callback:Function;
		private var _color:uint;
		
		/**
		 * 
		 * @param	x 			The flash's x coordinate. This should be 0.
		 * @param	y 			The flash's y coordinate. This should be 0.
		 * @param	riseRate	How slowly the flash should turn opaque.
		 * @param	fallRate	How quickly the flash should disappear.
		 * @param	callback	An optional function to call in between brightening and darkening.
		 * @param	color		The color of the flash.
		 */
		public function Flash(x:Number, y:Number, riseRate:Number = 0.3, fallRate:Number = 0.3, callback:Function = null, color:uint = 0xFFFFFF) 
		{
			super(x, y);
			touchable = false;
			_riseRate = riseRate;
			_fallRate = fallRate;
			_callback = callback;
			_callbackCalled = false;
			_brighten = true;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_q = new Quad(stage.stageWidth, stage.stageHeight);
			_q.alpha = 0;
			_q.color = _color;
			addChild(_q);
		}
		
		override public function update(passedTime:Number):void 
		{
			if (_brighten && _q.alpha + _riseRate * passedTime < 1) 
			{
				_q.alpha += Math.max(1 - _q.alpha, 0.01) * _riseRate;
			} else if(_brighten && _q.alpha + _riseRate * passedTime >= 1) {
				_brighten = false;
				_q.alpha = 1;
				if (_callback != null)
				{
					if (!_callbackCalled) 
					{
						_callback();
						_callbackCalled = true;
					}
				}
			}
			
			if (!_brighten && _q.alpha > 0) 
			{
				_q.alpha += Math.min(0 - _q.alpha, - 0.01) * _fallRate;
			}
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			_q.alpha = 0;
			_brighten = true;
			_callbackCalled = false;
			_callback = null;
		}
		
		/**
		 * How quickly the flash should turn opaque.
		 */
		public function get riseRate():Number 
		{
			return _riseRate;
		}
		
		/**
		 * How quickly the flash should turn opaque.
		 */
		public function set riseRate(value:Number):void 
		{
			_riseRate = value;
		}
		
		/**
		 * How quickly the flash should disappear.
		 */
		public function get fallRate():Number 
		{
			return _fallRate;
		}
		
		/**
		 * How quickly the flash should disappear.
		 */
		public function set fallRate(value:Number):void 
		{
			_fallRate = value;
		}
		
		/**
		 * An optional function to call in between brightening and darkening.
		 */
		public function set callback(value:Function):void 
		{
			_callback = value;
		}
		
		/**
		 * Whether the flash is still brightening.
		 */
		public function get brighten():Boolean 
		{
			return _brighten;
		}
		
		public override function get alpha():Number
		{
			return _q.alpha;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
			if (_q) 
			{
				_q.color = _color;
			}
		}
		
	}

}