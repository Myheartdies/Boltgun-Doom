class Legionary : ChaosMarine 
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
		Scale 0.51;
		Health 680;
		Speed 10;
		Height 64;
		SeeSound "TCSM/sight";
		ActiveSound "TCSM/active";
		PainSound "TCSM/pain";
		DeathSound  "TCSM/death";
		PainChance 60;
		MeleeRange 48;
		MeleeThreshold 140;
// 		+DropOff
		MinMissileChance 130;
		DropItem "ClipBox";
		Tag "$FN_CSM";
	}
	States
	{
	Spawn:
		TCSM TU 10 A_Look;
		Loop;
	Charge:
		TNT1 A 0 FeelNoPain(8);
		TCSM R 4 A_StartSound("TCSM/bark");
		TCSM SR 5 A_FaceTarget;
		TCSM A 3 DirectedThrust(18);
		TNT1 A 0 FeelNoPain(8);
		TCSM AA 1 MarineCharge;
		TCSM B 2 TacticalStep("TCSM/steps",True);
		TCSM CCDD 1 MarineCharge;
		TCSM E 2 TacticalStep("TCSM/steps",True);
		TCSM FFAA 1 MarineCharge;
		TCSM B 2 TacticalStep("TCSM/charge",True);
// 		TCSM CCDD 1 MarineCharge;
// 		TCSM E 2 TacticalStep("TCSM/charge",True);
		TCSM F 3 DirectedThrust(17,17);
		TCSM AJ 6 MarineCharge;
		Goto FastMelee;
	See:
		TNT1 A 0  A_JumpIfCloser(180, "Advance");
		TCSM AA 3 A_Chase;
		TCSM B 2 TacticalStep("TCSM/steps");
		TCSM CCCDDD 2 A_Chase; 
// 		TCSM DD 3 A_Chase("Melee","Charge");
		TCSM E 2 TacticalStep("TCSM/steps");
// 		TCSM FF 3 A_Chase("Melee","Charge") ;
		TCSM FFF 2 A_Chase;
		Loop;
// 	Advance:
// 		TCSM AA 2 A_Chase;
// 		TCSM B 2 TacticalStep("TCSM/steps");
// 		TCSM CCDD 2 A_Chase;
// 		TCSM E 2 TacticalStep("TCSM/steps");
// 		TCSM FF 2 A_Chase;
// 		Goto See;
	FastMelee:
		TCSM J 2 A_StartSound("TCSM/active"); 
		TCSM J 1 DirectedThrust(5);
		TCSM J 3 A_FaceTarget; 
		TCSM K 8 A_CustomMeleeAttack(random(3, 9) * 8, "TCSM/melee", "TCSM/melee-miss");
		TCSM J 2;
		Goto See;
	Melee:
		TCSM A 3 {A_FaceTarget(); DirectedThrust(5);}
		TCSM J 3 ;  //2 originally
		TCSM J 3 ;
		TCSM J 4 A_StartSound("TCSM/active");
		TCSM K 6 A_CustomMeleeAttack(random(3, 9) * 8, "TCSM/melee", "TCSM/melee-miss");
		TCSM J 2 ; 
		Goto See;
	Missile:
		TNT1 A 0  A_JumpIf(random(0,4) > 3, "Charge");
		TCSM G 8 {A_FaceTarget();A_StartSound("TCSM/active");}
		TNT1 A 0 FeelNoPain(6);
		TCSM H 3 Bright;
		TCSM H 3 Bright MarineMissile;
		TCSM H 3 Bright A_FaceTarget;
		TCSM I 2 Bright MarineMissile;
		TCSM I 3 Bright A_FaceTarget;
		TCSM I 2 Bright MarineMissile;
		TCSM I 4 Bright A_FaceTarget;
		TCSM I 2 Bright;
		TCSM H 3 Bright MarineMissile;
		Goto See;
	Pain:
		TNT1 A 0 A_TakeInventory("ParryMe_Stack",1);
		TCSM L  2 A_Pain;
		TNT1 A 0 FeelNoPain(10);
		TCSM M  4 ;
// 		TNT1 A 0  A_JumpIf(random(0,3) > 2, "Charge");
		TNT1 A 0  A_JumpIfInventory("ParryMe_Stack", 2 ,"Pain");
		
		Goto See+1;
	Death:
		TCSM M  6 ;
		TCSM N  6 A_Scream;
		TCSM O  6;
		TCSM O  4 A_NoBlocking;
		TCSM P  11;
		TCSM Q -1;
		Stop;
	Raise:
		TCSM Q 8;
		TCSM PPOONN  8;
		Goto See;

 	}
