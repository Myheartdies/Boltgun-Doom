class MeltaGun : SternguardWeapon Replaces SuperShotgun
{
	Default
	{
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Weapon.SelectionOrder 550;
		Weapon.AmmoUse 3;
		Weapon.AmmoGive 25;
		Weapon.AmmoType "MeltaAmmo";
		Inventory.Pickupmessage "Picked up the meltagun! (unfinished)"; //"Time to melt something";
		Obituary "$OB_MPSSHOTGUN";
		Tag "$TAG_MELTAGUN";
	}
	States
	{
	Ready:
		MELT A 3 {
			A_WeaponReadyBob();
			A_SetCrosshair(24);
		}
		Loop;
	NoChainSword:
		TNT1 A 1 OverlayReAdjust;
	NoChainSwordLoop:
		MELT A 3 {
			A_WeaponReadyBob_NoCS(WRF_ALLOWRELOAD);
			A_SetCrosshair(24);
		}
		MELT A 3 {
			A_WeaponReadyBob_NoCS(WRF_ALLOWRELOAD);
			A_Refire("NoChainSwordLoop");
		}	
		Goto Ready;
	Deselect:
		TNT1 A 0 checkDeath;
		MELT A 1 A_Lower(18);
		Loop;
	Select:
		MELT A 1 A_WeaponOffset(0,32);
		MELT A 1 A_Raise(18);
		Wait;
	Fire:
		TNT1 A 0 OverlayReadjust;
		MELT A 5{
			 A_Startsound("weapons/meltagun_chargeup", starttime: 0.1);
// 			proj.scale = (0.6,0.6);
		}
		
		MELT C 2 Bright {
			A_FireMelta();
			A_Quake(2,6,0,30);
			A_Light(2);
		}
		TNT1 A 0{
			A_ZoomFactor(0.990);
			A_SetPitch(pitch - 2.0);
		}
		MELT D 2 Bright {
			A_FireMelta(1.2, False);
			A_Light(2);
		}
		TNT1 A 0{
			A_ZoomFactor(0.995);
			A_SetPitch(pitch + 1.0);
		}
		MELT E 2 Bright {
			A_FireMelta(0.8,False);
			A_Light(2);
		}
		TNT1 A 0{
			A_ZoomFactor(0.998);
			A_SetPitch(pitch + 0.7);
		}
		
		MELT F 2 Bright {
			A_FireMelta(0.4,False);
			A_Light(2);
		}
		TNT1 A 0{
			A_ZoomFactor(1.0);
			A_SetPitch(pitch + 0.3);
		}
		MELT G 3;
		MELT H 3{
			A_CheckReload();
			MeltaReloadSound();
		}
		MELT I 4 ;
		MELT J 4;
		MELT K 4 ;
		MELT L 4 ;
		MELT M 4 ;
		MELT N 6;
		MELT A 4 A_ReFire;
		Goto Ready;
	// unused states
		SHT2 B 7;
		SHT2 A 3;
		Goto Deselect;
	Spawn:
		SMLT A -1;
		Stop;
	}



	action void A_FireMelta(float firescale = 1.8, bool is_main = True)
	{
		if (player == null)
		{
			return;
		}
		if (is_main)
			A_StartSound ("weapons/meltagun_fire", CHAN_WEAPON);
		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			if (is_main && !weap.DepleteAmmo (weap.bAltFire, true, 0))
				return;
			
		}
		player.mo.PlayAttacking2 ();

		double pitch = BulletSlope ();
		let proj = A_FireProjectile("MeltaFlame", useammo: False);
		if (proj)
		{
			proj.scale = (firescale, firescale);
		}
		for (int i = 0; i < 3; i++)
		{
			A_FireProjectile("MeltaProjectile",angle: frandom(-3.5,3.5), useammo: False);
		}
		for (int i = 0; i < 6;i++)
		{
			A_FireProjectile("MeltaProjectileInvisible",angle: frandom(-3.5,3.5), useammo: False);
		}
		return;
		
// 		Unused
		for (int i = 0 ; i < 20 ; i++)
		{
			int damage = 6 * random[FireSG2](1, 3);
			double ang = angle + Random2[FireSG2]() * (11.25 / 256);

			// Doom adjusts the bullet slope by shifting a random number [-255,255]
			// left 5 places. At 2048 units away, this means the vertical position
			// of the shot can deviate as much as 255 units from nominal. So using
			// some simple trigonometry, that means the vertical angle of the shot
			// can deviate by as many as ~7.097 degrees.

			LineAttack (ang, PLAYERMISSILERANGE, pitch + Random2[FireSG2]() * (7.097 / 256), damage, 'Hitscan', "BulletPuff");
		}
	}

	
	action void MeltaReloadSound() 
	{ 
		A_Startsound("weapons/meltagun_reload", CHAN_AUTO
		, volume:0.9, attenuation:ATTN_NONE, pitch:0.7, startTime:0.2);
// 		A_StartSound("weapons/meltagun_reload", CHAN_WEAPON);
	}

}
class MeltaProjectileInvisible: MeltaProjectile
{
	Default
	{
		MeltaProjectile.NoParticle True;
	}
}

