class HeavyBolter : ShellEjectingWeapon Replaces Chaingun
{
	Default
	{
		Weapon.SelectionOrder 700;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
        +WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
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
		HBTR A 1 A_Lower(18);
		Loop;
	Select:
		HBTR A 1 A_Raise(18);
		Loop;
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
        HBTR G 3;
		HBTR H 3 A_FireCGun;
		HBTR I 0 A_ReFire("Firing");
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
		A_FireBullets (3, 3, -1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"BolterProjectile", 15,10 );
		// if(isLowAmmo)
		// 	A_StartSound("weapons/bolter_low_ammo_click", CHAN_AUTO, 0, 0.65);
		A_StartSound ("weapons/bolter_fire", CHAN_AUTO, 0, 1.05);
    }
}