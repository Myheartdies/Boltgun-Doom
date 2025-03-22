class CultistShock: ShotgunGuy
{
	Default
	{
		Health 30;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 10;
		PainChance 170;
		Monster;
		+FLOORCLIP
		DamageFactor "Bolt", 2;
		SeeSound "shotguy/sight";
		AttackSound "shotguy/attack";
		PainSound "shotguy/pain";
		DeathSound "shotguy/death";
		ActiveSound "shotguy/active";
		Obituary "$OB_SHOTGUY";
		Scale 0.66;
		Tag "$FN_CLTS";
		DropItem "Shotgun";
	}
	States
	{
	Spawn:
		CLTS AB 10 A_Look;
		Loop;
	See:
		CLTS AABBCCDD 3 A_Chase;
		Loop;
	Missile:
		CLTS E 10 A_FaceTarget;
		CLTS F 5 BRIGHT ShotgunnerMissile;//A_SposAttackUseAtkSound;
		CLTS MN 3 BRIGHT;
		CLTS OPQ 3;
		Goto See;
	Pain:
		CLTS G 3;
		CLTS G 3 A_Pain;
		Goto See;
	Death:
		CLTS H 5;
		CLTS I 5 A_Scream;
		CLTS J 5 A_NoBlocking;
		CLTS K 5;
		CLTS L -1;
		Stop;
	XDeath:
		OVKS A 5 A_NoBlocking;
		OVKS B 5 A_XScream;
		OVKS C 5 ;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	Raise:
		CLTS L 5;
		CLTS KJIH 5;
		Goto See;
	}
	
	action void ShotgunnerMissile(){
		A_StartSound("shotguy/attac",flags:CHAN_WEAPON);
		A_CustomBulletAttack(25
		, 0, 3,0, pufftype :"BulletPuff",0, flags:CBAF_NORANDOM,missile:"ShotgunTracer");
// 		A_CustomBulletAttack(22.5, 0, 3,0, pufftype :"BulletPuff", 0, flags:CBAF_NORANDOM);
// 		A_SpawnProjectile("Tracer");
	}
}

class ShotgunTracer: Tracer{
	Default
	{
		Scale 0.3;
// 		DamageFunction 3 * random(1,3);
	}
}