﻿package  {
	
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	import flash.events.KeyboardEvent;
	
	public class AwesomeGame extends MovieClip 
	{
		public var gameTimer:Timer;
		public var avatar:Avatar;
		public var enemies:Array;
		public var enemyCounter:int;
		public var burgers:Array;
		public var burgerCounter:int;
		public var sky:Background;
		public var gradient:Background;
		public var grass:Grass;
		public var nextArrow:Arrow;
		public var txt:TextField;
		public var score:int;
		public var pauseGame;
		
        private static var lastFrame:int = 0;
        private static var currFrame:int;
        private static var dT:Number;

		public function AwesomeGame() 
		{
			score = 0;
			
			pauseGame = false;

			sky = new Background();
			addChild(sky);
			gradient = new Background();
			addChild(gradient);
			grass = new Grass();
			addChild(grass);
			
			nextArrow = new Arrow();
			addChild(nextArrow);
			nextArrow.visible = false;

			avatar = new Avatar();
			addChild(avatar);

			enemies = new Array();
			enemyCounter = 1;
			
			burgers = new Array();
			burgerCounter = 1;
			
			txt = newText(24, 10, 5, "0", 0x0000da);

			gameTimer = new Timer( 25 );
			gameTimer.addEventListener( TimerEvent.TIMER, tick );
			gameTimer.start();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		function keyPressed(keyEvent:KeyboardEvent) {
			if (keyEvent.keyCode == 32) {
				if (!pauseGame){
					pauseGame = true;
				} else if (pauseGame){
					pauseGame = false;
				}
			}
		}

		public function newText(fontSize:int, x:Number, y:Number, str:String, color:uint):TextField
		{
			txt = new TextField();
			
			// set properties to define the text field
			txt.defaultTextFormat = new TextFormat('Verdana', fontSize, color);
			txt.x = x;                     //  Distance from the left edge
			txt.y = y;                     // Distance from the top edge
			txt.width = stage.stageWidth/2;                // Lenght of the text field
			txt.background = false;           // Disables to display the background colors
			txt.border = false;               // Disables to display the border
			txt.text = str;     // Adds text
			txt.autoSize = "left";
			addChild(txt);
			
			return(txt);
		}
		
		public function addEnemy(enemy:Enemy):void
		{
			enemies.push(enemy);
			addChild(enemy);
			enemy.gotoAndStop(1);
		}
 
		public function addBurger(burger:Burger):void
		{
			burgers.push(burger);
			addChild(burger);
		}
 
		public function tick( timerEvent:TimerEvent ):void 
		{
			currFrame = getTimer();
			dT = (currFrame - lastFrame) / 50;
			lastFrame = currFrame;
			
			if(!pauseGame){
				avatar.update(dT);
				for(var i:int = enemies.length-1; i >= 0; i--) {
					enemies[i].update(dT);
					if (distance(enemies[i].x,  enemies[i].y, avatar.x, avatar.y)<13){
						enemies[i].remove();
						enemies[i].gotoAndStop(2);
						score--;
					}
					if (enemies[i].trash){
						removeChild(enemies[i]);
						enemies.splice(i, 1);
					}
				}
				
				for(var i:int = burgers.length-1; i >= 0; i--) {
					burgers[i].update(dT);
					if (burgers[i].hitTestObject(avatar)){
						burgers[i].remove();
						score++;
					}
					if (burgers[i].trash){
						removeChild(burgers[i]);
						burgers.splice(i, 1);
					}
				}
				
				var red:int = int(83 + 70 * Math.min(255, score)/100.0);
				var green:int = int(152 - 132 * Math.min(255, score)/100.0);
				var blue:int = int(255 - 235 * Math.min(255, score)/100.0);
				
				var colorTransform:ColorTransform = new ColorTransform(0,0,0,0,red,green,blue,1000);
				sky.transform.colorTransform = colorTransform;
				
				score++;
				txt.text = score.toString() + "/100";
				if(score >= 100){
					nextArrow.visible = true;
				}
				enemyCounter--;
				if(enemyCounter == 0){
					addEnemy(new Enemy());
					enemyCounter = 20 + Math.random() * 30;
				}
				burgerCounter--;
				if(burgerCounter == 0){
					addBurger(new Burger());
					burgerCounter = 20 + Math.random() * 30;
				}
			}
		}
		
		public function distance( x1:Number, y1:Number, x2:Number, y2:Number ):Number
		{
			var dx;
			var dy;
			var distance;
			dx = x2-x1;
			dy = y2-y1;
			distance = Math.sqrt(dx*dx+dy*dy);
			return distance;
		}
	}
}