package screens.subscreens 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Back;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class Instructions 
	{
		private var _display:			Sprite;
		private var _x:					Number;
		private var _y: 				Number;
		private var _width:				Number;
		private var _bg:				 Image;
		private var _plaque:			 Image;
		private var _textfield: 	 TextField;
		private var _text: 				String;
		private var _backBtn:			Button;
		
		public function Instructions() 
		{
			_bg = new Image(Assets.Manager.getTexture("instructions-screen-resized"));
			_plaque = new Image(Assets.Manager.getTexture('instructions-plaque-resized'));
			_plaque.pivotX = _plaque.width / 2;
			_plaque.pivotY = _plaque.height / 2;
			_display = new Sprite();
			_display.addChild(_bg);
			_plaque.x = _display.width / 2 - _plaque.width / 2;
			_plaque.y = _display.height / 2 - _plaque.height * .5;
			
			_text = "\nDestroy all the germs.\n\n\nLonger combos will earn more points.\n\n\nUse powerups to clear the screen.\n\n\nUse hypermode when the bar is full.\n\n\nGood luck!".toUpperCase();
			_textfield = new TextField(_plaque.width - 40, _plaque.height - 40, _text, "pressStart80", 10, Color.WHITE);
			_textfield.vAlign = VAlign.TOP;
			//_textfield.blendMode = BlendMode.ADD;
			_textfield.x = _plaque.x + 20;
			_textfield.y = _plaque.y + 20;
			
			_backBtn = new Button(Assets.Manager.getTexture('backBtn'), "", Assets.Manager.getTexture('backBtn'));
			_backBtn.x = _display.width / 2 - _backBtn.width / 2;
			_backBtn.y = _display.height * .75;
		}
		
		public function showText():void
		{
			_plaque.x = _display.stage.stageWidth / 2;
			_plaque.y = _display.stage.stageHeight / 2;
			_display.addChild(_plaque);
			TweenLite.from(_plaque, 0.5, {scaleX:0, scaleY:0, ease:Strong.easeOut, onComplete: onShowTextComplete } );
		}
		
		private function onShowTextComplete():void 
		{
			_display.addChild(_textfield);
			TweenLite.from(_textfield, 0.4, { alpha: 0, ease:Back.easeOut } );
			
			_display.addChild(_backBtn);
			TweenLite.from(_backBtn, 0.4, { alpha: 0, ease:Back.easeOut, delay: 0.5 } );
		}
		
		public function hide():void
		{
			_display.visible = false;
			_display.removeChild(_plaque);
			_display.removeChild(_textfield);
			_display.removeChild(_backBtn);
		}
		
		public function show():void
		{
			_display.visible = true;
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
			_display.x = value;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
		}
		
		public function get display():Sprite 
		{
			return _display;
		}
		
		public function get width():Number 
		{
			return _display.width;
		}
		
		public function get backBtn():Button 
		{
			return _backBtn;
		}
		
	}

}