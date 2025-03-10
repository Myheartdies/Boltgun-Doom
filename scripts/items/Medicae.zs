// Faith is health bonus
class Medicae: HealthBonus Replaces HealthBonus{
	Default
	{
		Scale 0.19;
	}
	States
	{
	Spawn:
		BONH A 6;
		Loop;
	}
}