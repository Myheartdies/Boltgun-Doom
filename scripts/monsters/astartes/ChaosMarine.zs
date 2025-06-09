class ChaosMarine : HellKnight
{
	int staggerRes;
	int defaultPainChance;
	bool dead;
	Default
	{
		Mass 600;
		PainThreshold 6;
		PainChance "ChainSword", 100;
		DamageFactor "Bolter", 0.85;
		DamageFactor "HeavyBolter", 0.9;
		DamageFactor "SmallExplosion", 0.35; //
		DamageFactor "StrongExplosion", 0.7;
	}
// 	Chase but with footstep
	void MarineStep(string footStep, statelabel melee, statelabel missile,int flags = 0){
		A_StartSound(footStep,volume:0.6);
		A_Chase(melee, missile, flags);
	}
	
// Set the actor to be unable to be staggered for the next painlessTime ticks
	void FeelNoPain(int painlessTime = 8){
		staggerRes = painlessTime;
		Console.printf("set staggerres %d nopain`mads %d",staggerRes, bNOPAIN);
	}

	override void BeginPlay(void)
	{
		defaultPainChance = painchance;
	}
	override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath){
		super.Die(source, inflictor, dmgflags, MeansOfDeath);
		dead = True;
	}
	override void Tick(void)
	{
		super.Tick();
		if (dead) return;
		if (staggerRes > 0 && target && health > 0)
		{
			staggerRes -= 1;
			painchance = 0;
		}
		else painchance = defaultpainchance;
// 		Console.printf("%d nopain %d",staggerRes, bNOPAIN);
	}
	

}
class dddd : legionary{
	Default
	{
		Mass 600;
		Health 5000;
	}
	States
	{
	Spawn:
		TCSM TU 10 A_Look;
		Loop;
	See:
		TCSM ABCDEF 5;
		Loop;
	Pain:
		TCSM L  2 A_Pain;
		TCSM M  4 ;
		Goto See;
	Death:
		TCSM M  6 ;
		TCSM N  6 A_Scream;
		TCSM O  6;
		TCSM O  4 A_NoBlocking;
		TCSM P  11;
		TCSM Q -1;
		Stop;
		
	}
}