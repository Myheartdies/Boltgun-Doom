// handle the taunting, chainsword, and grenade
class SternguardWeapon : DoomWeapon
{
	int addedoffset_x;
	int addedoffset_y;
	float targetScaleX;
	float targetScaleY;
	float tauntOffsetX;
	float tauntOffsetY;
	float csChargeRange;
	float csQuakeStrength;
	float chainswordDamageStrike;
	float chainswordDamageSaw;
	int IframeLength;
	float csSwingAngle;
	bool isTaunting;
	int TauntWaitTime;
	int tauntCoolDown;
	Property TargetScaleX : targetScaleX;
	Property TargetScaleY : targetScaleY;
	Property TauntOffsetX : tauntOffsetX;
	Property TauntOffsetY : tauntOffsetY;
	Property ChainSwordChargeRange : csChargeRange; 
	Property ChainswordQuakeStrength : csQuakeStrength; 
	Property ChainswordDamageStrike : chainswordDamageStrike; 
	Property ChainswordDamageSaw : chainswordDamageSaw; 
	Property ChainswordInvulnLength: IframeLength;
	Property ChainswordSwingAngle: csSwingAngle;
	Property TauntWaitTime : tauntWaitTime;
	bool PlayerDied;
	int timer;
	float default_weaponscale_x;
	float default_weaponscale_y;
	Actor chargeTarget;
	bool chainswordFirstStrike;
	float originalKickBack;
	bool isCsCharging;
	int Iframe;
	
	override void BeginPlay()
	{
		default_weaponscale_x = WeaponScaleX;
		default_weaponscale_y = WeaponScaley;
		originalKickBack = kickBack;
		tauntCoolDown = 3;
		super.BeginPlay();
	}
	Default
	{
		SternguardWeapon.TargetScaleX 0.8;
		SternguardWeapon.TargetScaleY 0.8;
		SternguardWeapon.TauntOffsetX 120;
		SternguardWeapon.TauntOffsetY 10;
		SternguardWeapon.ChainSwordChargeRange 500; //charge range of chainsword
		SternguardWeapon.ChainswordQuakeStrength 1.5; //intensity of all chainsword related screenshake
		SternguardWeapon.ChainswordDamageStrike 35; //Damage of chainsword on first two hit
		SternguardWeapon.ChainswordDamageSaw 15; //Damage of chainsword during the sawing
		SternguardWeapon.ChainswordInvulnLength 8; //The length of invulnerabilty time when charging in ticks
		SternguardWeapon.ChainswordSwingAngle 1.0;
		SternguardWeapon.TauntWaitTime 40;
		Weapon.BobRangeX 0.1;
		Weapon.BobRangeY 1.0;
		Weapon.BobSpeed 2;
	}
	States
	{
	Ready:
		TNT1 A 0 A_Jump(256, "Ready");
		CHNS A 4 A_WeaponReady;
		Loop;
	Deselect:
		TNT1 A 0 A_Jump(256, "Deselect");
		SAWG C 1 A_Lower;
		Loop;
	Select:
		SAWG C 1 A_Raise;
		Loop;
	Fire:
// 		TNT1 A 0 A_Jump(256, "Fire");
		SAWG AB 4 A_Saw;
		SAWG B 0 A_ReFire;
		Goto Ready;
// 	=================================================================================
// 	Taunting
// 	================================================================================
	TauntingCheck:
		TNT1 A 0 checkTaunt;
// 		TNT1 A 1 A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
		TNT1 A 0 A_Jumpifinventory("isDirectedTaunt", 0, "TauntingDirected");
		TNT1 A 0 A_Jump(256, "TauntingUndirected");
	TauntingUndirected:
		TNT1 A 0 {
			AdjustScale();
			A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
			playUndirectedTaunt();
		}
// 		TNT1 A 0 A_SetPitch(pitch - 0.6);
		TNT1 A 0 A_StartSound("sternguard/taunt_directed_foley2",CHAN_AUTO,volume:0.3);
		TUNA ABC 3 A_SetPitch(pitch + 0.08);
		TUNA DE 4 A_SetPitch(pitch - 0.12);
		TUNA FGHIJ 4;
		TNT1 A 0 A_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD);
		TNT1 A 0 A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
		TUNA JKK 2{
			A_WeaponOffset(4,40,WOF_ADD);
		}
		TNT1 A 0 {
			A_OverlayScale(1, 1, 1);
			A_WeaponOffset(0, 0);
		}
		TNT1 A 0 {A_Jump(256, "Ready"); }
		Goto Ready;
	TauntingDirected:
		TNT1 A 0 {
			AdjustScale();
			A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
			playDirectedTaunt();
		}
		TNT1 A 0 A_StartSound("sternguard/taunt_directed_foley2",CHAN_AUTO,volume:0.3);
		TUNB AA 3 A_SetPitch(pitch + 0.2);
// 		TNT1 A 0 A_ZoomFactor(1);
// 		TUNB DDDDDEFGH 3;
		TUNB BC 3 A_SetPitch(pitch - 0.15);
		TUNB D 3 {
// 			A_StartSound("sternguard/taunt_directed_foley1",CHAN_AUTO,0.3);
			A_SetPitch(pitch - 0.15);
		}
		TUNB D 3 A_SetPitch(pitch + 0.05);
		TUNB DDD 3;
		TNT1 A 0 A_StartSound("sternguard/taunt_directed_foley1",CHAN_AUTO,volume:0.4);
		TUNB DEF 3;
		TNT1 A 0 A_StartSound("sternguard/taunt_directed_foley3",CHAN_AUTO,volume:0.4);
		TUNB GH 3;
// 		TNT1 A 0 {invoker.isTaunting = False;}
		TNT1 A 0 A_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD);
		TNT1 A 0 A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
		TUNB IIIJ 3{
			A_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD);
			A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
		}
		TUNB JJK 2{
			A_WeaponOffset(4,40,WOF_ADD);
			}
		TNT1 A 0 {
			A_OverlayScale(1, 1, 1);
			A_WeaponOffset(0, 32);
		}
		TNT1 A 0 {A_Jump(256, "Ready"); }
		Goto Ready;
