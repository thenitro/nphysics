package com.thenitro.nphysics.sample {
	import ngine.math.Random;
	import ngine.math.TRectangle;
	
	import nphysics.bodies.AABB;
	import nphysics.world.World;
	import nphysics.world.forces.BoundingForce;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class SampleAABBImpulse extends Sprite {
		private static const SIZE:int = 20;
		
		public function SampleAABBImpulse() {
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
			
			for (var i:int = 0; i < 20; i++) {
				var rectB:AABB  = new AABB();
				
					rectB.position.randomize(0, Math.min(stage.stageWidth, stage.stageHeight));
					
					rectB.max.x = SIZE;
					rectB.max.y = SIZE;
					
					rectB.restitution = 0.4;
					rectB.friction = 0.1;
					rectB.mass = 1.0;
					
					rectB.velocity.randomize(-100, 100);
					
					var quad:Quad = new Quad(SIZE, SIZE, Random.color);
						quad.pivotX = SIZE / 2;
						quad.pivotY = SIZE / 2;
					
					rectB.init(quad);
				
				world.addBody(rectB);
			}
		};
	};
}