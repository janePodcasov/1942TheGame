package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
		*Program: CSY1024 Assignment 2
		*Filename: enemyGreen.as
		*@Jane Podcasova 18419945
		*Course: BSc Computer Games Development
		*Module: CSY1024 Game Techniques
		*Tutor: Dr Anastasios G. Bakaoukas
		*@version: 4.0, commented and tested, final and ready for public release
		*Date: 02/05/2019
	 */
	
	public class enemyGreen extends Sprite
	{
		[Embed(source = "../Assets/enemy1.png")]
		public static const enemyGreenPlane: Class;
		public var greenPlane: Bitmap;
		
		public function enemyGreen() 
		{
			greenPlane = new enemyGreen.enemyGreenPlane();
			scaleX = 1.0;
			scaleY = 1.0;
			addChild(greenPlane);
		}
		
	}

}