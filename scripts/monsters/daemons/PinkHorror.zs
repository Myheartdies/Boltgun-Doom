class Revenant : Actor
{
	Default
	{
		Health 300;
		Radius 20;
		Height 56;
		Mass 500;
		Speed 10;
		PainChance 100;
		Monster;
		MeleeThreshold 196;
		+MISSILEMORE 
		+FLOORCLIP
		SeeSound "skeleton/sight";
		PainSound "skeleton/pain";
		DeathSound "skeleton/death";
		ActiveSound "skeleton/active";
		MeleeSound "skeleton/melee";
		HitObituary "$OB_UNDEADHIT";
		Obituary "$OB_UNDEAD";
		Tag "$FN_REVEN";
	}
	States
	{
	Spawn:
		SKEL AB 10 A_Look;
		Loop;
	See:
		SKEL AABBCCDDEEFF 2 A_Chase;
		Loop;
	Melee:
		SKEL G 0 A_FaceTarget;
		SKEL G 6 A_SkelWhoosh;
		SKEL H 6 A_FaceTarget;
		SKEL I 6 A_SkelFist;
		Goto See;
	Missile:
		SKEL J 0 BRIGHT A_FaceTarget;
		SKEL J 10 BRIGHT A_FaceTarget;
		SKEL K 10 A_SkelMissile;
		SKEL K 10 A_FaceTarget;
		Goto See;
	Pain:
		SKEL L 5;
		SKEL L 5 A_Pain;
		Goto See;
	Death:
		SKEL LM 7;
		SKEL N 7 A_Scream;
		SKEL O 7 A_NoBlocking;
		SKEL P 7;
		SKEL Q -1;
		Stop;
	Raise:
		SKEL Q 5;
		SKEL PONML 5;
		Goto See;
	}
}