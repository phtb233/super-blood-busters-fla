package screens.levels 
{
	import com.greensock.loading.data.ImageLoaderVars;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import interfaces.IUpdateable;
	
	/**
	 * The animated background for the first level.
	 * @author Stephen Oppong Beduh
	 */
	public class BackgroundOne extends AbstractBackground implements IUpdateable
	{
		private var _cloudsNear:			Sprite;
		private var _cloudsFar:				Sprite;
		private var _buildings:				Sprite;
		private var _ground:				Sprite;
		private var _reflection:			Sprite;
		private var _wavesFar:				Sprite;
		private var _wavesMid:				Sprite;
		private var _wavesNear:				Sprite;
		private var _wavesNearest:			Sprite;
		private var _sun:					Image;
		private var _totalPassed:			Number;
		
		private var _sky:					Quad;
		private var _water:					Quad;
		
		public function BackgroundOne() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_totalPassed = 0;
			_cloudsNear = 	createParallaxSprite(Assets.Manager.getTexture("clouds_near"));
			_cloudsFar = 	createParallaxSprite(Assets.Manager.getTexture("clouds_furthest"));
			_buildings =    createParallaxSprite(Assets.Manager.getTexture("buildings_near"));
			_ground = 		createParallaxSprite(Assets.Manager.getTexture("buildings_and_ground"), true);
			_reflection = 	createParallaxSprite(Assets.Manager.getTexture("reflection"), true);
			_wavesFar = 	createParallaxSprite(Assets.Manager.getTexture("waves_far"));
			_wavesMid = 	createParallaxSprite(Assets.Manager.getTexture("waves_mid"));
			_wavesNear = 	createParallaxSprite(Assets.Manager.getTexture("waves_near"));
			_wavesNearest = createParallaxSprite(Assets.Manager.getTexture("waves_nearest"));
			_sun = 			new Image(Assets.Manager.getTexture("sun"));
			
			_buildings.y = 113;
			_ground.y = 125;
			
			_sky = new Quad(stage.stageWidth, stage.stageHeight, 0x61A3FF);
			_water = new Quad(stage.stageWidth, stage.stageHeight, 0xBDDEE4);
			
			addChild(_sky);
			addChild(_water);
			addChild(_sun);
			_sun.x = stage.stageWidth - _sun.width * 1.5;
			_sun.y = 15;
			_sun.scaleX = _sun.scaleY = 0.7;
			_water.y =   _ground.y + _ground.height - 10;
			_reflection.y = _ground.y + +_ground.height - 3;
			_wavesFar.y = 190;
			_wavesMid.y = _wavesFar.y + 8;
			_wavesNear.y = _wavesMid.y + 32;
			_wavesNearest.y = _wavesNear.y + 30;
			_cloudsNear.y = 6;
			_cloudsFar.y = _cloudsNear.y - 3;
			addChild(_cloudsFar);
			addChild(_cloudsNear);
			addChild(_buildings);
			addChild(_ground);
			addChild(_reflection);
			addChild(_wavesFar);
			addChild(_wavesMid);
			addChild(_wavesNear);
			addChild(_wavesNearest);
		}
		
		public override function update(passedTime:Number):void
		{
			moveParallaxSprite(_buildings, 80, passedTime);
			moveParallaxSprite(_ground, 100, passedTime);
			moveParallaxSprite(_reflection, 100, passedTime);
			moveParallaxSprite(_cloudsNear, 40, passedTime);
			moveParallaxSprite(_cloudsFar, 30, passedTime);
			moveParallaxSprite(_wavesFar, 120, passedTime);
			moveParallaxSprite(_wavesMid, 180, passedTime);
			moveParallaxSprite(_wavesNear, 280, passedTime);
			moveParallaxSprite(_wavesNearest, 450, passedTime);
			
			_sun.y += Math.sin(_totalPassed += passedTime) * 0.1;
		}
		
	}

}