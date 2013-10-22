package nphysics.bodies {
	public class Circle extends Body {
		
		public function Circle() {
			super();
		};
		
		override public function get reflection():Class {
			return Circle;
		};
	};
}