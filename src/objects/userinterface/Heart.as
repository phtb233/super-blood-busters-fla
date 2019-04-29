package objects.userinterface 
{
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * On of the hearts that indicates the player's health.
	 * @author Stephen Oppong Beduh
	 */
	public class Heart extends Sprite 
	{
		private var _graphic:			MovieClip;
		private var _alive:				Boolean;
		private var _angle:				Number;
		private var _ascend:            Boolean;
		private var _grow_target: 		Number;
		private const _SHRINK_TARGET: 	Number = 0.3;
		
		private const _EASE:			Number = 0.04;
		
		public function Heart() 
		{
			super();
			createGraphic();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_alive = true;
			_angle = 0;
			_grow_target = 0;
			_ascend = false;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function createGraphic():void
		{
			_graphic = new MovieClip(Assets.Manager.getTextures("hearts_"));
			_graphic.scaleX = _graphic.scaleY = 0.33;
			pivotX = _graphic.width / 2;
			pivotY = _graphic.height / 2;
			addChild(_graphic);
		}
		
		public function update(angle:Number):void
		{
			if (_alive) 
			{
				_grow_target = 1.1 + (Math.sin(angle) * 0.1);
				if (!_ascend) 
				{
					scaleX = scaleY = _grow_target;
				}else 
				{
					if (_ascend && scaleX < 1.1)
					{
						scaleX = scaleY += (_grow_target - scaleX) * _EASE;
					} else {
						_ascend = false;
					}
				}
				
				//scaleX = scaleY += (_grow_target - scaleY) * _EASE;
				
			} else if(!_alive && Utility.round(this.scaleX, 2) > 0.3)
			{
				scaleX = scaleY += (0.2 - scaleY) * _EASE;
			}
		}
		
		public function get alive():Boolean 
		{
			return _alive;
		}
		
		public function set alive(value:Boolean):void 
		{
			_alive = value;
			if (_alive) 
			{
				_graphic.currentFrame = 0;
				_ascend = true;
			} else 
			{
				_graphic.currentFrame = 1;
				_ascend = false;
			}
		}
		
		
	}

}