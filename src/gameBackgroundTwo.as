package 
{
	import flash.display.Bitmap;
	
	/**
		*Program: CSY1024 Assignment 2
		*Filename: gameBackgroundTwo.as
		*@Jane Podcasova 18419945
		*Course: BSc Computer Games Development
		*Module: CSY1024 Game Techniques
		*Tutor: Dr Anastasios G. Bakaoukas
		*@version: 4.0, commented and tested, final and ready for public release
		*Date: 02/05/2019
	 */
	
	[Embed(source="../Assets/background2.png")]
	 
	public class gameBackgroundTwo extends Bitmap
	{
		
		public function gameBackgroundTwo() 
		{
			scaleX = 1.0;
			scaleY = 1.0;
		}
		
	}

}