class Bolter : ShellEjectingWeapon
{


	override void BeginPlay(){
		queueLength = 12;
		maxCasingCount = 5;
		super.BeginPlay();
	}
	Default
	{	
		Weapon.SelectionOrder 500;
// 		Weapon.AmmoGive 40;
// 		Weapon.AmmoType "Clip";
		Obituary "%o Is mowed down by Bolter fire";
		Inventory.Pickupmessage "You have Retrieved the Bolter. Deliver righteous fury!";
		Tag "$TAG_BOLTER";
		Weapon.AmmoUse 1;
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Weapon.KickBack 80;
		Weapon.BobSpeed 2;
		Weapon.AmmoType1 "BolterMag";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoGive1 6;
		Weapon.AmmoGive2 20;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 1.1;
		ShellEjectingWeapon.MaxCasingCount 5;
		ShellEjectingWeapon.CasingDropSound "weapons/bolter_casing";
		ShellEjectingWeapon.DropSoundVolume 0.3;
	}
	States
	{
	Ready:
		BOTR A 4 {
			A_WeaponReady(WRF_ALLOWRELOAD);
			CasingLayerReady();
// 			A_JumpIfInventory("clipEjected", 1, "ReloadingPartialReinsert");
		}
		Loop;
	Deselect:
		BOTR A 1{
			A_Lower(15);
			CasingLayerExit();
		}
		Wait;
// 		Loop;
	Select:
		BOTR A 1 A_WeaponOffset(0,32);
		BOTR A 1 {
			A_Raise(18);
			A_ClearOverlays(-1-invoker.maxCasingCount, -2);
			CasingLayerReady();
		}
		TNT1 A 0 A_Raise(100);
		Wait;
	Fire:
		TNT1 A 0 OverlayReAdjust;
// 		Go to reload if out of ammo
		TNT1 A 0 A_JumpIfInventory("BolterMag", 1, 2);
		TNT1 A 0 A_GiveInventory("isFullReload", 1);
		Goto Reload;
		
		TNT1 A 0 A_ZoomFactor(0.994);
		TNT1 A 0 A_SetPitch(pitch - 0.5);
		TNT1 A 0 A_OverlayScale(1, 1.06,1.06);
		BOTR A 2 ;
		TNT1 A 0 {A_WeaponOffset(-3, 5, WOF_ADD); CompensateOffset(3,-5);}
		
		
// 		Fire with low ammo click if ammo is less than 8
		TNT1 A 0 A_JumpIfInventory("BolterMag", 8, 3);
		BOTR B 1 Bright {FireBolter(True); AllowQuickSwitch();}
		TNT1 A 0 A_Jump(256,2);
		BOTR B 1 Bright {FireBolter(); AllowQuickSwitch();}
		TNT1 A 0 A_QuakeEx(0.5,0.5,0.5, 2 , 0, 20,QF_SCALEDOWN|QF_SHAKEONLY,damage:0);
		
		TNT1 A 0 A_ZoomFactor(0.996);
		TNT1 A 0 A_OverlayScale(1,1.1,1.1);
		TNT1 A 0 {A_WeaponOffset(2, -2.5, WOF_ADD); CompensateOffset(-2,2.5); }
		BOTR B 1 Bright {A_SetPitch(pitch + 0.3); AllowQuickSwitch();}
		TNT1 A 0 A_OverlayScale(1,1.08,1.08);
		BOTR C 1 Bright;
		TNT1 A 0 A_OverlayScale(1,1,1);
		BOTR C 1 Bright {A_ZoomFactor(1.00); AllowQuickSwitch();}
		TNT1 A 0 {A_WeaponOffset(1, -2.5, WOF_ADD); CompensateOffset(-1,2.5); }
		BOTR C 1 {A_SetPitch(pitch + 0.2); AllowQuickSwitch();}
		

		BOTR D 2 A_ReFire;
		TNT1 A 0 A_JumpIfInventory("BolterMag", 1, "Ready");
		BOTR A 0 A_GiveInventory("isFullReload", 1);
		Goto Ready;
	MuzzleFlash:
		TNT1 A 0 A_jump(256, "FireRing");
	FireRing:
		BTRF A 2 Bright A_Light(2);
		BTRF BC 1 Bright A_Light(2);
		Goto LightDone;
	Casing:
// 		BTRF AAAAAAAAAA 4;
		TNT1 A 0 A_jump(80, "Casing1");
		TNT1 A 0 A_jump(120,"Casing2");
		TNT1 A 0 A_jump(255, "Casing3");
	Casing1:
		CASN AB 2 Bright;
		CASN CDEFGHIJKLMNOPAB 2;
		Goto LightDone;
	Casing2:
		CASN NO 2 Bright;
		CASN PABCDEGHIJKLMNOP 2;
		Goto LightDone;
	Casing3:
		CASN FG 2 Bright;
		CASN HIJKLMNOPABCDEFG 2;
		Goto LightDone;
	
	StagedReloadInsert:
// 		TNT1 A 0 A_JumpIfInventory("isFullReload", 1, "ReloadingFullReinsert");
		Goto ReloadingPartialReinsert;
	
	
		
	
// 	Reloading : if empty mag, Fire -> reload -> ReloadCheck
// 	ReloadCheck: If Full mag, to Ready, otherwise, if have reserve goto Reload Prepare
// 	ReloadPrepare: Mostly animation, Jump to full or partial reload based on the "isFullReload"
// 	ReloadPartial/Full: Animations, go to ReloadLogic after that
// 	ReloadLogic: Basically load one reserve into mag one every state, and then loop
// 				The check at start Jump to ReloadOver if Mag already full, after that if reserve gone also go to reloadOver
// 				The two states after that deduct reserve and load mag one by one, and loop if there is still reserve
// 	ReloadOver: Animation
	
	Reload:
		TNT1 A 0 OverlayReAdjust;
		Goto ReloadCheck;
	ReloadCheck:
// 		If mag full go back to ready
		TNT1 A 0 A_JumpIfInventory("BolterMag", 0,"Ready");
// 		If still have reserve go to reload
        TNT1 A 0 A_JumpIfInventory("Clip",2, "ReloadPrepare");
// 		Otherwise lower weapon
		Goto Ready;
	ReloadPrepare:
		BOTR EF 2;
// 		Play full reload sound if it is a full reload
		TNT1 A 0 A_JumpIfInventory("isFullReload",1, "ReloadingFull");
		Goto ReloadingPartial;
	ReloadingPartial:
	ReloadingPartialEject:	
		BOTR G 4 A_Startsound("weapons/bolter_reload_partial");
		BOTR H 4;
	ReloadingPartialReinsert:
		TNT1 A 0 A_GiveInventory("clipEjected", 1);
		BOTR IJ 5; //AllowQuickSwitch; 
		BOTR KL 3; //AllowQuickSwitch;
		TNT1 A 0 A_TakeInventory("clipEjected", 256);
		Goto ReloadLogic;
	
	ReloadingFull:
	ReloadingFullEject:
		BOTR G 2 A_Startsound("weapons/bolter_reload_full");
		BOTR H 3;
	ReloadingFullReinsert:
		TNT1 A 0 A_GiveInventory("clipEjected", 1);
		BOTR IJKL 3; //AllowQuickSwitch;
		BOTR PQRST 2; //AllowQuickSwitch;
		TNT1 A 0 A_TakeInventory("isFullReload", 256);
		TNT1 A 0 A_TakeInventory("clipEjected", 256);
		Goto ReloadLogic;
	
	ReloadLogic:
		TNT1 A 0 A_JumpIfInventory("BolterMag", 0, "ReloadOver");
        TNT1 A 0 A_JumpIfInventory("Clip",2, 1);
        Goto ReloadOver;
        TNT1 A 0 A_Giveinventory("BolterMag",1);
        TNT1 A 0 A_Takeinventory("Clip",2);
		TNT1 A 0 A_JumpIfInventory("Clip",2, "ReloadLogic");
		Goto ReloadOver;
	ReloadOver:
		BOTR MNO 3;
		Goto Ready;
 	Spawn:
		PIST A -1;
		Stop;
	}
	
