package nphysics.bodies {
	import com.thenitro.ngine.math.vectors.Vector2D;
	import com.thenitro.ngine.pool.Pool;
	
	public final class Circle extends Body {
		
		public function Circle() {
			super();
		};
		
		override public function get reflection():Class {
			return Circle;
		};
	};
}