class BlueHorror : Demon replaces Demon
{
	Default
	{
		Health 150;
		PainChance 180;
		Speed 6;
		Radius 22;
		Height 56;
		Mass 400;
		Scale 0.6;
		Monster;
		+FLOORCLIP
		SeeSound "bluehorror/sight";
		AttackSound "bluehorror/attack";
		PainSound "bluehorror/pain";
		DeathSound "bluehorror/death";
		ActiveSound "bluehorror/active";
		Obituary "$OB_DEMONHIT";
		Tag "$FN_DEMON";
	}
	States
	{
	Spawn:
		BLHR QRS 10 A_Look;
		Loop;
	See:
		BLHR AABBCCDDEE 1 A_Chase;
		BLHR FF 2 A_Chase;
		Loop;
	Melee:
		BLHR G 12 A_FaceTarget;
		BLHR HI 8 A_SargAttack;
		Goto See;
	Pain:
		BLHR K 2 Fast;
		BLHR L 2 Fast A_Pain;
		Goto See;
	Death:
		BLHR M 8 A_Scream;
		BLHR N 8;
		BLHR O 4;
		BLHR O 4 A_NoBlocking;
		BLHR P 4;
		BLHR P -1;
		Stop;
	Raise:
		SARG N 5;
		SARG MLKJI 5;
		Goto See;
	}
}
	