class Cultist1 : ZombieMan
{
	Default
	{
		Health 20;
		GibHealth 10;
		Radius 20;
		Height 56;
		Speed 8;
		PainChance 200;
		Scale 0.58;
		Monster;
		+FLOORCLIP
		+DOHARMSPECIES
		DamageFactor "Bolt", 2;
		SeeSound "CLTA/sight";
		AttackSound "grunt/attack";
		PainSound "grunt/pain";
		DeathSound "grunt/death";
		ActiveSound "grunt/active";
		Obituary "$OB_ZOMBIE";
		Tag "$FN_ZOMBIE";
		DropItem "Clip";
	}
 	States
	{
	Spawn:
		TNT1 A 1 spawnTeammate;
		CLT1 MN 10 A_Look;
		Wait;
	See:
		CLT1 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT1 E 10 A_FaceTarget;
		CLT1 F 8 CultistMissile;
		CLT1 E 8;
		Goto See;
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
			A_CustomBulletAttack(2
			, 0, 1,0, pufftype :"BulletPuff",0, flags:CBAF_NORANDOM, missile:"Tracer");
		}
		
// 		A_StartSound("weapons/pistol",flags:CHAN_WEAPON);
// 		A_SpawnProjectile("Tracer");
// 		A_CustomBulletAttack(22.5, 0, 3,0, pufftype :"BulletPuff", 0, flags:CBAF_NORANDOM);
	}
}
class Cultist2 : Cultist1
{
	States
	{
	Spawn:
		CLT2 MN 10 A_Look;
		Loop;
	See:
		CLT2 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT2 E 10 A_FaceTarget;
		CLT2 F 8 CultistMissile;
		CLT2 E 8;
		Goto See;
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
}

class Cultist3 : Cultist1
{
	States
	{
	Spawn:
		CLT3 MN 10 A_Look;
		Loop;
	See:
		CLT3 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT3 E 10 A_FaceTarget;
		CLT3 F 8 CultistMissile;
		CLT3 E 8;
		Goto See;
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
}
// Cultist 4's sprite order is different from others because it was the original that replaces the
// zombieman texture directly
// TODO: change it to the same as others
class Cultist4 : Cultist1
{
 	States
	{
	Spawn:
		CLT4 AB 10 A_Look;
		Loop;
	See:
		CLT4 AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		CLT4 E 10 A_FaceTarget;
		CLT4 F 8 CultistMissile;//A_PosAttack;
		CLT4 E 8;
		Goto See;
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
}

class Tracer : FastProjectile
{
	Default
	{
		Scale 0.4;
		Radius 1;
		Height 1;
		Speed 60;
		FastSpeed 120;
		+FORCEXYBILLBOARD
//    Damage 3;
		DamageFunction 3*random(1,5);
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