class AstartesShotgun : ShellEjectingWeapon Replaces Shotgun
{
	int reloadInput;
	override void BeginPlay(){
		dropSoundVolume = 1.1;
		queueLength = 10;
		maxCasingCount = 2;
		casingDropSound = "weapon/scout_shotgun_casing";
		
		reloadInput = 0;
		super.BeginPlay();
	}
	Default
	{
		Weapon.SelectionOrder 1300;
		Weapon.AmmoUse 1;
// 		Weapon.AmmoGive 8;
		Weapon.KickBack 300;
// 		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN";
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
// 		+WEAPON.NOAUTOAIM
		Weapon.AmmoType1 "ShellInTube";
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoGive1 5;
		Weapon.AmmoGive2 10;
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Weapon.BobSpeed 2;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 1.1;
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_AST_SHOTGUN";
	}
	States
	{
	Ready:
		STGN A 4 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
// 		STGN A 1 Offset(0, 34);
// 		STGN A 1 Offset(0, 60);
// 		STGN A 1 Offset(0, 80);
		STGN A 1 {
			A_Lower(15);
			CasingLayerExit();
		}
		Wait;
	Select:
		STGN A 1 A_WeaponOffset(0,32);
		STGN A 1 {
			A_Raise(18);
			A_ClearOverlays(-1-invoker.maxCasingCount, -2);
			CasingLayerReady();
		}
		Wait;
	Fire:
// 		Go to reload if out of ammo
		TNT1 A 0 A_JumpIfInventory("ShellInTube", 1, 1);
		Goto Reload;
		
		TNT1 A 0 A_ZoomFactor(0.99);
		TNT1 A 0 A_SetPitch(pitch - 1.15);
		TNT1 A 0 A_OverlayScale(1, 1.15,1.15);
		TNT1 A 0 OverlayRecoil(13,25);
		// TNT1 A 0 A_WeaponOffset(13, 25, WOF_ADD);
		// TNT1 A 0 CompensateOffset(-13, -25);
		STGN B 1; //Recoil should dampen entirely after first firing frame
		TNT1 A 0 A_ZoomFactor(0.993);
		TNT1 A 0 A_OverlayScale(1, 1.14,1.14);
		TNT1 A 0 A_WeaponOffset(13, 20, WOF_ADD);
		TNT1 A 0 CompensateOffset(-13, -20);
		STGN B 1;
		TNT1 A 0 A_SetPitch(pitch + 0.35);
		TNT1 A 0 A_ZoomFactor(0.995);
		TNT1 A 0 A_OverlayScale(1, 1.12,1.12);
		TNT1 A 0 A_WeaponOffset(0, 15, WOF_ADD);
		TNT1 A 0 CompensateOffset(0, -15);
		STGN B 1 Bright {FireScoutShotgun(); }
		TNT1 A 0 A_WeaponOffset(-12, -23, WOF_ADD);
		TNT1 A 0 CompensateOffset(12, 23);
		TNT1 A 0 A_ZoomFactor(0.997);
		TNT1 A 0 A_SetPitch(pitch + 0.4);
		TNT1 A 0 A_OverlayScale(1, 1.1, 1.1);
		STGN B 1 Bright ;
		TNT1 A 0 A_WeaponOffset(-8, -22, WOF_ADD);
		TNT1 A 0 CompensateOffset(8, 22);
		TNT1 A 0 A_ZoomFactor(1.00);
		TNT1 A 0 A_SetPitch(pitch + 0.3);
		TNT1 A 0 A_OverlayScale(1, 1.05, 1.05);
		STGN C 2 Bright A_SetPitch(pitch + 0.1);
		TNT1 A 0 A_WeaponOffset(-6, -15, WOF_ADD);
		TNT1 A 0 CompensateOffset(6, 15);
		TNT1 A 0 A_OverlayScale(1, 1, 1);
		STGN C 1 Bright;
		STGN DE 1 Bright;
		STGN E 1;
	Pump:
		STGN F 2 A_StartSound("weapons/scout_shotgun_pump");
		STGN GH 3;
		STGN I 3{
			EjectCasing("ShotgunCasing",2.5,-12,-10);
			AddToSoundQueue(28);
			A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
		}
		STGN J 2  A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
		STGN KL 2 A_WeaponReady(WRF_ALLOWRELOAD);
		TNT1 A 0 A_ReFire("Fire");
		Goto Ready;
	ShotgunCasing:
		TNT1 A 0 A_jump(80, "Casing1");
		TNT1 A 0 A_jump(120,"Casing2");
		TNT1 A 0 A_jump(255, "Casing3");
	Casing1:
		CSNS AB 2 Bright;
		CSNS CDEFGHIJKLMNOPAB 2;
		Goto LightDone;
	Casing2:
		CSNS NO 2 Bright;
		CSNS PABCDEGHIJKLMNOP 2;
		Goto LightDone;
	Casing3:
		CSNS FG 2 Bright;
		CSNS HIJKLMNOPABCDEFG 2;
		Goto LightDone;
		
	Reload:
	ReloadCheck:
// 		If mag is full or no reserves, don't even do anything
		TNT1 A 0 A_JumpIfInventory("ShellInTube", 0, "Ready");
        TNT1 A 0 A_JumpIfInventory("Shell",1, "ReloadStart");
        Goto Ready;
	ReloadStart:
		STGN MN 2 A_WeaponReady;
		STGN O 2;
	LoadShell:
// 		If mag is full or no reserves, end reload
		TNT1 A 0 A_JumpIfInventory("ShellInTube", 0, "ReloadOver");
        TNT1 A 0 A_JumpIfInventory("Shell",1, 1);
        Goto ReloadOver;
		
		TNT1 A 0 A_StartSound("weapons/scout_shotgun_insert_shell",CHAN_AUTO, 0, 1.05);
		STGN P 1;
		STGN QR 1;
		STGN S 2 A_WeaponReady;

        TNT1 A 0 A_Giveinventory("ShellInTube",1);
        TNT1 A 0 A_Takeinventory("Shell",1);
		
		STGN T 1 A_WeaponReady;
		STGN U 1 A_WeaponReady;
		Loop;
	ReloadOver:
		STGN V 2;
		STGN WX 2 A_WeaponReady(WRF_ALLOWRELOAD);
		Goto Ready;
	MuzzleFlash:
		TNT1 A 0 A_jump(255, "FireRing");
	FireRing:
		BTRF A 2 Bright  A_Light(2);
		BTRF BC 1 Bright  A_Light(2);
		Goto LightDone;
	Spawn:
		SHOT A -1;
		Stop;
	}
	action void FireScoutShotgun(){
		if (player == null)
		{
			return;
		}

		A_StartSound ("weapons/scout_shotgun_fire", CHAN_AUTO, 0, 1.08);
		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			if (!weap.DepleteAmmo (weap.bAltFire, true, -1))
				return;
		
// 			player.SetPsprite(PSP_FLASH, weap.FindState('Flash'), true);
		}
		player.mo.PlayAttacking2 ();