// 	void ShowStack(){
// 		A_LogInt(CheckInventory("ParryMe_Stack"));
// 	}
	void TacticalStep(string footStep, bool is_charge=False){
// 		grenade = grenade +1;
		if (is_charge){
			MarineStep(footStep, "FastMelee",null,CHF_NOPOSTATTACKTURN);
		}
		else{
			MarineStep(footStep, "_a_chase_default","_a_chase_default",CHF_DONTMOVE);
		}
	}
	void MarineMissile(){
// 		A_SpawnProjectile("MarineBall", 46,7);
		A_SpawnProjectile("MarineBall", 46);
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
			angle = (angle +random(-20,20))%360;
		}
		A_SetAngle(angle);
		Thrust(strength, angle);
		ThrustThingz(0,jump_strength,0,1);
		
	}
	void TurnToTarget(){
// 	A_setAngle to turn
//     Angle_to to get angle
	
	}
	override void MarineXDeath(){
		bool spawned;
		Actor gib;
		A_SpawnItemEx("GibHeadTCSM", xofs:5, zofs:64,xvel: frandom(1,2), yvel: frandom(-3,3), zvel: random(6,12));
// 		left arm
		A_SpawnItemEx("GibArmTCSM", xofs:3, yofs: -6,  zofs:40, xvel: frandom(1,2), yvel: frandom(-5,-3), zvel: random(1,3));
// 		right arm
		[spawned, gib] =  A_SpawnItemEx("GibArmTCSM", xofs:3, yofs: 6, zofs:40,xvel: frandom(1,2), yvel: frandom(3,5), zvel: random(1,3));
		if (spawned) gib.scale.x = gib.scale.x * -1;
		return ;
	}
	
}


class GibArmTCSM: GibActor
{
	Default
	{
		Radius 8.0;
		Height 4.0;
		Gravity 0.6;
		Scale 0.52;
		BounceFactor 0.4;
		BounceCount 6;
		BounceSound "TCSM/gibbounce";
	}
	States
	{
// 		First loop has bright frames
		Spawn:
			TNT1 A 0 {Gravity = Gravity * 0.5; A_Setroll(random(180,270));}
			TSMA ABCDE 2 Bright;
			TNT1 A 0 {Gravity = Gravity * 2;}
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop2");
			}
			TSMA F -1;
			Stop;
		RollLoop1:
			TSMA ABCDE 2;
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop2");
			}
			TSMA F -1;
			Stop;
		RollLoop2:
			TSMA FGHABC 2;
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop3");
			}
			TSMA F -1;
			Stop;
		RollLoop3:
			TSMA DEFGH 2;
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop1");
			}
			TSMA I -1;
			Stop;
		Death:
			TSMA I -1;
			Stop;
	}
}

class GibHeadTCSM: GibActor 
{
	Default
	{
		Radius 8.0;
		Height 4.0;
		Gravity 0.6;
		Scale 0.6;
		BounceType 'Doom';
		BounceFactor 0.4;
		BounceCount 6;
		BounceSound "TCSM/gibbounce";
	}
	States
	{
// 		First loop has bright frames
		Spawn:
			TNT1 A 0 {Gravity = Gravity * 0.25;}
			TSMH ABC 2 Bright;
			TNT1 A 0 {Gravity = Gravity * 2;}
			TSMH DEF 2 Bright;
			TNT1 A 0 {Gravity = Gravity * 2;}
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop2");
			}
			TSMH F -1;
			Stop;
		RollLoop1:
			TSMH ABCDEF 2;
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop2");
			}
			TSMH F -1;
			Stop;
		RollLoop2: 
			TSMH GHIABC 2;
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop3");
			}
			TSMH F -1;
			Stop;
		RollLoop3: 
			TSMH DEFGHI 2;
			TNT1 A 0 {
				return A_Jumpif(abs(vel.x) > 0.2 || abs(vel.y) > 0.2 || abs(vel.z) > 0.2, "RollLoop1");
			}
			TSMH I -1;
			Stop;
		Death:
			TNT1 A 0 {scale.x = scale.x * (random(0,1)-0.5) * 2;}
			TSMH A -1;
			Stop;
	}
}

class MarineBall: BolterProjectile{
	Default
	{
		Radius 3;
		Height 4;
// 		Scale 1;
		RenderStyle "Add";
		SeeSound "TCSM/attack";
		DeathSound "weapons/bolter_impact";
		Species "BaronOfHell";
		Damage 4;
// 		DamageFunction 3.5 * random(1,8);
// 		DamageFunction 24;
		Speed 14;
		FastSpeed 20;
	}
	States
	{
	Spawn:
		BAL1 A 1 Bright {
			bolterParticle(1,15,8,10,5);
// 			FlameRing();
		}
		BAL1 A 1 Bright {
			bolterParticle(1,15,8,10,5);
			FlameRing();
		}
		Loop;
	Crash:
	XDeath:
	Death:
		BTRE A 2 Bright ;
		BTRE BDFHJL 2 Bright;
		BTRE MOQ 2;
// 		Goto LightDone;
		Stop;
	}
	void FlameRing(){
		A_SpawnParticleEx("red",TexMan.CheckForTexture("FMRNA0"),STYLE_AddShaded,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM , 8
		, 35, 0
		,0,0,0
		,0,0,0,0,0,0
		, 1.0, 0, -2
		, Random(0,12)*30, Random(-2,2));
	}
}