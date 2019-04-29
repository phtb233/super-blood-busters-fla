package objects.userinterface 
{
	import adobe.utils.CustomActions;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * Holds the ammo graphics that represent's the player's ammo.
	 * @author Stephen Oppong Beduh
	 */
	public class AmmoPlaque extends Sprite 
	{
		private var _ammoVector:Vector.<Ammo>;
		private var _plaque:Image;
		private var _currentShot:uint;
		private var _timer:Number;
		private var _counting:Boolean;
		
		private const _AMMO_HORZ_PADDING:uint = 7;
		
		public function AmmoPlaque() 
		{
			super();
			_plaque = new Image(Assets.Manager.getTexture("ammo_plaque"));
			addChild(_plaque);
			
			_ammoVector = new Vector.<Ammo>();
			for (var i:int = 0; i < 3; i++) 
			{
				var a:Ammo = new Ammo();
				a.x = ((a.width + _AMMO_HORZ_PADDING) * i) + a.width / 2 + 6;
				a.y = 20;
				_ammoVector.push(a);
				addChild(a);
			}
			_currentShot = _ammoVector.length;
			_timer = 0;
			_counting = false
		}
		
		
		public function update(passedTime:Number):void
		{
			var len:uint = _ammoVector.length;
			for (var i:int = 0; i < len; i++) 
			{
				_ammoVector[i].update(passedTime);
			}
			if (_counting) 
			{
				_timer += passedTime;
				if (_timer > 4.5) 
				{
					reloadAllShots();
				}
			}
		}
		
		/**
		 * Restore all ammo.
		 */
		public function reloadAllShots():void 
		{
			_counting = false;
			_timer = 0;
			for (var i:int = 0; i < 3; i++) 
			{
				_ammoVector[i].state = Ammo.NORMAL;
			}
			_currentShot = 3;
		}
		
		/**
		 * Replenish one shot.
		 */
		public function gainAmmo():void
		{
			currentShot += 1;
			for (var j:int = 0; j < 3 ; j++) 
			{
				if (_ammoVector[j].state === Ammo.FIRED) 
				{
					_ammoVector[j].state = Ammo.NORMAL;
					break;
				}
			}
		}
		
		/**
		 * Consume one shot.
		 */
		public function loseAmmo():void
		{
			_counting = true;
			_timer = 0;
			_ammoVector[_currentShot - 1].state = Ammo.FIRED;
			currentShot -= 1;
		}
		
		/**
		 * Mark the most recently fired shot as "missed".
		 */
		public function shotMissed():void
		{
			var i:uint = 0;
			for (var j:int = 2; j >= 0 ; j--) 
			{
				if (_ammoVector[j].state !== Ammo.FIRED) 
				{
					continue;
				} else 
				{
					_ammoVector[j].state = Ammo.MISSED;
					break;
				}
			}
		}
		
		override public function get height():Number 
		{
			return _plaque.height;
		}
		
		override public function set height(value:Number):void 
		{
			super.height = value;
		}
		
		/**
		 * The number of bullets left to be fired.
		 */
		public function get currentShot():uint
		{
			return _currentShot;
		}
		
		public function set currentShot(value:uint):void
		{
			_currentShot = value;
			
			if (_currentShot < 0) 
			{
				_currentShot = 0;
			} else if (_currentShot > 3) 
			{
				_currentShot = 3;
			}
		}
		
	}

}