// handle the taunting, chainsword, and grenade
class SternguardWeapon : DoomWeapon
{
	int addedoffset_x;
	int addedoffset_y;
	float targetScaleX;
	float targetScaleY;
	float tauntOffsetX;
	float tauntOffsetY;
	float chargeRange;
	float chainswordQuakeStrength;
	Property TargetScaleX : targetScaleX;
	Property TargetScaleY : targetScaleY;
	Property TauntOffsetX : tauntOffsetX;
	Property TauntOffsetY : tauntOffsetY;
	Property ChargeRange : chargeRange;
	Property ChainswordQuakeStrength : chainswordQuakeStrength;
	bool PlayerDied;
	int timer;
	float default_weaponscale_x;
	float default_weaponscale_y;
	Actor chargeTarget;
	override void BeginPlay()
	{
		default_weaponscale_x = WeaponScaleX;
		default_weaponscale_y = WeaponScaley;
		super.BeginPlay();
	}
	Default
	{
		SternguardWeapon.TargetScaleX 0.8;
		SternguardWeapon.TargetScaleY 0.8;
		SternguardWeapon.TauntOffsetX 120;
		SternguardWeapon.TauntOffsetY 10;
		SternguardWeapon.ChargeRange 500;
		SternguardWeapon.ChainswordQuakeStrength 1.0;
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
// 		TNT1 A 0 A_ZoomFactor(0.994);
		TNT1 A 0 A_StartSound("sternguard/taunt_directed_foley2",CHAN_AUTO,volume:0.3);
		TUNA ABC 3 A_SetPitch(pitch + 0.08);
// 		TNT1 A 0 A_ZoomFactor(1);
		TUNA DE 4 A_SetPitch(pitch - 0.12);
// 		TUNA E 4;
		TUNA FGHIJ 4;
		TNT1 A 0 A_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD);
		TNT1 A 0 A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
		TUNA JKK 2{
			A_WeaponOffset(4,40,WOF_ADD);
// 			A_WeaponReady();
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
		
		
	AltFire:
		TNT1 A 0 {
// 			A_OverlayScale(0.7, 0.7, 0.7);
			A_WeaponOffset(-120, 32);
		}
		CHNS A 1
		{ 
			A_Startsound("weapons/chainsword_Idle",CHAN_7,CHANF_LOOP);
			A_Refire("Idle");
			A_Quake(invoker.chainswordQuakeStrength, 4, 0, 5);
		}
		TNT1 A 0 {
			A_StopSound(CHAN_7);
			A_Startsound("weapons/chainsword_Strike",CHAN_5,flags: CHANF_OVERLAP);
			ChargeIfHaveTarget(range: invoker.ChargeRange);
		}
		CHNS BCD 2 {
			FaceChargetarget();
// 			A_Refire("Sawing");
		}
		CHNS D 1 {
			FaceChargetarget();
// 			A_Refire("Sawing");
		}
		CHNS EF 3 {
			FaceChargetarget();
			ChainswordCutting(30, range:80);
			RefireIfHasTarget("Sawing", range:80);
		}
		Goto Followthroughmiss;
	Sawing:
		CHNS F 2 ChainswordCutting(12); 
		CHNS G 2; 
		CHNS H 1 RefireIfHasTarget("Sawing", range:80);
		Goto Followthrough;
	Followthroughmiss:
		TNT1 A 0 A_Startsound("weapons/swing_miss",CHAN_7, startTime: 0.3);
		CHNS U 4;
		CHNS V 3; 
		Goto Ready;
	Followthrough:
		CHNS JL 1 RefireIfHasTarget("Sawing", range:80); // Allow refire in some followthrough frame because the timing is touch
		TNT1 A 0 A_Startsound("weapons/swing_cut",CHAN_7, startTime: 0.3);
		CHNS NPR 2;
		CHNS T 2 A_WeaponReady(WRF_ALLOWRELOAD);
		Goto Ready;
	Idle:
		CHNS A 1 {
			A_Startsound("weapons/chainsword_Idle",CHAN_7,CHANF_LOOPING);
			A_Quake(invoker.chainswordQuakeStrength, 2, 0, 5);
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
		invoker.timer = (invoker.timer + breathspeed + frandom(0, 0.1 * breathspeed)) % period;
		float degree = float(invoker.timer)/float(period) * 360;
		A_WeaponOffset(range_x * (- cos(degree))* frandom(0.998,1.002) , 32 + range_y * sin(degree)* frandom(0.998,1.002) );
		
		
	}
	
	action void ChargeIfHaveTarget(float range = 300)
	{
		invoker.chargeTarget = invoker.getChargeTarget(range);
		if (invoker.chargeTarget)
		{
			Console.printf("Charging");
			Thrust( (invoker.owner.distance2d(invoker.chargeTarget)/ 50 )**2 );
			Console.printf("%d",angle);
			ThrustThingz(0,10,0,1);
		}	
		else Console.printf("No target");
	}
	action void FaceChargetarget(){
		if(invoker.chargeTarget)
			invoker.owner.angle = invoker.owner.angleto(invoker.chargeTarget);
	}
	
	action Actor getChargeTarget(float range, float spread_xy = 2, float spread_z = 2){
		Console.Printf("Checking have target");
		FTranslatedLineTarget t;
		double ang = invoker.owner.angle + spread_xy * (Random2[Saw]() / 255.);
		double slope = invoker.owner.AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);
		if (!t.linetarget)
		{
			Console.printf("no target");
			return null;
		}
		Console.printf("have target");
		return t.linetarget;
	}
	action void RefireIfHasTarget(statelabel flash, float range = 200, float spread_xy = 2, float spread_z = 2)
	{
		Console.Printf("doing refire if target");
		FTranslatedLineTarget t;
		double ang = invoker.owner.angle + spread_xy * (Random2[Saw]() / 255.);
		double slope = invoker.owner.AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);
		if (!t.linetarget)
		{
			Console.printf("no target");
			return;
		}
		Console.printf("have target");
		A_Refire(flash);
	}
