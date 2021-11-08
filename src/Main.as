package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.*;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	/**
		*Program: CSY1024 Assignment 2
		*Filename: Main.as
		*@Jane Podcasova 18419945
		*Course: BSc Computer Games Development
		*Module: CSY1024 Game Techniques
		*Tutor: Dr Anastasios G. Bakaoukas
		*@version: 4.0, commented and tested, final and ready for public release
		*Date: 02/05/2019
	 */
	public class Main extends Sprite 
	{
		//--------------------------------------------------VARIABLES
		public var startScreenLogo: StartLogo;
		public var pressSpace: pressSpaceLogo;
		public var background1: gameBackgroundOne;
		public var background11: gameBackgroundOne;
		public var background2: gameBackgroundTwo;
		public var background22: gameBackgroundTwo;
		public var firstBackgroundTimer: uint;
		public var secondBackgroundTimer: uint;
		public var plane: player;
		public var planeMoveLeft: playerMoveLeft;
		public var planeMoveRight: playerMoveRight;
		public var planeMoveStraight: playerMoveStraight;
		public var planeExplosion: explosion;
		public var explosionArray: Array = new Array();
		public var ammo: bullet;
		public var ammoArray: Array = new Array();
		public var planeGreen: enemyGreen;
		public var planeRed: enemyRed;
		public var planeBlue: enemyBlue;
		public var level: uint;
		public var score: int;
		public var playerLives: int = 3;
		public var topPanelInterval : uint;
		public var planeMoveInt: uint;
		public var ammoMoveInt: uint;
		public var enemyMoveInt: uint;
		public var explosionInt:uint;
		public var progressInt: uint;
		public var bossInt: uint;
		public var enemyArray: Array = new Array();
		public var randX: int;
		public var randY: int;
		public var timer: int;
		public var lvl1: level1;
		public var lvl2: level2;
		public var lvl3: level3;
		public var lvl4: level4;
		public var lvl5: level5;
		public var lvlboss: levelboss;
		public var bossDirection: int = 1;
		public var bossHits: int = 3;
		public var bossAmmoArray: Array = new Array();
		public var bossShooting: uint;
		public var win: WinLogo;
		public var winScreenInterval: uint;
		public var lossScreenInterval: uint;
		public var winlossProgression: int = 0;
		public var loss: LossLogo;
		public var hitCount: uint;
		public var LeftArrowKeyPressed: Boolean = false;
		public var RightArrowKeyPressed: Boolean = false;
		public var UpArrowKeyPressed: Boolean = false;
		public var DownArrowKeyPressed : Boolean = false;
		public var backToStartInt : int = 0;
		//sound
		[Embed(source="../Sound/backgroundSong.mp3")]
		private const BackgroundSong:Class;
		[Embed(source = "../Sound/shoot.mp3")]
		private const ShootingSound:Class;
		public var ShootingClip:Sound = new ShootingSound();
		[Embed(source = "../Sound/hit.mp3")]
		private const HitSound:Class;
		public var HitClip:Sound = new HitSound();
		//top panel
		public var topPanelText: TextField = new TextField();
		public var topPanelFormat: TextFormat = new TextFormat();
		public var topPanelHealth: TextField = new TextField();
		//win screen messages
		public var winlossMessage1Text: TextField = new TextField();
		public var winlossMessage1Format: TextFormat = new TextFormat();
		public var winlossMessage2Text: TextField = new TextField();
		public var winlossMessage2Format: TextFormat = new TextFormat();
		//----------------------------------------------------END OF VARIABLES
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//-----------------------------------------------GAME LOAD POINT			
			Mouse.hide();	//hide the mouse
			startScreen();	//run the function that handles the title screen/start of the game screen
			//Sound
			var BackgroundSongClip:Sound = new BackgroundSong();
			BackgroundSongClip.play(0, 9999);	//play the background song that will loop forever (9999 times to be more precise)
		}
		//--------------------------------------------------START SCREEN
		public function startScreen() :void {
			//becasue the game can allow the player to return to the start screen,
			//it is important to reset all the used variables by all the functions and event listener that handle the game
			level = 1;
			timer = 0;
			hitCount = 0;
			score = 0;
			bossHits = 3;
			playerLives = 3;
			winlossProgression = 0;
			backToStartInt = 0;
			//it is unknown at what stage the player will be forced to end the game when they crash into a plane,
			//so it is important that the keys are registered as not pressed when the game loads up again
			LeftArrowKeyPressed = false;
			RightArrowKeyPressed = false;
			UpArrowKeyPressed = false;
			DownArrowKeyPressed = false;
			//display the start screen background
			startScreenLogo = new StartLogo();
			startScreenLogo.x = 125;
			startScreenLogo.y = 150;
			stage.addChild(startScreenLogo);
			//display "press space" image
			pressSpace = new pressSpaceLogo();
			pressSpace.x = 165;
			pressSpace.y = 500;
			stage.addChild(pressSpace);
			//add keyboard events for the start screen
			stage.addEventListener(KeyboardEvent.KEY_DOWN, startGame);
		}
		//---------------------------------------------------START SCREEN KEYBOARD EVENTS
		private function startGame(e:KeyboardEvent):void {
			var key:uint = e.keyCode;
			if (key == 32){		//if space bar is pressed
				stage.removeChild(startScreenLogo);		//remove the start screen background
				stage.removeChild(pressSpace);		//remove the "press space" image
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, startGame);	//remove the key events for the start screen
				gameScreen(); 	//load up the function that handles the game
			}
		}
		//---------------------------------------------------GAME SCREEN
		public function gameScreen(): void {
			//---------BACKGROUND
			//two images for the scrolling background
			background1 = new gameBackgroundOne();
			background1.x = 0;
			background1.y = 0;
			stage.addChild(background1);
			background11 = new gameBackgroundOne();
			background11.x = 0;
			background11.y = -650;
			stage.addChild(background11);
			//two images for the scrolling transparent star images (also a background)
			background2 = new gameBackgroundTwo();
			background2.x = 0;
			background2.y = 0;
			stage.addChild(background2);
			background22 = new gameBackgroundTwo();
			background22.x = 0;
			background22.y = -650;
			stage.addChild(background22);
			//set the interval for the background scrolling
			//the back one scrolls slower than the one on top of it
			firstBackgroundTimer = setInterval(backgroundScroll1, 5);
			secondBackgroundTimer = setInterval(backgroundScroll2, 10);
			//----------PLAYER
			//static plane
			plane = new player();
			plane.x = 150;
			plane.y = 500;
			stage.addChild(plane);
			//load up 3 more planes and set the to not visible;
			//they will be set to visible and displayed when the player plane will need to display itself in motion
			//plane moving straight
			planeMoveStraight = new playerMoveStraight();
			planeMoveStraight.x = plane.x;
			planeMoveStraight.y = plane.y;
			stage.addChild(planeMoveStraight);
			planeMoveStraight.visible = false;
			//plane moving left
			planeMoveLeft = new playerMoveLeft();
			planeMoveLeft.x = plane.x;
			planeMoveLeft.y = plane.y;
			stage.addChild(planeMoveLeft);
			planeMoveLeft.visible = false;
			//plane moving right
			planeMoveRight = new playerMoveRight();
			planeMoveRight.x = plane.x;
			planeMoveRight.y = plane.y;
			stage.addChild(planeMoveRight);
			planeMoveRight.visible = false;
			//add keyboard event listeners for player movement or stand-still (as well as firing bullets)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, playerMovement);
			stage.addEventListener(KeyboardEvent.KEY_UP, endMovement);
			//set the interval for the movement of the plane
			planeMoveInt = setInterval(movePlane, 2);
			//set the interval for the movement of bullets
			ammoMoveInt = setInterval(moveAmmo, 5);
			//call on the function that handles spawning the enemies
			enemySpawn();
			//set the interval for enemy plane movement
			enemyMoveInt = setInterval(moveEnemy, 2);
			//set the interval for displaying the top panel
			//this is needed so that the top panel is always on top of everything else
			topPanelInterval = setInterval(topPanel, 1);
			//set the interval that check for and removes explosions
			explosionInt = setInterval(showExplosion, 400);
			//set the interval that calls on a timer value, which values determine the progression of the levels
			progressInt = setInterval(ProgressionTimer, 1);
		}
		//-------------------------------------------------------TOP PANEL
		public function topPanel(): void {
			//format the panel
			topPanelFormat.size = 20;
			topPanelFormat.color = 0xFFFAAAAA; //pastel pink
			topPanelFormat.bold = true;
			topPanelText.width = 400;
			topPanelText.height = 30;
			topPanelText.x = 0;
			topPanelText.y = 0;
			topPanelText.background = true;
			topPanelText.backgroundColor = 0x00000000;	//black 
			//display current level and going score
			topPanelText.text = "	Level: " + level.toString() + "		" + "Score: " + score.toString(); 
			topPanelText.setTextFormat(topPanelFormat);
			//format the healthbar of the player
			topPanelHealth.background = true;
			topPanelHealth.backgroundColor = 0x00FF0000;	//red
			topPanelHealth.width = playerLives * 20;	//it will display 20 px for each life the player still has
			topPanelHealth.height = 10;
			topPanelHealth.x = 335;
			topPanelHealth.y = 10;
			//add the top panel on the screen and then the health bar on top of it
			stage.addChild(topPanelText);
			stage.addChild(topPanelHealth);
		}
		//------------------------------------------------------BACKGROUND
		public function backgroundScroll1(): void {
			background1.y += 2;
			background11.y += 2;
			//reset background when done scrolling
			if (background1.y == 650) background1.y = -650;
			if (background11.y == 650) background11.y = -650;
		}
		public function backgroundScroll2(): void {
			background2.y += 5;
			background22.y += 5;
			//reset background when done scrolling
			if (background2.y == 650) background2.y = -650;
			if (background22.y == 650) background22.y = -650;
		}
		//----------------------------------------------GAME SCREEN KEYBOARD EVENTS
		private function playerMovement (e:KeyboardEvent): void{
			var key:uint = e.keyCode;
			//left arrow pressed
			if (key == 37){
				LeftArrowKeyPressed = true;
				plane.visible = false;	//hide the stasis plane
			}
			//right arrow pressed
			if (key == 39) {
				RightArrowKeyPressed = true;
				plane.visible = false;
			}
			//up arrow pressed
			if (key == 38) {
				UpArrowKeyPressed = true;
				plane.visible = false;
			}
			//down arrow pressed
			if (key == 40) {
				DownArrowKeyPressed = true;
				plane.visible = false;
			}
			//space bar presse
			if (key == 32) {
				fireAmmo();	//shoot the bullet
				ShootingClip.play();	//play the shooting sound
			}
			
		}
		
		public function endMovement(e: KeyboardEvent): void {
			var key:uint = e.keyCode;
			//left arrow released
			if (key == 37){
				LeftArrowKeyPressed = false;
				plane.visible = true;	//set the stasis plane back to visible
			}
			//right arrow released
			if (key == 39) {
				RightArrowKeyPressed = false;
				plane.visible = true;
			}
			//up arrow released
			if (key == 38) {
				UpArrowKeyPressed = false;
				plane.visible = true;
			}
			//down arrow released
			if (key == 40) {
				DownArrowKeyPressed = false;
				plane.visible = true;
			}
		}
		//-------------------------------------------------------MOVING PLAYER PLANE
		public function movePlane(): void {
			//all the if statements are handled under the same logic
			//only one if statement can be true per different key combination
			//left
			if (LeftArrowKeyPressed == true && UpArrowKeyPressed == false && DownArrowKeyPressed == false && RightArrowKeyPressed == false){
				plane.x -= 5;	//move the plane
				if (plane.x <= 0) plane.x = 0;	//handle the plane hitting the screen bounds
				
				planeMoveStraight.visible = false;	//only make the plane visible that appears to be flying left
				planeMoveLeft.visible = true;
				planeMoveRight.visible = false;
				planeMoveLeft.x = plane.x;
				planeMoveLeft.y = plane.y;
			}
			//left & up
			if (LeftArrowKeyPressed == true && UpArrowKeyPressed == true && DownArrowKeyPressed == false && RightArrowKeyPressed == false){
				plane.x -= 5;
				plane.y -= 5;
				if (plane.x <= 0) plane.x = 0;
				if (plane.y <= 0) plane.y = 0;
				
				planeMoveStraight.visible = false;
				planeMoveLeft.visible = true;
				planeMoveRight.visible = false;
				planeMoveLeft.x = plane.x;
				planeMoveLeft.y = plane.y;
			}
			//left & down
			if (LeftArrowKeyPressed == true && UpArrowKeyPressed==false && DownArrowKeyPressed==true && RightArrowKeyPressed==false){
				plane.x -= 5;
				plane.y += 5;
				if (plane.x <= 0) plane.x = 0;
				if (plane.y >= 576) plane.y = 576;
				
				planeMoveStraight.visible = false;
				planeMoveLeft.visible = true;
				planeMoveRight.visible = false;
				planeMoveLeft.x = plane.x;
				planeMoveLeft.y = plane.y;
			}
			//right
			if (RightArrowKeyPressed == true && UpArrowKeyPressed == false && DownArrowKeyPressed == false && LeftArrowKeyPressed == false ){
				plane.x += 5;
				if (plane.x >= 300) plane.x = 300;
				
				planeMoveStraight.visible = false;
				planeMoveLeft.visible = false;
				planeMoveRight.visible = true;
				planeMoveRight.x = plane.x;
				planeMoveRight.y = plane.y;
			}
			//right & up
			if (RightArrowKeyPressed == true && UpArrowKeyPressed == true && DownArrowKeyPressed == false && LeftArrowKeyPressed == false ){
				plane.x += 5;
				plane.y -= 5;
				if (plane.x >= 300) plane.x = 300;
				if (plane.y <= 0) plane.y = 0;
				
				planeMoveStraight.visible = false;
				planeMoveLeft.visible = false;
				planeMoveRight.visible = true;
				planeMoveRight.x = plane.x;
				planeMoveRight.y = plane.y;
			}
			//right & down
			if (RightArrowKeyPressed == true && UpArrowKeyPressed == false && DownArrowKeyPressed == true && LeftArrowKeyPressed == false ){
				plane.x += 5;
				plane.y += 5;
				if (plane.x >= 300) plane.x = 300;
				if (plane.y >= 576) plane.y = 576;
				
				planeMoveStraight.visible = false;
				planeMoveLeft.visible = false;
				planeMoveRight.visible = true;
				planeMoveRight.x = plane.x;
				planeMoveRight.y = plane.y;
			}
			//up
			if (RightArrowKeyPressed == false && UpArrowKeyPressed == true && DownArrowKeyPressed == false && LeftArrowKeyPressed == false ){
				plane.y -= 5;
				if (plane.y <= 0) plane.y = 0;
				
				planeMoveStraight.visible = true;
				planeMoveLeft.visible = false;
				planeMoveRight.visible = false;
				planeMoveStraight.x = plane.x;
				planeMoveStraight.y = plane.y;
			}
			//down
			if (RightArrowKeyPressed == false && UpArrowKeyPressed == false && DownArrowKeyPressed == true && LeftArrowKeyPressed == false){
				plane.y += 5;
				if (plane.y >= 576) plane.y = 576;
				
				planeMoveStraight.visible = true;
				planeMoveLeft.visible = false;
				planeMoveRight.visible = false;
				planeMoveStraight.x = plane.x;
				planeMoveStraight.y = plane.y;
			}
			//none
			if (LeftArrowKeyPressed == false && UpArrowKeyPressed == false && DownArrowKeyPressed == false && RightArrowKeyPressed == false ){
				planeMoveStraight.visible = false;	//when no arrows are pressed, all the different flight planes are not visible, only stasis plane is
				planeMoveLeft.visible = false;
				planeMoveRight.visible = false;
			}
		}
		//--------------------------------------------BULLET ARRAY HANDLING AND SHOOTING HANDLING
		//shooting a bullet
		public function fireAmmo(): void{
			ammoArray.push(ammo = new bullet);	//create a new bullet in the bullet array
			ammo.x = plane.x+45;	//set the bullet in front of the player plane
			ammo.y = plane.y;
			stage.addChild(ammo);	//add the bullet onto the screen
		}
		//moving a bullet
		public function moveAmmo(): void{
			for (var i:int = 0; i < ammoArray.length; i++){		//move the bullets
				ammoArray[i].y -= 10;
			}
			for (var ii:int = 0; ii < ammoArray.length; ii++){		//if the bullet reaches the top of the screen, remove it
				if (ammoArray[ii].y <= 0) {
					stage.removeChild(ammoArray[ii]);
					ammoArray.shift();
					ii--;	//adjust the count of the foor loop
				}
			}
		}
		//--------------------------------------------ENEMY SPAWNING AND LEVEL ADVANCING
		public function enemySpawn(): void{
			//-------------------LEVEL 1
			if (level == 1) {
				for (var i:int = 0; i < 4; i++){
					createGreenEnemies();	//spawn 4 green planes at level 1
				}
			}
			//-------------------LEVEL 2
			if (level == 2) {
				createRedEnemies();		//spawn an additional red plane at level 2
			}
			//-------------------LEVEL 3
			if (level == 3) {
				createRedEnemies();		//spawn an additional red plane at level 3
			}
			//-------------------LEVEL 4
			if (level == 4) {
				createGreenEnemies();
				createRedEnemies();		//spawn additional green and red plane at level 4
			}
			//-------------------LEVEL 5
			if (level == 5){
				createGreenEnemies();
				createRedEnemies();		//spawn additional green and red plane at level 5
			}
			//--------------BOSS LEVEL
			if (level == 6){
				createBlueEnemies();	//spawn boss plane at level 6
			}
		}
		//-------------------------------------------------------------------------random coordinates
		public function randomCoordGen(): void{
			var i:int = Math.random() * 321;
			randX = i;
			var ii:int = Math.random() * 101;
			randY = ii - 159;
		}
		//----------------------------------------------------------------create different enemy planes
		public function createGreenEnemies(): void{
			enemyArray.push(planeGreen = new enemyGreen);	//create a plane and add it to the enemy array
			randomCoordGen();
			planeGreen.x = randX;
			planeGreen.y = randY;
			stage.addChild(planeGreen);
		}
		public function createRedEnemies(): void{
			enemyArray.push(planeRed = new enemyRed);	//create a plane and add it to the enemy array
			randomCoordGen();
			planeRed.x = randX;
			planeRed.y = randY;
			stage.addChild(planeRed);
		}
		public function createBlueEnemies(): void {	
			planeBlue = new enemyBlue();	//the boss plane is separate from the enemey array
			planeBlue.x = 155;
			planeBlue.y = -80;
			stage.addChild(planeBlue);
		}
		//---------------------------------------------------------------------HANDLE ENEMY PLANES
		public function moveEnemy(): void{
			for (var i:int = 0; i < enemyArray.length; i++){
				//different movement speeds for different levels
				if (level == 1 || level == 2)
					enemyArray[i].y += 3;
				if (level == 3 || level == 4 || level == 5)
					enemyArray[i].y += 4;
				//get out of the screen for boss fight
				if (level == 6) {
					enemyArray[i].y = 718;
					enemyArray[i].visible = false;
				}
				//reset back up top if they were not destroyed by player and reached bottom of the screen (off screen)
				if (enemyArray[i].y >= 728) {
					randomCoordGen();
					enemyArray[i].x = randX;
					enemyArray[i].y = randY;
				}
				//if collides with bullet
				for (var ii:int = 0; ii < ammoArray.length; ii++){
					if (ammoArray[ii].hitTestObject(enemyArray[i])) {
						//play sound
						HitClip.play();
						//replace plane with explosion image
						enemyArray[i].visible = false;
						explosionArray.push(planeExplosion = new explosion);
						planeExplosion.x = enemyArray[i].x;
						planeExplosion.y = enemyArray[i].y;
						stage.addChild(planeExplosion);
						//reset plane up top
						randomCoordGen();
						enemyArray[i].x = randX;
						enemyArray[i].y = randY;
						enemyArray[i].visible = true;
						//remove the bullet
						stage.removeChild(ammoArray[ii]);
						ammoArray.removeAt(ii);
						ii--;
						//add to score
						score += 1000;
					}
				}
				//collides with player plane
				if (enemyArray[i].hitTestObject(plane)){
						//play sound
						HitClip.play();
						//replace plane with explosion image
						enemyArray[i].visible = false;
						explosionArray.push(planeExplosion = new explosion);
						planeExplosion.x = enemyArray[i].x;
						planeExplosion.y = enemyArray[i].y;
						stage.addChild(planeExplosion);
						//reset plane up top
						randomCoordGen();
						enemyArray[i].x = randX;
						enemyArray[i].y = randY;
						enemyArray[i].visible = true;
						//take away one player health point
						playerLives--;
				}
				//if player lives go into negative numbers, get the game over screen going
				if (playerLives == -1) {
					endGame();		//load the function that handles the end of the game if the player dies
				}
			}
			
		}
		//--------------------------------------------------------------TIMER AND PROGRESSION OF LEVELS
		public function ProgressionTimer(): void{
			timer++;	//increment the timer every time the progression function is called on by the interval
			//handle displaying the prompts and removing the promts of level and boss progression
			if (timer == 1) {
				lvl1 = new level1();
				lvl1.x = 100;
				lvl1.y = 294;
				stage.addChild(lvl1);
			}
			if (timer == 100) {
				stage.removeChild(lvl1);
			}
			if (timer == 1000) {
				level++;
				enemySpawn();
				lvl2 = new level2();
				lvl2.x = 100;
				lvl2.y = 294;
				stage.addChild(lvl2);
			}
			if (timer == 1100){
				stage.removeChild(lvl2);
			}
			if (timer == 2000) {
				level++;
				enemySpawn();
				lvl3 = new level3();
				lvl3.x = 100;
				lvl3.y = 294;
				stage.addChild(lvl3);
			}
			if (timer == 2100){
				stage.removeChild(lvl3);
			}
			if (timer == 3000) {
				level++;
				enemySpawn();
				lvl4 = new level4();
				lvl4.x = 100;
				lvl4.y = 294;
				stage.addChild(lvl4);
			}
			if (timer == 3100){
				stage.removeChild(lvl4);
			}
			if (timer == 4000){
				level++;
				enemySpawn();
				lvl5 = new level5();
				lvl5.x = 100;
				lvl5.y = 294;
				stage.addChild(lvl5);
			}
			if (timer == 4100){
				stage.removeChild(lvl5);
			}
			if (timer == 5000){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, playerMovement);	//remove player movement as the boss fight is starting
				level++;
				enemySpawn();
				lvlboss = new levelboss();
				lvlboss.x = 100;
				lvlboss.y = 286;
				stage.addChild(lvlboss);
				//reset the player back to the bottom of the screen
				plane.x = 150;
				plane.y = 500;
			}
			if (timer == 5100){
				stage.removeChild(lvlboss);
				bossInt = setInterval(bossMovement, 50);	//start up the interval that handles the boss plane
				bossShooting = setInterval(bossShootingBullets, 3000); 		//start up the interval that handles creating and shooting the boss plane bullet
			}
			if (timer == 5300){
				stage.addEventListener(KeyboardEvent.KEY_DOWN, playerMovement);	//once the boss is done coming into the stage and starts firing, restart the player movement
			}
		}
		//--------------------------------------------------------------------------------------HANDLE BOSS PLANE
		public function bossMovement(): void{
			planeBlue.y += 5;	//move the boss plane down towards the player
			if (planeBlue.y >= 150){	//if the boss plane reaches a certain point on y axes, only make it move back and forth on x axis
				planeBlue.y = 150;
				if (bossDirection == 1) 	//change between the directions to handle the boss plane the sides of the screen
					planeBlue.x += 10; 
				if (bossDirection == 2)	
					planeBlue.x -= 10;
				if (planeBlue.x >= 300)
					bossDirection = 2;
				if (planeBlue.x <= 0)
					bossDirection = 1;
			}
			//handle the boss shooting bullets at the player
			//moving a bullet
			for (var b:int = 0; b < bossAmmoArray.length; b++){		//move the bullets
				bossAmmoArray[b].y += 10;
			}
			for (var ii:int = 0; ii < bossAmmoArray.length; ii++){		//if the bullet reaches the bottom of the screen, remove it
				if (bossAmmoArray[ii].y >= 650) {
					stage.removeChild(bossAmmoArray[ii]);
					bossAmmoArray.shift();
					ii--;	//adjust the count of the for loop
				}
				//if the boss plane bullet hits a player
				if (bossAmmoArray[ii].hitTestObject(plane)) {
					//play the sound
					HitClip.play();
					//show and explosion
					explosionArray.push(planeExplosion = new explosion);
					planeExplosion.x = plane.x;
					planeExplosion.y = plane.y;
					stage.addChild(planeExplosion);
					//remove the bullet
					stage.removeChild(bossAmmoArray[ii]);
					bossAmmoArray.removeAt(ii);
					ii--;
					//take one life point from the player
					playerLives--;
				}
			}
			//handle hitting the boss plane with bullets
			for (var i:int = 0; i < ammoArray.length; i++){
				if (planeBlue.hitTestObject(ammoArray[i])) {
					//play sound
					HitClip.play();
					//remove the bullet
					stage.removeChild(ammoArray[i]);
					ammoArray.removeAt(i);
					i--;
					//take a point away from the boss health points
					bossHits--;
					//when the boss has no more health points
					if (bossHits == 0) {
						//replace plane with explosion image
						planeBlue.visible = false;
						explosionArray.push(planeExplosion = new explosion);
						planeExplosion.x = planeBlue.x;
						planeExplosion.y = planeBlue.y;
						stage.addChild(planeExplosion);
						//push the boss plane with the rest of the discarded planes off the screen at the bottom
						planeBlue.x = planeBlue.x;
						planeBlue.y = 750;
						//add to score
						score += 5000;
						//load up the function that handles the end of the game if the player wins
						gameWin();
					}
				}
			}
		}
		//------------------------------------------------------------------------HANDLE BOSS SHOOTING BULLETS
		public function bossShootingBullets(): void {
			//shooting a bullet
			bossAmmoArray.push(ammo = new bullet);	//create a new bullet in the bullet array
			ammo.rotation = 180;	//rotate the bullet upside down
			ammo.x = planeBlue.x+40;	//set the bullet in front of the boss plane
			ammo.y = planeBlue.y+52;
			stage.addChild(ammo);	//add the bullet onto the screen
			
		}
		//----------------------------------------------------------------------------HANDLE REMOVING EXPLOSIONS
		public function showExplosion(): void {
			for (var i:int = 0; i < explosionArray.length; i++) {
				stage.removeChild(explosionArray[i]);
				explosionArray.shift();
				i--;
			}
		}
		//----------------------------------------------------------------------------GAME WIN
		public function gameWin(): void{
			//clear all intervals and input of the game
			clearInterval(firstBackgroundTimer);
			clearInterval(secondBackgroundTimer);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, playerMovement);
			stage.removeEventListener(KeyboardEvent.KEY_UP, endMovement);
			clearInterval(planeMoveInt);
			clearInterval(ammoMoveInt);
			clearInterval(enemyMoveInt);
			clearInterval(topPanelInterval);
			clearInterval(explosionInt);
			clearInterval(progressInt);
			clearInterval(bossInt);
			clearInterval(bossShooting);
			//clear everything used in the game off the screen
			stage.removeChild(background1);
			stage.removeChild(background11);
			stage.removeChild(background2);
			stage.removeChild(background22);
			stage.removeChild(plane);
			stage.removeChild(planeMoveLeft);
			stage.removeChild(planeMoveRight);
			stage.removeChild(planeMoveStraight);
			stage.removeChild(topPanelText);
			stage.removeChild(planeBlue);
			//clear the arrays
			for (var a:int = 0; a < ammoArray.length; a++){
				stage.removeChild(ammoArray[a]);
			}
			ammoArray.splice(0);
			for (var e:int = 0; e < enemyArray.length; e++){
				stage.removeChild(enemyArray[e]);
			}
			enemyArray.splice(0);
			for (var ex: int = 0; ex < explosionArray.length; ex++){
				stage.removeChild(explosionArray[ex]);
			}
			explosionArray.splice(0);
			for (var b: int = 0; b < bossAmmoArray.length; b++){
				stage.removeChild(bossAmmoArray[b]);
			}
			bossAmmoArray.splice(0);
			//load up the win screen
			win = new WinLogo();
			win.x = 0;
			win.y = 0;
			stage.addChild(win);
			//---------------------------------adding timed displayed messages
			winScreenInterval = setInterval(showWinScreenMessages, 1000);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, backToStart);
			backToStartInt = 1;	//mark  for the keyboard event handler that the input is handled from the winning game condition
		}
		//-------------------------------------------------------------------------ADDING TIMED MESSAGES
		public function showWinScreenMessages(): void {
			if (winlossProgression == 1){
				winlossMessage1Format.size = 20;
				winlossMessage1Format.color = 0xFFFFFFFF; //white
				winlossMessage1Format.bold = true;
				winlossMessage1Text.width = 400;
				winlossMessage1Text.height = 30;
				winlossMessage1Text.x = 150;
				winlossMessage1Text.y = 400;
				winlossMessage1Text.background = true;
				winlossMessage1Text.backgroundColor = 0x00000000;
				winlossMessage1Text.text = "+1 000 000 POINTS!";	//display that the player gets a million extra points
				winlossMessage1Text.setTextFormat(winlossMessage1Format);
				stage.addChild(winlossMessage1Text);
				score += 1000000;
			}
			if (winlossProgression == 3){
				winlossMessage2Text.width = 400;
				winlossMessage2Text.height = 30;
				winlossMessage2Text.x = 100;
				winlossMessage2Text.y = 450;
				winlossMessage2Text.background = true;
				winlossMessage2Text.backgroundColor = 0x00000000;
				winlossMessage2Text.text = "Total Score: " + score.toString(); // display the final score
				winlossMessage2Text.setTextFormat(winlossMessage1Format);
				stage.addChild(winlossMessage2Text);
			}
			if (winlossProgression == 5){
				stage.addChild(pressSpace);	//display the image prompting to press the space button
			}
			winlossProgression++;
		}
		//---------------------------------------------------------------------------GAME LOSS
		public function endGame(): void{
			//clear all intervals and input of the game
			clearInterval(firstBackgroundTimer);
			clearInterval(secondBackgroundTimer);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, playerMovement);
			stage.removeEventListener(KeyboardEvent.KEY_UP, endMovement);
			clearInterval(planeMoveInt);
			clearInterval(ammoMoveInt);
			clearInterval(enemyMoveInt);
			clearInterval(topPanelInterval);
			clearInterval(explosionInt);
			clearInterval(progressInt);
			if (level == 6){
				clearInterval(bossInt);
				clearInterval(bossShooting);
			}
			//clear everything used in the game off the screen
			stage.removeChild(background1);
			stage.removeChild(background11);
			stage.removeChild(background2);
			stage.removeChild(background22);
			stage.removeChild(plane);
			stage.removeChild(planeMoveLeft);
			stage.removeChild(planeMoveRight);
			stage.removeChild(planeMoveStraight);
			stage.removeChild(topPanelText);
			stage.removeChild(topPanelHealth);
			if (level == 1 && timer <= 100)
				stage.removeChild(lvl1);
			if (level == 2 && timer <= 1100)
				stage.removeChild(lvl2);
			if (level == 3 && timer <= 2100)
				stage.removeChild(lvl3);
			if (level == 4 && timer <= 3100)
				stage.removeChild(lvl4);
			if (level == 5 && timer <= 4100)
				stage.removeChild(lvl5);
			if (level == 6) {
				stage.removeChild(planeBlue);
				if (timer <= 5100)
					stage.removeChild(lvlboss);
			}
			//clear the arrays
			for (var a:int = 0; a < ammoArray.length; a++){
				stage.removeChild(ammoArray[a]);
			}
			ammoArray.splice(0);
			for (var e:int = 0; e < enemyArray.length; e++){
				stage.removeChild(enemyArray[e]);
			}
			enemyArray.splice(0);
			for (var ex: int = 0; ex < explosionArray.length; ex++){
				stage.removeChild(explosionArray[ex]);
			}
			explosionArray.splice(0);
			if (level == 6) {
				for (var b: int = 0; b < bossAmmoArray.length; b++){
					stage.removeChild(bossAmmoArray[b]);
				}
				bossAmmoArray.splice(0);
			}
			//display end screen 
			loss = new LossLogo();
			loss.x = 0;
			loss.y = 0;
			stage.addChild(loss);
			//---------------------------------adding timed displayed messages
			lossScreenInterval = setInterval(showLossScreenMessages, 1000);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, backToStart);
			backToStartInt = 2; //mark  for the keyboard event handler that the input is handled from the lost game condition
		}
		//------------------------------------------------------adding timed displayed messages
		public function showLossScreenMessages(): void {
			if (winlossProgression == 1){
				winlossMessage1Format.size = 20;
				winlossMessage1Format.color = 0xFFFFFFFF; //white
				winlossMessage1Format.bold = true;
				winlossMessage1Text.width = 400;
				winlossMessage1Text.height = 30;
				winlossMessage1Text.x = 150;
				winlossMessage1Text.y = 400;
				winlossMessage1Text.background = true;
				winlossMessage1Text.backgroundColor = 0x00000000;
				winlossMessage1Text.text = "Better luck next time!";	//wish the player better luck next time
				winlossMessage1Text.setTextFormat(winlossMessage1Format);
				stage.addChild(winlossMessage1Text);
			}
			if (winlossProgression == 3){
				winlossMessage2Text.width = 400;
				winlossMessage2Text.height = 30;
				winlossMessage2Text.x = 100;
				winlossMessage2Text.y = 450;
				winlossMessage2Text.background = true;
				winlossMessage2Text.backgroundColor = 0x00000000;
				winlossMessage2Text.text = "Total Score: " + score.toString();	//display the final score
				winlossMessage2Text.setTextFormat(winlossMessage1Format);
				stage.addChild(winlossMessage2Text);
			}
			if (winlossProgression == 5){
				stage.addChild(pressSpace);	//display the image prompting the player to press space
			}
			winlossProgression++;
		}
		//------------------------------------------------------WIN/LOSS SCREEN KEYBOARD INPUT
		public function backToStart(e:KeyboardEvent): void {
			var key:uint = e.keyCode;
			//if space bar is pressed
			if (key == 32){
				if (backToStartInt == 1 && winlossProgression >= 6){ //only if the event is running from the winning game screen and the "press space" image is displayed
					//clear intervals and remove keyboard event handlers and content from the screen
					clearInterval(winScreenInterval);
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, backToStart);
					stage.removeChild(win);
					stage.removeChild(winlossMessage1Text);
					stage.removeChild(winlossMessage2Text);
					stage.removeChild(pressSpace);
					//return back to start of the screen by running the start screen function
					startScreen();
				}
				if (backToStartInt == 2 && winlossProgression >= 6){	//only if the event is running from the lost game screen and the "press space" image is displayed
					//clear intervals and remove keyboard event handlers and content from the screen
					clearInterval(lossScreenInterval);
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, backToStart);
					stage.removeChild(loss);
					stage.removeChild(winlossMessage1Text);
					stage.removeChild(winlossMessage2Text);
					stage.removeChild(pressSpace);
					//return back to start of the screen by running the start screen function
					startScreen();
				}
			}
		}
	}
}