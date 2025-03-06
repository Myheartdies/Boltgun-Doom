class HeavyBolter : ShellEjectingWeapon Replaces Chaingun
{
    override void BeginPlay(){
		dropSoundVolume = 0.5;
		queueLength = 10;
		maxCasingCount = 20;
		casingDropSound = "weapons/heavybolter_casing";
        extraOffset_x = -120;
        extraOffset_y = 0;
		super.BeginPlay();
	}
	Default
	{
		Weapon.SelectionOrder 700;
		Weapon.AmmoUse 3;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
//         +WEAPON.AMMO_OPTIONAL
// 		+WEAPON.ALT_AMMO_OPTIONAL
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Inventory.PickupMessage "$GOTCHAINGUN";
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
	}
	States
	{
	Ready:
		HBTR A 1 A_WeaponReady;
		Loop;
	Deselect:
		HBTR A 1 {A_Lower(8); CasingLayerExit();}
		Loop;
	Select:
		HBTR A 1 {A_Raise(8); CasingLayerReady();}
		Loop;
    Casing:
// 		BTRF AAAAAAAAAA 4;
		TNT1 A 0 A_jump(80, "Casing1");
		TNT1 A 0 A_jump(120,"Casing2");
		TNT1 A 0 A_jump(255, "Casing3");
	Casing1:
		CSNH AB 2 Bright;
		CSNH CDEFGHIJKLMNOPAB 2;
		Goto LightDone;
	Casing2:
		CSNH NO 2 Bright;
		CSNH PABCDEGHIJKLMNOP 2;
		Goto LightDone;
	Casing3:
		CSNH FG 2 Bright;
		CSNH HIJKLMNOPABCDEFG 2;
		Goto LightDone;
    
	Fire:
    Windup1:
        HBTR AB 3;
        HBTR B 1 A_ReFire("Windup2");
    Winddown1:
        HBTR B 3 A_ReFire("Windup2");
        HBTR A 3 A_ReFire("Windup1");
        Goto Ready;
    Windup2:
        HBTR CD 3;
        HBTR D 1 A_ReFire("Windup3");
    Winddown2:
        HBTR D 2 A_ReFire("Windup3");
        HBTR C 3 A_ReFire("Windup2");
        Goto Winddown1;
    Windup3:
        HBTR E 3;
        HBTR E 1 A_ReFire("Firing");
    Winddown3:
        HBTR E 3 A_ReFire("Firing");
        HBTR D 1 A_ReFire("Windup3");
        Goto Winddown2;
    Firing:
        HBTR G 1;
        TNT1 A 0 A_ZoomFactor(0.992);
		TNT1 A 0 A_SetPitch(pitch - 1.1);
		TNT1 A 0 A_OverlayScale(1, 1.15,1.15);
		TNT1 A 0 OverlayRecoil(15,55);
        HBTR G 1 A_Light1;
		// HBTR H 3 A_FireCGun;
        TNT1 A 0 A_Quake(0.5,4,0,50,"");
        HBTR H 1 Bright FireHeavyBolter;
        TNT1 A 0 A_Recoil(0.8);
        
        TNT1 A 0 A_ZoomFactor(0.993);
		TNT1 A 0 A_OverlayScale(1, 1.14,1.14);
		TNT1 A 0 OverlayRecoil(-6, -10);
        HBTR H 1 Bright;
        TNT1 A 0 A_SetPitch(pitch + 0.4);
        TNT1 A 0 A_ZoomFactor(0.995);
		TNT1 A 0 A_OverlayScale(1, 1.12,1.12);
		TNT1 A 0 OverlayRecoil(-5, -28);
        HBTR H 1;
        TNT1 A 0 A_SetPitch(pitch + 0.7);
        TNT1 A 0 OverlayRecoil(-4, -17);
		HBTR I 0 A_ReFire("Firing");
        // TNT1 A 0 A_SetPitch(pitch + 0.35);
        TNT1 A 0 A_ZoomFactor(1);
		TNT1 A 0 A_OverlayScale(1, 1, 1);
		Goto Winddown3;
	Flash:
		CHGF A 5 Bright A_Light1;
		Goto LightDone;
		CHGF B 5 Bright A_Light2;
		Goto LightDone;
	Spawn:
		MGUN A -1;
		Stop;
	}
    action void FireHeavyBolter(bool isLowAmmo = False){
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
		// if (accurate) A_FireBullets(0, 0, 1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"BolterProjectile", 15,10 );
		A_FireBullets (3, 3, -1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"HeavyBolterProjectile", 15,10 );
		// if(isLowAmmo)
		// 	A_StartSound("weapons/bolter_low_ammo_click", CHAN_AUTO, 0, 0.65);
		A_StartSound ("weapons/heavybolter_fire", CHAN_AUTO, 0, 1);
        A_Light2();
        // 		Eject casing
		EjectCasing("Casing");
		
// 		Call delayed sound for casing drop
		AddToSoundQueue(25);
    }


    
    override void Tick(void){
		CasingAnimationTick();
		CasingDropSoundTick(dropSoundVolume);
		super.Tick();
	}
}

class HeavyBolterProjectile: BolterProjectile{
    Default
	{
		Radius 5;
		Height 5;
		Speed 90;
		Scale 0.8;
// 		Damage 15;
		DamageFunction 8 * random(4, 14);
		DeathSound "weapons/bolter_impact";
	}

    States
	{
	Spawn:
		BOLT A 1 Bright TrailParticle(10, 60, 15, 6, 3);
// 		TNT1 A 0 bolterParticle(16, 90, 15, 20, 20);
		Loop;
	Death:
		HTRE A 2 Bright A_Explode(6 * random(4,7), 50, 0, True, 30/*, damagetype="SmallExplosion"*/);
		HTRE BCDEFGHIJKL 2 Bright;
		HTRE MNOP 2;
// 		Goto LightDone;
		Stop;
	}
}