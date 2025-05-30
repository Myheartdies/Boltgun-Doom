class MissileLauncher : SternguardWeapon Replaces RocketLauncher
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
		SternguardWeapon.TauntOffsetX 80;
		SternguardWeapon.TauntOffsetY 45;
	}
	States
	{
	Ready:
		MSLL A 1 A_WeaponReady;
		Loop;
	Deselect:
		MSLL A 1 {
			A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			A_Lower(18);
			}
		Loop;
	Select:
		MSLL A 1 {
			A_WeaponReady(WRF_NOBOB);
			A_Lower(18);
		}
		Loop;
	Fire:
// 		TNT1 A 0 OverlayReAdjust;
		MSLL B 3 Bright{A_GunFlash();A_Light2();}
		MSLL C 3 Bright FireFragMissile();
		MSLL C 3 Bright ;
        MSLL D 3 {A_Light0();}
		TNT1 A 0 A_CheckReload;
// 		MSLL D 0 A_ReFire;
		Goto Reload;
	Reload:
		MSLL EFGH 4;
		MSLL I 3 A_StartSound("weapons/missile_launcher_reload", CHAN_AUTO);
		MSLL JKL 3 A_WeaponReady(WRF_NOFIRE);
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
// 		A_FireProjectile("FragMissile");
		A_FireBullets(0, 0, 1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM|FBF_USEAMMO,0,"FragMissile", 0,7 );
		A_StartSound ("weapons/missile_launcher_fire", CHAN_AUTO, 0, 1.05,ATTN_NONE);
	}
}


class FragMissile : Rocket
{
	Default
	{
// 		Scale 1.5;
		Radius 8;
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
		MISL A 1 Bright {
			missileTrail();
			A_Quake(0.4, 2, 0, 50);
		}
		Loop;
	Death:
		MSEX A 1 Bright {
		A_Explode(170,150,XF_HURTSOURCE,True, 75,0,0,"bulletpuff",damagetype = "ExplosionSelfDamage");
		A_QuakeEx(0,1.2,2, 20, 0, 2000,flags:QF_SCALEDOWN|QF_SHAKEONLY);
		}
		MSEX B 0 Bright missileExplosion();
		TNT1 A 6 ;
		TNT1 A 24 {
			firering("",270,0);
			firering("orange", 460, 0,0.5);
			}
		TNT1 B 15 ;
// 		MISL D 4 Bright;
		Stop;
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	}
	action void missileTrail(){
// 		Fire trail
		A_SpawnParticle("fba744",SPF_FULLBRIGHT, 20 , 12 , 0
		, 0+frandom(-0.5,0.5), 0+frandom(-0.5,0.5), 4+frandom(-0.5,0.5)
		, 0,0,0, 0,0,0
		, 1,-1,-0.3);
	}
	action void missileExplosion(){
		spawnCenterExplosion(180);

// 		firering("orange", 420, 0,0.5);
		for (int i = 0; i < 20; i++){
			spawnFragParticle(frandom(15,20));
		}
// 		Spawn a ton of particles
		float angle1;
		float angle2;
		float speed;
		for (int i = 0; i < 400; i++)
		{
			angle1 = frandom(0,360);
			angle2 = frandom(90,185);
			speed = frandom(4,13);
			invoker.A_SpawnParticle("grey4", 0, 40, 8
// 				, velx:frandom(-8,8), vely:frandom(-8,8), velz:frandom(-2,12),
				, velx: speed * cos(angle2) * sin(angle1), vely: speed * cos(angle2) * cos(angle1), velz: speed * sin(angle2),
				accelz: -0.2);
				
			angle1 = frandom(0,360);
			angle2 = frandom(90,185);
			speed = frandom(4,13);
			invoker.A_SpawnParticle("orange", SPF_FULLBRIGHT, 40, 8
// 				, velx:frandom(-8,8), vely:frandom(-8,8), velz:frandom(-2,12),
				, velx: speed * cos(angle2) * sin(angle1), vely: speed * cos(angle2) * cos(angle1), velz: speed * sin(angle2),
				accelz: -0.2);
		}
		
	}
	
	action void spawnCenterExplosion(float baseSize){
		invoker.A_SpawnParticleEx("", TexMan.CheckForTexture("EXIAA0")
		,0,SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELPOS|SPF_RELANG|SPF_ROLL  , 63
		, baseSize, 0
		,0, 0, 10
		,0,0,0, 0,0,0
		, 0.9, 0.008, 10
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
		,0,SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELVEL|SPF_RELACCEL|SPF_RELANG  |SPF_ROLL  , 60
		, baseSize, 0
// 		,random(-30,30), random(-30,30), random(-30,30)
// 		,offsety, offsetx, offsetz
		,0,0,0
		
// 		,0,0,0,0,0,0
		,-offsety,offsetx,offsetz, offsety/80,-offsetx/80,-offsetz/80
// 		, 0,0,0, offsety, offsetx, offsetz
		, 0.8, -0.002, 8
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