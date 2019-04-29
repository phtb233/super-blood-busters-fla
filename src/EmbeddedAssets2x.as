package  
{
	/**
	 * Anything that's needed before the application loads the game assets (e.g. for the loading screen). 
	 * HIGH-DEF
	 * @author Stephen Oppong Beduh
	 */
	public class EmbeddedAssets2x extends EmbeddedAssetsCore
	{
		
		[Embed(source = "../lib/assets/images/loading_and_gameover/@2x/loading_and_gameover.png")]
		public static const loading_and_gameover:Class;
		
		[Embed(source="../lib/assets/images/loading_and_gameover/@2x/loading_and_gameover.xml", mimeType = "application/octet-stream")]
		public static const l_and_g_xml:Class;
	}

}