		double pitch = BulletSlope ();


		A_FireBullets (6.5, 2, 6, /*7*/ 0, "BulletPuff",0,0 ,"ShotgunProjectile",15,8);
// 			A_FireBullets (1.5, 1.5, 1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"BolterProjectile", 15,10 );
// 			GunShot (false, "BulletPuff", pitch);

		A_Overlay(-2, "MuzzleFlash");
		A_OverlayPivot(-2, 0.5, 0.5);
		A_OverlayScale(-2, 0.4 + random(-3,3)/100, 0.4 + random(-3,3)/100);
		A_OverlayOffset(-2, 250 + random(-5,5), 40 + random(-5,5));
		A_OverlayRotate(-2, random(0,8)*30, WOF_ADD );
		A_OverlayAlpha(-2, 0.95);
	}
	
	override void Tick(void){
		
		CasingAnimationTick();
		CasingDropSoundTick(dropSoundVolume);
		super.Tick();
	}
}
class ShotgunProjectile: FastProjectile {
	Vector3 facing;
	double speedx;
	double speedy;
	double speedz;
	Default
	{
		Radius 2;
		Height 2;
		Speed 150;
		Scale 0.8;
// 		Damage 7;
		DamageFunction 7 * random(1,3);
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ZDOOMTRANS
// 		DeathSound "weapons/scout_shotgun_impact";
// 		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		TNT1 A 1 Bright ShotgunParticle(18, 10, 4);
// 		TNT1 A 0 bolterParticle(16, 90, 15, 20, 20);
		Loop;
	Death:
		TNT1 A 1 A_StartSound("weapons/scout_shotgun_impact", CHAN_AUTO, 0, 0.3);
// 		Goto LightDone;
		Stop;
	}
	
// 	convert the facing to a vector
	Vector3 facingToVector(float angle, float pitch, int length){
		vector3 vec = quat.FromAngles(angle, pitch, 0) * (length, 0, 0);
		return vec;
	}

	

	void ShotgunParticle(int subdivide
		, float baseTTL = 120
		, float mainSmokeSize = 4)
	{
// 		a.color1 = "white";
// 		float baseTTL = 120;
		float baseAlpha = 0.6; //Starting alpha value
		float fadeAlpha = baseAlpha/baseTTL; //Value of alpha decrease each tick
		float interval = fadeAlpha/subdivide; //The difference in alpha  of particle for each division within a tick
		
	
		int length = vel.length()/subdivide;
		facing = facingToVector(angle,pitch, length);

		
// 		Spawn center fire trail yellow - #fac64d  orange - #fc883a average #fba744
		A_SpawnParticle("fba744",SPF_FULLBRIGHT, baseTTL ,mainSmokeSize, 0
		, 0+frandom(-1,1),0+frandom(-1,1),0+frandom(-1,1)
		, 0,0,0, 0,0,0
		, baseAlpha,-1,-0.1);
		
		for ( int div = 1; div <= subdivide; div++ )  // sid is the sector ID
		{
			
// 			Spawn center fire trail
			A_SpawnParticle("fba744",SPF_FULLBRIGHT,baseTTL,mainSmokeSize - 0.1* div/subdivide, 0
			, -facing.x*div+frandom(-1,1),-facing.y*div+frandom(-1,1),-facing.z*div+frandom(-1,1)
			, 0,0,0, 0,0,0
			, baseAlpha - div*interval, fadeAlpha,-0.1);
			
			
		}
		
	}
}


class ShellInTube : Ammo
{
	Default{
		Inventory.Amount 10;
		Inventory.MaxAmount 10;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 0;
	}
}