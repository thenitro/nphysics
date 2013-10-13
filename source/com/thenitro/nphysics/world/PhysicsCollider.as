package com.thenitro.nphysics.world {
	import com.thenitro.ngine.collections.LinkedList;
	import com.thenitro.ngine.display.gameentity.Entity;
	import com.thenitro.ngine.display.gameentity.collider.GridCollider;
	import com.thenitro.ngine.display.gameentity.collider.LinearCollider;
	import com.thenitro.ngine.math.TMath;
	import com.thenitro.ngine.math.TRectangle;
	import com.thenitro.ngine.math.vectors.Vector2D;
	import com.thenitro.ngine.pool.Pool;
	import com.thenitro.nphysics.bounding.AABB;
	import com.thenitro.nphysics.bounding.Body;
	
	public final class PhysicsCollider extends GridCollider {
		private var _pool:Pool = Pool.getInstance();
		
		private var _correction:Number;
		private var _slop:Number;
		
		public function PhysicsCollider(pBounds:TRectangle, pGridSize:Number, 
										pCorrection:Number, pSlop:Number) {
			super(pBounds.size.x, pBounds.size.y, pGridSize, null);
			
			_correction = pCorrection;
			_slop       = pSlop;
		};
		
		override public function isColliding(pEntityA:Entity, 
											 pEntityB:Entity):Boolean {
			if (pEntityA == pEntityB) {
				return false;
			}
			
			if (pEntityA.expired || pEntityB.expired) {
				return false;
			}
			
			if (pEntityA is AABB && pEntityB is AABB) {
				var manifold:Manifold = AABBtoAABB(pEntityA as AABB, pEntityB as AABB);
				
				if (manifold) {
					resolveCollision(manifold);
				}
				
				_pool.put(manifold);
				
				return true;
			}
			
			return false;
		};
		
		private function AABBtoAABB(pA:AABB, pB:AABB):Manifold {			
			var normal:Vector2D  = pB.position.substract(pA.position, true);
			
			var extentA:Number = pA.max.x / 2;
			var extentB:Number = pB.max.x / 2;
			
			var overlapX:Number = extentA + extentB - Math.abs(normal.x);
			
			var manifold:Manifold;
			
			if (overlapX > 0) {
				extentA = pA.max.y / 2; 
				extentB = pB.max.y / 2;
				
				var overlapY:Number = extentA + extentB - Math.abs(normal.y);
				
				if (overlapY > 0) {
					manifold = Manifold.EMPTY;
				
					manifold.a = pA;
					manifold.b = pB;
					
					if (overlapX > overlapY) {
						manifold.penetration = overlapX;
						
						if (normal.x < 0) {
							manifold.normal.x = -1;
							manifold.normal.y =  0;
						} else {
							manifold.normal.x =  1;
							manifold.normal.y =  0;
						}
					} else {
						manifold.penetration = overlapY;
						
						if (normal.y < 0) {
							manifold.normal.x =  0;
							manifold.normal.y = -1;
						} else {
							manifold.normal.x =  0;
							manifold.normal.y =  1;
						}
					}
				}
			}
			
			_pool.put(normal);
			
			return manifold;
		};
		
		private function resolveCollision(pManifold:Manifold):void {
			var a:Body = pManifold.a;
			var b:Body = pManifold.b;
			
			var relativeVelocity:Vector2D = b.velocity.substract(a.velocity, true);
			var rvDotNormal:Number 		  = relativeVelocity.dotProduct(pManifold.normal);
			
			if (rvDotNormal > 0) {
				return;
			}
			
			var e:Number = Math.min(a.restitution, b.restitution);
			var j:Number = -(1 + e) * rvDotNormal;
				j /= a.invMass + b.invMass;
			
			var impulse:Vector2D = pManifold.normal.multiplyScalar(j, true);
			
			a.velocity.x -= a.invMass * impulse.x;
			a.velocity.y -= a.invMass * impulse.y;
			
			b.velocity.x += b.invMass * impulse.x;
			b.velocity.y += b.invMass * impulse.y;
			
			positionalCorrection(pManifold);
			
			_pool.put(relativeVelocity);
			_pool.put(impulse);
		};
		
		private function positionalCorrection(pManifold:Manifold):void {
			var correction:Number = Math.max(pManifold.penetration - _slop, 0) / (pManifold.a.invMass + pManifold.b.invMass) * _correction;
			
			pManifold.a.position.x -= pManifold.a.invMass * correction * pManifold.normal.x;
			pManifold.a.position.y -= pManifold.a.invMass * correction * pManifold.normal.y;
			
			pManifold.b.position.x += pManifold.a.invMass * correction * pManifold.normal.x;
			pManifold.b.position.y += pManifold.a.invMass * correction * pManifold.normal.y;
		};
	}
}