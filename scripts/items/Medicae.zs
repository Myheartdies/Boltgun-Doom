// Faith is health bonus
class Medicae: HealthBonus Replaces HealthBonus{
	Default
	{
		Scale 0.19;
	}
	States
	{
	Spawn:
		BONH A 10;
		BONH B 8;
		BONH C 6;
		BONH D 8;
		BONH E 10;
		BONH D 8;
		BONH C 6;
		BONH B 8;
		Loop;
	}
}