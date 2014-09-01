package nphysics.world {
    import ngine.core.Entity;
    import ngine.core.manager.EntityManager;

    import nmath.TRectangle;
    import nmath.vectors.Vector2D;

    import nphysics.world.forces.AbstractForce;

    import starling.core.Starling;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.EventDispatcher;

    public final class World extends EventDispatcher {
		public static const COLLIDED_EVENT:String = 'collided_event';
		
		private var _canvas:Sprite;
		private var _inited:Boolean;
		
		private var _manager:EntityManager;
		
		private var _bounds:TRectangle;
		
		private var _cellSize:Number;
		private var _correction:Number;
		private var _slop:Number;
		
		private var _forces:Vector.<AbstractForce>;
		
		private var _collider:PhysicsCollider;
		
		private var _stopped:Boolean;
		
		private var _background:Quad;
		
		public function World(pGridSize:Number, 
							  pCorrection:Number, pSlop:Number) {
			super();
			
			_inited  = false;
			_stopped = true;
			
			_cellSize   = pGridSize;
			_slop       = pSlop;
			_correction = pCorrection;
			
			_canvas = new Sprite();
			_canvas.addEventListener(Event.ADDED_TO_STAGE, 
									 addedToStageEventHandler);
			
			_forces = new Vector.<AbstractForce>();
		};
		
		public function get canvas():Sprite {
			return _canvas;
		};
		
		public function get bounds():TRectangle {
			return _bounds;
		};
		
		public function get stopped():Boolean {
			return _stopped;
		};
		
		public function get entityManager():EntityManager {
			return _manager;
		};
		
		public function start():void {
			_stopped = false; 
			
			_canvas.addEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
		};
		
		public function stop():void {
			_stopped = true;
			
			_canvas.removeEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
		};
		
		public function setBounds(pBounds:TRectangle):void {
			_bounds = pBounds;
			
			if (_background) {
				_canvas.removeChild(_background, true);
			}
			
			_background = new Quad(pBounds.size.x, pBounds.size.y);
			_background.alpha = 0.0;
			
			var parameters:PhysicsColliderParameters = PhysicsColliderParameters.NEW;
				parameters.init(this, _cellSize, _correction, _slop, 
								Starling.current.nativeStage.frameRate);
			
			_collider.setup(parameters);
			
			_canvas.addChildAt(_background, 0);
		};
		
		public function add(pBody:Entity):void {
			if (!_inited) {
				return;
			}
			
			_manager.add(pBody);
			_canvas.addChild(pBody.canvas);
		};
		
		public function remove(pBody:Entity):void {
			if (!_inited) {
				return;
			}
			
			_manager.remove(pBody);
			_canvas.removeChild(pBody.canvas);
		};
		
		public function addForce(pForce:AbstractForce):void {
			_forces.push(pForce);
		};
		
		public function getNearbyEntities(pPosition:Vector2D, pRadius:Number,
										  pFilterFunction:Function = null, 
										  pSorted:Boolean = false):Array {
			return _manager.getNearbyEntities(pPosition, pRadius, 
											  pFilterFunction, pSorted);
		};
		
		public function clean():void {
			stop();
			
			_manager.clean();
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			_canvas.removeEventListener(Event.ADDED_TO_STAGE, 
										addedToStageEventHandler);
			
			_inited = true;
			
			_collider = new PhysicsCollider();
			
			_manager = new EntityManager();
			_manager.setCollider(_collider);
			_manager.addEventListener(EntityManager.EXPIRED,
									  entityExpiredEventHandler);
		};
		
		private function entityExpiredEventHandler(pEvent:Event):void {
			_canvas.removeChild(pEvent.data.canvas);
		};
		
		private function enterFrameEventHandler(pEvent:EnterFrameEvent):void {
			_manager.update(pEvent.passedTime);
			
			applyForces();
		};
		
		private function applyForces():void {
			if (!_forces.length) {
				return;
			}
			
			var body:Entity = _manager.entities.first as Entity;
			
			while (body) {
				for each (var force:AbstractForce in _forces) {
					force.applyTo(body);
				}
				
				body = _manager.entities.next(body) as Entity;
			}
		};
	};
}