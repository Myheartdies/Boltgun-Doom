class ExaltedFlamer : Cacodemon
{
	Default
	{
		Health 400;
		Radius 31;
		Height 56;
		Mass 400;
		Speed 8;
		PainChance 100;
		PainThreshold 15;
		Monster;
		Scale 0.44;
		+FLOAT +NOGRAVITY
		SeeSound "exflamer/sight";
		PainSound "exflamer/pain";
		DeathSound "exflamer/death";
		ActiveSound "caco/active";
		Obituary "$OB_CACO";
		HitObituary "$OB_CACOHIT";
		Tag "$FN_CACO";
	}
	States
	{
	Spawn:
		EFLM UV 8 A_Look;
		Loop;
	See:
		EFLM AABBCCDD 3 A_Chase;
		Loop;
	Missile:
		EFLM EFG 3 A_FaceTarget;
		EFLM H 5 BRIGHT A_HeadAttack;
		EFLM I 3;
		Goto See;
	Pain:
		EFLM N 3;
		EFLM O 5 A_Pain;
		Goto See;
	Death:
		EFLM P 8 A_Scream;
		EFLM P 8;
		EFLM Q 8;
		EFLM R 8;
		EFLM S 8 A_NoBlocking;
		EFLM T -1 A_SetFloorClip;
		Stop;
	Raise:
		EFLM T 8 A_UnSetFloorClip;
		EFLM SRQPP 8;
		Goto See;
	}
}