// 	=================================================================================
// 	Death
// 	================================================================================
	DeathFrames:
		TNT1 A 0 {
			OverlayReAdjust();
			AdjustScale();
			A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
		}
		TNT1 A 0 {A_Jump(85, "Death1"); } 
		TNT1 A 0 {A_Jump(128, "Death2"); } 
		TNT1 A 0 {A_Jump(256, "Death3"); } 
		Goto Death3;
	Death1:
		SGD1 ABCDEFG 6;
		TNT1 A 20;
		Wait;
		
	Death2:
		SGD2 ABCDEFGHI 6;
		TNT1 A 20;
		Wait;
	Death3:
		SGD3 ABCDEFGHI 6;
		TNT1 A 20;
		Wait;
// 	=================================================================================
// 	Chainsword
// 	================================================================================
		
	AltFire:
		TNT1 A 0 {
// 			A_OverlayScale(0.7, 0.7, 0.7);
			A_WeaponOffset(-120, 32);
			ResetFirstStrike();
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
			if(invoker.isCsCharging){
				invoker.Iframe = invoker.IframeLength;
			}
		}
		CHNS B 2 {
			A_Quake(invoker.csQuakeStrength, 6, 0, 5, "");
			FaceChargeTarget(interpolation: 0.5);
		}
		CHNS CD 2 {
// 			A_SetPitch(pitch - invoker.csSwingAngle * 0.4);
			FaceChargeTarget(interpolation: 0.5);
		}
		CHNS D 1 {
			FaceChargeTarget(thrust:False,interpolation:0.2);
			A_QuakeEx(invoker.csQuakeStrength * 1.2,invoker.csQuakeStrength*1.2,invoker.csQuakeStrength * 1.2
			, 2, 0, 10, "", flags: QF_SCALEDOWN);
		}
		CHNS E 3 {
// 			A_SetPitch(pitch - invoker.csSwingAngle * 0.4);
			FaceChargeTarget(thrust:False, trystop:True);
// 			A strong shake if the chainswod hit something
			if (ChainswordCutting(invoker.chainswordDamageStrike, range:80 + 20)){
				Console.printf("TARGETHIT");
				A_QuakeEx(invoker.csQuakeStrength * 20,invoker.csQuakeStrength*20,invoker.csQuakeStrength * 40
				, 6, 0, 10, "", flags: QF_SCALEDOWN);
			}
			else{
				A_Quake(invoker.csQuakeStrength, 4, 0, 5, "");
			}
			RefireIfHasTarget("Sawing", range:80);
		}
		CHNS F 3 {
			FaceChargeTarget(thrust:False, trystop:True);
			ChainswordCutting(invoker.ChainswordDamageSaw, range:80);
			A_Quake(invoker.csQuakeStrength, 4, 0, 5, "");
			RefireIfHasTarget("Sawing", range:80);
		}
		Goto Followthroughmiss;
	Sawing:
		CHNS F 2 ChainswordCutting(invoker.ChainswordDamageSaw); 
		TNT1 A 0 chainswordshake(3, 3, 35, 0.6);
		CHNS G 2 A_QuakeEx(invoker.csQuakeStrength * 2, invoker.csQuakeStrength*2, invoker.csQuakeStrength * 2
		, 6, 0, 10, flags: QF_SCALEDOWN);
		CHNS H 1 RefireIfHasTarget("Sawing", range:80);
		Goto Followthrough;
	Followthroughmiss:
		TNT1 A 0 A_Startsound("weapons/swing_miss",CHAN_7, startTime: 0.3);
		TNT1 A 0;
		CHNS U 2 {
			A_QuakeEx(invoker.csQuakeStrength * 1.2,invoker.csQuakeStrength*1.2,invoker.csQuakeStrength * 1.2
			, 12, 0, 10, flags: QF_SCALEDOWN);
// 			RefireIfHasTarget("Sawing", range:80);
		}
		CHNS U 2;// RefireIfHasTarget("Sawing", range:80);
		CHNS V 2; 
		Goto Ready;
	Followthrough:
