class AstartesShotgun : ShellEjectingWeapon Replaces Shotgun
{
	int reloadInput;
	override void BeginPlay(){
		queueLength = 10;
		
		reloadInput = 0;
		super.BeginPlay();
	}
	Default
	{
		Weapon.SelectionOrder 1300;
		Weapon.AmmoUse 1;
		Weapon.KickBack 200;
		Inventory.PickupMessage "$GOTSHOTGUN";
		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
		Weapon.AmmoType1 "ShellInTube";
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoGive1 5;
		Weapon.AmmoGive2 10;
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		
		ShellEjectingWeapon.MaxCasingCount 2;
		ShellEjectingWeapon.CasingDropSound "weapon/scout_shotgun_casing";
		ShellEjectingWeapon.DropSoundVolume 1.0;
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_AST_SHOTGUN";
	}
	States
	{
	Ready:
		STGN A 4 {
			A_WeaponReady(WRF_ALLOWRELOAD);
			A_SetCrosshair(22);
		}
		Loop;
	Deselect:
// 		STGN A 1 Offset(0, 34);
// 		STGN A 1 Offset(0, 60);
// 		STGN A 1 Offset(0, 80);
		STGN A 1 {
			A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			A_Lower(18);
			CasingLayerExit();
		}
		Loop;
	Select:
		TNT1 A 0 A_StartSound("weapons/scout_shotgun_select", starttime:0.2);
		STGN A 1 A_WeaponOffset(0,32);
		STGN A 1 {
			A_WeaponReady(WRF_NOBOB);
			A_Raise(18);
			A_ClearOverlays(-1-invoker.maxCasingCount, -2);
			CasingLayerReady();
		}
		Wait;
	Fire:
		TNT1 A 0 OverlayReadjust;
// 		Go to reload if out of ammo
		TNT1 A 0 A_JumpIfInventory("ShellInTube", 1, 1);
		Goto Reload;
		
		TNT1 A 0 A_ZoomFactor(0.99);
		TNT1 A 0 A_SetPitch(pitch - 1.15);
		TNT1 A 0 A_OverlayScale(1, 1.15,1.15);
		TNT1 A 0 OverlayRecoil(13,25);
		// TNT1 A 0 A_WeaponOffset(13, 25, WOF_ADD);
		STGN B 1 ; //Recoil should dampen entirely after first firing frame
		TNT1 A 0 A_ZoomFactor(0.993);
		TNT1 A 0 A_OverlayScale(1, 1.14,1.14);
		TNT1 A 0 OverlayRecoil(13, 20);
		
		STGN B 1 ;
		TNT1 A 0 A_SetPitch(pitch + 0.35);
		TNT1 A 0 A_ZoomFactor(0.995);
		TNT1 A 0 A_OverlayScale(1, 1.12,1.12);
		TNT1 A 0 OverlayRecoil(0, 15);
		TNT1 A 0 A_Quake(1,5,0,20);
		STGN C 1 Bright FireScoutShotgun; 
		TNT1 A 0 OverlayRecoil(-12, -23);
		
		TNT1 A 0 A_ZoomFactor(0.997);
		TNT1 A 0 A_SetPitch(pitch + 0.4);
		TNT1 A 0 A_OverlayScale(1, 1.1, 1.1);
		STGN C 1 Bright ;
		TNT1 A 0 OverlayRecoil(-8, -22);
		TNT1 A 0 A_ZoomFactor(1.00);
		TNT1 A 0 A_SetPitch(pitch + 0.3);
		TNT1 A 0 A_OverlayScale(1, 1.05, 1.05);
		STGN C 1 Bright A_SetPitch(pitch + 0.1);
		STGN D 1;
		TNT1 A 0 OverlayRecoil(-6, -15);
		TNT1 A 0 A_OverlayScale(1, 1, 1);
		STGN D 1 Bright;
		STGN EE 1 Bright;
		STGN E 1;
	Pump:
		STGN F 2 {
			A_StartSound("weapons/scout_shotgun_pump");
		}
		STGN G 3{
			EjectCasing("ShotgunCasing",2.3,-12,-10);
			AddToSoundQueue(28);
		}
		STGN H 3;
		STGN I 3{
			
			A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
		}
		STGN J 2  A_WeaponReady(WRF_ALLOWRELOAD|WRF_NOFIRE);
		STGN K 2 {
			
			A_WeaponReady(WRF_ALLOWRELOAD);
		}
// 		STGN K 1 A_WeaponReady(WRF_ALLOWRELOAD);
		STGN L 2 A_WeaponReady(WRF_ALLOWRELOAD);
		TNT1 A 0 A_ReFire("Fire");
		Goto Ready;
	ShotgunCasing:
		TNT1 A 0 A_jump(80, "Casing1");
		TNT1 A 0 A_jump(120,"Casing2");
		TNT1 A 0 A_jump(255, "Casing3");
	Casing1:
		CSNS AB 2 Bright;
		CSNS CDEFGHIJKLMNOPAB 2;
		Goto LightDone;
	Casing2:
		CSNS NO 2 Bright;
		CSNS PABCDEGHIJKLMNOP 2;
		Goto LightDone;
	Casing3:
		CSNS FG 2 Bright;
		CSNS HIJKLMNOPABCDEFG 2;
		Goto LightDone;
		
	Reload:
	TNT1 A 0 OverlayReAdjust;
	ReloadCheck:
// 		If mag is full or no reserves, don't even do anything
		TNT1 A 0 A_JumpIfInventory("ShellInTube", 0, "Ready");
        TNT1 A 0 A_JumpIfInventory("Shell",1, "ReloadStart");
        Goto Ready;
	ReloadStart:
		STGN MN 2 A_WeaponReady;
		STGN O 2;
	LoadShell:
// 		If mag is full or no reserves, end reload
		TNT1 A 0 A_JumpIfInventory("ShellInTube", 0, "ReloadOver");
        TNT1 A 0 A_JumpIfInventory("Shell",1, 1);
        Goto ReloadOver;
		
		TNT1 A 0 A_StartSound("weapons/scout_shotgun_insert_shell",CHAN_AUTO, 0, 1.05);
		STGN P 1;
		STGN QR 1;
		STGN S 2 A_WeaponReady;

        TNT1 A 0 A_Giveinventory("ShellInTube",1);
        TNT1 A 0 A_Takeinventory("Shell",1);
		
		STGN T 1 A_WeaponReady;
		STGN U 1 A_WeaponReady;
		Loop;
	ReloadOver:
		STGN V 2;
		STGN WX 2 A_WeaponReady(WRF_ALLOWRELOAD);
		Goto Ready;
	MuzzleFlash:
		TNT1 A 0 A_jump(255, "FireRing");
	FireRing:
		BTRF A 2 Bright  A_Light(2);
		BTRF BC 1 Bright  A_Light(2);
		Goto LightDone;
	Spawn:
		SHOT A -1;
		Stop;
	}
	action void smoke_puff(){
		Vector3 facing = TrailedProjectile.facingToVector(invoker.owner.angle, invoker.owner.pitch, 30);
// SMKAE0
		A_SpawnParticleEx("a1a1a1",TexMan.CheckForTexture("SMKAE0"),STYLE_Shaded,/*SPF_RELANG|*/SPF_RELVEL|SPF_RELANG|SPF_ROLL|SPF_LOCAL_ANIM , 29 
// 		20
		, 60, 0
// 		,30,15,40
		,facing.x+facing.y*0.35, facing.y-facing.x*0.35, facing.z +50
		,0,frandom(0.6,1.2),0, 0,0,0.1
		, 0.8,/*-0.02*/ -1,0.05
		, Random(0,12)*30);
	}
	
