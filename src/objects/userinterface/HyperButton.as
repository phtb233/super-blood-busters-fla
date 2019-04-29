package objects.userinterface 
{
	import starling.display.Sprite;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.core.Starling;
	import starling.utils.HAlign;
	
	/**
	 * The user can click this to initiate hypermode.
	 * @author Stephen Oppong Beduh
	 */
	public class HyperButton extends Sprite 
	{
		/**
		 * The clickable red button.
		 */
		private var _button:MovieClip;
		//private var _text:TextField;
		private var _text:MovieClip;
		
		private var _targetY:Number;
		private const _EASE:Number = 0.09;
		
		private var _index:uint;
		
		private const _rainbow:Vector.<uint> = Utility.RAINBOW_VECTOR;
		
		public function HyperButton() 
		{
			super();
			_index = 0;
			_button = new MovieClip(Assets.Manager.getTextures("hypermode-button"), 30);
			_button.pivotX = _button.width / 2;
			_text = new MovieClip(Assets.Manager.getTextures("hypermode_"), 30);
			_text.pivotX = _text.width / 2;
			Starling.juggler.add(_button);
			Starling.juggler.add(_text);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			reset();
			addChild(_button);
			addChild(_text);
		}
		
		public function update(passedTime:Number):void
		{
			if (_button.y !== _targetY) 
			{
				_button.y += (_targetY - _button.y) * _EASE;
			}
		}
		
		public function reset():void
		{
			_targetY = stage.stageHeight - _button.height - 20;
			_button.y =  stage.stageHeight + _button.height;
			_text.x = _button.x;
			_text.y = _targetY - _text.height;
		}
		
		/**
		 * Get a reference to the hyperbutton for touch events etc.
		 */
		public function get button():MovieClip 
		{
			return _button;
		}
		
	}

}