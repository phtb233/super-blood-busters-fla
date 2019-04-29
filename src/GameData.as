package  
{
	import flash.net.SharedObject;
	/**
	 * Holds and manages saved game data.
	 * @author Stephen Oppong Beduh
	 */
	public class GameData 
	{
		private var _sharedObject:SharedObject;
		private var _highScores:Array;
		
		public function GameData()
		{
			
		}
		
		public static function Save(newData:Object):void
		{
			var highScores:Array = newData.highScores;
			var maxLevel:int = newData.maxLevel;
			
			// Order the scores, highest to lowest.
			highScores.sort(function(a:*, b:*):int { return b[1] - a[1]; } );
			var shared:SharedObject = SharedObject.getLocal("SuperBloodBusters");
			shared.data.highScores = highScores;
			Assets.HighScores = highScores;
			
			shared.data.maxLevel = maxLevel;
			shared.close();
		}
		
		public static function Load():Object
		{
			var o:Object = new Object();
			var a:Array;
			var m:int;
			var shared:SharedObject = SharedObject.getLocal("SuperBloodBusters");
			if (shared.data.highScores == undefined) {
				// Create new game data.
				a = shared.data.highScores = [
				["DOG", 4000], 
				["CAT", 3000], 
				["PIG", 2000],
				["HEN", 1000]
				];
			}else 
			{
				// Load existing data.
				a = shared.data.highScores;
				a.sort(function(a:*, b:*):int { return b[1] - a[1]; } );
			}
			
			if (shared.data.maxLevel == undefined) 
			{
				m = shared.data.maxLevel = 0;
			}else 
			{
				m = Math.max(shared.data.maxLevel, 0);
			}
			
			o.maxLevel = m;
			o.highScores = a;
			
			return o;
			shared.close();
		}
		
		public static function Reset():void
		{
			var shared:SharedObject = SharedObject.getLocal("SuperBloodBusters");
			
			shared.data.highScores = [
			["DOG", 4000], 
			["CAT", 3000], 
			["PIG", 2000],
			["HEN", 1000]
			];
			
			shared.data.maxLevel = 0;
			
			shared.close();
		}
		
	}

}