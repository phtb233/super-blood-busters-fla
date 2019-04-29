package objects 
{
	import objects.stars.Star;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class Starfield extends Sprite 
	{
		private var _starsGroup:Group;
		private var _timer:Number;
		private var _timing:Boolean;
		//private var _delay:FlxDelay;
		
		private static const _MAX:			uint = 100;
		private static const _INTERVAL:		Number = 0.005;
		
		public function Starfield() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_timer = 0;
			_timing = true;
			_starsGroup = new Group();
			touchable = false;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function update(passedTime:Number):void
		{
			if (_timing) 
			{
				_timer += passedTime;
				if (_timer >= _INTERVAL) 
				{
					makeStar();
					_timer = 0;
				}
			}
			
			var len:uint = _starsGroup.length;
			for (var i:int = 0; i < len; i++) 
			{
				var s:Star = _starsGroup.array[i];
				if (!s.stage) continue;
				s.update(passedTime);
				if (s.x + s.width < 0 || s.y + s.height < 0 || s.x - s.width > stage.stageWidth || s.y - s.width > stage.stageHeight) 
				{
					//The star will automatically reset to the centre of the screen.
					s.reset(0, 0);
				}
			}
		}
		
		/**
		 * Add another star to the scene.
		 */
		private function makeStar():void 
		{
			var amount:uint = _starsGroup.length;
			if (amount < _MAX) 
			{
				var s:Star = _starsGroup.recycle(stage.stageWidth / 2, stage.stageHeight / 2, Utility.STAR) as Star;
				//s.flatten();
				addChild(s);
			} else 
			{
				_timing = false;
			}
			
		}
		
	}

}