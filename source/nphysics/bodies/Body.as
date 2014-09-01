package nphysics.bodies {
    import ngine.core.Entity;

    import nmath.vectors.Vector2D;

    import nphysics.world.Manifold;

    import starling.display.DisplayObject;

    public class Body extends Entity {
		private static const GRAVITY:Number = 9.81;
		
		private var _mass:Number;
		private var _restitution:Number;
		private var _invMass:Number;
		
		private var _oldVelocity:Vector2D;
		
		public var friction:Number;
		
		public function Body() {
			super();
			
			_mass    = 0;
			_invMass = 0;
			
			_restitution = 0;
			
			friction = 0;
			
			_oldVelocity = Vector2D.ZERO;
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
			_mass = pValue * 1000;
			
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
		
		public function touch(pManifold:Manifold):void {
			
		};
		
		override public function update(pElapsed:Number):void {
			_oldVelocity.x = _velocity.x;
			_oldVelocity.y = _velocity.y;
			
			_velocity.y += (_mass / GRAVITY) * pElapsed;
			
			_position.x += (_velocity.x + _oldVelocity.x) * 0.5 * pElapsed;
			_position.y += (_velocity.y + _oldVelocity.y) * 0.5 * pElapsed;
			
			_canvas.x = _position.x;
			_canvas.y = _position.y;
		};
		
		override public function handleCollision(pTarget:Entity):void {
			
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_oldVelocity.zero();
		};
		
		override public function dispose():void {
			super.dispose();
			
			_pool.put(_oldVelocity);
			_oldVelocity = null;
		};
	};
}