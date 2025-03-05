// Somehow binding the user1 key with an alias cause the input to repeat forever
// TODO: Change the parry key from btn_user1 to a custom keybind
class ParryMe : EventHandler {
	override void PlayerEntered(PlayerEvent e) {
		let pmo = players[e.playerNumber].mo;
		
		if (pmo && !pmo.CountInv("ParryMe_System")) {
			pmo.GiveInventory("ParryMe_System", 1);
		}
	}
	
	override void RenderOverlay(RenderEvent e) {
		let pmo = e.camera;
		
		if (pmo && pmo.CountInv("ParryMe_System")) {
			ParryMe_System parry = ParryMe_System(pmo.FindInventory("ParryMe_System"));
			
			if (parry && parry.parryComboTime) {
				int combo = parry.parryCombo;
				
				if (combo > 1) {
					string header = "Combo!";
					if (parry.reparry){
						header = "Chain Parry Combo!";
					}
// 					string header = "Combo!";
					string comboText = "x"..combo;
					
					Screen.DrawText(smallFont, Font.CR_White, 160 - (smallFont.StringWidth(header) * 0.5), 110, header, DTA_320x200, true);
					Screen.DrawText(bigFont, Font.CR_Red, 160 - (bigFont.StringWidth(comboText) * 0.5), 118, comboText, DTA_320x200, true);
				}
			}
		}
	}
}
class ParryMe_Stack: Inventory{
	Default {
		Inventory.MaxAmount 20;
		+Inventory.Undroppable
		+Inventory.Untossable
	}
}
class ParryMe_System : Inventory {
	int parryTime, parryFreezeTime, parryCombo, parryComboTime, noParryTime, buttons;
	bool reparry;
	override void BeginPlay(){
		reparry = False;
		super.BeginPlay();
	}
	
	Default {
		Inventory.MaxAmount 1;
		
		+Inventory.Undroppable
		+Inventory.Untossable
		+Inventory.AutoActivate
	}
	
	States {
		Use:
			TNT1 A 0;
			Fail;
		
		Pickup:
			TNT1 A 0 {
				return true;
			}
			
			Stop;
	}
	
	override void Tick() {
		if (!owner) {
			DepleteOrDestroy();
			
			return;
		}
		
		buttons = owner.GetPlayerInput(Input_Buttons);
// 		if(buttons){
// 			A_LogInt(buttons);
// 		}

// 		A_LogInt(parryTime);
		if (noParryTime) {
			--noParryTime;
		} else {
			if ((parryTime <= 0||reparry)
				&& (buttons & BT_USER1)
// 				&& !(owner.GetPlayerInput(Input_OldButtons) & BT_USER1 /*BT_Forward*/)
				) {
				if (parryTime>0) A_log("Reparried");
// 				A_Log("Parry");
				owner.A_StartSound("ParryMe/ready", Chan_6, ChanF_UI | ChanF_Overlap | ChanF_Local);
				parryTime = sv_parryMe_time + sv_parryMe_cooldown;
// 				owner.A_StartSound("ParryMe/combo3");
				reparry = False;
			}
		}
		
		if (parryFreezeTime) {
			--parryFreezeTime;
			
			if (parryFreezeTime <= 0) {
				level.SetFrozen(false);
			}
		} else {
			if (parryTime) {
				--parryTime;
			}
			
			if (parryComboTime) {
				--parryComboTime;
				
				if (parryComboTime <= 0) {
					parryCombo = 0;
				}
			}
		}
		
		super.Tick();
	}
	
	override void ModifyDamage(int damage, Name damageType, out int newDamage,
							   bool passive, Actor inflictor, Actor source,
							   int flags) {
		if (!passive || noParryTime) {
			return;
		}
// 		reparry = False;
		if (parryTime > sv_parryMe_cooldown && owner && inflictor) {
			reparry = True;
			if (inflictor != owner && source != owner) {
				newDamage = 0;
				++parryCombo;
				parryComboTime = 100;
				
				Vector3 oPos = owner.pos + (0, 0, owner.height * 0.7);
				Vector3 iPos = inflictor.pos + (0, 0, inflictor.height * 0.5);
				
				owner.Spawn("ParryMe_Effect", oPos + (0.5 * (iPos - oPos)));
				owner.A_Quake(1, 5, 0, owner.radius, "");
				
				if (!multiplayer) {
					parryFreezeTime = 4;
					level.SetFrozen(true);
				}
				
				if (parryCombo > 1) {
					Sound snd;
					
					if (parryCombo >= 10) {
						snd = "ParryMe/combo4";
					} else {
						if (parryCombo >= 7) {
							snd = "ParryMe/combo3";
						} else {
							if (parryCombo >= 4) {
								snd = "ParryMe/combo2";
							} else {
								snd = "ParryMe/combo1";
							}
						}
					}
					
					owner.A_StartSound(snd, Chan_7, ChanF_UI | ChanF_NoPause | ChanF_Overlap | ChanF_Local);
				}
				
				if (sv_parryMe_pain && source
					&& source.target == owner && source.CheckMeleeRange()
					&& (source.InStateSequence(source.curState, source.ResolveState("Melee")) || source.InStateSequence(source.curState, source.ResolveState("FastMelee")))
					&& source.FindState("Pain")) {
					source.SetStateLabel("Pain");
					

					double angle = 0;
					if(source){
						angle = owner.AngleTo (source);
						angle = (angle +random(-10,10))%360;
					}
					source.Thrust(10, angle);
// 					RadiusAttack (owner, 1800, 700, "none", RADF_NODAMAGE, 300);
					inflictor.A_GiveInventory("ParryMe_Stack", parryCombo);
// 					ParryMe_Stack
					owner.A_RadiusThrust(inflictor.mass *3 + 1000, 1000, RTF_NOTMISSILE|RTF_NOIMPACTDAMAGE, 500);

				}
			}
			
			return;
		}
		
// 		noParryTime = sv_parryMe_failTime;
	}
}

class ParryMe_Effect : Actor {
	Default {
		Scale 0.625;
		SeeSound "ParryMe/parry";
		RenderStyle "Add";
		
		+ForceXYBillboard
		+NotOnAutomap
		+NoInteraction
		+ZDoomTrans
	}
	
	States {
		Spawn:
			PMFX ABCDEFGHI 2 Bright;
			Stop;
	}
	
	override void PostBeginPlay() {
		super.PostBeginPlay();
		
		A_StartSound(seeSound);
	}
}