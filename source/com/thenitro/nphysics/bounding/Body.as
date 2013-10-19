package com.thenitro.nphysics.bounding {
	import com.thenitro.ngine.display.gameentity.Entity;
	import com.thenitro.ngine.math.TRectangle;
	
	import starling.display.DisplayObject;
	
	public class Body extends Entity {
		private var _mass:Number;
		private var _restitution:Number;
		private var _invMass:Number;
		
		public var friction:Number;
		
		public function Body() {
			super();
			
			_invMass = 0;
			
			///friction = Math.random();
		};
		
		override public function get reflection():Class {
			return Body;
		};
		
		public function set restitution(pValue:Number):void {
			_restitution = pValue;
		};
		
		public function get restitution():Number {
			return _restitution;
		};
		
		public function set mass(pValue:Number):void {
			_mass = pValue;
			
			if (_mass != 0) {
				_invMass = 1 / _mass;
			}
		};
		
		public function get mass():Number {
			return _mass;
		};
		
		public function get invMass():Number {
			return _invMass;
		};
		
		public function init(pTexture:DisplayObject):void {
			_canvas = pTexture;
		};
		
		override public function handleCollision(pTarget:Entity):void {
			
		};
		
		override public function update(pElapsed:Number):void {
			_velocity.y += _mass / 10;
			
			super.update(pElapsed);
		};
	};
}