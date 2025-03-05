class Plush : LostSoul Replaces LostSoul
{
	Default
	{
		Health 100;
		Radius 16;
		Height 56;
		Mass 50;
// 		Speed 10;
// 		Damage 10;
		PainChance 256;
		Monster;
		+FLOAT +NOGRAVITY +MISSILEMORE +DONTFALL +NOICEDEATH +ZDOOMTRANS +RETARGETAFTERSLAM
		AttackSound "plush/generic";
		PainSound "plush/hurt";
		DeathSound "plush/hurt";
		ActiveSound "plush/generic";
// 		RenderStyle "SoulTrans";
		Obituary "$OB_SKULL";
		Tag "$FN_LOST";
		Scale 0.18;
	}
	States
	{
	Spawn:
		DPLS AA 10 BRIGHT A_Look;
		Loop;
	See:
		DPLS AA 3 BRIGHT A_Chase;
		Loop;
	Missile:
		DPLS A 10 BRIGHT A_FaceTarget;
		DPLS A 4 BRIGHT A_SkullAttack;
		DPLS AA 4 BRIGHT;
		Goto Missile+2;
	Pain:
		DPLS A 3 BRIGHT;
		DPLS A 3 BRIGHT A_Pain;
		Goto See;
	Death:
		SKUL F 6 BRIGHT;
		SKUL G 6 BRIGHT A_Scream;
		SKUL H 6 BRIGHT;
		SKUL I 6 BRIGHT A_NoBlocking;
		SKUL J 6;
		SKUL K 6;
		Stop;
	}
}

// class Plush : LostSoul Replaces LostSoul
// {
// 	Default
// 	{
// 		AttackSound "plush/generic";
// 		PainSound "plush/hurt";
// 		DeathSound "plush/hurt";
// 		ActiveSound "plush/generic";

// 	}
// 	States
// 	{
// 	Spawn:
// 		PLSH AA 10 BRIGHT A_Look;
// 		Loop;
// 	See:
// 		PLSH AA 3 BRIGHT A_Chase;
// 		Loop;
// 	Missile:
// 		PLSH A 10 BRIGHT A_FaceTarget;
// 		PLSH A 4 BRIGHT A_SkullAttack;
// 		PLSH AA 4 BRIGHT;
// 		Goto Missile+2;
// 	Pain:
// 		PLSH A 3 BRIGHT;
// 		PLSH A 3 BRIGHT A_Pain;
// 		Goto See;
// 	Death:
// 		SKUL F 6 BRIGHT;
// 		SKUL G 6 BRIGHT A_Scream;
// 		SKUL H 6 BRIGHT;
// 		SKUL I 6 BRIGHT A_NoBlocking;
// 		SKUL J 6;
// 		SKUL K 6;
// 		Stop;
// 	}
// }