class MeltaProjectile : FastProjectile
{
	int counter;
	Array<Actor> hitActors;
	bool no_particle;
	Property NoParticle: no_particle;
	Default
	{
		Radius 1;
		Height 1;
		Speed 32;
		Damagefunction 0;
		DamageType "Melta";
		scale 1.5;
		+ROLLSPRITE;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		+EXTREMEDEATH
// 		DamageFunction 30 * random(1,3);
// 		+NOCLIP
// 		RenderStyle "Add";
// 		Alpha 0.75;
// 		DeathSound "weapons/bfgx";
// 		Obituary "$OB_MPBFG_BOOM";
	}
	States
	{
	Spawn:
		TNT1 AAAA 1 Bright {
			if (!invoker.no_particle)
				FlameParticle();
		}
		TNT1 AAA 2 Bright {
			if (!invoker.no_particle)
				FlameParticle();
		}
// 		MFRA ABCDEF 1 Bright {
// 			invoker.counter += 1;
// 			A_SetRoll(roll + 40);
// 		}
// 		Loop;
	Death:
		TNT1 AAAA 2 Bright {
			if (!invoker.no_particle)
				FlameParticle();
		}
		Stop;
	}
	override int SpecialMissileHit (Actor victim)
	{
		if (victim != target && !victim.player )
		{
			if(hitActors.Find(victim) != hitActors.Size()) 
				return MHIT_PASS;
			victim.DamageMobj (self, target, 7 * random(1,3), 'Melta');
			victim.SpawnBlood(pos, 0, 3);
			hitActors.Push(victim);
			if (victim.bIsMonster)
			{
				for (int i = 0; i < 2; i++)
				{
					if (!no_particle)
					{
						victim.A_SpawnParticleEx("",TexMan.CheckForTexture("FLMPA0")
						,STYLE_Add,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELPOS , 60
						, 40, 0
		// 				,0,0,0
						,random(-8,8),random(-8,8), random(0,victim.height)
						,0,0,0,0,0,0.2
						, 1.0,-1,-1.5
						, Random(0,12)*30, Random(-3,3));
					}
				}
			}
			return MHIT_PASS;   
		}
		return MHIT_DEFAULT;
	}
	
	
	void FlameParticle(){
		Counter += 1;
		TextureID txtr;
		if (Counter % 2 == 0)
			txtr = TexMan.CheckForTexture("FLMPA0");
		else
			txtr = TexMan.CheckForTexture("FLMYA0");
// 		TextureID txtr = TexMan.CheckForTexture("FLMBA0");
		A_SpawnParticleEx("",txtr,STYLE_Add,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM|SPF_RELPOS , 8
		, 15, 0
// 		,0,0,0
		,random(-5,5),random(-5,5),random(-5,5)
		,0,0,0,0,0,0.1
		, 0.5,-1,-2
		, Random(0,12)*30, Random(-3,3));
	}
}

class MeltaFlame : Actor
{
	int counter;
	Array<Actor> hitActors;
	Default
	{
		Radius 1;
		Height 1;
		Speed 32;
		scale 1.5;
		+ROLLSPRITE;
		Projectile;
		+NOTELEPORT;
		+NOINTERACTION;
		+NOCLIP;
		+ZDOOMTRANS
// 		RenderStyle "Add";
// 		Alpha 0.75;
// 		DeathSound "weapons/bfgx";
// 		Obituary "$OB_MPBFG_BOOM";
	}
	States
	{
	Spawn:
// 		TNT1 A 0 A_SetRoll(roll + random(0,12)*30);
		MFRA ABCDEF 1 Bright {
// 			FlameParticle();
			invoker.counter += 1;
			A_SetRoll(roll + 40);
		}
// 		Loop;
// 	Death:
		MFRA GHIJ 2 Bright {
// 			A_FadeOut(0.25);
			A_SetRoll(roll + random(0,180));
		}
		Stop;
	}
	
}



class ShellBoxEx : CustomInventory Replaces Shellbox
{
	Default
	{
		Inventory.PickupMessage "Got some shells and some melta ammo";
// 		Inventory.Amount 4;
// 		Inventory.MaxAmount 50;
// 		Ammo.BackpackAmount 4;
// 		Ammo.BackpackMaxAmount 100;
		Inventory.Icon "SHELA0";
// 		Inventory.Amount 20;
	}
	States
	{
	Spawn:
		SBOX A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_GiveInventory("Shell", 20);
		TNT1 A 0 A_GiveInventory("MeltaAmmo", 6);
		Stop;
	}
}

class MeltaAmmo: Ammo
{
	Default{
		Inventory.Amount 20;
		Inventory.MaxAmount 80;
		Ammo.BackpackAmount 5;
		Ammo.BackpackMaxAmount 20;
	}
}