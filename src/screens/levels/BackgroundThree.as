package screens.levels 
{
	import interfaces.IUpdateable;
	import objects.stars.FlickeringStar;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class BackgroundThree extends AbstractBackground implements IUpdateable 
	{
		private var _nearest_grass:Sprite;
		private var _path:Sprite;
		private var _near_top:Sprite;
		private var _near_grass:Sprite;
		private var _near_tree_trunks:Sprite;
		private var _mid_grass:Sprite;
		private var _mid_tree_trunks:Sprite;
		private var _far_tree_trunks:Sprite;
		
		private var _stars1:Sprite;
		private var _stars2:Sprite;
		private var _sky:Quad;
		private var _starfield:QuadBatch;
		
		private var _flickering_stars:Vector.<FlickeringStar>;
		
		private const _NUM_OF_STARS:int = 30;
		
		public function BackgroundThree() 
		{
			super();
			
			_nearest_grass = createParallaxSprite(Assets.Manager.getTexture("nearest_grass"));
			_path = createParallaxSprite(Assets.Manager.getTexture("path"));
			_near_top = createParallaxSprite(Assets.Manager.getTexture("near_top"), true);
			_near_grass = createParallaxSprite(Assets.Manager.getTexture("near_grass"));
			_near_tree_trunks = createParallaxSprite(Assets.Manager.getTexture("near_tree_trunks"));
			_mid_grass = createParallaxSprite(Assets.Manager.getTexture("mid_grass"));
			_mid_tree_trunks = createParallaxSprite(Assets.Manager.getTexture("mid_tree_trunks"));
			_far_tree_trunks = createParallaxSprite(Assets.Manager.getTexture("far_tree_trunks"), true);
			
			_stars1 = new Sprite();
			_stars2 = new Sprite();
			
			_starfield = new QuadBatch();
			_flickering_stars = new Vector.<FlickeringStar>();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_nearest_grass.y = stage.stageHeight - _nearest_grass.height;
			_path.y = stage.stageHeight - _path.height;
			_near_grass.y = _path.y - _path.height * (3/5);
			_near_tree_trunks.y = _path.y - _near_tree_trunks.height;
			_mid_grass.y = _near_grass.y - _near_grass.height * (1/5);
			_mid_tree_trunks.y = _near_grass.y - _mid_tree_trunks.height;
			_far_tree_trunks.y = 24;
			
			_sky = new Quad(stage.stageWidth, stage.stageHeight, 0x7244B0);
			
			var s:FlickeringStar;
			var q:Quad;
			var temp:QuadBatch = new QuadBatch();
			var xPos:Number = 0;
			var yPos:Number = 0;
			for (var i:int = 0; i < 7; i++) 
			{
				for (var j:int = 0; j < 8; j++) 
				{
					s = new FlickeringStar();
					s.x = stage.stageWidth * (j / 4) + ((Math.random() * - 60) + 60);
					s.y = stage.stageHeight * (i / 14) + ((Math.random() * - 60) + 60);
					_flickering_stars.push(s);
					q = new Quad(2, 2, s.color);
					q.x = s.x; q.y = s.y;
					temp.addQuad(q);
				}
			}
			var s2:QuadBatch = temp.clone();
			s2.x = - stage.stageWidth;
			_starfield.addQuadBatch(temp);
			_starfield.addQuadBatch(s2);
			addChild(_sky);
			addChild(_starfield);
			addChild(_far_tree_trunks);
			addChild(_mid_tree_trunks);
			addChild(_mid_grass);
			addChild(_near_tree_trunks);
			addChild(_near_grass);
			addChild(_near_top);
			addChild(_path);
			addChild(_nearest_grass);
		}
		
		/**
		 * Update background starfield.
		 */
		private function draw(passedTime:Number):void
		{
			_starfield.reset();
			var len:uint = _flickering_stars.length;
			var s:FlickeringStar;
			var q:Quad;
			var temp:QuadBatch = new QuadBatch();
			for (var i:int = 0; i < len; i++) 
			{
				s = _flickering_stars[i];
				s.update();
				q = new Quad(2, 2, s.color);
				q.x = s.x;
				q.y = s.y;
				temp.addQuad(q);
			}
			var s2:QuadBatch = temp.clone();
			s2.x = - stage.stageWidth;
			_starfield.addQuadBatch(temp);
			_starfield.addQuadBatch(s2);
			_starfield.x += passedTime * 4;
			if (_starfield.x > stage.stageWidth) 
			{
				_starfield.x = 0;
			}
		}
		
		public override function update(passedTime:Number):void
		{
			moveParallaxSprite(_far_tree_trunks, 50, passedTime);
			moveParallaxSprite(_mid_tree_trunks, 100, passedTime);
			moveParallaxSprite(_mid_grass, 200, passedTime);
			moveParallaxSprite(_near_tree_trunks, 280, passedTime);
			moveParallaxSprite(_near_grass, 320, passedTime);
			moveParallaxSprite(_near_top, 280, passedTime);
			moveParallaxSprite(_path, 380, passedTime);
			moveParallaxSprite(_nearest_grass, 500, passedTime);
			draw(passedTime);
		}
		
		
	}

}