// 		Do an extra "cleaving" hit when you are dragging the sword away
		CHNS I 1 {
			ChainswordCutting(invoker.chainswordDamageStrike, range:80 + 20, isCleave: True);
			RefireIfHasTarget("Sawing", range:80); // Allow refire in some follow through frame because the timing is tough
			FaceChargeTarget(False, False, 0);
		}
		CHNS JL 1 {
			RefireIfHasTarget("Sawing", range:80); // Allow refire in some followthrough frame because the timing is touch
			FaceChargeTarget(False, False, 0);
		}
// 		TNT1 A 0 A_Stopsound(CHAN_7);
		CHNS N 2  {
			A_Quake(invoker.csQuakeStrength * 5, 6, 0, 10);
			A_Stopsound(CHAN_7);
			A_Startsound("weapons/swing_cut",CHAN_5, startTime: 0.3);
		}
		CHNS P 2;
		CHNS R 2 A_QuakeEx(invoker.csQuakeStrength * 2,invoker.csQuakeStrength*2,invoker.csQuakeStrength * 3
		, 12, 0, 10, "", flags: QF_SCALEDOWN|QF_RELATIVE);
		CHNS T 2 A_WeaponReady(WRF_ALLOWRELOAD);
		Goto Ready;
	Idle:
		CHNS A 1 {
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
	
// 	The original chainsword state, unused
	Chainsword:
		TNT1 A 0 {
// 			A_OverlayScale(0.7, 0.7, 0.7);
			A_WeaponOffset(-120, 32);
		}
		CHNS BCBBDEFGHJLNPRT 1;
		TNT1 A 0 A_Jump(256, "Ready");
		Goto Ready;
	Spawn:
		CSAW A -1;
		Stop;
	}
	action void A_WeaponReadyBob(int flags = 0){
		int period = 80;
		int breathspeed = 1;
		int range_x = 1;
		int range_y = 1.2;
		A_WeaponReady(flags);
// 		Reset iframe
		invoker.iFrame = 0;
		invoker.timer = (invoker.timer + breathspeed + frandom(0, 0.1 * breathspeed)) % period;
		float degree = float(invoker.timer)/float(period) * 360;
		A_WeaponOffset(range_x * (- cos(degree))* frandom(0.998,1.002) , 32 + range_y * sin(degree)* frandom(0.998,1.002) );
	}
	
// 	The wobbling animation when a chainsword is revving
	action void chainswordShake(int range_x= 10,int range_y=3, int period = 35, int randomrange = 0.1){
		int breathspeed = 1;
		invoker.timer = (invoker.timer + breathspeed + frandom(0, 0.1 * breathspeed)) % period;
		float degree = float(invoker.timer)/float(period) * 360;
		A_WeaponOffset(-120 + range_x * (- cos(degree))* frandom(1.0 - randomrange,1.0 + randomrange) 
		, 32 + range_y * sin(degree)* frandom(1.0 - randomrange, 1.0 + randomrange));
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
			if (! invoker.owner.distance2d(invoker.chargeTarget) < range * 2.0 /3.0)
			{
				Console.printf("Target far, performing initial boost");
				Thrust(sqrt(invoker.owner.distance2d(invoker.chargeTarget)/2), chargeAngle);
			}
			ThrustThingz(0,15,0,1);
			invoker.isCsCharging = True;
		}	
	}
	
