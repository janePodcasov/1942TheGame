package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jane
	 */
	public class playerMove extends Sprite
	{
		[Embed(source = "../Assets/player_move.png")]
		private static const playerMovePlane: Class;
		private var movePlane: Bitmap;
		
		public function playerMove() 
		{
			movePlane = new playerMove.playerMovePlane();
			scaleX = 1.0;
			scaleY = 1.0;
			addChild(movePlane);
		}
		
	}
}