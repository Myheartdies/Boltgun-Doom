class VolkiteCaliver : DoomWeapon Replaces PlasmaRifle
{
	BEAMZ_LaserBeam beam;
	bool isFiring;
	int recoilOffsetx;
	int recoilOffsety;
	PointLightFlickerRandom selfLight;
	Default
	{
		Weapon.SelectionOrder 100;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTPLASMA";
		Tag "$TAG_PLASMARIFLE";
		+WEAPON.NOAUTOAIM
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6;	
		Weapon.BobSpeed 2;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 1.1;
		
	}
	States
	{
	Ready:
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		VKT1 A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		TNT1 A 0 BeamForceStop;
		TNT1 A 0 {
			TurnUpBrightness(); 
			A_ZoomFactor(1.0);
			A_OverlayScale(1, 1.0,1.0);
		}
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		VKT1 A 1 A_Lower(18);
		Loop;
	Select:
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		VKT1 A 1 A_Raise(18);
		Loop;
	Reload:	
		TNT1 A 0 A_Startsound("weapons/volkite_reload",CHAN_AUTO,attenuation:ATTN_NONE);
		VKT2 ABCDEFGFHIJKLNNOP 3;
		Goto Ready;
	Fire:
// 		VKT1 JKL 2;
		TNT1 A 0 A_Startsound("weapons/volkite_charging",CHAN_WEAPON,CHANF_OVERLAP,attenuation:ATTN_NONE,startTime:0.75);
		VKT1 LM 1 Bright;
		VKT1 N 2 Bright;
		TNT1 A 0 {
			A_ZoomFactor(1.02); 
			A_OverlayScale(1, 1.02,1.02);
			A_Quake(1, 3, 0, 50, "");
		}
		TNT1 A 0 A_Startsound("weapons/volkite_startfiring",CHAN_AUTO,attenuation:ATTN_NONE);
		TNT1 A 0 TurnDownBrightness;
		TNT1 A 0 ;
	Firing:
		VKT1 I 1 Bright {
			FireVolkite();
			A_ZoomFactor(1.036);
			A_OverlayScale(1, 1.0585, 1.0585);
		}
		
		VKT1 I 2 Bright{ 
			A_ZoomFactor(1.04);
			A_OverlayScale(1, 1.06, 1.06);
			
		}
		TNT1 A 0 A_Quake(0.2, 4, 0, 50, "");
// 		VKT1 JK 3 FireVolkite;
		VKT2 A 0 {A_ReFire("Firing");}
		VKT2 A 4 {
			A_ReFire();
			A_StopSound(CHAN_WEAPON);
			A_Startsound("weapons/volkite_cooling",CHAN_AUTO,attenuation:ATTN_NONE);
			BeamExit();
			A_ZoomFactor(1.0);
			TurnUpBrightness();
			A_OverlayScale(1, 1.0,1.0);
			}
// 		VKT2 F 20 {A_ReFire();A_StopSound(CHAN_WEAPON);}
		Goto Ready;
	Flash:
// 		PLSF A 4 Bright A_Light1;
// 		Goto LightDone;
// 		PLSF B 4 Bright A_Light1;
		Goto LightDone;
	Spawn:
		PLAS A -1;
		Stop;
	}

	action void TurnDownBrightness(){
		ACS_NamedExecute("DarkenScreen", 0, 0, 0, 0);
	}
	action void TurnUpBrightness(){
		ACS_NamedExecute("BrightenScreen", 0, 0, 0, 0);
	}
	action void FireVolkite()
	{
// 		invoker.hitZoomFactor = 1.04;
		if (player == null)
		{
			return;
		}
		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			if (!weap.DepleteAmmo (weap.bAltFire, true, 1))
				return;
			
			State flash = weap.FindState('Flash');
			if (flash != null)
			{
				player.SetSafeFlash(weap, flash, random[FirePlasma](0, 1));
			}
		}
		A_Startsound("weapons/volkite_fire",CHAN_WEAPON,CHANF_LOOPING,0.5,ATTN_NONE);
		if (!invoker.beam)
			invoker.beam = BEAMZ_LaserBeam.Create(invoker.owner,20,8,-4,type:"VolkiteBeam");
			VolkiteBeam(invoker.beam).parent = invoker;
		if (!invoker.selfLight)
			invoker.selfLight = PointLightFlickerRandom(spawn("PointLightFlickerRandom",invoker.owner.pos));
		VolkiteBeam(invoker.beam).BeamStart();//setEnabled(True);
		
// 		VolkiteBeam(invoker.beam).adjustedAimAtCrosshair();
		
		LineAttack(invoker.owner.angle, 8192, invoker.owner.pitch, 5 *random(1,8),"Hitscan","VolkitePuff");
		invoker.isFiring = True;
// 		A_FireBullets(0,0,0,13);
// 		SpawnPlayerMissile ("VolkiteBall");
	}
	
	action void BeamExit(){
		VolkiteBeam(invoker.beam).BeamEnd();//setEnabled(False); 
		invoker.isFiring = False;
	}
	// 	immediately turn off the beam
	action void BeamForceStop(){
		if (invoker.beam)
			invoker.beam.setEnabled(False);
		invoker.isFiring = False;
	}
}

