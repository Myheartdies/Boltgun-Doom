class PlasmaGun: SternguardWeapon
{
	Default
	{
		Weapon.SelectionOrder 1300;
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN";
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_SHOTGUN";
	}
	States
	{
	Ready:
		PLSM A 1 A_WeaponReady;
		Loop;
	Deselect:
		PLSM A 1 A_Lower;
		Loop;
	Select:
		PLSM A 1 A_Raise;
		Loop;
	Fire:
		PLSM B 7;
		PLSM C 7 A_FireShotgun;
		PLSM C 5;
		PLSM D 4;
		PLSM D 7 A_ReFire;
		Goto Ready;
	Flash:
		SHTF A 4 Bright A_Light1;
		SHTF B 3 Bright A_Light2;
		Goto LightDone;
	Spawn:
		SHOT A -1;
		Stop;
	}
}