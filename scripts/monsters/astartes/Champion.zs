class AspiringChampion : ChaosMarine Replaces BaronOfHell
{
//  6 movement frame ABCDEF  , foot step happens at state B and E
//  4 ranged attack frame reduce to 3 GHI
//  2 melee attack frame JK
//  2 flinch frame LM
//  4 death frame including corpse NOPQ
//  2 taunt frame RS
// 	2 grenade frames TU
	int grenade;
	Default
	{
		Scale 0.42;
		Health 1200;
		Speed 12;
		SeeSound "CCSM/sight";
		ActiveSound "CCSM/active";
		PainSound "CCSM/pain";
		DeathSound  "CCSM/death";
		+BOSSDEATH
		PainChance 80;
		MeleeRange 55;
		MeleeThreshold 100;
		MinMissileChance 150;
		DropItem "ClipBox";
		Tag "$FN_CAPN";
	}
	States
	{
	Spawn:
		CPNB ABCD 10 A_Look;
		Loop;
		
	Bark:
		CPNB E 5 {
			A_StartSound("CCSM/bark");
			A_TakeInventory("Rage",22);
		}
		CPNB FGHIJK 5;
		Goto Advance;
		
// 	Charge:
// 		TCSM R 4 A_StartSound("TCSM/bark");
// 		TCSM SR 5 A_FaceTarget;
// 		TCSM A 3 DirectedThrust(18);
// 		TCSM AA 1 MarineCharge;
// 		TCSM B 2 ChampionStep("TCSM/steps",True);
// 		TCSM CCDD 1 MarineCharge;
// 		TCSM E 2 ChampionStep("TCSM/steps",True);
// 		TCSM FFAA 1 MarineCharge;
// 		TCSM B 2 ChampionStep("TCSM/steps",True);
// 		TCSM CCDD 1 MarineCharge;
// 		TCSM E 2 ChampionStep("TCSM/charge",True);
// 		TCSM F 3 DirectedThrust(17,17);
// 		TCSM AJ 6 MarineCharge;
// 		Goto FastMelee;
	See:
// 		TNT1 A 0  A_JumpIfCloser(220, "Advance");
		CPNA AA 3 A_Chase;
		CPNA B 2 ChampionStep("TCSM/steps");
		CPNA CCDD 3 A_Chase; 
		CPNA E 2 ChampionStep("TCSM/steps");
		CPNA FF 3 A_Chase;
// 		Loop;
		Goto Advance;

	Advance:

		TNT1 A 0  A_JumpIfInventory("Rage", 20 ,"Bark");
		TNT1 A 0  A_JumpIfCloser(480, "Intermediate");
		TNT1 A 0  A_JumpIfCloser(200, "See");
		CPNA AA 2 A_Chase("_a_chase_default","_a_chase_default",CHF_NORANDOMTURN);
		CPNA B 1 ChampionStep("TCSM/steps",True);
// 		Deduct rage if taken one step
		TNT1 A 0 A_GiveInventory("Rage", 2);
// 		----------
		CPNA CCDD 2 A_Chase("_a_chase_default","_a_chase_default",CHF_NORANDOMTURN );
		CPNA E 1 ChampionStep("TCSM/steps",True);
		CPNA FF 2 A_Chase("_a_chase_default","_a_chase_default",CHF_NORANDOMTURN );
		Goto Advance;
		
// 	FastMelee:
// 		TCSM J 2 A_StartSound("TCSM/active");
// 		TCSM J 1 DirectedThrust(5);
// 		TCSM J 3 A_FaceTarget;
// 		TCSM K 8 A_CustomMeleeAttack(random(3, 9) * 8, "TCSM/melee");
// 		TCSM J 2;
// 		Goto See;

// 	An intermediate state between advance and leap attack to give it a jump with possibility
	Intermediate:
		TNT1 A 0  A_JumpIfInventory("Rage", 20 ,"Bark");
		TNT1 A 0  A_Jump(100, "LeapAttack");
		Goto Advance+3;
	LeapAttack:
		TNT1 A 0 A_GiveInventory("Rage", 5);
		CPNA A 0 DirectedThrust(10);
		CPNA AA 1 MarineCharge;
		CPNA B 2 ChampionStep("TCSM/charge",True);
		CPNA CCDD 1 MarineCharge;
		CPNA E 2 ChampionStep("TCSM/charge",True);
		CPNA L 2 { 
			A_StartSound("CCSM/melee"); 
			LeapSwing();
			A_JumpIfTargetInsideMeleeRange("MeleeSwing");
		}
		CPNA LLLLLL 2 A_JumpIfTargetInsideMeleeRange("MeleeSwing");
		Goto MeleeSwing;
		
		
//  TODO: Change melee logic to a short-lived projectile like in brutaldoom
	Melee:
		CPNA K 3 A_FaceTarget;
		CPNA L 5 A_StartSound("CCSM/melee");   //2 originally
// 		CPNA M 2;
	MeleeSwing:
		TNT1 A 0 A_GiveInventory("Rage", 2);
		CPNA M 6 {A_FaceTarget(); DirectedThrust(8);}
		CPNA N 4 A_CustomMeleeAttack(random(4, 10) * 7, "TCSM/melee");
// 		CPNA N 0 A_MonsterRefire(0, "MeleeFollowThrough");
// 		TNT1 A 0 A_JumpIfTargetOutsideMeleeRange("MeleeFollowThrough");
// 		Goto Melee + 1;
	MeleeFollowThrough:
		CPNA O 10 A_CustomMeleeAttack(random(2, 6) * 5, "TCSM/melee");
		CPNA P 5; 
		Goto See;
	Missile:
		TNT1 A 0  A_JumpIfInventory("Rage", 20 ,"Bark");
// 		TNT1 A 0  A_JumpIf(random(0,3) > 2, "Charge");
		CPNA G 6 {A_FaceTarget(); A_StartSound("PCSM/chargeup");}
		CPNA H 4 Bright;
		CPNA H 2 Bright ChampionMissile;
// 		CPNA G 6 Bright;
// 		CPNA H 2 Bright ChampionMissile;
		TNT1 A 0 A_GiveInventory("Rage", 2);
		CPNA I 4 Bright A_FaceTarget;
		CPNA J 2 A_Chase;
		Goto Advance;
	Pain:
// 		TNT1 A 0 A_TakeInventory("ParryMe_Stack",1);
		CPNA Q  2 A_Pain;
		CPNA R  3 ;
// 		TNT1 A 0  A_JumpIf(random(0,3) > 2, "Charge");
// 		TNT1 A 0  A_JumpIfInventory("ParryMe_Stack", 2 ,"Pain");
		Goto See;
	Death:
		CPNA S  8 ;
		CPNA T  8 A_Scream;
		CPNA U  10;
		CPNA V  13 A_NoBlocking;
		CPNA W  8;
		CPNA X -1;
		Stop;
// 	Raise:
// 		TCSM Q 8;
// 		TCSM PPOONN  8;
// 		Goto See;

 	}
// 	void ShowStack(){
// 		A_LogInt(CheckInventory("ParryMe_Stack"));
// 	}
	void ChampionStep(string footStep, bool special_condition=False){
		if (special_condition){
			MarineStep(footStep, "_a_chase_default","_a_chase_default",CHF_NOPOSTATTACKTURN);
		}
		else{
			MarineStep(footStep, "_a_chase_default","_a_chase_default",CHF_DONTMOVE);
		}
	}
	void ChampionMissile(){
		A_CustomComboAttack("ChampionPlasmaBall", 40, 5 * random(1, 5), "TCSM/melee");
	}
	void MarineCharge(){
// 		double angle = AngleTo (target);
// 		A_setAngle(angle);
// 		A_FaceTarget();
		A_Chase("FastMelee",null,CHF_NOPOSTATTACKTURN );
	}
	
	void DirectedThrust(double strength, double jump_strength = 0){
		double angle = 0;
		if(target){
			angle = AngleTo (target);
			angle = (angle +random(-15,15))%360;
		}
		A_SetAngle(angle);
		Thrust(strength, angle);
		ThrustThingz(0,jump_strength,0,1);
		
	}
	void LeapSwing(){
		DirectedThrust(22,15);
		A_JumpIfTargetInsideMeleeRange("MeleeSwing");
	}

	void TurnToTarget(){
// 	A_setAngle to turn
//     Angle_to to get angle
	
	}
	
	
}

// The "Stamina" of this monster. Missile, leap and advancing costs rage, barking replenishes it
// Counts up instead of down
class Rage : Inventory{
	Default {
		Inventory.MaxAmount 100;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}

class ChampionPlasmaBall: BaronBall{
		Default
		{
			Speed 17;
// 			Damage 7;
			SeeSound "CCSM/attack";
		
		}
}
