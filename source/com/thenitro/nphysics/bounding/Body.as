package com.thenitro.nphysics.bounding {
	import com.thenitro.ngine.display.gameentity.Entity;
	import com.thenitro.ngine.math.TRectangle;
	
	import starling.display.DisplayObject;
	
	public class Body extends Entity {
		private var _mass:Number;
		private var _restitution:Number;
		private var _invMass:Number;
		
		private var _bounds:TRectangle;
		
		public function Body() {
			super();
			
			_invMass = 0;
			
			restitution = 0.2;
			mass = 100 * Math.random();
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
		
		public function init(pTexture:DisplayObject, 
							 pBounds:TRectangle):void {
			_canvas = pTexture;
			_bounds = pBounds;
		};
		
		override public function handleCollision(pTarget:Entity):void {
			
		};
		
		override public function update():void {
			super.update();
			
			if (_position.x < _bounds.position.x) {
				_position.x = _bounds.position.x;
				_velocity.x = -_velocity.x;
			} else if (_position.x > _bounds.size.x) {
				_position.x = _bounds.size.x;
				_velocity.x = -_velocity.x;
			}
			
			if (_position.y < _bounds.position.y) {
				_position.y = _bounds.position.y;
				_velocity.y = -_velocity.y;
			} else if (_position.y > _bounds.size.y) {
				_position.y = _bounds.size.y;
				_velocity.y = -_velocity.y;
			}
		};
	};
}