	action void FireScoutShotgun(){
		if (player == null)
		{
			return;
		}

		A_StartSound ("weapons/scout_shotgun_fire", CHAN_AUTO, 0, 1.08);
		Weapon weap = player.ReadyWeapon;
		if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
		{
			if (!weap.DepleteAmmo (weap.bAltFire, true, -1))
				return;
		}
		player.mo.PlayAttacking2 ();

		A_FireBullets (5, 1.5, 8, /*7*/ 0, "ClearPuff", flags:0, missile:"ShotgunProjectile",Spawnheight:-1,Spawnofs_xy:14);
// 		alternatShotgunFire(4, "ShotgunProjectile", 2);
		A_Overlay(-2, "MuzzleFlash");
		A_OverlayPivot(-2, 0.5, 0.5);
		A_OverlayScale(-2, 0.4 + random(-3,3)/100, 0.4 + random(-3,3)/100);
		A_OverlayOffset(-2, 250 + random(-5,5), 40 + random(-5,5));
		A_OverlayRotate(-2, random(0,8)*30, WOF_ADD );
		A_OverlayAlpha(-2, 0.95);
		smoke_puff();
		smoke_puff();
	}
	action void alternatShotgunFire(int bulletcount, class<Actor> missile, float spread)
	{
		double zoffs = invoker.owner.height*0.5;
		if(invoker.owner.player) zoffs = invoker.owner.player.viewz - invoker.owner.pos.z;
	
		FLineTraceData lt;
		invoker.owner.LineTrace(invoker.owner.angle, 1000, invoker.owner.pitch, offsetz:zoffs, offsetforward:invoker.owner.radius, data:lt);
		Vector3 hitposition = lt.HitLocation;
		Actor proj1,proj2;
		[proj1,proj2] = A_FireProjectile(missile,invoker.angle,True,10,0,0,invoker.pitch);
// 		proj2.A_SetPitch(invoker.pitch);
	}
	override void Tick(void){
		
		CasingAnimationTick();
		CasingDropSoundTick(dropSoundVolume);
		super.Tick();
	}
}

