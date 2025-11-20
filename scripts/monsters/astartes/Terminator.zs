class Terminator : Fatso Replaces Fatso
{
	int staggerRes;
	int defaultPainChance;
	bool dead;
	Default
	{
		Health 1200;
		Radius 30;
		Height 64;
		Mass 1000;
		PainChance 30;
		PainChance "ChainSword", 20;
		PainChance "Shotgun", 8;
		DamageFactor "Shotgun", 0.6;
		PainThreshold 12;
		Monster;
		+FLOORCLIP
		+BOSSDEATH
		Speed 7;
		Scale 0.51;
		SeeSound "TERM/sight";
		MeleeRange 50;
		MeleeThreshold 90;
// 		ActiveSound "TERM/active";
		ActiveSound "TERM/active";
		PainSound "TERM/pain";
		DeathSound  "TERM/death";
		DropItem "ClipBox";
		DropItem "Chaingun";
		DamageFactor "SmallExplosion", 0.2; //used to be 0.1 when bolter damage was 11
		DamageFactor "StrongExplosion", 0.52;
		Obituary "Terminated";
		Tag "$FN_TERM";
	}
	States
	{
	Spawn:
		TRMB MN 15 A_Look;
		Loop;
	See:
		TRMA AAA 3 A_Chase;
		TRMA B 3 TerminatorStep("TERM/steps");
		TRMA BB 3 A_Chase;
		TRMA CCC 3 A_Chase;
		TRMA D 3 TerminatorStep("TERM/steps");
		TRMA DD 3 A_Chase;
		Loop;
	Reload:
		TRMB A 4 A_StartSound("TERM/reload");
		TRMB BCDEF 5;
		TRMB G 5 A_TakeInventory("TerminatorAmmo", 255);
		TRMB HIJ 5;
		Goto See;
	Missile:
		TNT1 A 0  A_JumpIfInventory("TerminatorAmmo", 4 ,"Reload");
		TNT1 A 0 A_GiveInventory("TerminatorAmmo", 1);
		TRMA E 10 TermRaise;
		TRMA F 10;
		TRMA G 8 BRIGHT A_FatAttack1;
		TRMA HH 5 A_FaceTarget;
		TRMA I 8 BRIGHT A_FatAttack2;
		TRMA JJ 5 A_FaceTarget;
		TRMA G 8 BRIGHT A_FatAttack3;
		TRMA HH 5 A_FaceTarget;
		Goto See;
	Melee:
		TRMA K 5 A_StartSound("TERM/melee");
		TRMA LM 6;
		TRMA N 8 A_CustomMeleeAttack(random(3, 9) * 10);
		Goto See;
	Pain:
		TRMA O 3;
		TRMA P 3 A_Pain;
		TNT1 A 0 FeelNoPain(8);
		Goto See;
	Death:
		TRMA P 20 A_Scream;
		TRMA Q 20 ;
		TRMA R 12 A_NoBlocking;
		TRMA S 12;
		TRMA T 8;
		TRMA T -1 A_BossDeath;
		Stop;
	 Raise:
		TRMA T 5;
		TRMA SSRRQQ 5;
		Goto See;
	}
	void TermRaise(){
		A_StartSound("TERM/raisegun");
		A_chase();
	}
	void TerminatorStep(string footstep, bool special = False){
		A_Quake(0.2, 6, 0, 300, "");
		MarineStep(footstep, "_a_chase_default","_a_chase_default");

	}
	void MarineStep(string footStep, statelabel melee, statelabel missile,int flags = 0){
		A_StartSound(footStep);
		A_Chase(melee, missile, flags);
	}
	
	override void BeginPlay(void)
	{
		defaultPainChance = painchance;
	}
	void FeelNoPain(int painlessTime = 8){
		staggerRes = painlessTime;
// 		Console.printf("set staggerres %d nopain`mads %d",staggerRes, bNOPAIN);
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

class TerminatorAmmo: Inventory{
	Default {
		Inventory.MaxAmount 100;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}
