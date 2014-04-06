package nphysics.world {
	import ngine.math.vectors.Vector2D;
	
	import nphysics.bodies.Body;
	
	import npooling.IReusable;
	import npooling.Pool;
	
	public final class Manifold implements IReusable {
		private static var _pool:Pool = Pool.getInstance();
		
		public var a:Body;
		public var b:Body;
		
		public var penetration:Number;
		
		private var _normal:Vector2D;
		
		public function Manifold() {
			_normal = Vector2D.ZERO;
		};
		
		public static function get EMPTY():Manifold {
			var result:Manifold = _pool.get(Manifold) as Manifold;
			
			if (!result) {
				result = new Manifold();
				_pool.allocate(Manifold, 1);
			}
			
			return result;
		};
		
		public function get reflection():Class {
			return Manifold;
		};
		
		public function get normal():Vector2D {
			return _normal;
		};
		
		public function poolPrepare():void {
			_normal.zero();
			
			a = null;
			b = null;
			
			penetration = 0;
		};
		
		public function dispose():void {
			_pool.put(_normal);
			_normal = null;
			
			a = null;
			b = null;
			
			penetration = 0;
		};
	}
}