// 	Turn the player to face the target during a chainsword charge
// 	Also act as extra charges
	action void FaceChargeTarget(bool thrust = True, bool trystop = False, float interpolation = 0){
		Console.Printf("turning to face charge target, original angle %f, interpolation rate %f", invoker.owner.angle,interpolation);
		float chargeAngle = 0;
		float targetpitch = 0;
// 		If target is close, stop there
		if(invoker.chargeTarget && invoker.owner.Distance2D(invoker.chargeTarget) < 60)
		{
			invoker.owner.vel = (0.1,0.1,0.1);
		}
		
// 		chargeAngle = invoker.owner.AngleTo (invoker.chargeTarget);
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
// 			invoker.owner.angle = chargeangle;
			invoker.owner.angle = float(chargeAngle - invoker.owner.angle) * float(1.0-interpolation) + invoker.owner.angle;
			invoker.owner.pitch = float(targetPitch - invoker.owner.pitch) * float(1.0-interpolation) + invoker.owner.pitch;
		}
		
// 		Perform extra charge if needed
		if(invoker.chargeTarget && invoker.isCsCharging && thrust)
		{
			Thrust(sqrt(invoker.owner.distance2d(invoker.chargeTarget)/3.5), chargeAngle);
		}
		Console.Printf("target angle %f, interpolated %f",chargeAngle,invoker.owner.angle);
		if (trystop)
			invoker.isCsCharging = False;
	}
	action void SetIframe()
	{
	
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
				else Console.printf("no target found");
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
	action void RefireIfHasTarget(statelabel flash, float range = 200, float spread_xy = 2, float spread_z = 2)
	{
// 		Console.Printf("doing refire if target");
		FTranslatedLineTarget t;
		double ang = invoker.owner.angle + spread_xy * (Random2[Saw]() / 255.);
		double slope = invoker.owner.AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);
		if (!t.linetarget)
		{
// 			Console.printf("no target");
			return;
		}
// 		Console.printf("have target");
		A_Refire(flash);
	}
	
	action void ResetFirstStrike()
	{
		invoker.chainswordFirstStrike = True;
	}
	
// 	A modifed A_saw
	action Bool ChainswordCutting(float damage, Sound fullsound = "weapons/chainsword_lowrev", Sound hitsound = "weapons/chainsword_cutting", 
	float range = 0,float spread_xy = 1, float spread_z = 0,
	Bool lifesteal = False, Bool doturn=True, Bool dopull=True
	, bool isCleave = False)
	{
		FTranslatedLineTarget t;
		if (player == null)
		{
			return False;
		}

		class<Actor> pufftype = 'BulletPuff';
		if (damage == 0)
		{
			damage = 2;
		}
		if (range == 0)
		{ 
			range = 77; // MBF21 SAWRANGE;
		}

		double ang = angle + spread_xy * (Random2[Saw]() / 255.);
// 		Give a kickback effect to the final cleave strike so the player can be safe from the follow up melee
		if(isCleave)
			invoker.kickback = 800;
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
// 			Special check for when it's called in a hit follow through, where the sawing sound should not be interrupted
// 			by miss sound because you did hit things, and have the sawing sound interrupted later by the follow through sound
			if(!isCleave)
				A_StartSound (fullsound, CHAN_7);
			invoker.kickback = invoker.originalKickBack;
			return False;
		}

		if (lifesteal && !t.linetarget.bDontDrain)
		{
// 			if (flags & SF_STEALARMOR)
// 			{
// 				if (armorbonustype == null)
// 				{
// 					armorbonustype = "ArmorBonus";
// 				}
// 				if (armorbonustype != null)
// 				{
// 					BasicArmorBonus armorbonus = BasicArmorBonus(Spawn(armorbonustype));
// 					armorbonus.SaveAmount = int(armorbonus.SaveAmount * actualdamage * lifesteal);
// 					armorbonus.MaxSaveAmount = lifestealmax <= 0 ? armorbonus.MaxSaveAmount : lifestealmax;
// 					armorbonus.bDropped = true;
// 					armorbonus.ClearCounters();

// 					if (!armorbonus.CallTryPickup (self))
// 					{
// 						armorbonus.Destroy ();
// 					}
// 				}
// 			}

// 			else
// 			{
// 				GiveBody (int(actualdamage * lifesteal), lifestealmax);
// 			}
		}

		A_StartSound (hitsound, CHAN_7, flags: CHANF_LOOPING, starttime:0.5);
