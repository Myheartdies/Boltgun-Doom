class PlushElemental : PainElemental Replaces PainElemental
{
	Default
	{
// 		Health 400;
// 		Radius 31;
// 		Height 56;
// 		Mass 400;
// 		Speed 8;
// 		PainChance 128;
// 		Monster;
// 		+FLOAT
// 		+NOGRAVITY
		SeeSound "plush/generic";
		PainSound "plush/generic";
		DeathSound "plush/generic";
		ActiveSound "plush/generic";
		Tag "$FN_PAIN";
		YScale 0.24;
		XScale 0.36;
	}
	States
	{
	Spawn:
		DPLS A 10 A_Look;
		Loop;
	See:
		DPLS AAAAAAAA 3 A_Chase;
		Loop;
	Missile:
		DPLS A 5 A_FaceTarget;
		DPLS A 5 A_FaceTarget;
		DPLS A 5 BRIGHT A_FaceTarget;
		DPLS A 0 BRIGHT A_PainAttack;
		Goto See;
	Pain:
		DPLS A 6;
		DPLS A 6 A_Pain;
		Goto See;
	Death:
		DPLS A 8 BRIGHT;
		DPLS A 8 BRIGHT A_Scream;
		DPLS AA 8 BRIGHT;
		DPLS A 8 BRIGHT A_PainDie;
		DPLS A 8 BRIGHT;
		Stop;
	Raise:
		DPLS AAAAAA 8;
		Goto See;
	}
}