class VolkiteBeam: BEAMZ_LaserBeam{
// 	SoundPlayer impactsound;
	float sizeMultiplier;
	int wait;
	int counter;
	float minScale;
	float maxScale;
	int pulseInterval;
	bool beamEnding;
	VolkiteCaliver parent;
	float hitZoomFactor;
	Property MinSize : minScale;
	Property MaxSize : maxScale;
	Property PulseInterval : pulseInterval;
	Default{
		Scale 2.4;
		BEAMZ_LaserBeam.LaserColor "e27a34";
		BEAMZ_LaserBeam.ContinuousImpact true; 
		VolkiteBeam.MinSize 2.6;
		VolkiteBeam.MaxSize 3.2;
		VolkiteBeam.PulseInterval 18;
// 		Alpha 0.5;
	}
	void BeamStart(){
		Scale.x = 2.4;
		beamEnding = False;
		setEnabled(True);
	}
	void BeamEnd(){
// 		Signal the beam to start disappearing
		beamEnding = True;
	}
	
	void adjustedAimAtCrosshair()
	{
		double zoffs = source.height*0.5;
		if(source.player) zoffs = source.player.viewz - source.pos.z -15;
// 		if(source.player) zoffs = source.player.AttackZOffset;
	
		FLineTraceData lt;
		source.LineTrace(source.angle, maxDist, source.pitch, offsetz:zoffs, offsetforward:source.radius, data:lt);
		if(lt.HitType != TRACE_HitNone) 
		{
			vector3 aimAngles = level.SphericalCoords(curPos, lt.HitLocation, (source.angle,source.pitch));
			angleOffsets.x = aimAngles.x;
			angleOffsets.y = aimAngles.y;
		}
	}
	
	override void BeamTick(){
// 		sizeIndex = (sizeIndex +1 )%
// 		parent.hitZoomFactor = 1.04;
// 		Two tick of bright yellow
		trackPSprite = False;
		aimAtCrossHair();
		if (counter % 6 < 3)
			shade = "e29834";
// 		one tick of red hue
		if (counter % 6 == 3)
			shade = "e25c34";
// 		three ticks of orange
		else
			shade = "e27a34";
		float shrinkMultiplier = 0.6;
// 		if beam is turning off, make the beam smaller and smaller until it reaches a threshold and disappear
		if (beamEnding){
			Scale.x = Clamp(Scale.x*shrinkMultiplier, 0.1, 3);
			if (Scale.x <= 0.1){
				beamEnding = False;
				setEnabled(False);
			}
		}
		else{
			if (counter> 2 * pulseInterval) 
				counter = 0;
			Scale.x = minScale + (pulseInterval - abs(pulseInterval - counter)) *(maxScale-minScale)/pulseInterval;
			counter+= random(-1,4);
			Alpha = frandom(0.8,1.0);
		}
		
	}
	override void OnImpact(vector3 hitPos, Actor hitActor)
	{
		FSpawnParticleParams params;
		params.color1 = "fac64d";
		params.pos = hitPos;
		params.flags = SPF_FULLBRIGHT;
		params.size = 10;
		params.lifetime = 15;
		params.sizestep = -0.3;
		params.startalpha = 1;
		params.fadestep = -0.01;

		if (hitActor){
			double angle = source.AngleTo(hitActor);
			hitActor.Thrust(0.1, angle);
		}
// 		TODO: change the particles to a puff instead
		if(!beamEnding){
			for(let i = 0; i< 8;i++){
				params.vel = (frandom(-1,1), frandom(-1,1), frandom(-0.5,2));
				params.accel = (0, 0, -0.1);
				level.spawnparticle(params);
			}
		}
		wait -= 1;

	}

}
// class SelfLight :Actor{
	
// }
class VolkitePuff: Actor{
	Default
	{
		Scale 0.8;
		+NOBLOCKMAP
		+NOGRAVITY
		+ALLOWPARTICLES
		+RANDOMIZE
		+ZDOOMTRANS
		+EXTREMEDEATH
		RenderStyle "Translucent";
		Alpha 0.8;
		Mass 5;
	}
	States
	{
	Spawn:
		TNT1 A 2;
// 		Loop;
	Death:
		PLSE B 2 Bright A_Startsound("weapons/plasmax",CHAN_5);
		PLSE CDE 1 Bright;
		Stop;
	}
}

class VolkiteBall : FastProjectile
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 200;
		Damage 5;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
// 		SeeSound "weapons/plasmaf";
		DeathSound "weapons/plasmax";
		Obituary "$OB_MPPLASMARIFLE";
		+EXTREMEDEATH
	}
	States
	{
	Spawn:
		TNT1 A 6;
		Loop;
	Death:
		PLSE ABCDE 4 Bright;
		Stop;
	}
}