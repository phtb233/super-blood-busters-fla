package objects 
{
	import objects.userinterface.*;
	import objects.data.Level;
	import starling.display.*;
	import starling.events.*;
	import interfaces.IUpdateable;
	import starling.text.TextField;
	
	/**
	 * Contains elements such as the player score, how many germs remaining, the player health and ammo and the hypermode button.
	 * @author Stephen Oppong Beduh
	 */
	public class HUD extends Sprite 
	{
		private var _heartPlaque:HeartPlaque;
		private var _ammoPlaque:AmmoPlaque;
		private var _hypermodeButton:HyperButton;
		private var _hypermodeBar:HypermodeBar;
		private var _hyperModeCallback:Function;
		private var _endOfLevelCallback:Function;
		
		private var _hypermode:Boolean;
		
		private var _score:ScoreText;
		private var _combo:ComboText;
		private var _remaining:TextField;
		private var _levelNumber:TextField;
		
		private var _remainingAmount:int;
		
		private var _scores:Vector.<IUpdateable>;
		
		private var _comboTimer:Number;
		private var _comboAmount:uint;
		private var _counting:Boolean;
		
		private var _maxCombo:uint;
		
		private var _currentLevel:Level;
		
		private const _HORZ_PADDING:uint = 10;
		private const _VERT_PADDING:uint = 10;
		private const _EASE:Number = 0.09;
		
		/**
		 * Contains elements such as the player score, how many germs remaining, the player health and ammo and the hypermode button.
		 * @param	callback	This is called when hypermode ends.
		 * @param   eolCallback This is called when all germs are killed.
		 */
		public function HUD(callback:Function, eolCallback:Function) 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_heartPlaque = new HeartPlaque(5);
			_ammoPlaque = new AmmoPlaque();
			_hypermodeBar = new HypermodeBar(_heartPlaque.width);
			_hypermodeButton = new HyperButton();
			_hypermode = false;
			_hyperModeCallback = callback;
			_endOfLevelCallback = eolCallback;
			_score = new ScoreText(170 , 50, "SCORE");
			_remaining = new TextField(200, 50, "REMAINING : ", "pressStart80", 10, 0xFFFFFF);
			_levelNumber = new TextField(150, 50, "LEVEL : ", "pressStart80", 10, 0xFFFFFF);
			_combo = new ComboText(170, 50);
			_scores = new Vector.<IUpdateable>();
			_comboTimer = _comboAmount = 0;
			_counting = false;
			_maxCombo = 0;
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_heartPlaque.x = stage.stageWidth - _heartPlaque.width - _HORZ_PADDING;
			_heartPlaque.y = stage.stageHeight - _heartPlaque.height - _VERT_PADDING;
			addChild(_heartPlaque);
			
			_ammoPlaque.x = _HORZ_PADDING;
			_ammoPlaque.y = stage.stageHeight - _ammoPlaque.height - _VERT_PADDING ;
			addChild(_ammoPlaque);
			
			_hypermodeBar.x = stage.stageWidth - _hypermodeBar.width - _VERT_PADDING;
			_hypermodeBar.y = _ammoPlaque.y - _hypermodeBar.height;
			addChild(_hypermodeBar);
			
			_hypermodeButton.x = _ammoPlaque.x + _ammoPlaque.width + (_heartPlaque.x - (_ammoPlaque.x + _ammoPlaque.width)) / 2 - (_hypermodeButton.width / 2);
			
			_score.x = _HORZ_PADDING + 80;
			_score.y = _VERT_PADDING + _score.height / 2;
			_scores.push(_score);
			addChild(_score);
			
			_combo.x = _HORZ_PADDING + 50;
			_combo.y = _score.y + _score.height + 5;
			_scores.push(_combo);
			
			_remaining.x = stage.stageWidth - _remaining.width - _HORZ_PADDING + 20;
			_remaining.y = _VERT_PADDING;
			addChild(_remaining);
			
			_levelNumber.x = stage.stageWidth / 2 - _levelNumber.width / 2 - 10;
			_levelNumber.y = _VERT_PADDING;
			addChild(_levelNumber);
			
			updateLevel();
		}
		
	   /**
		* Calculate the bonus points from the combo and add it to the total score.
		* The combo must be 2 hits or more.
		*/
	   private function calculateCombo():void 
	   {
		   if (_comboAmount >= 2) 
		   {
			   var multiplier:int = 100;
			   if (_comboAmount > 5) multiplier = 300;
			   if (_comboAmount > 10) multiplier = 500;
			   if (_comboAmount > 15) multiplier = 700;
			   if (_comboAmount > 20) multiplier = 1000;
			   if (_comboAmount > 50) multiplier = 5000;
			   _score.amount += _comboAmount * multiplier;
		   }
		   if (_comboAmount > _maxCombo) 
		   {
			   _maxCombo = _comboAmount;
		   }
	   }
	   
	   /**
	    * Update the HUD using the current level data.
	    */
	   public function updateLevel():void
	   {
		   _currentLevel = Assets.LevelArray[Assets.LevelIndex];
		   _levelNumber.text = "LEVEL : " + (Assets.LevelIndex + 1);
		   remaining = _currentLevel.toKill;
		   _maxCombo = 0;
	   }
	   
		/**
		 * One shot has been fired. The ammo plaque should update to show this.
		 */
		public function bulletFired():void
		{
			if (!_hypermode) 
			{
				_ammoPlaque.loseAmmo();
			}
		}
		
		/**
		 * A shot has missed. Update the HUD graphics.
		 */
		public function bulletMissed():void
		{
			_ammoPlaque.shotMissed();
		}
		
		public function loseHealth(amount:uint = 1):void
		{
			_heartPlaque.health -= amount;
		}
		
		public function recoverHealth(amount:uint = 1):void
		{
			_heartPlaque.health += amount;
		}
		
		public function replenishShot():void
		{
			_ammoPlaque.gainAmmo();
		}
		
		public function update(passedTime:Number):void
		{
			_heartPlaque.update(passedTime);
			_ammoPlaque.update(passedTime);
			_hypermodeBar.update(passedTime);
			if (_hypermodeButton.stage) 
			{
				_hypermodeButton.update(passedTime);
			}
			
			if (_hypermode) 
			{
				_hypermodeBar.energy -= passedTime * 0.1;
				
				if (_hypermodeBar.energy <= 0) 
				{
					_hypermode = false;
					if (_hyperModeCallback != null) 
					{
						_hyperModeCallback();
					}
				}
			}
			
			for (var i:int = 0; i < 2; i++) 
			{
				var text:IUpdateable = _scores[int(i)];
				if (!text.stage) continue;
				text.update(passedTime);
			}
			
			if (_counting) 
			{
				_comboTimer -= passedTime;
				if (_comboTimer <= 0) 
				{
					endCombo();
				}
			}
		}
		
		/**
		 * End the combo instantly (for the end of a round).
		 */
		public function endCombo():void
		{
			calculateCombo();
			_comboTimer = _comboAmount = _combo.amount = 0;
			_counting = false;
			if(_combo.stage) 
			{
				removeChild(_combo);
			}
		}
		
		
		/**
		 * Build up the energy in the hypermode bar.
		 * If it's full, show hypermode button.
		 * @param	amount Should be between 0 and 1.
		 */
		public function buildMeter(amount:Number):void
		{
			if (!_hypermode) 
			{
				_hypermodeBar.energy += amount;
			}
			
			if (!_hypermode && Utility.round(_hypermodeBar.energy, 3) === 1 && !_hypermodeButton.stage) 
			{
				addChild(_hypermodeButton);
			}
		}
		
		public function addToScore(amount:Number):void
		{
			_score.amount += amount;
			if (!_counting) 
			{
				_counting = true;
			}
			_comboTimer = 3;
			_comboAmount += 1;
			if (!_combo.stage && _comboAmount >= 2) 
			{
				addChild(_combo);
			}
			_combo.amount = _comboAmount;
		}
		
		public function emptyMeter():void 
		{
			_hypermodeBar.energy = 0;
		}
		
		/**
		 * The health the player currently has.
		 */
		public function get health():uint
		{
			return _heartPlaque.health;
		}
		
		/**
		 * Set the player health.
		 */
		public function set health(value:uint):void
		{
			_heartPlaque.health = value;
		}
		
		/**
		 * The number of shots the player has left.
		 */
		public function get ammo():uint
		{
			return _ammoPlaque.currentShot;
		}
		
		/**
		 * Get a reference to the hypermodeButton.
		 */
		public function get hypermodeButton():MovieClip
		{
			return _hypermodeButton.button;
		}
		
		/**
		 * Whether hypermode is activated or not.
		 */
		public function get hypermode():Boolean 
		{
			return _hypermode;
		}
		
		public function set hypermode(value:Boolean):void 
		{
			_hypermode = value;
			if (_hypermode) 
			{
				_hypermodeButton.reset();
				removeChild(_hypermodeButton);
			}
		}
		
		private function set comboAmount(value:uint):void
		{
			_comboAmount = value;
		}
		
		public function set remaining(value:int):void
		{
			_remainingAmount = value;
			if (_remainingAmount < 0) _remainingAmount = 0;
			
			if (_remainingAmount === 0) 
			{
				if(_endOfLevelCallback !== null) _endOfLevelCallback();
			}
			_remaining.text = "REMAINING : " + _remainingAmount;
		}
		
		public function get remaining():int
		{
			return _remainingAmount;
		}
		
		private function get comboAmount():uint
		{
			return _comboAmount;
		}
		
		public function get maxCombo():uint 
		{
			return _maxCombo;
		}
		
		/**
		 * The player's score for this playthrough.
		 */
		public function get score():uint
		{
			return _score.amount;
		}
		
	}

}