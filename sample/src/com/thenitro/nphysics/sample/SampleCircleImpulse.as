package com.thenitro.nphysics.sample {
	import com.thenitro.ngine.math.Random;
	import com.thenitro.ngine.math.TRectangle;
	import com.thenitro.nphysics.bounding.Circle;
	import com.thenitro.nphysics.world.World;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class SampleCircleImpulse extends Sprite {
		private static const RADIUS:int = 10;
		
		public function SampleCircleImpulse() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		
			var bounds:TRectangle = new TRectangle();
				bounds.position.x = 0;
				bounds.position.y = 0;
				bounds.size.x = stage.stageWidth;
				bounds.size.y = stage.stageHeight;
				
			var world:World = new World(bounds, RADIUS * 4, 0.2, 0.01);
			
			addChild(world.canvas);
			
			for (var i:int = 0; i < 500; i++) {
				var circle:Circle  = new Circle();
					circle.position.randomize(0, Math.min(stage.stageWidth, stage.stageHeight));
					
					circle.size = RADIUS;
				
					circle.velocity.randomize(-1.0, 1.0);
				
				var shape:Shape = new Shape();
				
					shape.graphics.beginFill(Random.color);
					shape.graphics.drawCircle(0, 0, RADIUS);
				
				circle.init(shape, bounds);
				
				world.addBody(circle);
			}
		};
	};
}