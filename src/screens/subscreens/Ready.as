package screens.subscreens 
{
	import flash.text.TextField;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * Ready? 3, 2, 1, GO!
	 * @author Stephen Oppong Beduh
	 */
	public class Ready extends Sprite 
	{
		private var _bg:Quad;
		private var _ready:Image;
		private var _3:Image;
		private var _2:Image;
		private var _1:Image;
		private var _go:MovieClip;
		
		private var _elapsed:Number;
		private const _INTERVAL:Number = 0.2;
		private var _targetTime:Number;
		private var _currentImage:DisplayObject;
		
		private var _state:		uint = 0;
		private const ease:     Number = 0.05;
		
		public function Ready() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_bg = new Quad(stage.stageWidth, stage.stageHeight);
			_ready = new Image(Assets.Manager.getTexture('ready'));
			_3 = new Image(Assets.Manager.getTexture('three'));
			_2 = new Image(Assets.Manager.getTexture('two'));
			_1 = new Image(Assets.Manager.getTexture('one'));
			_go = new MovieClip(Assets.Manager.getTextures('go_'), 40);
			Starling.juggler.add(_go);
			_elapsed = 0;
			_targetTime = 1.5;
			_bg.alpha = 0.6;
			_bg.color = 0x000000;
			addChild(_bg);
			swapGraphics(_ready);
		}
		
		public function update(passedTime:Number):void
		{
			_elapsed += passedTime;
			
			//trace(_elapsed);
			
			if (_elapsed > _targetTime && _state === 0) 
			{
				_state = 1;
				_targetTime += _INTERVAL;
				swapGraphics(_3);
			} else if (_elapsed > _targetTime && _state === 1) 
			{
				_state = 2;
				_targetTime += _INTERVAL;
				swapGraphics(_2);
			} else if (_elapsed > _targetTime && _state === 2) 
			{
				_state = 3;
				_targetTime += _INTERVAL;
				swapGraphics(_1);
			} else if (_elapsed > _targetTime && _state === 3)
			{
				_state = 4;
				_targetTime += _INTERVAL;
				swapGraphics(_go);
			} else if (_elapsed > _targetTime && _state === 4) 
			{
					this.alpha -= Math.max(this.alpha * ease, 0.01);
			}
		}
		
		private function swapGraphics(newImage:Image):void
		{
			if (_currentImage) 
			{ 
				removeChild(_currentImage);
			}
			newImage.x = Math.round(stage.stageWidth / 2 - newImage.width / 2);
			newImage.y = Math.round(stage.stageHeight / 2 - newImage.height / 2);
			addChild(newImage);
			_currentImage = newImage;
		}
		
	}

}