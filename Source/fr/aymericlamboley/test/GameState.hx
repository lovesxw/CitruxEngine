package fr.aymericlamboley.test;

import box2D.dynamics.contacts.B2Contact;

import com.citruxengine.core.CitruxEngine;
import com.citruxengine.core.State;
import com.citruxengine.math.MathVector;
import com.citruxengine.objects.CitruxSprite;
import com.citruxengine.objects.PhysicsObject;
import com.citruxengine.objects.platformer.Baddy;
import com.citruxengine.objects.platformer.Coin;
import com.citruxengine.objects.platformer.Crate;
import com.citruxengine.objects.platformer.Hero;
import com.citruxengine.objects.platformer.MovingPlatform;
import com.citruxengine.objects.platformer.Platform;
import com.citruxengine.objects.platformer.Sensor;
import com.citruxengine.physics.Box2D;
import com.citruxengine.utils.ObjectMaker;
import com.citruxengine.view.spriteview.AnimationSequence;

import com.eclecticdesignstudio.spritesheet.SpriteSheet;
import com.eclecticdesignstudio.spritesheet.importers.SpriteLoq;

import format.SWF;

import nme.Assets;
import nme.geom.Rectangle;

class GameState extends State<GameData> {

	public function new() {

		super();
	}

	override public function initialize():Void {

		super.initialize();
		
		_ce.gameData.dataChanged.add(_gameDataChanged);

		var box2d:Box2D = new Box2D("Box2D");
		//box2d.visible = true;
		add(box2d);

		//ObjectMaker.FromMovieClip(new SWF(Assets.getBytes("Assets/LevelA1.swf")).createMovieClip());

		var background:CitruxSprite = new CitruxSprite("background", {x:0, y:0, view:"Assets/background.jpg"});
		add(background);

		var physicsObject:Crate = new Crate("physicsObject", {x:250, y:200, width:70, height:75, view:"Assets/crate.png"});
		//var physicsObject:PhysicsObject = new PhysicsObject("physicsObject", {x:100, y:20});
		//var physicsObject:PhysicsObject = new PhysicsObject("physicsObject", {x:100, y:20, radius:20});
		add(physicsObject);

		//var movingPlatform:MovingPlatform = new MovingPlatform("movingPlatform", {x:430, y:120, width:120, height:20, endX:430, startY:20, endY:270});
		//add(movingPlatform);

		add(new Platform("platform1", {x:498, y:403, width:948, height:20}));
		add(new Platform("platform2", {x:0, y:202, width:20, height:404}));
		add(new Platform("platform3", {x:1278, y:363, width:624, height:20}));
		add(new Platform("platform4", {x:1566, y:165, width:20, height:404}));

		var spriteSheet:SpriteSheet = SpriteLoq.parse(ApplicationMain.getAsset("Assets/hero.xml"), "Assets");
		var hero:Hero = new Hero("hero", {x:100, y:20, width:60, height:135, view:new AnimationSequence(spriteSheet, "idle")});
		add(hero);

		spriteSheet = SpriteLoq.parse(ApplicationMain.getAsset("Assets/baddy.xml"), "Assets");
		var baddy:Baddy = new Baddy("baddy", {x:540, y:200, width:46, height:68, view:new AnimationSequence(spriteSheet, "walk")});
		add(baddy);

		var coin:Coin = new Coin("Coin", {x:Std.random(400), y:Std.random(300) + 100, radius:30, view:"Assets/jewel.png"});
		add(coin);
		coin.onBeginContact.add(_recoltCoin);

		view.setupCamera(hero, new MathVector(320, 240), new Rectangle(0, 0, 1550, 0), new MathVector(.25, .05));
	}

	private function _gameDataChanged(object:String, value:Dynamic):Void {

		trace(object + " - " + value);
	}

	private function _recoltCoin(ctc:B2Contact):Void {

		var hero:Hero = Std.is(ctc.m_fixtureA.getBody().getUserData(), Hero) ? ctc.m_fixtureA.getBody().getUserData() : Std.is(ctc.m_fixtureB.getBody().getUserData(), Hero) ? ctc.m_fixtureB.getBody().getUserData() : null;
		
		if (hero != null) {

			remove(Std.is(ctc.m_fixtureA.getBody().getUserData(), Coin) ? ctc.m_fixtureA.getBody().getUserData() : ctc.m_fixtureB.getBody().getUserData());
			_ce.sound.playSound("collect");
		}
	}
}