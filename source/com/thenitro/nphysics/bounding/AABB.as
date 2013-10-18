package com.thenitro.nphysics.bounding {
	import com.thenitro.ngine.math.vectors.Vector2D;
	import com.thenitro.ngine.pool.Pool;
	
	public class AABB extends Body {
		private var _max:Vector2D;
		
		public function AABB() {
			super();
			
			_max = Vector2D.ZERO;
		};
		
		override public function get reflection():Class {
			return AABB;
		};
		
		public function get max():Vector2D {
			return _max;
		};
		
		override public function poolPrepare():void {
			super.poolPrepare();
			
			_max.zero();
		};
		
		override public function dispose():void {
			super.dispose();
			
			_pool.put(_max);
			_max = null;
		};
	};
}