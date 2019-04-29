package screens.subscreens 
{
	import adobe.utils.CustomActions;
	import objects.color.HyperColors;
	import screens.levels.AbstractBackground;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Quad;
	import interfaces.IUpdateable;
	
	/**
	 * Mutlicoloured background.
	 * @author Stephen Oppong Beduh
	 */
	public class Hypermode extends AbstractBackground implements IUpdateable
	{
		private var _background:Sprite;
		private var _lowNearStars:Sprite;
		private var _highNearStars:Sprite;
		private var _lowMidStars:Sprite;
		private var _highMidStars:Sprite;
		private var _closeMidStars:Sprite;
		private var _farMidStars:Sprite;
		private var _blocker:Quad;
		
		private var _colors:HyperColors;
		
		public function Hypermode(x:Number = 0, y:Number = 0) 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_colors = new HyperColors();
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeChildren( 0, -1, true);
			_background 	= _lowNearStars   = _highNearStars = 
			_lowMidStars 	= _highMidStars   = _closeMidStars  = 
			_farMidStars    = null;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_colors.resetColors();
			_background 	= createBackground();
			_lowNearStars 	= createNearStars(8, 30, 12, 1);
			_highNearStars	= createNearStars(8, 30, 12, 1);
			_lowMidStars 	= createNearStars(14, 70, 6, 1);
			_highMidStars   = createNearStars(14, 70, 6, 1);
			_closeMidStars  = createNearStars(9, 30, 2, 1);
			_farMidStars    = createNearStars(300, stage.stageHeight, 1, 1); 
			
			_lowNearStars.y 	= stage.stageHeight - 70;
			_highNearStars.y 	= 40;
			_lowMidStars.y 		= _lowNearStars.y - _lowNearStars.height - 40;
			_highMidStars.y     = _highNearStars.y + _highNearStars.height;
			_closeMidStars.y    = stage.stageHeight / 2;
			_farMidStars.y		= stage.stageHeight / 2 - _farMidStars.height / 2;	
			
			addChild(_background);
			addChild(_lowNearStars);
			addChild(_highNearStars);
			addChild(_lowMidStars);
			addChild(_highMidStars);
			addChild(_closeMidStars);
			addChild(_farMidStars);
		}
		
		public override function update(passedTime:Number):void
		{
			moveParallaxSprite(_background, 1100, passedTime);
			moveParallaxSprite(_lowNearStars, 600, passedTime);
			moveParallaxSprite(_highNearStars, 600, passedTime);
			moveParallaxSprite(_lowMidStars, 350, passedTime);
			moveParallaxSprite(_highMidStars, 350, passedTime);
			moveParallaxSprite(_closeMidStars, 200, passedTime);
			moveParallaxSprite(_farMidStars, 100, passedTime);
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			//_colors.resetColors();
			//removeChild(_background);
			//_background = createBackground();
			//addChildAt(_background, 0);
		}
		
		/**
		 * Generate stars for parallax scrolling.
		 * @param	no_of_stars			The number of stars to create.
		 * @param	max_height			The height of this band of stars.
		 * @param	star_width			Width of individual stars.
		 * @param	star_height			Height of individual stars.
		 * @return	The band of stars, ready for parallax scrolling.
		 */
		private function createNearStars(no_of_stars:uint, max_height:uint, star_width:uint, star_height:uint):Sprite 
		{
			var qb1:QuadBatch = new QuadBatch();
			var qb2:QuadBatch = new QuadBatch();
			
			var whole_sprite:Sprite = new Sprite();
			
			for (var i:int = 0; i < no_of_stars; i++) 
			{
				var star1:Quad = new Quad(star_width, star_height);
				var star2:Quad = new Quad(star_width, star_height);
				star1.x = Math.round(((i / no_of_stars) * stage.stageWidth) + ((Math.random() * 16) - 8));
				star1.y = max_height * Math.random();
				star2.x = star1.x;
				star2.y = star1.y;
				qb1.addQuad(star1);
				qb2.addQuad(star2);
			}
			qb2.x = qb1.width;
			whole_sprite.addChild(qb1);
			whole_sprite.addChild(qb2);
			whole_sprite.touchable = false;
			return whole_sprite;
		}
		
		/**
		 * Build a sectioned, blocky background.
		 */
		private function createBackground():Sprite 
		{
			const quad_width:Number = 20;
			const no_of_quads:Number = 24;
			var part1:QuadBatch = new QuadBatch();
			var part2:QuadBatch = new QuadBatch();
			var part3:QuadBatch = new QuadBatch();
			var part4:QuadBatch = new QuadBatch();
			var q:Quad;
			var r:uint;
			var g:uint;
			var b:uint;
			var color:uint;
			var factor:Number;
			var background1:Sprite = new Sprite();
			var background2:Sprite = new Sprite();
			var background:Sprite = new Sprite();
			
			for (var i:int = 0; i < no_of_quads; i++) 
			{
				factor = i / no_of_quads;
				r = _colors.red.generateColor(factor);
				g = _colors.green.generateColor(factor);
				b = _colors.blue.generateColor(factor);
				
				color = r << 16 | g << 8 | b;
				q = new Quad(quad_width, stage.stageHeight, color);
				q.x = i * quad_width;
				part1.addQuad(q);
				part2.addQuad(q);
				part3.addQuad(q);
				part4.addQuad(q);
			}
			background1.addChild(part1);
			background1.addChild(part2);
			background2.addChild(part3);
			background2.addChild(part4);
			part2.scaleX = part4.scaleX = -1;
			part2.x = part2.width;
			part4.x = part4.width * 2;
			background.addChild(background1);
			background.addChild(background2);
			background2.x = background1.width;
			return background;
			
		}
	}
}