package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
		*Program: CSY1024 Assignment 2
		*Filename: playerMoveStraight.as
		*@Jane Podcasova 18419945
		*Course: BSc Computer Games Development
		*Module: CSY1024 Game Techniques
		*Tutor: Dr Anastasios G. Bakaoukas
		*@version: 4.0, commented and tested, final and ready for public release
		*Date: 02/05/2019
	 */
	
	public class playerMoveStraight extends Sprite
	{
		[Embed(source="../Assets/player_moveStraight.png")]
		private static const playerMovingPlane: Class;
		private var planeMoveStraight: Bitmap;
		
		public function playerMoveStraight() 
		{
			planeMoveStraight = new playerMoveStraight.playerMovingPlane();
			scaleX = 1.0;
			scaleY = 1.0;
			addChild(planeMoveStraight);
		}
		
	}
}