package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
		*Program: CSY1024 Assignment 2
		*Filename: enemyRed.as
		*@Jane Podcasova 18419945
		*Course: BSc Computer Games Development
		*Module: CSY1024 Game Techniques
		*Tutor: Dr Anastasios G. Bakaoukas
		*@version: 4.0, commented and tested, final and ready for public release
		*Date: 02/05/2019
	 */
	
	public class enemyRed extends Sprite
	{
		[Embed(source = "../Assets/enemy2.png")]
		private static const enemyRedPlane: Class;
		private var redPlane: Bitmap;
		
		public function enemyRed() 
		{
			redPlane = new enemyRed.enemyRedPlane();
			scaleX = 1.0;
			scaleY = 1.0;
			addChild(redPlane);
		}
		
	}

}