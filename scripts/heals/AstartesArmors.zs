class GreenAstartesArmor : GreenArmor Replaces GreenArmor
{
	Default
	{
		Armor.SavePercent 45; //Raise armor save amount from 33% to 45
		Inventory.Pickupmessage "Picked up green astartes armor";
// 		Inventory.Icon "BONAA0";
	}
}

class BlueAstartesArmor : BlueArmor Replaces BlueArmor
{
	Default
	{
		Armor.SavePercent 70; //Raise armor save amount from 50 to 70
		Inventory.Pickupmessage "Picked up blue astartes armor";
// 		Inventory.Icon "BONAA0";
	}
}
class BlueAstartesArmorForMegasphere: BlueArmorForMegasphere Replaces BlueArmorForMegasphere
{
	Default
	{
		Armor.SavePercent 70; //Raise armor save amount from 50 to 70
// 		Inventory.Icon "BONAA0";
	}
}

class AstartesMegasphere : Megasphere Replaces Megasphere
{
	Default
	{
		Inventory.PickupMessage "The Emperor Protects"; // "MegaSphere!"
	}
	States
	{
	Pickup:
		TNT1 A 0 A_GiveInventory("BlueAstartesArmorForMegasphere", 1);
		TNT1 A 0 A_GiveInventory("MegasphereHealth", 1);
		Stop;
  }
}