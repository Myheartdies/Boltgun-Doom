Class SternGuard : Doomplayer replaces Doomplayer
{

// 	Player.Startitem "WhateverElseYouWantTostartWith"
	Default
	{
// 		Height 67; //firing offset will be 8 for this, 15 for normal height
// 		Height 60;
		Mass 400;
		Player.Startitem "Bolter";
		Player.StartItem "Clip", 50;
		Player.StartItem "BolterMag", 18;
		Player.StartItem "ShellInTube", 8;
		Player.Startitem "Fist";
		Player.WeaponSlot 2, "Bolter";
		Player.WeaponSlot 3, "AstartesShotgun", "SuperShotgun";
		Player.WeaponSlot 4, "HeavyBolter";
		Player.WeaponSlot 5, "MissileLauncher";
		Player.WeaponSlot 6, "VolkiteCaliver","PlasmaRifle";
		Player.SoundClass "sternguard";
		Damagefactor "ExplosionSelfDamage", 0.15;
		Player.ViewHeight 52;
// 		PainSound "sternguard/pain";
		
	}
}