class CultistShock: ShotgunGuy
{
	Default
	{
		Health 40;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 7;
		PainChance 170;
		Monster;
		+FLOORCLIP
		+DOHARMSPECIES
		MissileChanceMult 0.8;
		DamageFactor "Bolt", 2;
		SeeSound "CLTS/sight";
		AttackSound "weapons/shotgf";//"shotguy/attack";
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
		CLTS AABBCCDD 2 A_Chase;
		Loop;
	Missile:
		CLTS E 10 A_FaceTarget;
		CLTS F 5 BRIGHT ShotgunnerMissile;//A_SposAttackUseAtkSound;
		CLTS GI 3;
		CLTS JKL 3;
		Goto See;
	Pain:
		CLTS M 3;
		CLTS M 3 A_Pain;
		Goto See;
	Death:
		CLTS N 5;
		CLTS O 5 A_Scream;
		CLTS P 5 A_NoBlocking;
		CLTS Q 5;
		CLTS R -1;
		Stop;
	XDeath:
		OVKS A 5 A_NoBlocking;
		OVKS B 5 A_XScream;
		OVKS C 5 ;
		OVKS DEFGHI 3;
		OVKS J -1;
		Stop;
	Raise:
		CLTS R 5;
		CLTS QPON 5;
		Goto See;
	}
	
	action void ShotgunnerMissile(){
		A_StartSound("shotguy/attack", CHAN_WEAPON);
		for (int i = 0; i < 3; i ++)
		A_SpawnProjectile("Tracer", angle:random(-11,11), flags: CMF_AIMOFFSET, pitch: random(-2,2));
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