package com.thenitro.nphysics.sample {
	import ngine.math.Random;
	import ngine.math.TRectangle;
	
	import nphysics.bodies.Circle;
	import nphysics.world.World;
	import nphysics.world.forces.BoundingForce;
	
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

			var force:BoundingForce = new BoundingForce();
				force.init(bounds);
			
				world.addForce(force);
				world.start();
			
			for (var i:int = 0; i < 50; i++) {
				var circle:Circle  = new Circle();
					circle.position.randomize(0, Math.min(stage.stageWidth, stage.stageHeight));
					
					circle.size = RADIUS;
					circle.mass = 1.0;
					circle.friction = 0.01;
					circle.restitution = 0.3;
				
					circle.velocity.randomize(-100.0, 100.0);
				
				var shape:Shape = new Shape();
				
					shape.graphics.beginFill(Random.color);
					shape.graphics.drawCircle(0, 0, RADIUS);
				
				circle.init(shape);
				
				world.addBody(circle);
			}
		};
	};
}