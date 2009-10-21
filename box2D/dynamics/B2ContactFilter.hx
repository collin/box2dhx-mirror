/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/
package box2D.dynamics;

import box2D.collision.B2AABB;
import box2D.collision.B2Bound;
import box2D.collision.B2BoundValues;
import box2D.collision.B2BroadPhase;
import box2D.collision.B2BufferedPair;
import box2D.collision.B2Collision;
import box2D.collision.B2ContactID;
import box2D.collision.B2ContactPoint;
import box2D.collision.B2Distance;
import box2D.collision.B2Manifold;
import box2D.collision.B2ManifoldPoint;
import box2D.collision.B2OBB;
import box2D.collision.B2Pair;
import box2D.collision.B2PairCallback;
import box2D.collision.B2PairManager;
import box2D.collision.B2Point;
import box2D.collision.B2Proxy;
import box2D.collision.B2Segment;
import box2D.collision.B2TimeOfImpact;
import box2D.collision.ClipVertex;
import box2D.collision.Features;
import box2D.collision.shapes.B2CircleDef;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2FilterData;
import box2D.collision.shapes.B2MassData;
import box2D.collision.shapes.B2PolygonDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2Shape;
import box2D.collision.shapes.B2ShapeDef;
import box2D.dynamics.contacts.B2CircleContact;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.contacts.B2ContactConstraint;
import box2D.dynamics.contacts.B2ContactConstraintPoint;
import box2D.dynamics.contacts.B2ContactEdge;
import box2D.dynamics.contacts.B2ContactRegister;
import box2D.dynamics.contacts.B2ContactResult;
import box2D.dynamics.contacts.B2ContactSolver;
import box2D.dynamics.contacts.B2NullContact;
import box2D.dynamics.contacts.B2PolyAndCircleContact;
import box2D.dynamics.contacts.B2PolygonContact;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2BoundaryListener;
import box2D.dynamics.B2ContactFilter;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.B2ContactManager;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2DestructionListener;
import box2D.dynamics.B2Island;
import box2D.dynamics.B2TimeStep;
import box2D.dynamics.B2World;
import box2D.common.math.B2Mat22;
import box2D.common.math.B2Math;
import box2D.common.math.B2Sweep;
import box2D.common.math.B2Vec2;
import box2D.common.math.B2XForm;
import box2D.common.B2Color;
import box2D.common.B2Settings;

/// Implement this class to provide collision filtering. In other words, you can implement
/// this class if you want finer control over contact creation.
class B2ContactFilter
 {
	/// Return true if contact calculations should be performed between these two shapes.
	/// @warning for performance reasons this is only called when the AABBs begin to overlap.
	public function new() { }
	
	/// Return true if contact calculations should be performed between these two shapes.
	/// @warning for performance reasons this is only called when the AABBs begin to overlap.
	public  function ShouldCollide(shape1:B2Shape, shape2:B2Shape) : Bool{
		var filter1:B2FilterData = shape1.GetFilterData();
		var filter2:B2FilterData = shape2.GetFilterData();
		
		if (filter1.groupIndex == filter2.groupIndex && filter1.groupIndex != 0)
		{
			return filter1.groupIndex > 0;
		}
		
		var collide:Bool = (filter1.maskBits & filter2.categoryBits) != 0 && (filter1.categoryBits & filter2.maskBits) != 0;
		return collide;
	}
	
	public static var b2_defaultFilter:B2ContactFilter = new B2ContactFilter();
	
}