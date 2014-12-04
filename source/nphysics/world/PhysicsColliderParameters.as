package nphysics.world {
	import ngine.core.collider.abstract.IColliderParameters;
	
	import npooling.IReusable;
	import npooling.Pool;
	
	public final class PhysicsColliderParameters implements IColliderParameters, IReusable {
		private static var _pool:Pool = Pool.getInstance();

        private var _disposed:Boolean;

		private var _world:World;
		
		private var _gridSize:Number;
		
		private var _correction:Number;
		private var _slope:Number;
		
		private var _accumulator:Number;
		private var _dt:Number;
		
		public function PhysicsColliderParameters() {
		};
		
		public static function get NEW():PhysicsColliderParameters {
			var results:PhysicsColliderParameters = 
				_pool.get(PhysicsColliderParameters) as PhysicsColliderParameters;
			
			if (!results) {
				results = new PhysicsColliderParameters();
				_pool.allocate(PhysicsColliderParameters, 1);
			}
			
			return results;
		};
		
		public function get reflection():Class {
			return PhysicsColliderParameters;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function get colliderMethod():Function {
			return null;
		};
		
		public function get world():World {
			return _world
		};
		
		public function get gridSize():Number {
			return _gridSize;
		};
		
		public function get correction():Number {
			return _correction;
		};
		
		public function get slope():Number {
			return _slope;
		};
		
		public function get dt():Number {
			return _dt;
		};
		
		public function init(pWorld:World, pGridSize:Number, 
							 pCorrection:Number, pSlope:Number,
							 pFrameRate:Number):void {
			_world = pWorld;
			
			_gridSize = pGridSize;
			
			_correction = pCorrection;
			_slope      = pSlope;
			
			_dt = 1 / pFrameRate;
		};
		
		public function poolPrepare():void {
			_world = null;
		};
		
		public function dispose():void {
            _disposed = true;
			_world = null;
		};
	}
}