// 		Add an impact sound for the first saw hit
// 		Also add an impact sound for cleaving strike
		if (invoker.chainswordFirstStrike || isCleave){
			A_StartSound("weapons/bolter_impact_flesh",CHAN_AUTO,starttime: 0.1);
// 			Stop the player if they hit something
			invoker.owner.speed = 0;
			invoker.chainswordFirstStrike = False;
		}
			
		// turn to face target
		if (doturn)
		{
			double anglediff = deltaangle(angle, t.angleFromSource);

			if (anglediff < 0.0)
			{
				if (anglediff < -4.5)
					angle = t.angleFromSource + 90.0 / 21;
				else
					angle -= 4.5;
			}
			else
			{
				if (anglediff > 4.5)
					angle = t.angleFromSource - 90.0 / 21;
				else
					angle += 4.5;
			}
		}
		if (dopull)
			bJustAttacked = true;
		invoker.kickback = invoker.originalKickBack;
		return False;
	}
	
// 	Check if the taunt will be directed to an enemy or not
	action void checkTaunt(){
		double zoffs = invoker.owner.height*0.5;
		A_AlertMonsters();
		if(invoker.owner.player) zoffs = invoker.owner.player.viewz - invoker.owner.pos.z;
		FLineTraceData lt;
		if(invoker.owner.LineTrace(invoker.owner.angle, 1000, invoker.owner.pitch, 
			offsetz:zoffs, data:lt)){
			if (lt.HitType == TRACE_HitActor){
				A_GiveInventory("isDirectedTaunt", 1);
			}
		}
		invoker.isTaunting = True;
		
	}
// 	Adjust overlay scale to keep the size of taunting hand consistent between weapons with different scale
	action void AdjustScale(){
		A_OverlayScale(1, invoker.targetScaleX/invoker.WeaponScaleX
		, invoker.targetScaleY/invoker.WeaponScaleY);
	}
	
	action void playDirectedTaunt(){
		A_TakeInventory("isDirectedTaunt",256);
		A_StartSound("sternguard/taunt_directed",CHAN_6); //, attenuation:ATTN_NONE
	}
	action void playUndirectedTaunt(){
		A_StartSound("sternguard/taunt_undirected",CHAN_6); //, attenuation:ATTN_NONE
	}
	
	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (passive && Iframe > 0) newdamage = 0;
	}
	override void Tick(void){
		if (owner && owner.health > 0 && Iframe > 0)
		{
			Iframe -= 1;
		}
		else Iframe = 0;
		
		super.Tick();
	}
	
	override void DoEffect(void){
		Super.DoEffect();
		if (tauntCoolDown > 0)
		{
			tauntCoolDown -= 1;
			return;
		}
		let buttons = owner.GetPlayerInput(Input_Buttons);
		let player = owner.player;
		usercmd cmd = player.cmd;
		let psp = owner.player.findpsprite(psp_weapon);
		if(!playerDied && SternGuard(player.mo).health > 0
		&& (owner.GetPlayerInput(Input_Buttons) & BT_USER1)
		&& !(owner.GetPlayerInput(Input_OldButtons) & BT_USER1)
		){
			Console.printf("taunting with cooldown, %d",tauntCoolDown);
			tauntCoolDown = TauntWaitTime;
			psp.SetState(ResolveState("TauntingCheck"));
		}
	}
	
// 	The action function that switch psprite state to death frames when player died, 
// 	Should be called at the start of deselect
	action void checkDeath(){
		let player = invoker.owner.player;
		let psp = invoker.owner.player.findpsprite(psp_weapon);
		if(!invoker.playerDied
		&& SternGuard(player.mo).health<=0){
			invoker.playerDied = true;
			psp.SetState(invoker.ResolveState("DeathFrames"));
			invoker.A_Stopsound(CHAN_5);
			invoker.A_Stopsound(CHAN_6);
			invoker.A_Stopsound(CHAN_7);
		}
	}
	
	
// 	Set the weapon overlay to the original offset and scale
	action void OverlayReAdjust(){
		A_OverlayScale(1, 1, 1);
		A_WeaponOffset(0,32);

	}
}

// A transparent puff that puff on actors to make firebullets work properly
class ClearPuff : Actor{
		Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+ALLOWPARTICLES
		+PUFFONACTORS
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Translucent";
		Alpha 0.5;
		VSpeed 1;
		Mass 5;
	}
	States
	{
	Spawn:
		TNT1 A 1;
	Melee:
		TNT1 A 1;
		Stop;
	}
}

class isDirectedTaunt: Inventory{
	Default{
		Inventory.Amount 0;
		Inventory.MaxAmount 1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}