	action void AllowQuickSwitch(){
		 A_WeaponReady(WRF_NOFIRE|WRF_ALLOWRELOAD);
	}
	
	action void FireBolter(bool isLowAmmo = False){
		bool accurate;

		if (player != null)
		{
			Weapon weap = player.ReadyWeapon;
			if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
			{
				if (!weap.DepleteAmmo (weap.bAltFire, True, -1)){
					return;
				}
	//			player.SetPsprite(PSP_FLASH, weap.FindState('MuzzleFlash'));
			}
	//		player.mo.PlayAttacking2 ();

			accurate = !player.refire;
		}
		else
		{
			accurate = true;
		}
		if (accurate) A_FireBullets(0, 0, 1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"BolterProjectile", 0,10 );
		else A_FireBullets (1, 1, 1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"BolterProjectile", 0,10 );
// 		else A_FireProjectile ("BolterProjectile",0, false, 15, 20 );
// 		A_FireRailgun();
		if(isLowAmmo)
			A_StartSound("weapons/bolter_low_ammo_click", CHAN_AUTO, 0, 0.65);
		A_StartSound ("weapons/bolter_fire", CHAN_AUTO, 0, 1.05);
		
// 		Eject casing
		EjectCasing("Casing");
		
// 		Call delayed sound for casing drop
		AddToSoundQueue(25);

		A_Overlay(-2, "MuzzleFlash");
		A_OverlayPivot(-2, 0.5, 0.5);
		A_OverlayScale(-2, 0.3 + random(-3,3)/100, 0.3 + random(-3,3)/100);
		A_OverlayOffset(-2, 250 + random(-5,5), 50 + random(-5,5));
		A_OverlayRotate(-2, random(0,8)*30, WOF_ADD );
		A_OverlayAlpha(-2, 0.95);
		
		
	}
	override void Tick(void){
		CasingAnimationTick();
		CasingDropSoundTick(dropSoundVolume);
		super.Tick();
	}
	

}

