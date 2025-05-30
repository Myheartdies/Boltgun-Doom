class Flamer1 : DoomImp
{
	Default
	{
		Health 75;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 8;
		PainChance 200;
		Monster;
		Scale 0.4;
// 		DamageFactor "SmallExplosion", 0.6;
		+FLOORCLIP
// 		+FLOAT +NOGRAVITY
		SeeSound "flamer/sight";
		PainSound "flamer/pain";
		DeathSound "flamer/death";
		ActiveSound "flamer/active";
		HitObituary "$OB_IMPHIT";
		Obituary "$OB_IMP";
		Tag "$FN_IMP";
	}
	States
	{
	Spawn:
		FLM1 AB 10 A_Look;
		Loop;
	See:
		FLM1 AABBCCDD 3 A_Chase;
		Loop;
	Melee:
		FLM1 HF 8 A_FaceTarget;
		FLM1 G 6 A_CustomMeleeAttack(3 * random(1, 8), "imp/melee");
	Missile:
		FLM1 H 8 A_FaceTarget;
		FLM1 F 8 Bright A_FaceTarget;
		FLM1 F 2 Bright A_FaceTarget;
		FLM1 G 6 FlamerMissile ;
// 		FLM1 G 8 FlamerMissile ;
		Goto See;
	Pain:
		FLM1 J 2;
		FLM1 J 2 A_Pain;
		Goto See;
	Death:
		FLM1 K 8 A_Scream;
		FLM1 L 8;
		FLM1 M 6;
		FLM1 N 6 A_NoBlocking;
		FLM1 O -1;
		Stop;
	XDeath:
		OVKS J 1;
		FLM1 K 5 A_StartSound("flamer/death");
		FLM1 L 5 A_NoBlocking;
		FLM1 M 5;
		FLM1 N 5;
		FLM2 OOO 5;
		OVKS J -1;
		Stop;
// 		OVKS A 5 A_NoBlocking;
// 		OVKS B 5 A_XScream;
// 		OVKS C 5 A_NoBlocking;
// 		OVKS DEFGHI 3;
// 		OVKS J -1;
// 		Stop;
	Raise:
		TROO ML 8;
		TROO KJI 6;
		Goto See;
	}
	void FlamerMissile(){
		A_SpawnProjectile("FlamerBall", 32, 0);
// 		A_SpawnProjectile("FlamerBall", 32, 10);
	}
}

class Flamer2 : Flamer1
{
	Default
	{
		Scale 0.6;
	}
	States
	{
	Spawn:
		FLM2 AB 10 A_Look;
		Loop;
	See:
		FLM2 AABBCCDD 3 A_Chase;
		Loop;
	Melee:
		FLM2 HF 8 A_FaceTarget;
		FLM2 G 6 A_CustomMeleeAttack(3 * random(1, 8), "imp/melee");
	Missile:
		FLM2 HF 8 A_FaceTarget;
		FLM2 F 2 Bright A_FaceTarget;
		FLM2 G 6 FlamerMissile ;
// 		FLM2 G 8 FlamerMissile ;
		Goto See;
	Pain:
		FLM2 J 2;
		FLM2 J 2 A_Pain;
		Goto See;
	Death:
		FLM2 K 8 A_Scream;
		FLM2 L 8;
		FLM2 M 6;
		FLM2 N 6 A_NoBlocking;
		FLM2 O -1;
		Stop;
	XDeath:
		OVKS J 1;
		FLM2 K 5 A_StartSound("flamer/death");
		FLM2 L 5;
		FLM2 M 5;
		FLM2 N 5 A_NoBlocking;
		FLM2 OOO 5;
		TROO U -1;
		Stop;
	Raise:
		TROO ML 8;
		TROO KJI 6;
		Goto See;
	}

}

class Flamer3 : Flamer1
{
	Default
	{
		Scale 0.6;
	}

	States
	{
	Spawn:
		FLM3 AB 10 A_Look;
		Loop;
	See:
		FLM3 AABBCCDD 3 A_Chase;
		Loop;
	Melee:
		FLM3 HF 8 A_FaceTarget;
		FLM3 G 6 A_CustomMeleeAttack(3 * random(1, 8), "imp/melee");
	Missile:
		FLM3 HF 8 A_FaceTarget;
		FLM3 F 2 Bright A_FaceTarget;
		FLM3 G 6 FlamerMissile ;
		Goto See;
	Pain:
		FLM3 J 2;
		FLM3 J 2 A_Pain;
		Goto See;
	Death:
		FLM3 K 8 A_Scream;
		FLM3 L 8;
		FLM3 M 6;
		FLM3 N 6 A_NoBlocking;
		FLM3 O -1;
		Stop;
	XDeath:
		OVKS J 1;
		FLM3 K 5 A_StartSound("flamer/death");
		FLM3 L 5;
		FLM3 M 5;
		FLM3 N 5 A_NoBlocking;
		FLM3 OOO 5;
		TROO U -1;
		Stop;
	Raise:
		TROO ML 8;
		TROO KJI 6;
		Goto See;
	}
	void FlamerMissile(){
		A_SpawnProjectile("FlamerBall", 32, 0);
// 		A_SpawnProjectile("FlamerBall", 32, 10);
	}
}

class FlamerBall: DoomImpBall{
	Default
	{
		SeeSound "flamer/attack";
// 		Damage 5;
		Speed 12
		;
// 		FastSpeed 25;
	}
}

