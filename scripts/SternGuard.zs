Class SternGuard : Doomplayer replaces Doomplayer
{

// 	Player.Startitem "WhateverElseYouWantTostartWith"
	Default
	{
// 		Height 67; //firing offset will be 8 for this, 15 for normal height
// 		Height 80;
		Mass 400;
		Player.AttackZOffset 23;
		Player.Startitem "Bolter";
		Player.StartItem "Clip", 50;
		Player.StartItem "BolterMag", 18;
		Player.StartItem "ShellInTube", 8;
		Player.Startitem "Fist";
		Player.WeaponSlot 2, "Bolter";
		Player.WeaponSlot 3, "AstartesShotgun", "SuperShotgun", "MeltaGun";
		Player.WeaponSlot 4, "HeavyBolter";
		Player.WeaponSlot 5, "MissileLauncher";
		Player.WeaponSlot 6, "VolkiteCaliver";//,"PlasmaRifle";
		Player.SoundClass "sternguard";
		Damagefactor "ExplosionSelfDamage", 0.18;
		Player.ViewHeight 52;
// 		PainSound "sternguard/pain";
		
	}
}

class SternguardFootStepHandler : EventHandler
{
	const MAX_SPEED = 16.666666;
	const stoppingDelay = 60; //The min distance from last step when stopping for it to consider the need to take one more step to stop 
	private Array<double> wait;
	const STEP_SIZE = 150;
	const walkspeed = 10;
	const sprintspeed = 16;
	float lastx;
	float lasty;
	private Array<bool> wasMidAir; 
	private Array<bool> wasMoving; 
	
	override void worldTick()
	{
		double speed;
		PlayerPawn pl;
		float deltax;
		float deltay;
		
		for (int i = 0; i < players.size(); ++i)
		{
			if (players[i].mo)
			{
				pl = players[i].mo;
				
				if (players[i].onground)
				{
					deltax = pl.pos.x - lastx;
					deltay = pl.pos.y - lasty;
					speed = clamp(sqrt(deltax * deltax + deltay* deltay),
								0.0, MAX_SPEED);
					lastx = pl.pos.x;
					lasty = pl.pos.y;
// 					Console.printf("%d", speed);
					wait[i] -= (speed - walkspeed)/2.7 + walkspeed;
					
// 					To handle the case of landing sound after a jump
					if (wasMidAir[i]){
						playFootStepSound(pl);
						wasMidAir[i] = False;
					}
// 					Play moving footstep if speed is higher than 2
					if (speed > 2)
					{
						wasMoving[i] = True;
						if (wait[i] <= 0.0)
						{
							playFootStepSound(pl);
							wait[i] += STEP_SIZE + random(-10,10);
// 							wait[i] = 7.0 * clamp(MAX_SPEED / speed, 1.0, 1.5);
						}
						
						
					}
					else
					{
// 					create the "take one more step to slow down" effect
						if(wasMoving[i]){
							if (wait[i] < STEP_SIZE - stoppingDelay){
								playFootStepSound(pl);
							}
							wasMoving[i] = False;
						}
						wait[i] = STEP_SIZE + random(-10,10);
					}
				}
				else // to create the "shuffling down stairs" effect
				{
					wasMidAir[i] = True;
					wait[i] = 0;
				}
			}
		}
		super.worldTick();
	}
	void playFootStepSound(PlayerPawn pl){
		pl.A_StartSound("sternguard/steps_base_low", CHAN_BODY,CHANF_OVERLAP, 0.15,ATTN_NONE);
		pl.A_StartSound("sternguard/steps_base", CHAN_BODY,CHANF_OVERLAP, 0.15,ATTN_NONE);
	}
	
	override void playerEntered(PlayerEvent e)
	{
		wait.insert(e.playerNumber, STEP_SIZE);
		wasMidAir.insert(e.playerNumber, False);
		wasMoving.insert(e.playerNumber, False);
	}
	
	override void playerRespawned(PlayerEvent e)
	{
		wait[e.playerNumber] = 1.0;
		wasMidAir[e.playerNumber] = False;
		wasMoving.insert(e.playerNumber, False);
	}
	
	override void playerDisconnected(PlayerEvent e)
	{
	}
	
}