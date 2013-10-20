package nphysics.world {
	import ngine.core.manager.EntityManager;
	import ngine.math.TRectangle;
	import nphysics.bodies.Body;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public final class World {
		private var _canvas:Sprite;
		private var _inited:Boolean;
		
		private var _manager:EntityManager;
		
		private var _bounds:TRectangle;
		
		private var _gridSize:Number;
		private var _correction:Number;
		private var _slop:Number;
		
		public function World(pBounds:TRectangle, pGridSize:Number, 
							  pCorrection:Number, pSlop:Number) {
			super();
			
			_inited = false;
			
			_bounds     = pBounds;
			_gridSize   = pGridSize;
			_slop       = pSlop;
			_correction = pCorrection;
			
			_canvas = new Sprite();
			
			var bg:Quad = new Quad(pBounds.size.x, pBounds.size.y);
				bg.alpha = 0;
			
			_canvas.addChild(bg);
			_canvas.addEventListener(Event.ADDED_TO_STAGE, 
									 addedToStageEventHandler);
		};
		
		public function get canvas():Sprite {
			return _canvas;
		};
		
		public function get bounds():TRectangle {
			return _bounds;
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			_canvas.removeEventListener(Event.ADDED_TO_STAGE, 
										addedToStageEventHandler);
			
			_inited = true;
			
			_manager = new EntityManager();
			_manager.setCollider(new PhysicsCollider(_bounds, _gridSize, _correction, _slop, Starling.current.nativeStage.frameRate));
			_manager.addEventListener(EntityManager.EXPIRED,
									  entityExpiredEventHandler);
			
			_canvas.addEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
		};
		
		public function addBody(pBody:Body):void {
			if (!_inited) {
				return;
			}
			
			_manager.add(pBody);
			_canvas.addChild(pBody.canvas);
		};
		
		public function removeBody(pBody:Body):void {
			if (!_inited) {
				return;
			}
			
			_manager.remove(pBody);
			_canvas.removeChild(pBody.canvas);
		};
		
		private function entityExpiredEventHandler(pEvent:Event):void {
			_canvas.removeChild(pEvent.data.canvas);
		};
		
		private function enterFrameEventHandler(pEvent:EnterFrameEvent):void {
			_manager.update();
		};
	};
}