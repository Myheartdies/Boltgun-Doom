class PlasmaRenegade : DoomImp  /*Replaces DoomImp*/
{

	Default
	{
		Health 70;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 6;
		PainChance 200;
		Monster;
		+FLOORCLIP
		+MISSILEMORE
		DamageFactor "Bolt", 2;
		SeeSound "imp/sight";
		PainSound "imp/pain";
		DeathSound "imp/death";
		ActiveSound "imp/active";
		HitObituary "$OB_IMPHIT";
		Obituary "$OB_IMP";
		Tag "$FN_IMP";
		Scale 0.50;
		DropItem "Cell";
		DropItem "Shotgun";
	}
	States
	{
	Spawn:
		GCLT AB 10 A_Look;
		Loop;
	See:
		GCLT AABBCCDD 3 A_Chase;
		Loop;
	Melee:
	Missile:
		GCLT Q 2 A_StartSound("CLTP/charge",0, 1.3);
		GCLT RSTU 3 Bright A_FaceTarget;
		GCLT E 2 Bright A_FaceTarget;
		GCLT F 2 Bright A_FaceTarget;
		GCLT G 2 Bright A_CustomComboAttack("RenegadePlasmaBall", 32, 3 * random(1, 6));
		GCLT H 3 Bright ;
		GCLT IJK 3;
		Goto See;
	Pain:
		GCLT L 2;
		GCLT L 2 A_Pain;
		Goto See;
	Death:
		GCLT L 8;
		GCLT M 8 A_Scream;
		GCLT N 6;
		GCLT O 6 A_NoBlocking;
		GCLT P -1;
		Stop;
	XDeath:
		OVKS A 5;
		OVKS B 5 A_XScream;
		OVKS C 5 A_NoBlocking;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	Raise:
		GCLT PO 8;
		GCLT NML 6;
		Goto See;

	}

 	
}

class RenegadePlasmaBall :CacodemonBall{
	Default
		{
			SeeSound "CLTP/attack";
// 			StencilColor "f1680a";
// 			RenderStyle "Shaded";
		}
	States
	{
	Spawn:
		BAL2 AB 4 BRIGHT;
		Wait;
	Death:
		BAL2 CDE 6 BRIGHT;
		Stop;
	}
}