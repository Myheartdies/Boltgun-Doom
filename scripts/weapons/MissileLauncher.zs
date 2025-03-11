class MissileLauncher : RocketLauncher Replaces RocketLauncher
{
	Default
	{
        Weapon.WeaponScaleX 0.8; 
		Weapon.WeaponScaleY 0.8;
		Weapon.SelectionOrder 2500;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 2;
		Weapon.AmmoType "RocketAmmo";
		+WEAPON.NOAUTOFIRE
		Inventory.PickupMessage "$GOTLAUNCHER";
		Tag "$TAG_ROCKETLAUNCHER";
		Weapon.BobSpeed 1.8;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 1.0;	
	}
	States
	{
	Ready:
		MSLL A 1 A_WeaponReady;
		Loop;
	Deselect:
		MSLL A 1 A_Lower(15);
		Loop;
	Select:
		MSLL A 1 A_Raise(15);
		Loop;
	Fire:
		MSLL B 3 Bright{A_GunFlash();A_Light2();}
		MSLL C 3 Bright FireFragMissile();
		MSLL C 3 Bright;
        MSLL D 3 A_Light0;
// 		MSLL D 0 A_ReFire;
		Goto Reload;
	Reload:
		MSLL EFGH 4;
		MSLL I 3 A_StartSound("weapons/missile_launcher_reload", CHAN_AUTO);
		MSLL JKL 3;
		MSLL MNO 4 {A_ReFire("Fire");A_WeaponReady();}
		Goto Ready;
	Flash:
		MISF A 0 Bright A_Light1;
// 		MISF B 4 Bright;
		MISF CD 0 Bright A_Light2;
		Goto LightDone;
	Spawn:
		LAUN A -1;
		Stop;
	}
	action void FireFragMissile(){
		A_FireProjectile("FragMissile");
		A_StartSound ("weapons/missile_launcher_fire", CHAN_AUTO, 0, 1.05,ATTN_NONE);
	}
}


class FragMissile : Rocket
{
	Default
	{
// 		Scale 1.5;
		Radius 11;
		Height 8;
		Speed 40;
// 		Damage 25;
		DamageFunction 25 * random(2,7);
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ROCKETTRAIL
		+ZDOOMTRANS
// 		SeeSound "weapons/missile_launcher_fire";
		DeathSound "weapons/missile_launcher_explosion";
		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		MISL A 1 Bright;
		Loop;
	Death:
		MSEX A 1 Bright A_Explode(170,150,XF_HURTSOURCE,True, 100,0,0,"bulletpuff",damagetype = "ExplosionSelfDamage");
		MSEX B 0 Bright missileExplosion();
		TNT1 A 6 ;
		TNT1 A 24 {firering("",256,0);
		firering("orange", 420, 0,0.5);}
		TNT1 B 15 ;
// 		MISL D 4 Bright;
		Stop;
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	}

	action void missileExplosion(){
		spawnCenterExplosion(150);
// 		firering("",256,0);
// 		firering("orange", 420, 0,0.5);
		for (int i = 0; i < 20; i++){
			spawnFragParticle(frandom(15,20));
		}
		
	}
	action void spawnCenterExplosion(float baseSize){
		invoker.A_SpawnParticleEx("", TexMan.CheckForTexture("EXIAA0")
		,0,SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELPOS|SPF_RELANG|SPF_ROLL  , 63
		, baseSize, 0
		,0, 0, 0
		,0,0,0, 0,0,0
		, 0.9, -0.005, 10
// 		,random(0,12)*30
		);
	}
	
	action void spawnFragParticle(float baseSize, float length = 3){
		float angle1  = random(1,12)*30; //horizontal angle
		float angle2 = random(1,12)*30; //vertical angle
// 		float length =
		float offsetx = length * cos(angle2) * cos(angle1);
		float offsety = length * cos(angle2) * cos(angle2);
		float offsetz = length * sin(angle2);
		invoker.A_SpawnParticleEx("", TexMan.CheckForTexture("EXFAA0")
		,0,SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELVEL|SPF_RELACCEL|SPF_RELANG  |SPF_ROLL  , 63
		, baseSize, 0
// 		,random(-30,30), random(-30,30), random(-30,30)
// 		,offsety, offsetx, offsetz
		,0,0,0
		
// 		,0,0,0,0,0,0
		,-offsety,offsetx,offsetz, offsety/80,-offsetx/80,-offsetz/80
// 		, 0,0,0, offsety, offsetx, offsetz
		, 0.8, -1, 8
		,random(0,12)*30
		);
	}
	action void firering(color color1, float baseSize = 256, float distanceOffset = 0, float alpha = 1){
		invoker.A_SpawnParticleEx(color1, TexMan.CheckForTexture("MSEXA0")
		,0,SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELPOS|SPF_RELANG|SPF_ROLL  , 48
		, baseSize, 0
		,distanceOffset, 0, 0
		,0,0,0, 0,0,0
		, alpha, 0, 15
		);
	}
	action void fragExplosion(color color1, float baseSize = 256, float distanceOffset = 0, float alpha = 1){
		invoker.A_SpawnParticleEx(color1, TexMan.CheckForTexture("MSEXA0")
		,0,SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELPOS|SPF_RELANG|SPF_ROLL  , 24
		, baseSize, 0
		,distanceOffset, 0, 0
		,0,0,0, 0,0,0
		, alpha, 0, 20
		);
	}
}