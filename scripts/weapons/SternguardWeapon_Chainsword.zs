extend class SternguardWeapon 
{
	float csTargetScaleX;
	float csTargetScaleY;
	float csOffsetX;
	float csOffsetY;
	
	float csChargeRange;
	float csQuakeStrength;
	float chainswordDamageStrike;
	float chainswordDamageSaw;
	float csSwingAngle;
	float csAttackRange;

	Property ChainSwordChargeRange : csChargeRange; 
	Property ChainswordQuakeStrength : csQuakeStrength; 
	Property ChainswordDamageStrike : chainswordDamageStrike; 
	Property ChainswordDamageSaw : chainswordDamageSaw; 
	Property ChainswordInvulnLength: IframeLength;
	Property ChainswordSwingAngle: csSwingAngle;
	
	Property ChainSwordTargetScaleX : csTargetScaleX;
	Property ChainSwordTargetScaleY : csTargetScaleY;
	Property ChainSwordOffsetX: csOffsetX;
	Property ChainSwordOffsetY: csOffsetY;
	Property ChainSwordAttackRange: csAttackRange;
	
	Default
	{
		
		SternguardWeapon.ChainSwordTargetScaleX 0.6;
		SternguardWeapon.ChainSwordTargetScaleY 0.6;
		SternguardWeapon.ChainSwordOffsetX 160;
		SternguardWeapon.ChainSwordOffsetY 32;
// 		A_WeaponOffset(-120, 32);
		SternguardWeapon.ChainSwordChargeRange 500; //charge range of chainsword
		SternguardWeapon.ChainswordQuakeStrength 1.5; //intensity of all chainsword related screenshake
		SternguardWeapon.ChainswordDamageStrike 36; //Damage of chainsword on first two hit
		SternguardWeapon.ChainswordDamageSaw 25; //Damage of chainsword during the sawing
		SternguardWeapon.ChainswordInvulnLength 10; //The length of invulnerabilty time when charging in ticks
		SternguardWeapon.ChainswordSwingAngle 1.0;
		SternguardWeapon.ChainswordAttackRange 70;
	}

	States
	{
	// 	=================================================================================
	// 	Chainsword states
	// 	================================================================================	
	
// 	A transitional state after a chainsword swing, do not allow chainsword input if altfire is held down
//  This state exist to mitigate the problem of accidentally entering the chainsword state again after finishing an attack
// 	because the altfire key was held down
// 	Only go back to weaponready if altfire button is released
// 	This state needs to be redefined in child class to show the individual weapon sprites
	NoChainSword:
		TNT1 A 1 OverlayReAdjust;
	NoChainSwordLoop:
		TNT1 A 2 {
			A_WeaponReadyBob_NoCS(WRF_ALLOWRELOAD);

		}
		TNT1 A 2 {
			A_WeaponReadyBob_NoCS(WRF_ALLOWRELOAD);
			A_Refire("NoChainSwordLoop");
		}	
		Goto Ready;
	AltFire:
		TNT1 A 0 {
			AdjustChainswordScale();
			A_WeaponOffset(-invoker.csOffsetX, invoker.csOffsetY);
			invoker.chainswordFirstStrike = True;
		}
		CHNS A 1
		{ 
			A_Startsound("weapons/chainsword_Idle", CHAN_7, CHANF_LOOP, volume: 0.7);
			A_Refire("Idle");
			A_Quake(invoker.csQuakeStrength, 4, 0, 5, "");
		}
		TNT1 A 0 {
			A_StopSound(CHAN_7);
			A_Startsound("weapons/chainsword_Strike",CHAN_5,flags: CHANF_OVERLAP);
			A_Startsound("weapons/chainsword_swoosh",CHAN_5,flags: CHANF_OVERLAP,volume: 0.3, pitch: 1.0);
			ChargeIfHaveTarget(range: invoker.csChargeRange);
		}
	Strike:
		TNT1 A 0 {
			A_WeaponOffset(-invoker.csOffsetX, invoker.csOffsetY);
			if(invoker.isCsCharging){
				invoker.Iframe = invoker.IframeLength;
			}
		}
		CHNS B 2 {
			A_Quake(invoker.csQuakeStrength, 6, 0, 5, "");
			FaceChargeTarget( interpolation: 0.5);
		}
		CHNS CD 1 {
// 			A_SetPitch(pitch - invoker.csSwingAngle * 0.4);
			FaceChargeTarget( interpolation: 0.5);
		}
		CHNS D 1 {
			FaceChargeTarget( interpolation:0.2);
			A_QuakeEx(invoker.csQuakeStrength * 1.2,invoker.csQuakeStrength*1.2,invoker.csQuakeStrength * 1.2
			, 2, 0, 10, "", flags: QF_SCALEDOWN);
		}
		CHNS E 1 {
// 			A_SetPitch(pitch - invoker.csSwingAngle * 0.4);
			FaceChargeTarget(thrust:False);
// 			A strong shake if the chainswod hit something
			if (ChainswordCutting(invoker.chainswordDamageStrike, range:invoker.csAttackRange + 20)){
// 				Console.printf("TARGETHIT");
				A_QuakeEx(invoker.csQuakeStrength * 20,invoker.csQuakeStrength*20,invoker.csQuakeStrength * 40
				, 6, 0, 10, "", flags: QF_SCALEDOWN);
			}
			else{
				A_Quake(invoker.csQuakeStrength, 4, 0, 5, "");
			}
			CsRefire("Sawing", range:invoker.csAttackRange);
		}
		CHNS EE 1 {
			FaceChargeTarget(trystop:True);
			CsRefire("Sawing", range:invoker.csAttackRange);
		}
		CHNS F 1 {
			FaceChargeTarget(thrust:True, trystop:True);
			if (ChainswordCutting(invoker.ChainswordDamageSaw + 10, range:invoker.csAttackRange)){
				Console.printf("TARGETHIT 2");
				A_QuakeEx(invoker.csQuakeStrength * 20,invoker.csQuakeStrength*20,invoker.csQuakeStrength * 40
				, 6, 0, 10, "", flags: QF_SCALEDOWN);
			}
			A_Quake(invoker.csQuakeStrength, 4, 0, 5, "");
			CsRefire("Sawing", range:invoker.csAttackRange);
		}
		CHNS F 1{
			FaceChargeTarget(thrust:False, trystop:True);
			CsRefire("Sawing", range:invoker.csAttackRange);
		}
		Goto Followthroughmiss;
	Sawing:
		CHNS F 2 ChainswordCutting(invoker.ChainswordDamageSaw, is_saw: True); 
		TNT1 A 0 chainswordshake(3, 3, 35, 0.6);
		CHNS G 2 A_QuakeEx(invoker.csQuakeStrength * 2, invoker.csQuakeStrength*2, invoker.csQuakeStrength * 2
		, 6, 0, 10, flags: QF_SCALEDOWN);
		CHNS H 1 CsRefire("Sawing", range:invoker.csAttackRange);
		Goto Followthrough;
	Followthroughmiss:
		TNT1 A 0 A_Startsound("weapons/swing_miss",CHAN_7, startTime: 0.3);
		TNT1 A 0;
		CHNS U 2 {
			FaceChargeTarget(thrust:False, trystop:True);
			A_QuakeEx(invoker.csQuakeStrength * 1.2,invoker.csQuakeStrength*1.2,invoker.csQuakeStrength * 1.2
			, 12, 0, 10, flags: QF_SCALEDOWN);
// 			CsRefire("Sawing", range:invoker.csAttackRange);
		}
		CHNS U 2;
		CHNS V 2 {
			A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			A_Refire("NoChainSword");
			A_WeaponOffset(-invoker.csOffsetX, invoker.csOffsetY);
		} 
		CHNS T 2 {
			A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			A_Refire("NoChainSword");
			A_WeaponOffset(-invoker.csOffsetX, invoker.csOffsetY);
		}
		CHNS T 1 {
			A_Refire("NoChainSword");
// 			A_Refire("Fire");
		}
		TNT1 A 0 OverlayReAdjust;
		Goto Ready;
	Followthrough:
// 		Do an extra "cleaving" hit when you are dragging the sword away
		CHNS I 1 {
			ChainswordCutting(invoker.chainswordDamageStrike, range:invoker.csAttackRange + 20,isCleave: True);
			CsRefire("Sawing", range:invoker.csAttackRange); // Allow refire in some follow through frame because the timing is tough
			FaceChargeTarget(False, False, 0);
		}
		CHNS JL 1 {
// 			CsRefire("Sawing", range:invoker.csAttackRange);
			FaceChargeTarget(False, False, 0);
		}
// 		TNT1 A 0 A_Stopsound(CHAN_7);
		CHNS N 2  {
			A_Quake(invoker.csQuakeStrength * 5, 6, 0, 10);
			A_Stopsound(CHAN_7);
			A_Startsound("weapons/swing_cut",CHAN_AUTO, startTime: 0.3);
		}
		CHNS P 2;
		CHNS R 2 {
// 			A_Stopsound(CHAN_7);
			A_QuakeEx(invoker.csQuakeStrength * 2,invoker.csQuakeStrength*2,invoker.csQuakeStrength * 3
			, 12, 0, 10, "", flags: QF_SCALEDOWN|QF_RELATIVE);
			A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			A_Refire("NoChainSword");
			A_WeaponOffset(-invoker.csOffsetX, invoker.csOffsetY);
		}
		CHNS ST 2 {
			A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
			A_Refire("NoChainSword");
			A_WeaponOffset(-invoker.csOffsetX, invoker.csOffsetY);
		}
		TNT1 A 0 OverlayReAdjust;
		Goto Ready;
	Idle:
		CHNS A 1 {
			AdjustChainswordScale();
			chainswordshake();
			A_Startsound("weapons/chainsword_Idle",CHAN_7,CHANF_LOOPING, volume: 0.7);
			A_Quake(invoker.csQuakeStrength * 0.8, 2, 0, 5);
		}
		CHNS A 1{ 
			A_Refire("Idle");
		}
		TNT1 A 0 {
			A_StopSound(CHAN_7);
		}
		Goto AltFire + 2;
	}
	action void A_WeaponReadyBob_NoCS(int flags = 0){
		A_WeaponReadyBob(flags|WRF_NOSECONDARY);
	}
	
	// 	First try to get a charge target, then charge towards it if one is found
	action void ChargeIfHaveTarget(float range = 300)
	{
		invoker.chargeTarget = invoker.getChargeTarget(range, spread_xy: 10, raycastCount:6);
		if (invoker.chargeTarget)
		{
// 			Reset speed to prepare for charge
			invoker.owner.vel = (0,0,0);

// 			Magic number at the moment because I can't figure out the ground friction
			double chargeAngle = 0;
			chargeAngle = invoker.owner.AngleTo (invoker.chargeTarget);
			invoker.owner.angle = chargeAngle;
			if (invoker.owner.distance2d(invoker.chargeTarget) > range * 2.0 /3.0)
			{
				Thrust(sqrt(invoker.owner.distance2d(invoker.chargeTarget)), chargeAngle);
// 				Console.printf("Target far, performing initial boost");
// 				A_Startsound("ParryMe/parry", CHAN_AUTO);
// 				Thrust(sqrt(invoker.owner.distance2d(invoker.chargeTarget)/2), chargeAngle);
			}
// 			else{
			
// 			}
			invoker.owner.bnogravity = True;
			ThrustThingz(0,15,0,1);
			invoker.isCsCharging = True;
			invoker.FaceChargeTarget(Thrust: False);
		}	
	}
	
	// 	The wobbling animation when a chainsword is revving
	action void chainswordShake(int range_x= 10,int range_y=3, int period = 35, int randomrange = 0.1){
		int breathspeed = 1;
		invoker.timer = (invoker.timer + breathspeed + frandom(0, 0.1 * breathspeed)) % period;
		float degree = float(invoker.timer)/float(period) * 360;
		A_WeaponOffset(-invoker.csOffsetX + range_x * (- cos(degree))* frandom(1.0 - randomrange,1.0 + randomrange) 
		, invoker.csOffsetY + range_y * sin(degree)* frandom(1.0 - randomrange, 1.0 + randomrange));
	}
	

	
// 	Turn the player to face the target during a chainsword charge
// 	Also act as extra charges
	action void FaceChargeTarget(bool thrust = True, bool trystop = False, float interpolation = 0){
// 		Console.Printf("turning to face charge target, original angle %f, interpolation rate %f", invoker.owner.angle,interpolation);
		float chargeAngle = 0;
		float targetpitch = 0;
// 		If target is close, stop there
		if(invoker.chargeTarget && invoker.owner.Distance2D(invoker.chargeTarget) 
		< invoker.chargeTarget.radius + invoker.csAttackRange - 15)
		{
			invoker.owner.vel = (0.1,0.1,0.1);
			invoker.isCsCharging = False;
			return;
		}
		
// 		Don't face target if its already dead, and also stop moving. 
// 		This is to avoid the cases where player will pass through the target and then turn 180 degree to face them because
// 		the target is one-shotted
		if(invoker.chargeTarget && invoker.chargeTarget.health <= 0)
		{
			invoker.owner.vel = (0.1,0.1,0.1);
			invoker.isCsCharging = False;
			return;
		}
	// 		Turn to face target
		if(invoker.chargeTarget)
		{
			chargeAngle = invoker.owner.AngleTo(invoker.chargeTarget);
			targetPitch = invoker.owner.PitchTo(invoker.chargeTarget, zOfs: 40, targZOfs: invoker.chargeTarget.height/2);
			invoker.owner.angle = chargeangle;
			invoker.owner.pitch = targetPitch;
// 			invoker.owner.angle = float(chargeAngle - invoker.owner.angle) * float(1.0-interpolation) + invoker.owner.angle;
// 			invoker.owner.pitch = float(targetPitch - invoker.owner.pitch) * float(1.0-interpolation) + invoker.owner.pitch;
		}
		
// 		Perform extra charge if needed
		if(invoker.chargeTarget && invoker.isCsCharging && thrust)
		{
			Thrust(sqrt(invoker.owner.distance2d(invoker.chargeTarget)/3), chargeAngle);
		}
// 		Console.Printf("target angle %f, interpolated %f",chargeAngle,invoker.owner.angle);
		if (trystop){
			invoker.isCsCharging = False;
			invoker.owner.bnogravity = False;
		}
	}
	
	action Actor getChargeTarget(float range, float spread_xy = 2, float spread_z = 2, int raycastCount = 4){
// 		spread_xy is used here for a fan shaped spread out check for charge target, instead of random spread
		Console.Printf("Getting charge target");
		FTranslatedLineTarget t;
		double ang = invoker.owner.angle;
		double slope = invoker.owner.AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);
		
		float angleOffset = 0;
// 		If a direct check gets nothing, try to to the side to see if there is any available target
		if (!t.linetarget)
		{
			Console.Printf("direct hit fail, spreading out, original angle %f", ang);
// 			Spread out from the center in a fan shape
			for (int i = 1; i <= raycastCount; i++){
				if (i % 2 == 0)
				{
					angleOffset = - float( i / 2 ) * spread_xy / float(raycastCount) * 2;
				}
				else
				{
					angleOffset = float(i / 2 + 1) * spread_xy / float(raycastCount) * 2;
				}
				Console.Printf("index %d, checking with offset %f, new angle %f",i , angleOffset, (ang + angleOffset + 360) % 360);
				slope = invoker.owner.AimLineAttack ((ang + angleOffset + 360) % 360, range, t) + spread_z * (Random2[Saw]() / 255.);
// 				Keep going until it finds something
				if (t.linetarget)
				{
					Console.printf("TARGET FOUND");
					break;
				}
// 				else Console.printf("no target found");
			}
		}
		
		if (!t.linetarget)
		{
			Console.printf("No target");
			return null;
		}
		Console.printf("Have target");
		return t.linetarget;
	}
	
	// 	Refire to a specific state if there's something to hit in range
	action void CsRefire(statelabel flash, float range = 200, float spread_xy = 2, float spread_z = 2)
	{
// 		Console.Printf("doing refire if target");
		FTranslatedLineTarget t;
		double ang = invoker.owner.angle + spread_xy * (Random2[Saw]() / 255.);
		double slope = invoker.owner.AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);
