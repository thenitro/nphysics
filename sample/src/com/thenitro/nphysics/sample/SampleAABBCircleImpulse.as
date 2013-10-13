package com.thenitro.nphysics.sample {
	import com.thenitro.ngine.math.Random;
	import com.thenitro.ngine.math.TRectangle;
	import com.thenitro.nphysics.bounding.AABB;
	import com.thenitro.nphysics.world.World;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class SampleAABBCircleImpulse extends Sprite {
		private static const SIZE:int = 5;
		
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
				
			var world:World = new World(bounds, 50, 0.8, 0.1);
			
			addChild(world.canvas);
			
			
			for (var i:int = 0; i < 1000; i++) {
				var rectB:AABB 		= new AABB();
				
					rectB.position.randomize(0, Math.min(stage.stageWidth, stage.stageHeight));
					
					rectB.max.x = SIZE;
					rectB.max.y = SIZE;
					
					rectB.velocity.randomize(-1.0, 1.0);
					
					var quad:Quad = new Quad(SIZE, SIZE, Random.color);
						quad.pivotX = SIZE / 2;
						quad.pivotY = SIZE / 2;
					
					rectB.init(quad, bounds);
				
				world.addBody(rectB);
			}
		};
	};
}