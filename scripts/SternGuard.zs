Class SternGuard : Doomplayer replaces Doomplayer
{

// 	Player.Startitem "WhateverElseYouWantTostartWith"
	Default
	{
// 		Height 75;
		Mass 400;
		Player.Startitem "Bolter";
		Player.StartItem "Clip", 50;
		Player.StartItem "BolterMag", 18;
// 		Player.StartItem "ShellInTube" 8;
		Player.Startitem "Fist";
		Player.WeaponSlot 2, "Bolter";
		Player.WeaponSlot 3, "AstartesShotgun", "SuperShotgun";
		Player.SoundClass "sternguard";
		Player.ViewHeight 52;
// 		PainSound "sternguard/pain";
		
	}
}