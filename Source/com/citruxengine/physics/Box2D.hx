package com.citruxengine.physics;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2World;

import com.citruxengine.core.CitruxEngine;
import com.citruxengine.core.CitruxObject;
import com.citruxengine.view.ISpriteView;
import com.citruxengine.view.spriteview.Box2DDebugArt;

import nme.display.Sprite;

/**
 * This is a simple wrapper class that allows you to add a Box2D world to your game's state.
 * Add an instance of this class to your State before you create any phyiscs bodies. It will need to 
 * exist first, or your physics bodies will throw an error when they try to create themselves.
 */
class Box2D extends CitruxObject, implements ISpriteView {

	public var world(getWorld, never):B2World;
	public var scale(getScale, never):Int;
	public var gravity(getGravity, setGravity):B2Vec2;

	public var x(getX, never):Float;
	public var y(getY, never):Float;
	public var parallax(getParallax, never):Float;
	public var rotation(getRotation, never):Float;
	public var group(getGroup, setGroup):Int;
	public var visible(getVisible, setVisible):Bool;
	public var view(getView, never):Dynamic;
	public var animation(getAnimation, never):String;
	public var inverted(getInverted, never):Bool;
	public var offsetX(getOffsetX, never):Float;
	public var offsetY(getOffsetY, never):Float;
	public var registration(getRegistration, never):String;

	private var _contactListener:Box2DContactListener;

	var _world:B2World;
	var _scale:Int;
	var _gravity:B2Vec2;

	var _visible:Bool;
	var _group:Int;
	var _view:Dynamic;

	public function new(name:String, params:Dynamic = null) {

		_visible = false;
		_group = 1;
		_scale = 30;
		_gravity = new B2Vec2(0, 15);
		_view = Box2DDebugArt;

		super(name, params);

		_world = new B2World(_gravity, true);
		_contactListener = new Box2DContactListener();

		_world.setContactListener(_contactListener);
	}

	override public function destroy():Void {

		super.destroy();
	}

	override public function update(timeDelta:Float):Void {

		super.update(timeDelta);

		// 0.05 = 1 / 20
		_world.step(0.05, 8, 8);
		_world.clearForces();
	}

	public function getWorld():B2World {
		return _world;
	}

	/**
	 * This is hard to grasp, but Box2D does not use pixels for its physics values. Cutely, it uses meters
	 * and forces us to convert those meter values to pixels by multiplying by 30. If you don't multiple Box2D
	 * values by 30, your objecs will look very small and will appear to move very slowly, if at all.
	 * This is a reference to the scale number by which you must multiply your values to properly display physics objects. 
	 */	
	public function getScale():Int {
		return _scale;
	}

	public function getGravity():B2Vec2 {
		return _gravity;
	}

	public function setGravity(value:B2Vec2):B2Vec2 {
		return _gravity = value;
	}

	public function getX():Float {
		return 0;
	}

	public function getY():Float {
		return 0;
	}

	public function getParallax():Float {
		return 1;
	}

	public function getRotation():Float {
		return 0;
	}

	public function getGroup():Int {
		return _group;
	}

	public function setGroup(value:Int):Int {
		return _group = value;
	}

	public function getVisible():Bool {
		return _visible;
	}

	public function setVisible(value:Bool):Bool {
		return _visible = value;
	}

	public function getView():Dynamic {
		return _view;
	}

	public function getAnimation():String {
		return "";
	}

	public function getInverted():Bool {
		return false;
	}

	public function getOffsetX():Float {
		return 0;
	}

	public function getOffsetY():Float {
		return 0;
	}

	public function getRegistration():String {
		return "topLeft";
	}
}