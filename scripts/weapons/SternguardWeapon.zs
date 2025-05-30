// handle the taunting, chainsword, and grenade
class SternguardWeapon : DoomWeapon
{
	int addedoffset_x;
	int addedoffset_y;
	float targetScaleX;
	float targetScaleY;
	float tauntOffsetX;
	float tauntOffsetY;
	Property TargetScaleX : targetScaleX;
	Property TargetScaleY : targetScaleY;
	Property TauntOffsetX : tauntOffsetX;
	Property TauntOffsetY : tauntOffsetY;
	Default
	{
		SternguardWeapon.TargetScaleX 0.8;
		SternguardWeapon.TargetScaleY 0.8;
		SternguardWeapon.TauntOffsetX 120;
		SternguardWeapon.TauntOffsetY 10;
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
		TUNA ABC 3 A_SetPitch(pitch + 0.08);
// 		TNT1 A 0 A_ZoomFactor(1);
		TUNA DE 4 A_SetPitch(pitch - 0.12);
// 		TUNA E 4;
		TUNA FGHIJ 4;
		TNT1 A 0 A_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD);
		TNT1 A 0 A_WeaponOffset(-invoker.tauntOffsetX, invoker.tauntOffsetY);
		TUNA JJJ 2{
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
		TNT1 A 0 A_StartSound("sternguard/taunt_directed_foley2",CHAN_AUTO,volume:0.4);
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
		TUNB JJJ 2{
			A_WeaponOffset(4,40,WOF_ADD);
			}
		TNT1 A 0 {
			A_OverlayScale(1, 1, 1);
			A_WeaponOffset(0, 32);
		}
		TNT1 A 0 {A_Jump(256, "Ready"); }
		Goto Ready;
	AltFire:
	ChainswordReverse:
		TNT1 A 0 {
// 			A_OverlayScale(0.7, 0.7, 0.7);
			A_WeaponOffset(-120, 32);
		}
// 		CHNS TRPNLJ 1;
// 		CHNS HGFEB 3;
		CHNS TPKHEB 2;
// 		TNT1 A 0 A_OverlayScale(1, 1, 1);
		TNT1 A 0 A_Jump(256, "Ready");
		Goto Ready;
	
	Chainsword:
		TNT1 A 0 {
// 			A_OverlayScale(0.7, 0.7, 0.7);
			A_WeaponOffset(-120, 32);
		}
		CHNS BCBBDEFGHJLNPRT 1;
// 		TNT1 A 0 A_OverlayScale(1, 1, 1);
		TNT1 A 0 A_Jump(256, "Ready");
		Goto Ready;
	Spawn:
		CSAW A -1;
		Stop;
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
// 		A_OverlayPivot(1, 0.5,0.5);
	}
	action void playDirectedTaunt(){
		A_TakeInventory("isDirectedTaunt",256);
		A_StartSound("sternguard/taunt_directed",CHAN_6); //, attenuation:ATTN_NONE
	}
	
	action void playUndirectedTaunt(){
		A_StartSound("sternguard/taunt_undirected",CHAN_6); //, attenuation:ATTN_NONE
	}
	action void blockActions(){
		
	}
	override void Tick(void){
// 		Go to taunt if start taunting is on
		super.Tick();
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