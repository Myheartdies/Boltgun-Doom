class GreenAstartesArmor : GreenArmor Replaces GreenArmor
{
	Default
	{
		Armor.SavePercent 50; //Raise armor save amount from 33% to 50
		Inventory.Pickupmessage "Picked up green astartes armor";
	}
}
class AstartesArmorBonus : ArmorBonus Replaces ArmorBonus
{
	Default
	{
		Armor.SavePercent 45; //Raise armor save amount from 33% to 50
	}
}

class BlueAstartesArmor : BlueArmor Replaces BlueArmor
{
	Default
	{
		Armor.SavePercent 80; //Raise armor save amount from 33% to 50
		Inventory.Pickupmessage "Picked up blue astartes armor";
	}
}
class BlueAstartesArmorForMegasphere: BlueArmorForMegasphere Replaces BlueArmorForMegasphere
{
	Default
	{
		Armor.SavePercent 75; //Raise armor save amount from 33% to 50
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