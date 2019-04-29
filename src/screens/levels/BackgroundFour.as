package screens.levels 
{
	import interfaces.IUpdateable;
	import objects.snow.FallingSnow;
	import starling.display.*;
	import starling.events.Event;
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class BackgroundFour extends AbstractBackground implements IUpdateable 
	{
		private var _near_ice_mtn:Sprite;
		private var _far_ice_mtn:Sprite;
		private var _mid_ground:Sprite;
		private var _near_icicles:Sprite;
		private var _snow:FallingSnow;
		private var _sky:QuadBatch;
		private var _water:Quad;
		
		public function BackgroundFour() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_near_ice_mtn = createParallaxSprite(Assets.Manager.getTexture("near_ice_mtn"));
			_far_ice_mtn = createParallaxSprite(Assets.Manager.getTexture("far_ice_mtn"), true);
			_mid_ground = createParallaxSprite(Assets.Manager.getTexture("mid_ground"), true);
			_near_icicles = createParallaxSprite(Assets.Manager.getTexture("near_icicles"));
			
			_near_icicles.y = stage.stageHeight - _near_icicles.height;
			_mid_ground.y = stage.stageHeight / 2 + 23;
			_near_ice_mtn.y = _mid_ground.y - _near_ice_mtn.height + 4;
			_far_ice_mtn.y = _mid_ground.y - _far_ice_mtn.height + 25;
			
			var skyColors:Vector.<uint> = new <uint>[0x3A173C, 0x59235C, 0x6D2B71, 0x823386, 0x923896, 0xB867B1, 0xBE76B9, 0xC88CC4];
			var len:int = 16;
			var color:uint;
			var r:uint = 220;
			var g:uint = 20;
			var b:uint = 180;
			var gfactor:Number = 255 - g;
			var q:Quad;
			var prevY:Number = 0;
			_sky = new QuadBatch();
			for (var i:int = 0; i < len; i++) 
			{
				g = 50 + (gfactor * i / len);
				color = r << 16 | g << 8 | b;
				if (i !== len - 1) 
				{
					q = new Quad(stage.stageWidth, (i * i) + 3, color);
				}else 
				{
					q = new Quad(stage.stageWidth, stage.stageHeight - prevY, color);
				}
				q.y = prevY;
				prevY += q.height;
				_sky.addQuad(q);
			}
			
			_water = new Quad(stage.stageWidth, stage.stageHeight / 2, 0x97B9FF);
			_water.y = _mid_ground.y;
			
			_snow = new FallingSnow();
			
			addChild(_sky);
			addChild(_water);
			addChild(_far_ice_mtn);
			addChild(_near_ice_mtn);
			addChild(_mid_ground);
			addChild(_near_icicles);
			addChild(_snow);
		}
		
		override public function update(passedTime:Number):void 
		{
			moveParallaxSprite(_far_ice_mtn, 10, passedTime	);
			moveParallaxSprite(_near_ice_mtn, 30, passedTime);
			moveParallaxSprite(_mid_ground, 250, passedTime);
			moveParallaxSprite(_near_icicles, 500, passedTime);
			_snow.update(passedTime);
		}
		
		private function moveSnowflakes(passedTime:Number):void
		{
			
		}
		
	}

}