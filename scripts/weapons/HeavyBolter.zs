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
		Weapon.AmmoUse 2;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
//         +WEAPON.AMMO_OPTIONAL
// 		+WEAPON.ALT_AMMO_OPTIONAL
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Inventory.PickupMessage "$GOTCHAINGUN";
		Weapon.BobSpeed 1.5;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 1;	
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
	}
	States
	{
	Ready:
		TNT1 A 0 A_StopSound(CHAN_5);
		HBTR A 4 A_WeaponReady;
		Loop;
	Deselect:
		TNT1 A 0 A_StopSound(CHAN_5);
		HBTR A 1 {A_Lower(12); CasingLayerExit();}
		Wait;
	Select:
		TNT1 A 0 A_StartSound("weapons/heavybolter_winddown",CHAN_AUTO,0,0.7,ATTN_NONE);
		HBTR A 1 {A_Raise(12); CasingLayerReady();}
		Wait;
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
		TNT1 A 0 A_StartSound("weapons/heavybolter_windup",CHAN_AUTO,0,0.6,ATTN_NONE);
        HBTR A 4;
		HBTR B 3;
        HBTR B 1 A_ReFire("Windup2");
    Winddown1:
        HBTR B 3 A_ReFire("Windup2");

        HBTR A 3 A_ReFire("Windup1");
        Goto Ready;
    Windup2:
        HBTR CD 3;
        HBTR D 1 A_ReFire("Windup3");
    Winddown2:
		TNT1 A 0 A_StartSound("weapons/heavybolter_winddown",CHAN_AUTO,0,0.8,ATTN_NONE);
        HBTR D 2 A_ReFire("Windup3");
        HBTR C 3 A_ReFire("Windup2");
		
        Goto Winddown1;
    Windup3:

        HBTR E 1 A_ReFire("Firing");
    Winddown3:
		TNT1 A 0 A_StopSound(CHAN_5);
        HBTR E 3 A_ReFire("Firing");
        HBTR D 1 A_ReFire("Windup3");
        Goto Winddown2;
    StartFiring:
// 		TNT1 A 0 A_Startsound("weapons/heavybolter_mechanical",CHAN_5,CHANF_LOOPING,1,ATTN_NONE);
// 		TNT1 A 0 A_JumpIfInventory("isFired",2,2);
// 	    HBTR E 3;
// 		Goto Firing;
	Firing:
        HBTR G 1;
        TNT1 A 0 A_ZoomFactor(0.992);
		TNT1 A 0 A_SetPitch(pitch - 1.1);
		TNT1 A 0 A_OverlayScale(1, 1.15,1.15);
		TNT1 A 0 round_smoke();
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
		HBTR I 4 {A_ReFire("StartFiring");A_GiveInventory("isFired",1);}
        // TNT1 A 0 A_SetPitch(pitch + 0.35);
        TNT1 A 0 A_ZoomFactor(1);
		TNT1 A 0 A_OverlayScale(1, 1, 1);
		TNT1 A 0 A_TakeInventory("isFired",255);
		Goto Winddown3;
	MuzzleFlash:
// 		HBTF A 1 Bright A_Light1;
		HBTF C 1 Bright A_Light1;
		Goto LightDone;
	Spawn:
		MGUN A -1;
		Stop;
	}
	
	action void round_smoke(){
		Vector3 facing = TrailedProjectile.facingToVector(invoker.owner.angle, invoker.owner.pitch, 40);
		float speedx = frandom(-0.4,0.4);
		float speedy = frandom(-0.4,0.4);
		A_SpawnParticleEx("grey",TexMan.CheckForTexture("SMKCA0"),STYLE_Shaded,/*SPF_RELPOS|SPF_RELANG|*/SPF_ROLL , 50
		, 90 + frandom(-1,2), 0
// 		,30,15,40
		,facing.x+facing.y*0.35, facing.y-facing.x*0.35, facing.z +50
		,speedx,speedy,1.3, 0,0,0
		, 0.5,-1,0.05
		, Random(0,12)*30);
	}
	

	
	
    action void FireHeavyBolter(bool isLowAmmo = False){
		bool accurate;
		
// 		invoker.round_smoke();
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
// 		A_FireProjectile("HeavyBolterProjectile", 0, false, 15, 10);
		// if(isLowAmmo)
		// 	A_StartSound("weapons/bolter_low_ammo_click", CHAN_AUTO, 0, 0.65);
		A_StartSound ("weapons/heavybolter_fire", CHAN_WEAPON , CHANF_OVERLAP, 1);
        A_Light2();
        // 		Eject casing
		EjectCasing("Casing");
		
// 		Call delayed sound for casing drop
		AddToSoundQueue(25);
		
		A_Overlay(-2, "MuzzleFlash");
		A_OverlayPivot(-2, 0.5, 0.5);
		A_OverlayScale(-2, 0.12 + random(-3,3)/50, 0.12 + random(-3,3)/50);
		A_OverlayOffset(-2, 170 + random(-10,10), 220 + random(-10,10));
		A_OverlayRotate(-2, 90 + random(-3,3), WOF_ADD );
		A_OverlayAlpha(-2, 0.7);
    }
	


    
    override void Tick(void){
		CasingAnimationTick();
		CasingDropSoundTick(dropSoundVolume);
		super.Tick();
	}
}
class isFired : Inventory
{
	Default{
		Inventory.Amount 0;
		Inventory.MaxAmount 3;
	}
}
class HeavyBolterProjectile: BolterProjectile{
    Default
	{
		Radius 4;
		Height 4;
		Speed 100;
		Scale 0.8;
// 		Damage 15;
		DamageFunction 8 * random(4, 14);
		DeathSound "weapons/bolter_impact";
	}

    States
	{
	Spawn:
		BOLT A 1 Bright TrailParticle(10, 50, 20, 6, 4);
// 		TNT1 A 0 bolterParticle(16, 90, 15, 20, 20);
		Loop;
	Death:
		HTRE A 2 Bright A_Explode(6 * random(4,8), 50, 0, True, 30, damagetype:"StrongExplosion");
		HTRE BCDEFGHIJKL 2 Bright;
		HTRE MNOP 2;
// 		Goto LightDone;
		Stop;
	}
}