// 		Don't refire if there's no target or the target is dead
		if (!t.linetarget || (t.linetarget && t.linetarget.health <= 0))
		{
// 			Console.printf("no target to cut");
			return;
		}
		A_Refire(flash);
	}
	
// 	Attack Function of ChainSword, it is a modified version of A_saw()
// 	
	action Bool ChainswordCutting(float damage = 2, Sound fullsound = "weapons/chainsword_lowrev", Sound hitsound = "weapons/chainsword_cutting"
	, float range = 77,float spread_xy = 1, float spread_z = 0
	, Bool lifesteal = False, Bool doturn=True, Bool dopull=True
	, bool isCleave = False, bool is_saw = False)
	{
		FTranslatedLineTarget t;
		if (player == null)
		{
			return False;
		}

		class<Actor> pufftype = 'BulletPuff';

		double ang = angle + spread_xy * (Random2[Saw]() / 255.);
// 		Give a kickback effect to the final cleave strike so the player can be safe from the follow up melee
		if(isCleave)
			invoker.kickback = 200;
		else
		invoker.kickback = 0;
		double slope = AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);
		

		Weapon weap = player.ReadyWeapon;

		int puffFlags = SF_NORANDOMPUFFZ;

		Actor puff;
		int actualdamage;
		[puff, actualdamage] = LineAttack (ang, range, slope, damage, 'ChainSword', pufftype, puffFlags, t);
		
		if (!t.linetarget)
		{
// 			Special check for when it's called in a hit follow through (where isCleave is true), or an active sawing (is_saw is true)
// 			, where the sawing sound should not be interrupted by miss sound, because you will enter follow through state in both cases
// 			and the follow through audio should play directly after sawing audio to not sound out of place
			if(!(isCleave || is_saw))
				A_StartSound (fullsound, CHAN_7);
			invoker.kickback = invoker.originalKickBack;
			return False;
		}
		
		A_StartSound (hitsound, CHAN_7, flags: CHANF_LOOPING, pitch:0.7, starttime:0.0);
