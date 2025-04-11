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
	
	TauntingDirected:
	
	AltFire:
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
		TUNA ABCDEFGHIJ 4;
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
		TUNB AABCDDDDDEFGH 3;
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
	
	Chainsword:
		TNT1 A 0 A_OverlayScale(1, 1, 1);
		CHNS ABCDEFGHJLNPRT 1;
		TNT1 A 0 A_OverlayScale(1, 1, 1);
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
class isDirectedTaunt: Inventory{
	Default{
		Inventory.Amount 0;
		Inventory.MaxAmount 1;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}