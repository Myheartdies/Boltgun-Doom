version "4.11"

#include "scripts/Decorations.zs"
#include "scripts/Items.zs"

#include "scripts/Monsters.zs"


#include "scripts/Alias.zs"
#include "scripts/ParryMe.zs"
#include "scripts/Weapons.zs"

#include "scripts/SternGuard.zs"

// #include "scripts/monsters/dokiplush.zs"
// #include "scripts/monsters/plush_elemental.zs"

// #include "scripts/groundSoul.zs"
#include "ZScript/laser_base.zsc"
 
 class PulseLaser : BEAMZ_LaserBeam
 {
	Default
	{
		BEAMZ_LaserBeam.LaserColor "Red";
	}
	
	override void BeamTick()
	{
		alpha = sin(GetAge() * 60) + 0.5;
		aimAtCrosshair();
	}
 }
 
 
 class TestBeam : Inventory
 {
	BEAMZ_LaserBeam beam;
	
	override void DoEffect()
	{
		uint btns = Owner.player.cmd.buttons;
		uint obtns = Owner.player.oldbuttons;
	
		// Create Laser
		if(!beam) 
		{
			beam = beam.Create(Owner, 5, 0, -2, 0, 2, type:"PulseLaser");
			beam.SetEnabled(true);
		}
		
		// Toggle laser
		if( btns & BT_RELOAD && !(obtns & BT_RELOAD) ) 
			beam.SetEnabled(!beam.enabled);
		
		// Update laser if tracking target
		if(beam.isTracking())
		{
			Actor aim = Owner.AimTarget();
			if(aim) beam.targetPos = (aim.pos.xy, aim.pos.z + aim.height * 0.5);
		}
		
		// Toggle tracking
		if( btns & BT_ALTATTACK && !(obtns & BT_ALTATTACK) )
			beam.trackingPos = !beam.trackingPos;
	}
 }
 




class NashMoveHandler : EventHandler
{
	override void PlayerEntered(PlayerEvent e)
	{
		players[e.PlayerNumber].mo.A_GiveInventory("Z_NashMove", 1);
	}
}

class Z_NashMove : CustomInventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.AUTOACTIVATE
	}

	// How much to reduce the slippery movement.
	// Lower number = less slippery.
	const DECEL_MULT = 0.8;
	const HEAVYBOLTER_SLOWDOWN1 = 0.6;
	const HEAVYBOLTER_SLOWDOWN2 = 0.22;

	//===========================================================================
	//
	//
	//
	//===========================================================================

	bool bIsOnFloor(void)
	{
		return (Owner.Pos.Z == Owner.FloorZ) || (Owner.bOnMObj);
	}

	bool bIsInPain(void)
	{
		State PainState = Owner.FindState('Pain');
		if (PainState != NULL && Owner.InStateSequence(Owner.CurState, PainState))
		{
			return true;
		}
		return false;
	}

	double GetVelocity (void)
	{
		return Owner.Vel.Length();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		if (Owner && Owner is "PlayerPawn")
		{
			let psp = owner.player.FindPSprite(PSP_WEAPON);
			if (bIsOnFloor())
			{
				// bump up the player's speed to compensate for the deceleration
				// TO DO: math here is shit and wrong, please fix
				double s = 1.27 + (1.0 - DECEL_MULT);
				Owner.A_SetSpeed(s * 2.0);

				// decelerate the player, if not in pain
				if (!bIsInPain())
				{
					Owner.vel.x *= DECEL_MULT;
					Owner.vel.y *= DECEL_MULT;
				}

				// make the view bobbing match the player's movement
				PlayerPawn(Owner).ViewBob = DECEL_MULT * 0.5;

// 				If player is shooting a heavybolter, slow down even more
				if (owner.player.readyweapon.GetClass() == "HeavyBolter" && 
				HeavyBolter(owner.player.readyweapon).Slowed)
				{
					if (HeavyBolter(owner.player.readyweapon).Slowed2){
						Owner.vel.x *= HEAVYBOLTER_SLOWDOWN2;
						Owner.vel.y *= HEAVYBOLTER_SLOWDOWN2;
						Console.printf("Slowing down2");
					}
					else
					{
						Owner.vel.x *= HEAVYBOLTER_SLOWDOWN1;
						Owner.vel.y *= HEAVYBOLTER_SLOWDOWN1;
						Console.printf("Slowing down1");
					}
// 					
				}
				else Console.printf("normal speed");
			}
		}

		Super.Tick();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================
	States
	{
	Use:
		TNT1 A 0;
		Fail;
	Pickup:
		TNT1 A 0
		{
			return true;
		}
		Stop;
	}
}
