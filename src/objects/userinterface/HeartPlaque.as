package objects.userinterface 
{
	import objects.HUD;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * The entire collection of hearts representing the player's health.
	 * @author Stephen Oppong Beduh
	 */
	public class HeartPlaque extends Sprite 
	{
		private var _plaque:Image;
		private var _heartVector:Vector.<Heart>;
		private var _health:int;
		private var _angle:Number;
		private var _rate:uint;
		
		private const _HEART_HORZ_PADDING:uint = 10;
		
		/**
		 * The player health.
		 * @param	initialHealth	The health the player starts with.
		 */
		public function HeartPlaque(initialHealth:uint = 5) 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_heartVector = new Vector.<Heart>();
			_plaque = new Image(Assets.Manager.getTexture("plaque"));
			addChild(_plaque);
			for (var i:int = 0; i < 5; i++) 
			{
				var heart:Heart = new Heart();
				heart.x = ((heart.width + _HEART_HORZ_PADDING) * i) + heart.width / 2 + 6;
				heart.y = 20;
				_heartVector.push(heart);
				addChild(heart);
			}
			health = initialHealth;
			_rate = 6 - _health;
			_angle = 0;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//_heartVector[1].alive = false;
			
		}

		
		/**
		 * Update the status of all the hearts depending on the current health.
		 */
		private function refreshHearts():void
		{
			for (var i:int = 0; i < 5; i++) 
			{
				_heartVector[int(i)].alive = i <= _health - 1;
			}
		}
		
		public function update(passedTime:Number):void
		{
			for (var i:int = 0; i < 5; i++) 
			{
				var heart:Heart = _heartVector[int(i)];
				heart.update(_angle);
			}
			_angle += 0.04 * _rate;
		}
		
		/**
		 * Get the current amount of player health.
		 */
		public function get health():int 
		{
			return _health;
		}
		
		/**
		 * Change the health, and the status of the heart graphics.
		 */
		public function set health(value:int):void 
		{
			_health = value;
			if (_health < 0) 
			{
				_health = 0;
			} else if (_health > 5) 
			{
				_health = 5;
			}
			_rate = 6 - _health;
			refreshHearts();
		}
		
		override public function get height():Number 
		{
			return _plaque.height;
		}
		
		override public function get width():Number 
		{
			return _plaque.width;
		}
		
	}

}