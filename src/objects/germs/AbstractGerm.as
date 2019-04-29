package objects.germs 
{
	import flash.geom.Rectangle;
	import objects.AbstractObject;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.core.Starling;
	
	/**
	 * The base class that all germ inherit from.
	 * @author Stephen Oppong Beduh
	 */
	public class AbstractGerm extends AbstractObject
	{
		protected const _gravity:	Number = 0.7;
		protected const _min_horizontal: Number = 3;
		
		protected var _graphic:			MovieClip;
		protected var _sprites:			Vector.<Texture>;
		protected var _frameRate: 		uint;
		
		/**
		 * Horizontal momentum when falling.
		 */
		protected var _velocityX: 		Number;
		/**
		 * Vertical momentum when falling.
		 */
		protected var _velocityY:	    Number;
		/**
		 * Specify whether we spin backwards or forwards.
		 */
		protected var _direction: 		int;
		
		protected var _spinning:	 	Boolean;
		protected var _falling: 		Boolean;
		protected var _shrinking:       Boolean;
		/**
		 * The type of germ this is.
		 */
		protected var _type: 			String;
		
		protected var _hitbox:            Quad;
		
		/**
		 * The points the player gets for hitting this germ.
		 */
		protected var _score: 			  uint;
		
		/**
		 * The amount of meter gained from hitting this germ.
		 */
		protected var _meter: 			Number;
		
		public function AbstractGerm(x:Number, y:Number, sprites:Vector.<Texture>, frameRate:uint) 
		{
			super(x, y);
			_sprites = sprites;
			_frameRate = frameRate;
			createGraphic();
			addChild(_graphic);
			// Set it's pivot into the center.
			pivotX = _graphic.width/2;
			pivotY = _graphic.height/2;
			
			_spinning = _falling = _shrinking = false;
			_direction = 1;
			_type = "";
		}
		
		private function generateDirection(flat:Number = NaN):void
		{
			if(Math.random() < 0.5)
			{
				_direction = -1;
			}
			if (!isNaN(flat)) 
			{
				_velocityX = flat * _direction;
			}else 
			{
				_velocityX = Math.round(Math.random() * 1.5 + 2) * _direction;
			}
			_velocityY = - (Math.random() * 3 + 10);
		}
		
		protected function createGraphic():void 
		{
			_graphic = new MovieClip(_sprites, _frameRate);
			//_graphic.x = Math.ceil( -_graphic.width / 2);
			//_graphic.y = Math.ceil( -_graphic.height / 2);
			_graphic.scaleX = _graphic.scaleY = 0.5;
			Starling.juggler.add(_graphic);
			addChild(_graphic);
		}
		
		protected function drawHitbox():void
		{
			_hitbox = new Quad(_graphic.bounds.width, _graphic.bounds.height);
			_hitbox.color = 0xFF8000;
			_hitbox.alpha = 0.3;
			_hitbox.x = _graphic.bounds.x;
			_hitbox.y = _graphic.bounds.y;
			addChild(_hitbox);
		}
		
		/**
		 * Call this when the germ is hit by bullet.
		 * The germ will then spin and fall offscreen.
		 */
		public function hit():void
		{
			_spinning = true;
			_falling = true;
			
			generateDirection();
			
		}
		
		public function playSound():void
		{
			// override this.
		}
		
		/**
		 * Call this when the germ's still onscreen but hasn't been hit before the end of the round.
		 * The germ will spin and disappear.
		 */
		public function vanish():void
		{
			_spinning = true;
			_shrinking = true;
			generateDirection(5);
		}
				
		override public function reset(x:Number, y:Number):void 
		{
			super.reset(x, y);
			_falling = _shrinking = _spinning = false;
			scaleX = scaleY = _direction = 1;
			_velocityX = _velocityY = rotation = 0;
		}
		
		override public function update(passedTime:Number):void 
		{
			if (_spinning) 
			{
				this.rotation += passedTime * 5 * _direction * Math.abs(_velocityX * 0.5);
				
				if (_falling) 
				{
					_velocityY += _gravity;
					this.y += _velocityY;
					this.x += _velocityX;
				} else if (_shrinking) 
				{
					this.scaleX = this.scaleY -= passedTime;
				}
			} else 
			{
				move(passedTime);
			}
		}
		
		/**
		 * The regular movement behaviour which is unique to each germ.
		 * @param	passedTime
		 */
		protected function move(passedTime:Number):void
		{
			// override this.
		}
		
		public override function get width():Number
		{
			return _graphic.width;
		}
		
		public override function get height():Number
		{
			return _graphic.height;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public override function get bounds():Rectangle
		{
			var rect:Rectangle = _graphic.bounds.clone();
			rect.x = this.x - this.width / 2;
			rect.y = this.y - this.height / 2;
			
			return rect;
		}
		
		/**
		 * If the germ is spinning, it's either been shot or is being removed.
		 * We shouldn't check it for collisions.
		 */
		public function get spinning():Boolean 
		{
			return _spinning;
		}
		
		public function get score():uint 
		{
			return _score;
		}
		
		/**
		 * The amount of meter gained from hitting this enemy.
		 */
		public function get meter():Number 
		{
			return _meter;
		}
		
		public function get falling():Boolean 
		{
			return _falling;
		}
		
		public function get shrinking():Boolean 
		{
			return _shrinking;
		}
	}
}