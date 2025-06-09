class CultistHeavy : ChaingunGuy Replaces ChaingunGuy
{
	Default
	{
		Health 70;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 8;
		PainChance 170;
		Monster;
		+FLOORCLIP
		+DOHARMSPECIES
		DamageFactor "Bolt", 2;
		SeeSound "CLTH/sight";
		PainSound "chainguy/pain";
		DeathSound "chainguy/death";
		ActiveSound "chainguy/active";
		AttackSound "chainguy/attack";
		Obituary "$OB_CHAINGUY";
		Tag "$FN_HEAVY";
		Dropitem "Chaingun";
		Scale 0.62;
	}
	States
	{
	Spawn:
		CLTH AB 10 A_Look;
		Loop;
	See:
		CLTH AABBCCDD 3 A_Chase;
		Loop;
	Missile:
		CLTH E 10 A_FaceTarget;
		CLTH FE 4 BRIGHT CultistHeavyMissile;
		CLTH F 1 A_CPOSRefire;
		Goto Missile+1;
	Pain:
		CLTH G 3;
		CLTH G 3 A_Pain;
		Goto See;
	Death:
		CLTH H 5;
		CLTH I 5 A_Scream;
		CLTH J 5 A_NoBlocking;
		CLTH KLM 5;
		CLTH N -1;
		Stop;
	XDeath:
		OVKS A 5 A_NoBlocking;
		OVKS B 5 A_XScream;
		OVKS C 5 A_NoBlocking;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	}
	
	action void CultistHeavyMissile(){
		if (target)
		{
			A_FaceTarget();
			A_StartSound("shotguy/attack", CHAN_WEAPON);
			A_SpawnProjectile("Tracer", angle: frandom(-11.5,11.5), flags: CMF_AIMOFFSET, pitch: random(-2,2));
		}
	}
 	
}

class ChaingunTracer : Tracer
{
	Default
	{
		DamageFunction 3*random(1,4);
	}

}