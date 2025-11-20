class PinkHorror : BlueHorror Replaces Revenant
{
	Default
	{
		Health 380;
		GibHealth 100;
		Radius 20;
		Height 56;
		Mass 500;
		Speed 10;
		PainChance 100;
		Monster;
		MeleeThreshold 196;
		+MISSILEMORE 
		+FLOORCLIP
		SeeSound "pinkhorror/sight";
		PainSound "pinkhorror/pain";
		DeathSound "pinkhorror/death";
		ActiveSound "pinkhorror/active";

// 		MeleeSound "pinkhorror/attack";
		HitObituary "$OB_UNDEADHIT";
		Obituary "$OB_UNDEAD";
		Tag "$FN_REVEN";
	}
	States
	{
	Spawn:
		PKHR PQR 10 A_Look;
		Loop;
	See:
		PKHR AABBCCDDEEFF 2 A_Chase;
		Loop;
	Melee:
	Missile:
		TNT1 A 0 A_startsound("pinkhorror/attack");
		PKHR G 0 BRIGHT A_FaceTarget;
		PKHR H 10 BRIGHT A_FaceTarget;
		PKHR H 10 A_SpawnProjectile("PinkHorrorBall",40);
		PKHR G 10 A_FaceTarget;
		Goto See;
	Pain:
		PKHR J 5;
		PKHR J 5 A_Pain;
		Goto See;
	Death:
		PKHR L 7 A_Scream;
		PKHR M 7;
		PKHR N 7 A_NoBlocking;
		PKHR O 7 {
			A_SpawnMinion("BlueHorror",45);
			A_SpawnMinion("BlueHorror",315);
		}
		PKHR O -1;
		Stop;
	Raise:
		PKHR O 5;
		PKHR NMKL 5;
		Goto See;
	}
	
	
	
	void A_SpawnMinion(Class<Actor> spawntype, double angle, int flags = 0, int limit = -1)
	{
		// Don't spawn if we get massacred.
		if (DamageType == 'Massacre') return;

		if (spawntype == null) spawntype = "LostSoul";

		// [RH] check to make sure it's not too close to the ceiling
		if (pos.z + height + 8 > ceilingz)
		{
			if (bFloat)
			{
				Vel.Z -= 2;
				bInFloat = true;
				bVFriction = true;
			}
			return;
		}

		// [RH] make this optional
		if (limit < 0 && (Level.compatflags & COMPATF_LIMITPAIN))
			limit = 21;

		if (limit > 0)
		{
			// count total number of skulls currently on the level
			// if there are already 21 skulls on the level, don't spit another one
			int count = limit;
			ThinkerIterator it = ThinkerIterator.Create(spawntype);
			Thinker othink;

			while ( (othink = it.Next ()) )
			{
				if (--count == 0)
					return;
			}
		}

		// okay, there's room for another one
		double otherradius = GetDefaultByType(spawntype).radius;
		double prestep = 4 + (radius + otherradius) * 1.5;

		Vector2 move = AngleToVector(angle, prestep);
		Vector3 spawnpos = pos + (0,0,8);
		Vector3 destpos = spawnpos + move;

		Actor other = Spawn(spawntype, spawnpos, ALLOW_REPLACE);

		// Now check if the spawn is legal. Unlike Boom's hopeless attempt at fixing it, let's do it the same way
		// P_XYMovement solves the line skipping: Spawn the Lost Soul near the PE's center and then use multiple
		// smaller steps to get it to its intended position. This will also result in proper clipping, but
		// it will avoid all the problems of the Boom method, which checked too many lines that weren't even touched
		// and despite some adjustments never worked with portals.

		if (other != null)
		{
			if (spawntype == "BlueHorror")
				BlueHorror(other).IsPinkSpawn = True;
				other.giveinventory("isPinkSpawn",255);
			double maxmove = other.radius - 1;

			if (maxmove <= 0) maxmove = 16;

			double xspeed = abs(move.X);
			double yspeed = abs(move.Y);

			int steps = 1;

			if (xspeed > yspeed)
			{
				if (xspeed > maxmove)
				{
					steps = int(1 + xspeed / maxmove);
				}
			}
			else
			{
				if (yspeed > maxmove)
				{
					steps = int(1 + yspeed / maxmove);
				}
			}

			Vector2 stepmove = move / steps;
			bool savedsolid = bSolid;
			bool savednoteleport = other.bNoTeleport;
			
			// make the PE nonsolid for the check and the LS non-teleporting so that P_TryMove doesn't do unwanted things.
			bSolid = false;
			other.bNoTeleport = true;
			for (int i = 0; i < steps; i++)
			{
				Vector2 ptry = other.pos.xy + stepmove;
				double oldangle = other.angle;
				if (!other.TryMove(ptry, 0))
				{
					// kill it immediately
					other.ClearCounters();
					other.DamageMobj(self, self, TELEFRAG_DAMAGE, 'None');
					bSolid = savedsolid;
					other.bNoTeleport = savednoteleport;
					return;
				}

				if (other.pos.xy != ptry)
				{
					// If the new position does not match the desired position, the player
					// must have gone through a portal.
					// For that we need to adjust the movement vector for the following steps.
					double anglediff = deltaangle(oldangle, other.angle);

					if (anglediff != 0)
					{
						stepmove = RotateVector(stepmove, anglediff);
					}
				}

			}
			bSolid = savedsolid;
			other.bNoTeleport = savednoteleport;

			// [RH] Lost souls hate the same things as their pain elementals
			other.CopyFriendliness (self, !(flags & PAF_NOTARGET));

		}
	}
}

