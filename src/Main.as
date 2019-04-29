package 
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	
	
	//[SWF(width = "480", height = "320", frameRate = 60, backgroundColor = 0x532727)]
	[SWF(width = "960", height = "640", frameRate = 60, backgroundColor = 0x532727, wmode = "direct")]
	//[SWF(width = "1366", height = "768", frameRate = 60, backgroundColor = 0x532727)]
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class Main extends Sprite 
	{
		private var _starling:Starling;
		
		public function Main():void 
		{
			
			//var screenWidth:int = stage.fullScreenWidth;
			//var screenHeight:int = stage.fullScreenHeight;
			var screenWidth:int = 960;
			var screenHeight:int = 640;
			//var screenWidth:int = 480;
			//var screenHeight:int = 320;
			var viewport:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			_starling = new Starling(BloodBusters, stage, viewport);
			_starling.stage.stageWidth = 480;
			_starling.stage.stageHeight = 320;
			
			
			Starling.contentScaleFactor > 1 ?
				Assets.Scale = 2  :
				Assets.Scale = 1;
			
			//Assets.Scale = 2;
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			//_starling = new Starling(BloodBusters, stage);
			//_starling.showStats = true;
			_starling.antiAliasing = 0;
			_starling.start();
		}
		
		
	}
	
}