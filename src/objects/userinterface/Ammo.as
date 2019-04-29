package objects.userinterface 
{
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	/**
	 * One of the bullet graphics representing the player's ammo.
	 * @author Stephen Oppong Beduh
	 */
	public class Ammo extends Sprite 
	{
		private var _graphic:MovieClip;
		private var _angle:Number;
		private var _fired:Boolean;
		private var _missed:Boolean;
		private var _targetScale:Number;
		private var _state:String;
		
		private const _EASE:Number = 0.15;
		
		public static const NORMAL:String = "normal";
		public static const FIRED:String = "fired";
		public static const MISSED:String = "missed";
		
		public function Ammo() 
		{
			_angle = 0;
			_state = NORMAL;
			createGraphic();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function createGraphic():void
		{
			_graphic = new MovieClip(Assets.Manager.getTextures("ammo_"));
			_graphic.scaleX = _graphic.scaleY = 1.2;
			pivotX = _graphic.width / 2;
			pivotY = _graphic.height / 2;
			//_graphic.rotation = deg2rad(45);
			addChild(_graphic);
		}
		
		public function update(passedTime:Number):void
		{
			rotation = Math.sin(deg2rad(_angle)) * 0.5;
			_angle += 5;
			if (_state === FIRED && Utility.round(this.scaleX, 2) < 2 ) 
			{
				this.scaleX = this.scaleY += (2.1 - this.scaleX) * _EASE;
			} else if (_state === MISSED && Utility.round(this.scaleX, 2) > 0.5) 
			{
				this.scaleX = this.scaleY += (0.3 - this.scaleX) * _EASE;
			} else if (_state === NORMAL && Utility.round(this.scaleX, 2) !== 1)
			{
				this.scaleX = this.scaleY += (1 - this.scaleX) * _EASE;
			}
		}
		
		/**
		 * The bullet state. Can be "fired", "missed" or "normal".
		 */
		public function get state():String 
		{
			return _state;
		}
		
		/**
		 * The bullet state. Should be set using the Ammo class constants.
		 */
		public function set state(value:String):void 
		{
			_state = value;
			switch (value) 
			{
				case NORMAL:
					_graphic.currentFrame = 0;
					_state = value;
				break;
				case FIRED:
					_state = value;
				break;
				case MISSED:
					_graphic.currentFrame = 1;
					_state = value;
				break;
				default:
					throw "Use one of Ammo's constants e.g Ammo.FIRED";
			}
		}
	}
}