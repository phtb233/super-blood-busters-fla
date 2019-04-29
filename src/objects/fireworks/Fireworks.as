package objects.fireworks 
{
	import objects.Group;
	import objects.AbstractObject;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.events.Event;
	/**
	 * 
	 * @author Stephen Oppong Beduh
	 */
	public class Fireworks extends AbstractObject 
	{
		private var _sparkVector:		Vector.<Spark>;
		private var _age:				Number;
		private var _color:             uint;
		private var _qb:				QuadBatch;
		private var _graphic:           Quad;
		
		
		/**
		 * Create's colourful fireworks using a random rainbow colour.
		 * @param	x
		 * @param	y
		 */
		public function Fireworks(x:Number, y:Number, color:uint = 0) 
		{
			super(x, y);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_sparkVector = new Vector.<Spark>();
			_qb = new QuadBatch();
			_graphic = new Quad(2, 2);
			_age = 0;
			if (!color) 
				_color = Utility.RAINBOW_VECTOR[int(Math.round(Math.random() * 6))];
			else 
				_color = color;
			_graphic.color = _color;
			addChild(_qb);
			
			var s:Spark;
			for (var i:int = 0; i < 180; i++) 
			{
				s = new Spark();
				_sparkVector.push(s);
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Assets.SoundEffects.playSound("fireworks", 0.3);
		}
		
		/**
		 * Draw the firework sparks inside a quad batch, resetting and re-adding them each time.
		 */
		private function draw():void
		{
			_qb.reset();
			var len:int = _sparkVector.length;
			var s:Spark;
			for (var i:int = 0; i < len; i++) 
			{
				s = _sparkVector[i] as Spark;
				_graphic.x = s.x;
				_graphic.y = s.y;
				_qb.addQuad(_graphic);
				s.update();
			}
		}
		
		
		public override function update(passedTime:Number):void
		{
			draw();
			_age += passedTime;
		}
		
		override public function reset(x:Number, y:Number):void 
		{
			
			super.reset(x, y);
			var len:int = _sparkVector.length;
			var s:Spark;
			for (var i:int = 0; i < len; i++) 
			{
				s = _sparkVector[i] as Spark;
				s.init();
			}
			_color = Utility.RAINBOW_VECTOR[int(Math.round(Math.random() * 6))];
			_graphic.color = _color;
			_qb.reset();
			_age = 0;
			Assets.SoundEffects.playSound("fireworks", 0.3);
		}
		
		public function get age():Number 
		{
			return _age;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
			_graphic.color = _color;
		}
		
	}

}