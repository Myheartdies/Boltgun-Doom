class Screamer : Actor Replaces LostSoul
{
	Default
	{
		Health 100;
		Radius 16;
		Height 56;
		Mass 50;
		Speed 8;
		Damage 3;
		PainChance 256;
		Monster;
		+FLOAT +NOGRAVITY +NOICEDEATH  +RETARGETAFTERSLAM
		AttackSound "skull/melee";
		PainSound "skull/pain";
		DeathSound "skull/death";
		ActiveSound "skull/active";
		Obituary "$OB_SKULL";
		MinMissileChance 250;
		Tag "$FN_LOST";
		Scale 0.4;
	}
	States
	{
	Spawn:
		SRMA AB 10 BRIGHT A_Look;
		Loop;
	See:
		SRMA ABCDEF 4 BRIGHT A_Chase;
		Loop;
	Missile:
		SRMA GH 5 BRIGHT A_FaceTarget;
		SRMA I 4 BRIGHT A_SkullAttack;
		SRMA IJ 4 BRIGHT;
		Goto Missile+3;
	Pain:
		SRMA P 3 BRIGHT;
		SRMA P 3 BRIGHT A_Pain;
		Goto See;
	Death:
		SRMA Q 6 BRIGHT;
		SRMA R 6 BRIGHT A_Scream;
		SRMA S 6 BRIGHT;
		SRMA T 6 BRIGHT A_NoBlocking;
		SRMA U 6;
		Stop;
	}
}