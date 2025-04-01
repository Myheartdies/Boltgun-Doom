class MeltaGun : DoomWeapon
{
	Default
	{
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Weapon.SelectionOrder 400;
		Weapon.AmmoUse 2;
		Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN2";
		Obituary "$OB_MPSSHOTGUN";
		Tag "$TAG_SUPERSHOTGUN";
	}
	States
	{
	Ready:
		MELT A 1 A_WeaponReady;
		Loop;
	Deselect:
		MELT A 1 A_Lower(18);
		Loop;
	Select:
		MELT A 1 A_Raise(18);
		Loop;
	Fire:
		MELT A 2;
		MELT C 2 A_FireShotgun2;
		MELT DEF 2;
		MELT GH 5;
		MELT I 5 A_CheckReload;
		MELT J 5;
		MELT K 5 A_OpenShotgun2;
		MELT L 5 A_LoadShotgun2;
		MELT M 6 A_CloseShotgun2;
// 		MELT N 6 A_CloseShotgun2;
		MELT A 5 A_ReFire;
		Goto Ready;
	// unused states
		SHT2 B 7;
		SHT2 A 3;
		Goto Deselect;
	Flash:
		SHT2 I 4 Bright A_Light1;
		SHT2 J 3 Bright A_Light2;
		Goto LightDone;
	Spawn:
		SGN2 A -1;
		Stop;
	}



	action void A_FireShotgun2()
	{
		if (player == null)
		{
			return;
		}

		A_StartSound ("weapons/sshotf", CHAN_WEAPON);
		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			if (!weap.DepleteAmmo (weap.bAltFire, true, 2))
				return;
			
			player.SetPsprite(PSP_FLASH, weap.FindState('Flash'), true);
		}
		player.mo.PlayAttacking2 ();

		double pitch = BulletSlope ();
			
		for (int i = 0 ; i < 20 ; i++)
		{
			int damage = 5 * random[FireSG2](1, 3);
			double ang = angle + Random2[FireSG2]() * (11.25 / 256);

			// Doom adjusts the bullet slope by shifting a random number [-255,255]
			// left 5 places. At 2048 units away, this means the vertical position
			// of the shot can deviate as much as 255 units from nominal. So using
			// some simple trigonometry, that means the vertical angle of the shot
			// can deviate by as many as ~7.097 degrees.

			LineAttack (ang, PLAYERMISSILERANGE, pitch + Random2[FireSG2]() * (7.097 / 256), damage, 'Hitscan', "BulletPuff");
		}
	}


	action void A_OpenShotgun2() 
	{ 
		A_StartSound("weapons/sshoto", CHAN_WEAPON); 
	}
	
	action void A_LoadShotgun2() 
	{ 
		A_StartSound("weapons/sshotl", CHAN_WEAPON); 
	}
	
	action void A_CloseShotgun2() 
	{ 
		A_StartSound("weapons/sshotc", CHAN_WEAPON);
		A_Refire();
	}
}