package com.thenitro.nphysics.sample {
	import com.thenitro.ngine.math.Random;
	import com.thenitro.ngine.math.TRectangle;
	import com.thenitro.nphysics.bounding.AABB;
	import com.thenitro.nphysics.world.World;
	
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
				
			var world:World = new World(bounds, stage.stageWidth, 0.8, 0.01);
			
			addChild(world.canvas);
			
			var floor:AABB  = new AABB();
			
			floor.position.x = stage.stageWidth / 2;
			floor.position.y = stage.stageHeight - 50;
				
			floor.max.x = stage.stageWidth;
			floor.max.y = 100;
				
			floor.restitution = 0.2;
			floor.mass = 0;
			
			floor.friction = 0.3;
				
			//floor.velocity.randomize(-10.0, 10.0);
			
			var floorV:Quad = new Quad(floor.max.x, floor.max.y, Random.color);
				floorV.pivotX = floor.max.x / 2;
				floorV.pivotY = floor.max.y / 2;
				
				floor.init(floorV);
			
			world.addBody(floor);
			
			
			for (var i:int = 0; i < 20; i++) {
				var rectB:AABB  = new AABB();
				
					rectB.position.randomize(0, Math.min(stage.stageWidth, stage.stageHeight));
					
					rectB.max.x = SIZE;
					rectB.max.y = SIZE;
					
					rectB.restitution = 0.2;
					rectB.mass = 1;
					
					rectB.friction = 1.0;
					
					rectB.velocity.y = Math.random() * 2;
					
					var quad:Quad = new Quad(SIZE, SIZE, Random.color);
						quad.pivotX = SIZE / 2;
						quad.pivotY = SIZE / 2;
					
					rectB.init(quad);
				
				world.addBody(rectB);
			}
		};
	};
}