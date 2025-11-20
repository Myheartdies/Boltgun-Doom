class Cultist1 : ZombieMan
{
	int maxBurstCount;
	protected int burstCount;
	Property MaxBurstCount : maxBurstCount;
	Default
	{
		Health 20;
		GibHealth 15;
		Radius 20;
		Height 56;
		Speed 8;
		PainChance 200;
		Scale 0.58;
		Monster;
// 		+MISSILEMORE
		+FLOORCLIP
		+DOHARMSPECIES
// 		+PUSHABLE
		DamageFactor "Melta", 2;
		SeeSound "CLTA/sight";
// 		AttackSound "grunt/attack";
		AttackSound "CLTA/fire";
		PainSound "grunt/pain";
		DeathSound "grunt/death";
		ActiveSound "grunt/active";
		Obituary "$OB_ZOMBIE";
		Tag "$FN_ZOMBIE";
		Cultist1.MaxBurstCount 3;
		FriendlySeeBlocks 5;
		MeleeRange 60;
		ReactionTime 4;
		
	}
 	States
	{
	Spawn:
// 		TNT1 A 0 {
// 			A_SpawnTeammate("Cultist2", angle + 90);
// 			A_SpawnTeammate("Cultist3", angle + 270);
// 		}
		CLT1 ABMN 10 A_Look;
		Loop;
	See:
		TNT1 A 0 BurstCountReset;
		CLT1 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		TNT1 A 0 A_StartSound("CLTA/aim",CHAN_WEAPON, CHANF_OVERLAP);
		CLT1 E 8 A_FaceTarget;
	Firing:
		CLT1 E 4 {
			A_FaceTarget();
// 			A_JumpIfTargetInsideMeleeRange("Melee");
		}
		CLT1 F 6 Bright CultistMissile;
		CLT1 E 6;
		CLT1 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing +1;
	Pain:
		CLT1 H 3;
		CLT1 H 3 A_Pain;
		Goto See;
	Death:
		CLT1 I 5;
		CLT1 J 5 A_Scream;
		CLT1 K 5 A_NoBlocking;
		CLT1 L 5;
		CLT1 L -1;
		Stop;
	XDeath:
		OVKS A 3 A_NoBlocking;
		OVKS B 3 A_XScream;
		OVKS C 3 A_NoBlocking;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	Raise:
		CLT1 L 5;
		CLT1 KJI 5;
		Goto See;
	}
	override void BeginPlay()
	{
		super.BeginPlay();
		BurstCount = 0;
	}
	action void spawnTeammate(){
		Vector3 position;
		position.x = invoker.pos.x + 50;
		position.y = invoker.pos.y;
		position.z = invoker.pos.z;
		if (!Spawn("Cultist2",position))
		{
			Console.Printf("Failed to spawn Cultist2!");
		}
	}
	int CultistRefireChance(){
		burstCount = burstCount + 1;
		int chance;
		if (burstCount >= maxburstcount || !CheckSight(target))
		{
			chance = 256;
			burstCount = 0;
		}
		else{
// 			The higher the burst count, the higher possibility for it to stop mid way
			chance =  240  / (maxburstcount) * burstCount;
		}
// 		Console.printf("maxburst: %d currentburst:%d chance: %d",maxburstCount, burstCount, chance);
		return chance;
		
	}
	action void BurstCountReset(){
// 		Console.printf("Burst count resetted");
		invoker.burstCount = 0;
	}
	override void PostBeginPlay(){
		
		super.PostBeginPlay();
// 		if (!Spawn("Cultist2",pos))
// 		{
// 			Console.Printf("Failed to spawn Cultist2!");
// 		}
		
	}
	
	action void CultistMissile(){
		if (target)
		{
			A_FaceTarget();
// 			A_CustomBulletAttack(2
// 			, 0, 1,0, pufftype :"BulletPuff",0, flags:CBAF_NORANDOM, missile:"Tracer");
			A_StartSound("CLTA/fire", CHAN_WEAPON,CHANF_OVERLAP);
			A_StartSound("CLTA/fire", CHAN_WEAPON,CHANF_OVERLAP,pitch:0.8);
			A_SpawnProjectile("Tracer", angle:random(-13,13)+ 0.5*invoker.burstCount, flags: CMF_AIMOFFSET);
		}
		
// 		A_StartSound("weapons/pistol",flags:CHAN_WEAPON);
// 		A_SpawnProjectile("Tracer");
// 		A_CustomBulletAttack(22.5, 0, 3,0, pufftype :"BulletPuff", 0, flags:CBAF_NORANDOM);
	}
	void A_SpawnTeammate(Class<Actor> spawntype, double angle, int flags = 0, int limit = -1)
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
					other.Destroy();
// 					other.DamageMobj(self, self, TELEFRAG_DAMAGE, 'None');
// 					bSolid = savedsolid;
// 					other.bNoTeleport = savednoteleport;
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

			if (!(flags & PAF_NOSKULLATTACK))
			{
				other.A_SkullAttack();
			}
		}
	}
}
class Cultist2 : Cultist1
{
	Default
	{
		DropItem "Clip";
	}
	States
	{
	Spawn:
// 		TNT1 A 0 {
// 			A_SpawnTeammate("Cultist3", angle + 90);
// 			A_SpawnTeammate("Cultist4", angle + 270);
// 		}
		CLT2 MN 10 A_Look;
		Loop;
	See:
		TNT1 A 0 BurstCountReset;
		CLT2 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		TNT1 A 0 A_StartSound("CLTA/aim",CHAN_WEAPON, CHANF_OVERLAP);
		CLT2 E 8 A_FaceTarget;
	Firing:
		CLT2 E 4 A_FaceTarget() ;
		CLT2 F 6 Bright CultistMissile;
		CLT2 E 5;
		CLT2 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing +1;
	Pain:
		CLT2 H 3;
		CLT2 H 3 A_Pain;
		Goto See;
	Death:
		CLT2 I 5;
		CLT2 J 5 A_Scream;
		CLT2 K 5 A_NoBlocking;
		CLT2 L 5;
		CLT2 L -1;
		Stop;
	XDeath:
		OVKS A 5 A_NoBlocking;
		OVKS B 5 A_XScream;
		OVKS C 5 A_NoBlocking;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	Raise:
		CLT2 L 5;
		CLT2 KJI 5;
		Goto See;
	}
	
