package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jane
	 */
	public class playerDeath extends Sprite
	{
		[Embed(source = "../Assets/player_death.png")]
		private static const playerDeathPlane: Class;
		private var deathPlane: Bitmap;
		
		public function playerDeath() 
		{
			deathPlane = new playerDeath.playerDeathPlane();
			scaleX = 1.0;
			scaleY = 1.0;
			addChild(deathPlane);
		}
		
	}

}