class Cultist1 : ZombieMan
{
	int maxBurstCount;
	protected int burstCount;
	Property MaxBurstCount : maxBurstCount;
	Default
	{
		Health 20;
		GibHealth 8;
		Radius 20;
		Height 56;
		Speed 8;
		PainChance 200;
		Scale 0.58;
		Monster;
// 		+MISSILEMORE
		+FLOORCLIP
		+DOHARMSPECIES
		+PUSHABLE
		DamageFactor "Bolt", 2;
		SeeSound "CLTA/sight";
		AttackSound "grunt/attack";
		PainSound "grunt/pain";
		DeathSound "grunt/death";
		ActiveSound "grunt/active";
		Obituary "$OB_ZOMBIE";
		Tag "$FN_ZOMBIE";
		Cultist1.MaxBurstCount 3;
		FriendlySeeBlocks 5;
		
	}
 	States
	{
	Spawn:
		TNT1 A 1 spawnTeammate;
		CLT1 MN 10 A_Look;
		Wait;
	See:
		TNT1 A 0 BurstCountReset;
		CLT1 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT1 E 8 A_FaceTarget;
	Firing:
		CLT1 E 2 A_FaceTarget;
		CLT1 F 8 Bright CultistMissile;
		CLT1 E 6;
		CLT1 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing;
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
		OVKS A 5 A_NoBlocking;
		OVKS B 5 A_XScream;
		OVKS C 5 A_NoBlocking;
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
			A_StartSound("grunt/attack", CHAN_WEAPON,CHANF_OVERLAP);
			A_SpawnProjectile("Tracer", angle:random(-13,13)+ 0.5*invoker.burstCount, flags: CMF_AIMOFFSET);
		}
		
// 		A_StartSound("weapons/pistol",flags:CHAN_WEAPON);
// 		A_SpawnProjectile("Tracer");
// 		A_CustomBulletAttack(22.5, 0, 3,0, pufftype :"BulletPuff", 0, flags:CBAF_NORANDOM);
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
		CLT2 MN 10 A_Look;
		Loop;
	See:
		TNT1 A 0 BurstCountReset;
		CLT2 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT2 E 8 A_FaceTarget;
	Firing:
		CLT2 E 2 A_FaceTarget;
		CLT2 F 8 Bright CultistMissile;
		CLT2 E 5;
		CLT2 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing;
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
		CLT3 MN 10 A_Look;
		Loop;
	See:
		TNT1 A 0 BurstCountReset;
		CLT3 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT3 E 8 A_FaceTarget;
	Firing:
		CLT3 E 2 A_FaceTarget;
		CLT3 F 8 Bright CultistMissile;
		CLT3 E 6;
		CLT3 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing;
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
		CLT4 AB 10 A_Look;
		Loop;
	See:
		TNT1 A 0 BurstCountReset;
		CLT4 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT4 E 8 A_FaceTarget;
	Firing:
		CLT4 E 2 A_FaceTarget;
		CLT4 F 8 Bright CultistMissile;//A_PosAttack;
		CLT4 E 5;
		CLT4 E 2 A_Jump(CultistRefireChance(),"See");
		Goto Firing;
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