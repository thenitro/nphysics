package com.thenitro.nphysics.sample {
	import ngine.math.Random;
	import ngine.math.TRectangle;
	
	import nphysics.bodies.AABB;
	import nphysics.bodies.Circle;
	import nphysics.world.World;
	import nphysics.world.forces.BoundingForce;
	
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class SampleAABBCircleImpulse extends Sprite {
		private static const SIZE:int = 10;
		
		public function SampleAABBCircleImpulse() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			var bounds:TRectangle = new TRectangle();
				bounds.position.x = 0;
				bounds.position.y = 0;
				bounds.size.x = stage.stageWidth  - SIZE;
				bounds.size.y = stage.stageHeight - SIZE;
			
			var world:World = new World(bounds, SIZE * 4, 0.8, 0.01);
			
			addChild(world.canvas);
			
			var force:BoundingForce = new BoundingForce();
				force.init(bounds);
			
			world.addForce(force);
			world.start();
			
			for (var i:int = 0; i < 40; i++) {
				var rectB:AABB = new AABB();
				
					rectB.position.randomize(0, Math.min(stage.stageWidth, stage.stageHeight));
					
					rectB.max.x = SIZE;
					rectB.max.y = SIZE;
					
					rectB.friction = 0.1
					rectB.restitution = 0.4;
					rectB.mass = 1;
					
					rectB.velocity.randomize(-20.0, 20.0);
				
				var quad:Quad = new Quad(SIZE, SIZE, Random.color);
					quad.pivotX = SIZE / 2;
					quad.pivotY = SIZE / 2;
				
				rectB.init(quad);
				
				world.addBody(rectB);
			}
			
			for (i = 0; i < 40; i++) {
				var circle:Circle  = new Circle();
					circle.position.randomize(0, Math.min(stage.stageWidth, stage.stageHeight));
					
					circle.size = SIZE;
					circle.friction = 0.1
					circle.restitution = 0.4;
					circle.mass = 1;
					
					circle.velocity.randomize(-10.0, 10.0);
				
				var shape:Shape = new Shape();
				
				shape.graphics.beginFill(Random.color);
				shape.graphics.drawCircle(0, 0, SIZE);
				
				circle.init(shape);
				
				world.addBody(circle);
			}
		};
	};
}