// 	A modifed A_saw
	action Bool ChainswordCutting(float damage, Sound fullsound = "weapons/chainsword_lowrev", Sound hitsound = "weapons/chainsword_cutting", 
	float range = 0,float spread_xy = 1, float spread_z = 0,
	Bool lifesteal = False, Bool doturn=True, Bool dopull=True)
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
		double slope = AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);

		Weapon weap = player.ReadyWeapon;

		int puffFlags = SF_NORANDOMPUFFZ;

		Actor puff;
		int actualdamage;
		[puff, actualdamage] = LineAttack (ang, range, slope, damage, 'ChainSword', pufftype, puffFlags, t);

		if (!t.linetarget)
		{
			A_StartSound (fullsound, CHAN_7);
			return True;
		}

// 		if (lifesteal && !t.linetarget.bDontDrain)
// 		{
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
// 		}

		A_StartSound (hitsound, CHAN_7, flags: CHANF_LOOPING, starttime:0.2);
			
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
		return False;
	}
	
// 	Check if the taunt will be directed to an enemy or not
	action void checkTaunt(){
		double zoffs = invoker.owner.height*0.5;
		if(invoker.owner.player) zoffs = invoker.owner.player.viewz - invoker.owner.pos.z;
		FLineTraceData lt;
		if(invoker.owner.LineTrace(invoker.owner.angle, 1000, invoker.owner.pitch, 
			offsetz:zoffs, data:lt)){
			if (lt.HitType == TRACE_HitActor){
				A_GiveInventory("isDirectedTaunt", 1);
			}
		}
		
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
	
	
	override void Tick(void){
		super.Tick();
	}
	
	override void DoEffect(void){
		Super.DoEffect();
		let buttons = owner.GetPlayerInput(Input_Buttons);
		let player = owner.player;
		let psp = owner.player.findpsprite(psp_weapon);
		if(!playerDied && SternGuard(player.mo).health > 0 
		&& (owner.GetPlayerInput(Input_Buttons) & BT_USER2)
		&& !(owner.GetPlayerInput(Input_OldButtons) & BT_USER2)){
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