package objects.snow 
{
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * Falling snow for background four.
	 * @author Stephen Oppong Beduh
	 */
	public class FallingSnow extends Sprite 
	{
		private var _nearSnow:Vector.<Snow>;
		private var _middleSnow:Vector.<Snow>;
		private var _farSnow:Vector.<Snow>;
		private var _wholeSnow:Vector.<Snow>;
		private var _qbWhole:QuadBatch;
		private var _qbNear:QuadBatch;
		private var _qbMiddle:QuadBatch;
		private var _qbFar:QuadBatch;
		
		private static const _NO_OF_NEAR_SNOW:uint = 25;
		private static const _NO_OF_MIDDLE_SNOW:uint = 50;
		private static const _NO_OF_FAR_SNOW:uint = 80;
		
		public function FallingSnow() 
		{
			super();
			_qbNear = new QuadBatch();
			_qbMiddle = new QuadBatch();
			_qbFar = new QuadBatch();
			_qbWhole = new QuadBatch();
			_nearSnow = new Vector.<Snow>();
			_middleSnow = new Vector.<Snow>();
			_farSnow = new Vector.<Snow>();
			_wholeSnow = new Vector.<Snow>();
			addChild(_qbWhole);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var s:Snow;
			var q:Quad;
			for (var i:int = 0; i < _NO_OF_NEAR_SNOW; i++) 
			{
				s = new Snow(Snow.NEAR);
				s.x = stage.stageWidth * Math.random();
				s.y = stage.stageHeight * Math.random();
				q = new Quad(s.size, s.size, s.colour);
				q.x = s.x;
				q.y = s.y;
				_nearSnow.push(s);
				_wholeSnow.push(s);
				_qbNear.addQuad(q);
			}
			for (i  = 0; i < _NO_OF_MIDDLE_SNOW; i++) 
			{
				s = new Snow(Snow.MIDDLE);
				s.x = stage.stageWidth * Math.random();
				s.y = stage.stageHeight * Math.random();
				q = new Quad(s.size, s.size, s.colour);
				q.x = s.x;
				q.y = s.y;
				_middleSnow.push(s);
				_wholeSnow.push(s);
				_qbMiddle.addQuad(q);
			}
			for (i = 0; i < _NO_OF_FAR_SNOW; i++) 
			{
				s = new Snow(Snow.FAR);
				s.x = stage.stageWidth * Math.random();
				s.y = stage.stageHeight * Math.random();
				q = new Quad(s.size, s.size, s.colour);
				q.x = s.x;
				q.y = s.y;
				_farSnow.push(s);
				_wholeSnow.push(s);
				_qbFar.addQuad(q);
			}
			
			_qbWhole.addQuadBatch(_qbNear);
			_qbWhole.addQuadBatch(_qbMiddle);
			_qbWhole.addQuadBatch(_qbFar);
		}
		
		public function update(passedTime:Number):void
		{
			var len:uint = _wholeSnow.length;
			var s:Snow;
			for (var i:int = 0; i < len; i++) 
			{
				s = _wholeSnow[i];
				s.update(passedTime);
				if (s.y > stage.stageHeight) 
				{
					s.y = 0;
				}
				if (s.x > stage.stageWidth) 
				{
					s.x = 0;
				}
			}
			draw();
		}
		
		/**
		 * Redraw the snowflakes.
		 */
		private function draw():void
		{
			_qbWhole.reset();
			_qbNear.reset();
			_qbMiddle.reset();
			_qbFar.reset();
			
			var s:Snow;
			var q:Quad;
			for (var i:int = 0; i < _NO_OF_NEAR_SNOW; i++) 
			{
				s = _nearSnow[i];
				q = new Quad(s.size, s.size, s.colour);
				q.x = s.x;
				q.y = s.y;
				_qbNear.addQuad(q);
			}
			for (i  = 0; i < _NO_OF_MIDDLE_SNOW; i++) 
			{
				s = _middleSnow[i];
				q = new Quad(s.size, s.size, s.colour);
				q.x = s.x;
				q.y = s.y;
				_qbMiddle.addQuad(q);
			}
			for (i = 0; i < _NO_OF_FAR_SNOW; i++) 
			{
				s = _farSnow[i];
				q = new Quad(s.size, s.size, s.colour);
				q.x = s.x;
				q.y = s.y;
				_qbFar.addQuad(q);
			}
			
			_qbWhole.addQuadBatch(_qbNear);
			_qbWhole.addQuadBatch(_qbMiddle);
			_qbWhole.addQuadBatch(_qbFar);
		}
		
	}

}