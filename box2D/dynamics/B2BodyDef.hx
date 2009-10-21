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
import box2D.dynamics.joints.B2DistanceJoint;
import box2D.dynamics.joints.B2DistanceJointDef;
import box2D.dynamics.joints.B2GearJoint;
import box2D.dynamics.joints.B2GearJointDef;
import box2D.dynamics.joints.B2Jacobian;
import box2D.dynamics.joints.B2Joint;
import box2D.dynamics.joints.B2JointDef;
import box2D.dynamics.joints.B2JointEdge;
import box2D.dynamics.joints.B2MouseJoint;
import box2D.dynamics.joints.B2MouseJointDef;
import box2D.dynamics.joints.B2PrismaticJoint;
import box2D.dynamics.joints.B2PrismaticJointDef;
import box2D.dynamics.joints.B2PulleyJoint;
import box2D.dynamics.joints.B2PulleyJointDef;
import box2D.dynamics.joints.B2RevoluteJoint;
import box2D.dynamics.joints.B2RevoluteJointDef;
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
import box2D.common.B2Settings;
import box2D.common.math.B2Mat22;
import box2D.common.math.B2Math;
import box2D.common.math.B2Sweep;
import box2D.common.math.B2Vec2;
import box2D.common.math.B2XForm;
/// A body definition holds all the data needed to construct a rigid body.
/// You can safely re-use body definitions.
class B2BodyDef
 {
	/// This constructor sets the body definition default values.
	
	/// This constructor sets the body definition default values.
	public function new()
	{
		massData = new B2MassData();
		position = new B2Vec2();
		massData.center.SetZero();
		massData.mass = 0.0;
		massData.I = 0.0;
		userData = null;
		position.Set(0.0, 0.0);
		angle = 0.0;
		linearDamping = 0.0;
		angularDamping = 0.0;
		allowSleep = true;
		isSleeping = false;
		fixedRotation = false;
		isBullet = false;
	}
	/// You can use this to initialized the mass properties of the body.
	/// If you prefer, you can set the mass properties after the shapes
	/// have been added using B2Body::SetMassFromShapes.
	public var massData:B2MassData ;
	/// Use this to store application specific body data.
	public var userData:Dynamic;
	/// The world position of the body. Avoid creating bodies at the origin
	/// since this can lead to many overlapping shapes.
	public var position:B2Vec2 ;
	/// The world angle of the body in radians.
	public var angle:Float;
	/// Linear damping is use to reduce the linear velocity. The damping parameter
	/// can be larger than 1.0f but the damping effect becomes sensitive to the
	/// time step when the damping parameter is large.
	public var linearDamping:Float;
	/// Angular damping is use to reduce the angular velocity. The damping parameter
	/// can be larger than 1.0f but the damping effect becomes sensitive to the
	/// time step when the damping parameter is large.
	public var angularDamping:Float;
	/// Set this flag to false if this body should never fall asleep. Note that
	/// this increases CPU usage.
	public var allowSleep:Bool;
	/// Is this body initially sleeping?
	public var isSleeping:Bool;
	/// Should this body be prevented from rotating? Useful for characters.
	public var fixedRotation:Bool;
	/// Is this a fast moving body that should be prevented from tunneling through
	/// other moving bodies? Note that all bodies are prevented from tunneling through
	/// static bodies.
	/// @warning You should use this flag sparingly since it increases processing time.
	public var isBullet:Bool;
}