// Special puff for shotgun with puffonactors to make the spread pattern work properly
class ShotgunPuff: BulletPuff{
	Default
	{
		+PUFFONACTORS
	}
}
class ShotgunProjectile: FastProjectile {
	Vector3 facing;
	double speedx;
	double speedy;
	double speedz;
	bool particleDrawn;
	Default
	{
		Radius 2;
		Height 2;
		Speed 200;
		Scale 0.8;
		+PUFFONACTORS
// 		Damage 7;
		DamageFunction 4.5 * random(1,3);
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ZDOOMTRANS
		alpha 0.5;
		scale 0.3;
// 		DeathSound "weapons/scout_shotgun_impact";
	}
	States
	{
	Spawn:
		TRAC A 1 Bright ShotgunParticle(30, 12, 5);
		Loop;
	Crash:
	XDeath:
 		TNT1 A 0 A_Startsound("weapons/scout_shotgun_impact",CHAN_WEAPON, flags:CHANF_OVERLAP,volume:0.6,attenuation:ATTN_NONE,pitch: frandom(0.7,0.8));
	Death:
		TNT1 A 1 {
			A_StartSound("weapons/scout_shotgun_impact", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			ShotgunParticleTailCompensation(30, 12, 5);
		}
// 		Goto LightDone;
		Stop;
	}
	
// 	convert the facing to a vector
	Vector3 facingToVector(float angle, float pitch, int length){
		vector3 vec = quat.FromAngles(angle, pitch, 0) * (length, 0, 0);
		return vec;
	}

	

	void ShotgunParticle(int subdivide
		, float baseTTL = 120
		, float mainSmokeSize = 4, float speedOverride = 0)
	{
// 		a.color1 = "white";
		particleDrawn = True;
		float baseAlpha = 0.6; //Starting alpha value
		float fadeAlpha = baseAlpha/baseTTL; //Value of alpha decrease each tick
		float interval = fadeAlpha/subdivide; //The difference in alpha  of particle for each division within a tick
		
		int length;
		if (speedOverride != 0)
			length = speedOverride/subdivide;
		else
			length = vel.length()/subdivide;

		facing = facingToVector(angle,pitch, length);

// 		Spawn center fire trail yellow - #fac64d  orange - #fc883a average #fba744 fed882 #very orange f1680a
		A_SpawnParticle("f58428",SPF_FULLBRIGHT, baseTTL*1.2 ,mainSmokeSize, 0
		, 0+frandom(-0.5,0.5),0+frandom(-0.5,0.5),0+frandom(-0.5,0.5)
		, 0,0,0, 0,0,0
		, baseAlpha,-1,0.2);
		
		for ( int div = 1; div <= subdivide; div++ ) 
		{
// 			Spawn center fire trail
			A_SpawnParticle("f58428",SPF_FULLBRIGHT,baseTTL,mainSmokeSize + 0.1* div/subdivide, 0
			, -facing.x*div+frandom(-0.5,0.5),-facing.y*div+frandom(-0.5,0.5),-facing.z*div+frandom(-0.5,0.5)
			, 0,0,0, 0,0,0
			, baseAlpha - div*interval, fadeAlpha,0.2);
		}
		
	}
	

	
	
	void ShotgunParticleTailCompensation(int subdivide
		, float baseTTL = 120,float baseTTL_trail=10
		, float mainSmokeSize = 4, float subSmokeSize=3)
	{
		if (!particleDrawn) 
			ShotgunParticle(subdivide, baseTTL, mainSmokeSize,speedOverride:speed);
	}
}


class ShellInTube : Ammo
{
	Default{
		Inventory.Amount 8;
		Inventory.MaxAmount 8;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 0;
	}
}