class BolterProjectile: TrailedProjectile{
	bool particleDrawn;
	Default
	{
		Radius 3;
		Height 4;
		Speed 200;
		Scale 0.65;
// 		Damage 7;
		DamageFunction random(3,10)*random(3,10);
		+FORCEXYBILLBOARD
		DeathSound "weapons/bolter_impact";
	}
	
	States
	{
	Spawn:
		BOLT A 1 Bright bolterParticle(22, 80, 15, 4, 3);
// 		TNT1 A 0 bolterParticle(16, 90, 15, 20, 20);
		Loop;
	Death:
		BTRE A 2 Bright {
			A_Explode(6 * random(4,7), 40, 0, damagetype="SmallExplosion");
			bolterParticleTailCompensation(22, 80, 15, 4, 3);
		}
		BTRE BCDEFGHIJKL 2 Bright;
		BTRE MNOPQ 2;
// 		Goto LightDone;
		Stop;
	}
	
	action void bolterParticle(int subdivide
		, float baseTTL = 120,float baseTTL_trail=10
		, float mainSmokeSize = 4, float subSmokeSize=3)
	{
		invoker.particleDrawn = True;
		invoker.TrailParticle(subdivide, baseTTL, baseTTL_trail, mainSmokeSize, subSmokeSize);
	}
	
	
	action void bolterParticleTailCompensation(int subdivide
		, float baseTTL = 120,float baseTTL_trail=10
		, float mainSmokeSize = 4, float subSmokeSize=3)
	{
		if (!invoker.particleDrawn)
			invoker.TrailParticle(subdivide, baseTTL/2, baseTTL_trail/2, mainSmokeSize, subSmokeSize, speedOverride:speed*0.66);
	}
	
}


class BolterMag : Ammo
{
	Default{
		Inventory.Amount 16;
		Inventory.MaxAmount 16;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 0;
	}
}
class clipEjected: Inventory{
	Default{
		Inventory.Amount 0;
		Inventory.MaxAmount 1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}
class isFullReload : Inventory
{
	Default{
		Inventory.Amount 0;
		Inventory.MaxAmount 1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}


