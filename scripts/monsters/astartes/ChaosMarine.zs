class ChaosMarine : Actor
{
	int staggerRes;
	int defaultPainChance;
	bool dead;
	Default
	{
		Mass 600;
		PainThreshold 6;
		PainChance "ChainSword", 100;
		PainChance "Melta", 80;
		PainChance "Volkite", 90;
		DamageFactor "Bolter", 0.85;
		DamageFactor "Shotgun", 0.7;
		DamageFactor "Melta", 1.2;
		DamageFactor "HeavyBolter", 0.9;
		DamageFactor "SmallExplosion", 0.4; //
		DamageFactor "StrongExplosion", 0.7;
		Obituary "Death by chaos space marine";
		Height 64;
		Monster;
	}
	States{
		XDeath:
			TNT1 A 0 {
				Scale.x = 0.51;
				Scale.y = 0.51;
				A_Startsound(DeathSound, pitch:1.15);
				}
			OVKL A 3 {
				A_NoBlocking();
				MarineXDeath();
			}
			OVKL B 3 A_XScream;
			OVKL C 3 A_NoBlocking;
			OVKL DEFGHIJK 3;
			OVKL L -1;
			Stop;
	}
// 	Chase but with footstep
	void MarineStep(string footStep, statelabel melee, statelabel missile,int flags = 0){
		A_StartSound(footStep,volume:0.6);
		A_Chase(melee, missile, flags);
	}
	
	virtual void MarineXDeath(){
		
	}
	
// Set the actor to be unable to be staggered for the next painlessTime ticks
	void FeelNoPain(int painlessTime = 8){
		staggerRes = painlessTime;
// 		Console.printf("set staggerres %d nopain`mads %d",staggerRes, bNOPAIN);
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

// Test dummy
class dd : legionary{
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
		TCSM ABC 5;
		OVKL ABC 5;
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