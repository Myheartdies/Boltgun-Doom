class LegionaryPlasma : ChaosMarine Replaces HellKnight
{	
// 	PSMA:
//  	6 movement frame ABCDEF  , foot step happens at state B and E
//  	5 ranged attack frame reduce to GHIJK
//  	4 melee attack frame LMNO
//  	2 flinch frame PQ
//  	4 death frame including corpse RSTU
// 	PSMB:
//  	7 taunt frame ABCDEFG
// 		5 charge up frame HIJKL
	Default
	{
		Scale 0.32;
		Health 700;
		Speed 9;
		SeeSound "PCSM/sight";
		ActiveSound "TCSM/active";
		PainSound "PCSM/pain";
		DeathSound  "PCSM/death";
		PainChance 50;
		MeleeRange 60;
		MeleeThreshold 95;
// 		+DropOff
		MinMissileChance 170;
		Tag "$FN_PCSM";
	}
	States
	{
	Spawn:
		PSMB MNOP 8 A_Look;
		Loop;
	See:
		PSMA AA 3 A_Chase;
		PSMA B 2 PlasmaStep("TCSM/steps");
		PSMA CCDD 3 A_Chase; 
		PSMA E 2 PlasmaStep("TCSM/steps");
		PSMA FF 3 A_Chase;
		Loop;
	Melee:
		TNT1 A 0  A_JumpIf(random(0,3) > 2, "DashMissile");
		PSMA L 6 A_FaceTarget;
		PSMA M 3 A_StartSound("TCSM/active");
		PSMA M 3 A_FaceTarget;  //2 originally
		PSMA N 3 A_FaceTarget;  //3
		PSMA O 12 A_CustomMeleeAttack(random(3, 10) * 8, "TCSM/melee");
		Goto See;
	DashMissile:
		PSMA F 2 {A_FaceTarget();BackThrust(18,3);}
		PSMA E 2 PlasmaStep("TCSM/charge",True);
		PSMA DC 2;
		PSMA B 3 PlasmaStep("TCSM/charge",True);
		PSMA AF 2;
		PSMA E 2 PlasmaStep("TCSM/steps",True);
		PSMB D 2 A_StartSound("PCSM/chargeup");
// 		PSMB E 2;
// 		PSMA G 3 A_FaceTarget;
		PSMB E 2 A_FaceTarget;
		PSMA G 3;
		PSMA H 3;
		PSMA I 4 Bright MarineMissile();
// 		PSMA J 3 A_FaceTarget;
// 		PSMA G 4 Bright;
// 		PSMA H 8 Bright MarineMissile();
		PSMA I 3 Bright;
		PSMA J 3;
		PSMA K 8;
		Goto See;
	Missile:
		TNT1 A 0  A_JumpIf(random(0,3) > 2, "TurboMissile");
		TNT1 A 0  A_JumpIf(random(0,3) > 2, "DashMissile");
		PSMB H 4 A_StartSound("PCSM/chargeup");
		PSMB IJK 2 A_FaceTarget;
		PSMA GH 3 A_FaceTarget;
		PSMA H 3 Bright MarineMissile();
		PSMA JG 2 A_FaceTarget;
		PSMA H 3 Bright MarineMissile();
		PSMA I 8 Bright;
		PSMA JK 3;
		Goto See;
	TurboMissile:
		PSMB A 3 A_StartSound("TCSM/bark");
		PSMB BCDEFG 3 A_FaceTarget;
		PSMB H 2 A_StartSound("PCSM/chargeup");
		PSMB IJKL 3 A_FaceTarget;
		PSMA GH 2 A_FaceTarget;
		PSMA I 5 Bright MarineMissile();
		PSMA G 3 Bright A_FaceTarget;
		PSMA H 3 Bright A_FaceTarget;
		PSMA I 3 Bright MarineMissile();
		PSMA G 3 Bright A_FaceTarget;
		PSMA H 2 Bright;
		PSMA I 4 Bright MarineMissile();
		PSMA I 5 Bright;
		PSMA I 10;
		PSMA J 6 ;
		PSMA K 6;
		Goto See;
		
	Pain:
		PSMA P  2;
		PSMA Q  3 A_Pain;
		Goto See;
// 		TNT1 A 0 special_stagger;
	Death:
		PSMA R  6 ;
		PSMA S  8 A_Scream;
		PSMA T  8 A_NoBlocking;
		PSMA U  -1;
		Stop;

	}
	void BackThrust(double strength, double jump_strength = 0){
		double angle = 0;
		if(target){
			angle = AngleTo (target);
			angle = (angle +random(30,70)*random(-1,1) +180)%360;
		}
		A_SetAngle(angle);
		Thrust(strength, angle);
		ThrustThingz(0,jump_strength,0,1);
		
	}
	
	void MarineMissile(){
		A_SpawnProjectile("LegionaryPlasmaBall", 42, 10);
// 		A_CustomComboAttack("LegionaryPlasmaBall", 40, 8 * random(3, 7), "TCSM/melee");
	}
	
	void PlasmaStep(string footStep, bool no_missile=False){
		if (no_missile){
			MarineStep(footStep, "_a_chase_default",null,CHF_NODIRECTIONTURN );
		}
		else{
			MarineStep(footStep, "_a_chase_default","_a_chase_default",CHF_DONTMOVE);
		}
	}
// 	state special_stagger(){
// 		return FindState("Missile");
// 	}
	

}
	class LegionaryPlasmaBall: BaronBall{
		Default
		{
			Speed 15;
			Damage 7;
			SeeSound "PCSM/attack";
		
		}
	}