class PinkHorrorBall : Actor
{
	Default
	{
		Radius 6;
		Height 8;
		Speed 10;
		FastSpeed 20;
		Damage 3;
		Scale 0.8;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "AddShaded";
		Alpha 1;
		+SEEKERMISSILE
		SeeSound  "pinkhorror/fire";
// 		pufftype "";
		DeathSound "pinkhorror/impact";
		StencilColor  "b52d60";
	}
	States
	{
		Spawn:
			BFS1 AB 2 BRIGHT {
				HorrorTracer(4);
				A_SpawnParticleEx("ee4283",TexMan.CheckForTexture("FLMYA0"),STYLE_shaded,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM , 15
				, 35, 0
		// 		,0,0,0
				,random(-3,3),random(-3,3),random(0,3)
				,0,0,0,0,0,0.2
				, 0.8,0,-2.2
				, Random(0,12)*30, Random(-3,3));
				 MissileAccelerate(19, 0.4);
			}
			Loop;
		Death:
			BFE2 ABCD 4 BRIGHT;
			Stop;
	}
	void MissileAccelerate(int maxSpeed = 30, float accelRate = 1.0){
		if (speed > maxSpeed) return;
		speed = speed * (1 + accelRate);
		
	}
	
	void HorrorTracer(double traceang = 19.6875){
		double dist;
		double slope;
		Actor dest;
				
		// adjust direction
		dest = tracer;
		
		if (!dest || dest.health <= 0 || Speed == 0 || !CanSeek(dest))
			return;
	
		// change angle 	
		double exact = AngleTo(dest);
		double diff = deltaangle(angle, exact);

		if (diff < 0)
		{
			angle -= traceang;
			if (deltaangle(angle, exact) > 0)
				angle = exact;
		}
		else if (diff > 0)
		{
			angle += traceang;
			if (deltaangle(angle, exact) < 0.)
				angle = exact;
		}

		VelFromAngle();

		if (!bFloorHugger && !bCeilingHugger)
		{
			// change slope
			dist = DistanceBySpeed(dest, Speed);

// 			if (dest.Height >= 56.)
// 			{
				slope = (dest.pos.z + 5. - pos.z) / dist;
// 			}
// 			else
// 			{
// 				slope = (dest.pos.z + Height*(2./3) - pos.z) / dist;
// 			}

			if (slope < Vel.Z)
				Vel.Z -= 1;
			else
				Vel.Z += 1;
		}
	}
}