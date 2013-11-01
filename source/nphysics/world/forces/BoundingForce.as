package nphysics.world.forces {
	import ngine.core.Entity;
	import ngine.math.TRectangle;
	
	import nphysics.bodies.Body;
	
	public final class BoundingForce extends AbstractForce {
		private var _bounds:TRectangle;
		
		public function BoundingForce() {
			super();
		};
		
		public function init(pBounds:TRectangle):void {
			_bounds = pBounds;
		};
		
		override public function applyTo(pBody:Entity):void {
			super.applyTo(pBody);
			
			if (pBody.position.x < _bounds.position.x) {
				pBody.position.x = _bounds.position.x;
				pBody.velocity.x = -pBody.velocity.x;
			} else if (pBody.position.x > _bounds.size.x) {
				pBody.position.x = _bounds.size.x;
				pBody.velocity.x = -pBody.velocity.x;
			}
			
			if (pBody.position.y < _bounds.position.y) {
				pBody.position.y = _bounds.position.y;
				pBody.velocity.y = -pBody.velocity.y;
			} else if (pBody.position.y > _bounds.size.y) {
				pBody.position.y = _bounds.size.y;
				pBody.velocity.y = -pBody.velocity.y;
			}
		};
	};
}