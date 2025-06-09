class Contempt :ArmorBonus Replaces ArmorBonus
{
	Default
	{
		Scale 0.22;
		Armor.SavePercent 45;
	}
	States
	{
	Spawn:
		BONA A 10;
		BONA B 8;
		BONA C 6;
		BONA D 8;
		BONA E 10;
		BONA D 8;
		BONA C 6;
		BONA B 8;
		Loop;
	}

}