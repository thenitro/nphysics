package com.thenitro.nphysics.world {
	import com.thenitro.ngine.display.gameentity.Entity;
	import com.thenitro.ngine.display.gameentity.collider.GridCollider;
	import com.thenitro.ngine.math.TMath;
	import com.thenitro.ngine.math.TRectangle;
	import com.thenitro.ngine.math.vectors.Vector2D;
	import com.thenitro.ngine.pool.Pool;
	import com.thenitro.nphysics.bounding.AABB;
	import com.thenitro.nphysics.bounding.Body;
	import com.thenitro.nphysics.bounding.Circle;
	
	public final class PhysicsCollider extends GridCollider {
		private var _pool:Pool = Pool.getInstance();
		
		private var _accumulator:Number;
		private var _dt:Number;
		
		private var _correction:Number;
		private var _slop:Number;
		
		public function PhysicsCollider(pBounds:TRectangle, pGridSize:Number, 
										pCorrection:Number, pSlop:Number,
										pFrameRate:Number) {
			super(pBounds.size.x, pBounds.size.y, pGridSize, null);
			
			_correction = pCorrection;
			_slop       = pSlop;
			
			_accumulator = 0;
			_dt          = 1 / pFrameRate;
		};
		
		override public function update(pElapsed:Number):void {
			trace("PhysicsCollider.update(pElapsed)", pElapsed, _dt);
			_accumulator += pElapsed;
			
			if (_accumulator > _dt) {
				super.update(pElapsed);
				
				_accumulator -= _dt;
			} else {
				trace("PhysicsCollider.update(pElapsed) SKIP");
			}
		};
		
		override public function isColliding(pEntityA:Entity, 
											 pEntityB:Entity):Boolean {
			if (pEntityA == pEntityB) {
				return false;
			}
			
			if (pEntityA.expired || pEntityB.expired) {
				return false;
			}
			
			var manifold:Manifold;
			
			if (pEntityA is AABB && pEntityB is AABB) {
				manifold = AABBtoAABB(pEntityA as AABB, pEntityB as AABB);	
			}
			
			if (pEntityA is Circle && pEntityB is Circle) {
				manifold = CircleToCircle(pEntityA as Circle, pEntityB as Circle);
			}
			
			if (pEntityA is AABB && pEntityB is Circle) {
				manifold = AABBvsCircle(pEntityA as AABB, pEntityB as Circle);
			}
			
			if (pEntityA is Circle && pEntityB is AABB) {
				manifold = AABBvsCircle(pEntityB as AABB, pEntityA as Circle);
			}
			
			if (manifold) {
				resolveCollision(manifold);
				
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
					
					if (overlapX < overlapY) {
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
		
		private function CircleToCircle(pA:Circle, pB:Circle):Manifold {
			var normal:Vector2D = pB.position.substract(pA.position, true);
			
			var radius:Number = pA.size + pB.size;
				radius *= radius;
			
			if (normal.lengthSquared() > radius) {
				_pool.put(normal);
				
				return null;
			}
			
			var distance:Number   = normal.length();
			
			var manifold:Manifold = Manifold.EMPTY;
			
				manifold.a = pA;
				manifold.b = pB;
			
			if (distance) {
				manifold.penetration = (pA.size + pB.size) - distance;
				
				manifold.normal.x = normal.x / distance;
				manifold.normal.y = normal.y / distance;
			} else {
				manifold.penetration = pA.size;
				
				manifold.normal.x = 1;
				manifold.normal.y = 0;
			}
			
			_pool.put(normal);
			
			return manifold;
		};
		
		private function AABBvsCircle(pA:AABB, pB:Circle):Manifold {
			var normal:Vector2D  = pB.position.substract(pA.position, true);
			var closest:Vector2D = normal.clone();
			
			var extentX:Number = pA.max.x / 2;
			var extentY:Number = pA.max.y / 2;
			
			closest.x = TMath.clamp(closest.x, -extentX, extentX);
			closest.y = TMath.clamp(closest.y, -extentY, extentY);
			
			var inside:Boolean = false;
			
			if (normal.equals(closest)) {
				inside = true;
				
				if (Math.abs(normal.x) > Math.abs(normal.y)) {
					if (closest.x > 0) {
						closest.x =  extentX;
					} else {
						closest.x = -extentX;
					}
				} else {
					if (closest.y > 0) {
						closest.y =  extentY;
					} else {
						closest.y = -extentY;
					}
				}
			}
			
			var normal2:Vector2D = normal.substract(closest, true);
			var distance:Number  = normal2.lengthSquared();
			var radius:Number    = pB.size;
			
			if (distance > radius * radius && !inside) {
				_pool.put(normal);
				_pool.put(normal2);
				_pool.put(closest);
				
				return null;
			}
			
			distance = Math.sqrt(distance);
			
			var manifold:Manifold = Manifold.EMPTY;
			
				manifold.a = pA;
				manifold.b = pB;
				
				manifold.penetration = radius - distance;
			
			normal.normalize();
				
			if (inside) {
				manifold.normal.x = -normal.x;
				manifold.normal.y = -normal.y;
			} else {
				manifold.normal.x = normal.x;
				manifold.normal.y = normal.y;
			}
			
			_pool.put(normal);
			_pool.put(normal2);
			_pool.put(closest);
			
			return manifold;
		};
		
		private function resolveCollision(pManifold:Manifold):void {
			var a:Body = pManifold.a;
			var b:Body = pManifold.b;
			
			var relativeVelocity:Vector2D = b.velocity.substract(a.velocity, true);
			var rvDotNormal:Number 		  = relativeVelocity.dotProduct(pManifold.normal);
			
			if (rvDotNormal > 0) {
				_pool.put(relativeVelocity);
				_pool.put(impulse);
				
				return;
			}
			
			var e:Number = Math.max(a.restitution, b.restitution);
			var j:Number = -(1 + e) * rvDotNormal;
				j /= a.invMass + b.invMass;
				
			var impulse:Vector2D = pManifold.normal.multiplyScalar(j, true);
			
			a.velocity.x -= a.invMass * impulse.x;
			a.velocity.y -= a.invMass * impulse.y;
			
			b.velocity.x += b.invMass * impulse.x;
			b.velocity.y += b.invMass * impulse.y;
			
			var tangent:Vector2D = relativeVelocity.clone();
				tangent.substract(pManifold.normal).multiplyScalar(rvDotNormal);
				
				tangent.normalize();
			
			var jt:Number = relativeVelocity.dotProduct(tangent);
				jt /= a.invMass + b.invMass;
				
			var mu:Number = Math.sqrt(a.friction * a.friction + b.friction * b.friction);
				
			if (Math.abs(jt) < j * mu) {
				tangent.multiplyScalar(jt);
			} else {
				tangent.multiplyScalar(-j).multiplyScalar(mu);
			}
			
			a.velocity.x -= a.invMass * tangent.x;
			a.velocity.y -= a.invMass * tangent.y;
			
			b.velocity.x += b.invMass * tangent.x;
			b.velocity.y += b.invMass * tangent.y;
			
			positionalCorrection(pManifold);
			
			_pool.put(relativeVelocity);
			_pool.put(impulse);
			_pool.put(tangent);
		};
		
		private function positionalCorrection(pManifold:Manifold):void {
			var correction:Number = Math.max(pManifold.penetration - _slop, 0) / (pManifold.a.invMass + pManifold.b.invMass) * _correction;
			
			pManifold.a.position.x -= pManifold.a.invMass * correction * pManifold.normal.x;
			pManifold.a.position.y -= pManifold.a.invMass * correction * pManifold.normal.y;
			
			pManifold.b.position.x += pManifold.b.invMass * correction * pManifold.normal.x;
			pManifold.b.position.y += pManifold.b.invMass * correction * pManifold.normal.y;
		};
	}
}