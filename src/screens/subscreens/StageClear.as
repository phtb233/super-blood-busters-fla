package screens.subscreens 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import interfaces.IUpdateable;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	
	/**
	 * Shows at the end of each level
	 * @author Stephen Oppong Beduh
	 */
	public class StageClear extends Sprite implements IUpdateable
	{
		private var _bg:Quad;
		
		private var _state:uint;
		
		private const _ROW_ONE_TEXT:String = "STAGE";
		private const _ROW_TWO_TEXT:String = "CLEAR";
		private const _ROW_ONE_Y:int = 95;
		private const _ROW_TWO_Y:int = 160;
		
		private var _letters_top:Vector.<TextField>;
		private var _letters_bottom:Vector.<TextField>;
		private var _letters_all:Vector.<TextField>;
		
		private var _angle:Number;
		private var _timer:Number;
		private var _maxCombo:uint;
		private var _maxComboText:TextField;
		private var _removeMe:Boolean;
		/**
		 * Marks whether level switch has been called.
		 */
		private var _called:Boolean;
		
		private var _switchLevel:Function;
		
		private const _EASE:Number = 0.03;
		static public const _HORZ_PADDING:uint = 125;
		
		public function StageClear(maxCombo:uint = 0, switchLevel:Function = null) 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_state = 0;
			_letters_top = new Vector.<TextField>(5, true);
			_letters_bottom = new Vector.<TextField>(5, true);
			_letters_all = new Vector.<TextField>(10, true);
			_angle = 0;
			_timer = 0;
			_maxCombo = maxCombo;
			_removeMe = false;
			_called = false;
			
			if (switchLevel !== null) _switchLevel = switchLevel;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0x0);
			_bg.alpha = 0;
			_bg.touchable = false;
			addChild(_bg);
			
			//var len_top:uint = _ROW_ONE_TEXT.length;
			//var len_bottom:uint = _ROW_TWO_TEXT.length;
			var l:TextField;
			for (var i:int = 0; i < 5; i++) 
			{
				l = new TextField(40, 40, _ROW_ONE_TEXT.charAt(i), "pressStart80", 40, 0xFFFFFF);
				l.pivotX = l.width / 2;
				l.pivotY = l.height / 2;
				l.x = _HORZ_PADDING + i * 60;
				l.y = _ROW_ONE_Y;
				_letters_top[i] = _letters_all[i] = l;
				l.scaleX = l.scaleY = 0;
				addChild(l);
				l = new TextField(40, 40, _ROW_TWO_TEXT.charAt(i), "pressStart80", 40, 0xFFFFFF);
				l.pivotX = l.width / 2;
				l.pivotY = l.height / 2;
				l.x = _HORZ_PADDING + i * 60;
				l.y = _ROW_TWO_Y;
				_letters_bottom[i] = _letters_all[i + 5] = l;
				l.scaleX = l.scaleY = 0;
				addChild(l);
			}
			_maxComboText = new TextField(stage.stageWidth, 40, "MAX COMBO : " + _maxCombo, "pressStart80", 20, 0xFFFFFF);
			_maxComboText.hAlign = HAlign.CENTER;
		}
		
		public function update(passedTime:Number):void
		{
			if (_state === 0 && _bg.alpha < 0.7) 
			{
				_bg.alpha += Math.max(0.75 - _bg.alpha, 0.01) * _EASE;
			}else 
			{
				if (_state === 0) 
				{
					_state = 1;
					growLetters();
				}
			}
			if (_state === 2) 
			{
				_timer += passedTime;
				if (_timer > 0.1) 
				{
					_state = 3;
					showMaxCombo();
					_timer = 0;
				}
			}
			if (_state === 3) 
			{
				_timer += passedTime;
				if (_timer > 2) 
				{
					removeText();
					_state = 4;
				}
			} if (_state === 4) 
			{
				if (_switchLevel !== null) 
				{
					_switchLevel();
				}
				_state = 5;
			} if (_state === 5) 
			{
				if (_bg.alpha > 0) 
				{
					_bg.alpha += Math.min(0 - _bg.alpha, - 0.06) * _EASE;
				}else 
				{
					_removeMe = true;
					_state = 5;
				}
				//_q.alpha += Math.min(0 - _q.alpha, - 0.01) * _fallRate;
			}
			
			var l:TextField;
			for (var i:int = 0; i < 10 ; i++) 
			{
				l = _letters_all[int(9 - i)];
				l.rotation = 0 + (Math.cos(deg2rad(_angle + (i * 6))) * 0.7);
				l.color = 255 << 16 | ((Math.cos(deg2rad(_angle + (i * 8))) + 1)/2) * 255 << 8 | 0;
			}
			
			_angle += passedTime * 78;
		}
		
		/**
		 * Remove all textfields.
		 */
		private function removeText():void 
		{
			var len:uint = _letters_all.length;
			for (var i:int = 0; i < len; i++) 
			{
				removeChild(_letters_all[i]);
			}
			removeChild(_maxComboText);
		}
		
		/**
		 * Show the maximum combo score.
		 */
		private function showMaxCombo():void 
		{
			_maxComboText.y = _ROW_TWO_Y + _maxComboText.height + 15;
			addChild(_maxComboText);
		}
		
		/**
		 * Scale up letters.
		 */
		private function growLetters():void 
		{
			var l:TextField;
			var cb:Function = null;
			for (var i:int = 0; i < 10; i++) 
			{
				l = _letters_all[i];
				if (i === 9) 
				{
					cb = function():void 
					{
						_state = 2;
					};
				}
				
				TweenLite.to(l, 0.8, { scaleX: 1, scaleY: 1, ease:Strong.easeOut, delay: i * 0.1, onComplete:cb } );
			}
		}
		
		public function get removeMe():Boolean 
		{
			return _removeMe;
		}
		
	}

}