class VolkiteCaliver : DoomWeapon Replaces PlasmaRifle
{
	Default
	{
		Weapon.SelectionOrder 100;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTPLASMA";
		Tag "$TAG_PLASMARIFLE";
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6;	
		Weapon.BobSpeed 2;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 1.1;
	}
	States
	{
	Ready:
		TNT1 A 0;
		VKT1 A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		VKT1 A 1 A_Lower(18);
		Loop;
	Select:
		VKT1 A 1 A_Raise(18);
		Loop;
	Reload:	
		VKT2 ABCDEFGHIJKLMNOP 3;
		Goto Ready;
	Fire:
		VKT1 I 3 Bright FireVolkite;
// 		VKT1 JK 3 FireVolkite;
		VKT2 A 0 {A_ReFire();}
		VKT2 A 20 {A_ReFire();A_StopSound(CHAN_WEAPON);}
		Goto Ready;
	Flash:
// 		PLSF A 4 Bright A_Light1;
// 		Goto LightDone;
// 		PLSF B 4 Bright A_Light1;
		Goto LightDone;
	Spawn:
		PLAS A -1;
		Stop;
	}
	
	action void FireVolkite()
	{
		if (player == null)
		{
			return;
		}
		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			if (!weap.DepleteAmmo (weap.bAltFire, true, 1))
				return;
			
			State flash = weap.FindState('Flash');
			if (flash != null)
			{
				player.SetSafeFlash(weap, flash, random[FirePlasma](0, 1));
			}
			
		}
		A_Startsound("weapons/volkite_fire",CHAN_WEAPON,CHANF_LOOPING,0.5,ATTN_NONE);
		
		SpawnPlayerMissile ("VolkiteBall");
	}
}




class VolkiteBall : Actor
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 25;
		Damage 5;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
// 		SeeSound "weapons/plasmaf";
		DeathSound "weapons/plasmax";
		Obituary "$OB_MPPLASMARIFLE";
	}
	States
	{
	Spawn:
		PLSS AB 6 Bright;
		Loop;
	Death:
		PLSE ABCDE 4 Bright;
		Stop;
	}
}