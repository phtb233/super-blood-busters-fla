package screens.levels 
{
	import interfaces.IUpdateable;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class BackgroundTwo extends AbstractBackground implements IUpdateable
	{
		private var _near_detail:			Sprite;
		private var _near_ground:           Sprite;
		private var _near_ground_full:      Quad;
		private var _near_mtn:              Sprite;
		private var _far_detail:            Sprite;
		private var _far_ground:            Sprite;
		private var _far_mtn:               Sprite;
		private var _mid_detail:            Sprite;
		private var _mid_ground:			Quad;
		private var _clouds:                Sprite;
		private var _far_clouds:            Sprite;
		private var _near_cacti:            Sprite;
		private var _sky: 					QuadBatch;
		
		public function BackgroundTwo() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_near_detail = 	createParallaxSprite(Assets.Manager.getTexture("near_detail"));
			_near_ground = 	createParallaxSprite(Assets.Manager.getTexture("near_ground"));
			_near_mtn = 	createParallaxSprite(Assets.Manager.getTexture("near_mtn"), true);
			_far_detail = 	createParallaxSprite(Assets.Manager.getTexture("far_detail"));
			_far_ground = 	createParallaxSprite(Assets.Manager.getTexture("far_ground"));
			_far_mtn = 		createParallaxSprite(Assets.Manager.getTexture("far_mtn"));
			_mid_detail = 	createParallaxSprite(Assets.Manager.getTexture("mid_detail"));
			_sky =          new QuadBatch();
			_clouds =       createParallaxSprite(Assets.Manager.getTexture("clouds"));
			_far_clouds =   createParallaxSprite(Assets.Manager.getTexture("far_clouds"));
			_near_cacti =   createParallaxSprite(Assets.Manager.getTexture("near_cacti"));
			_near_ground_full = new Quad(stage.stageWidth, 70, 0xFF9161);
			
			var skyColors:Vector.<uint> = new <uint>[0xFF003E, 0xFF293E, 0xFF473E, 0xFF5B3E, 0xFF6735, 0xFF7F41, 0xFF9744, 0xFFBD5B];
			var len:int = skyColors.length;
			var q:Quad;
			var prevY:Number = 0;
			for (var i:int = 0; i < len; i++) 
			{
				if (i !== len - 1) 
				{
					q = new Quad(stage.stageWidth, (i * i) + 10, skyColors[i]);
				}else 
				{
					q = new Quad(stage.stageWidth, stage.stageHeight - prevY, skyColors[i]);
				}
				q.y = prevY;
				prevY += q.height;
				_sky.addQuad(q);
			}
			
			_far_ground.y = 140;
			_mid_ground = 	new Quad(stage.width, stage.height - (_far_ground.y + _far_ground.height), 0xFFC08B);
			_mid_ground.y = _far_ground.y + _far_ground.height / 3 + 35;
			_near_ground.y = stage.stageHeight - _near_ground.height - 50;
			_far_detail.y = _far_ground.y + _far_ground.height - 6;
			_mid_detail.y = _far_detail.y + _far_detail.height - 9;
			_near_detail.y = _mid_detail.y + _mid_detail.height;
			_near_mtn.y = _far_ground.y - _near_mtn.height / 3;
			_far_mtn.y = _far_ground.y - _far_mtn.height / 3;
			_near_ground_full.y = _near_ground.y + _near_ground.height;
			_near_cacti.y = stage.stageHeight - _near_cacti.height;
			
			addChild(_sky);
			addChild(_far_clouds);
			addChild(_clouds);
			addChild(_far_mtn);
			addChild(_near_mtn);
			addChild(_mid_ground);
			addChild(_far_ground);
			addChild(_near_detail);
			addChild(_mid_detail);
			addChild(_far_detail);
			addChild(_near_ground_full);
			addChild(_near_ground);
			addChild(_near_cacti);
			
		}
		
		/* INTERFACE interfaces.IUpdateable */
		
		public override function update(passedTime:Number):void 
		{
			moveParallaxSprite(_far_mtn, 10, passedTime);
			moveParallaxSprite(_far_clouds, 40, passedTime);
			moveParallaxSprite(_clouds, 80, passedTime);
			moveParallaxSprite(_near_mtn, 40, passedTime);
			moveParallaxSprite(_far_ground, 80, passedTime);
			moveParallaxSprite(_far_detail, 110, passedTime);
			moveParallaxSprite(_mid_detail, 160, passedTime);
			moveParallaxSprite(_near_detail, 230, passedTime);
			moveParallaxSprite(_near_ground, 270, passedTime);
			moveParallaxSprite(_near_cacti, 480, passedTime);
		}
		
		
	}

}