	override void BeginPlay()
	{
		super.BeginPlay();
		BurstCount = 0;
	}
}

class Cultist3 : Cultist1
{
	States
	{
	Spawn:
// 		TNT1 A 0 {
// 			A_SpawnTeammate("Cultist4", angle + 90);
// 			A_SpawnTeammate("Cultist1", angle + 270);
// 		}
		CLT3 MN 10 A_Look;
		Loop;
	See:
		TNT1 A 0 BurstCountReset;
		CLT3 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		TNT1 A 0 A_StartSound("CLTA/aim",CHAN_WEAPON, CHANF_OVERLAP);
		CLT3 E 8 A_FaceTarget;
	Firing:
		CLT3 E 4 A_FaceTarget;
		CLT3 F 6 Bright CultistMissile;
		CLT3 E 6;
		CLT3 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing+1;
	Pain:
		CLT3 H 3;
		CLT3 H 3 A_Pain;
		Goto See;
	Death:
		CLT3 I 5;
		CLT3 J 5 A_Scream;
		CLT3 K 5 A_NoBlocking;
		CLT3 L 5;
		CLT3 L -1;
		Stop;
	XDeath:
		OVKS A 5 A_NoBlocking;
		OVKS B 5 A_XScream;
		OVKS C 5 A_NoBlocking;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	Raise:
		CLT3 L 5;
		CLT3 KJI 5;
		Goto See;
	}
		
	override void BeginPlay()
	{
		super.BeginPlay();
		BurstCount = 0;
	}
}
// Cultist 4's sprite order is different from others because it was the original that replaces the
// zombieman texture directly
// TODO: change it to the same as others
class Cultist4 : Cultist1
{
	Default
	{
		DropItem "Clip";
	}
 	States
	{
	Spawn:
// 		TNT1 A 0 {
// 			A_SpawnTeammate("Cultist1", angle + 90);
// 			A_SpawnTeammate("Cultist2", angle + 270);
// 		}
		CLT4 AB 10 A_Look;
		Loop;
	See:
		TNT1 A 0 BurstCountReset;
		CLT4 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		TNT1 A 0 A_StartSound("CLTA/aim",CHAN_WEAPON, CHANF_OVERLAP);
		CLT4 E 8 A_FaceTarget;
	Firing:
		CLT4 E 4 A_FaceTarget;
		CLT4 F 6 Bright CultistMissile;//A_PosAttack;
		CLT4 E 5;
		CLT4 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing +1;
	Pain:
		CLT4 G 3;
		CLT4 G 3 A_Pain;
		Goto See;
	Death:
		CLT4 H 5;
		CLT4 I 5 A_Scream;
		CLT4 J 5 A_NoBlocking;
		CLT4 K 5;
		CLT4 L -1;
		Stop;
	XDeath:
		OVKS A 5 A_NoBlocking;
		OVKS B 5 A_XScream;
		OVKS C 5 A_NoBlocking;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	Raise:
		CLT4 L 5;
		CLT4 KJI 5;
		Goto See;
	}
		
	override void BeginPlay()
	{
		super.BeginPlay();
		BurstCount = 0;
	}
}

class Tracer : FastProjectile
{
	Default
	{
		Scale 0.4;
		Radius 1;
		Height 1;
		Speed 55;
		FastSpeed 120;
		+FORCEXYBILLBOARD
//    Damage 3;
		DamageType "Autogun";
		DamageFunction 2*random(1,4);
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		+NOEXTREMEDEATH
		RenderStyle "Add";
		Alpha 1;
		alpha 0.9;
// 		SeeSound "weapons/pistol";
// 		DeathSound "imp/shotx";
 }
	States
	{
	Spawn:
		TRAC A 1 BRIGHT A_SpawnParticle("fed882",SPF_FULLBRIGHT,10,5, sizestep:1);
		Loop;
	Death:
		TNT1 A 0 BRIGHT Spawn("BulletPuff");
		Stop;
 }
}