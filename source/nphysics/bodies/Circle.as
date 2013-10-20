package nphysics.bodies {
	public final class Circle extends Body {
		
		public function Circle() {
			super();
		};
		
		override public function get reflection():Class {
			return Circle;
		};
	};
}