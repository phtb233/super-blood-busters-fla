package screens 
{
	import events.ProgressEvent;
	import starling.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The abstract for the different screens.
	 * @author Stephen Oppong Beduh
	 */
	public class AbstractScreen extends Sprite 
	{
		
		public function AbstractScreen() 
		{
			super();
			
			//Make sure the constructor isn't called.
			if (getQualifiedClassName(this) == "AbstractScreen")
			{
				throw new ArgumentError("AbstractScreen can't be instantiated directly. Try one of it's sub-children.");
			}
		}
		
		/**
		 * Load assets. This isn't working properly at the moment, and just causes everything to jerk violently
		 * once the "loaded" event is fired.
		 */
		public function load():void
		{
			// Override this.
			dispatchEvent(new ProgressEvent(ProgressEvent.LOADED, true));
		}
		
		/**
		 * Destroy assets.
		 */
		public function unload():void
		{
			// Override this.
			removeEventListeners();
		}
		
		/**
		 * In case you want something to happen when the screen tween finished,
		 * put it in here.
		 */
		public function onTweenComplete():void
		{
			// Override this.
		}
	}

}