// 		Add an impact sound for the first saw hit
// 		Also add an impact sound for cleaving strike
		if (invoker.chainswordFirstStrike || isCleave){
			A_StartSound("weapons/bolter_impact_flesh",CHAN_AUTO,starttime: 0.1);
// 			Force a pain state on first strike
			if (invoker.chainswordFirstStrike && t.linetarget.FindState("Pain") && t.linetarget.health > 0)
			{
				t.linetarget.SetStateLabel("Pain");
			}
// 			Stop the player if they hit something
			invoker.owner.speed = 0;
			invoker.chainswordFirstStrike = False;
		}
		if (invoker.chainswordFirstStrike)
			invoker.owner.vel = (0.1,0.1,invoker.owner.vel.z);
			
		// turn to face target
		if (doturn)
		{
			double anglediff = deltaangle(angle, t.angleFromSource);

			if (anglediff < 0.0)
			{
				if (anglediff < -3.0)
					angle = t.angleFromSource + 2.7;
				else
					angle -= 3.0;
			}
			else
			{
				if (anglediff > 3.0)
					angle = t.angleFromSource - 2.7;
				else
					angle += 3.0;
			}
		}
		if (dopull)
		{
			bJustAttacked = true;
		}
		invoker.kickback = invoker.originalKickBack;
		return False;
	}
	
	action void AdjustChainswordScale(){
		A_OverlayScale(1, invoker.csTargetScaleX/invoker.WeaponScaleX
		, invoker.csTargetScaleY/invoker.WeaponScaleY);
	}
	
}