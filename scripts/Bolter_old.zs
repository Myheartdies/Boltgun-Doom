class Bolter : DoomWeapon
{
// 	Weapon weap
	int casingIdx;
	Array<float> casingTimeElapsed; //Time elapsed after a casing has ejected in ticks 
	Array<float> ejectSpeed_x; //The inital x speed of casing
	Array<float> ejectSpeed_y; //The inital y speed of casing
	Array<int> soundDelays; // The queue for delayed sound
	int currentIdx; //The slot for the oldest delayed sound
	int insertIdx; //The idx of the slot the new delayed sound is inserted
	int queueLength;
	String casingDropSound;
	bool shot;
	
	override void BeginPlay(){
		queueLength = 20;
		for (int i=0; i<5; i++){
			casingTimeElapsed.push(0);
			ejectSpeed_x.push(-10 + frandom(-4,2));
			ejectSpeed_y.push(frandom(-4,1));
		}
		for (int i = 0; i < queueLength; i++){
			soundDelays.push(0);
		}
		casingDropSound = "weapons/bolter_casing";
		currentIdx = 0;
		insertIdx = 0;
		casingIdx = 2;
		shot = False;
		super.BeginPlay();
	}
	Default
	{	
		Weapon.SelectionOrder 1900;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Clip";
		Obituary "%o Is mowed down by Bolter fire";
		Inventory.Pickupmessage "You have Retrieved the Bolter. Deliver righteous fury!";
		Tag "$TAG_BOLTER";
		Weapon.AmmoUse 2;
		Weapon.WeaponScaleX 0.6; 
		Weapon.WeaponScaleY 0.6; 
		Weapon.KickBack 80;
		Weapon.BobSpeed 2;
// 		Weapon.AmmoType1 "BolterAmmoLoadedBP";
// 		Weapon.AmmoType2 "Clip";
// 		Weapon.AmmoGive2 100;
// 		Weapon.AmmoGive1 41;
		Weapon.BobRangeX 0.2;
		Weapon.BobRangeY 1.1;
	}
	States
	{
	Ready:
		BOTR A 1 A_WeaponReady;
		Loop;
	Deselect:
		BOTR A 1 A_Lower(18);
		Loop;
	Select:
		BOTR A 1 A_Raise(18);
		Loop;
	Fire:
		TNT1 A 0 A_ZoomFactor(0.994);
		TNT1 A 0 A_SetPitch(pitch - 0.5);
		TNT1 A 0 A_OverlayScale(1, 1.06,1.06);
		BOTR A 2;
		TNT1 A 0 A_WeaponOffset(-3, 5, WOF_ADD);
		BOTR B 1 Bright FireBolter;
		TNT1 A 0 A_ZoomFactor(0.996);
		TNT1 A 0 A_OverlayScale(1,1.03,1.03);
		TNT1 A 0 A_WeaponOffset(2, -2.5, WOF_ADD);
		BOTR B 1 Bright A_SetPitch(pitch + 0.3);
		TNT1 A 0 A_OverlayScale(1,1.02,1.02);
		BOTR C 1 Bright;
		TNT1 A 0 A_OverlayScale(1,1,1);
		BOTR C 1 Bright A_ZoomFactor(1.00);
		TNT1 A 0 A_WeaponOffset(1, -2.5, WOF_ADD);
		BOTR C 1 A_SetPitch(pitch + 0.2) ;
		

		BOTR D 2 A_ReFire;
		Goto Ready;
	MuzzleFlash:
		TNT1 A 0 A_jump(255, "FireRing");
	FireRing:
		BTRF A 2 Bright;
		BTRF BC 1 Bright;
		Stop;
	Casing:
		TNT1 A 0 A_jump(80, "Casing1");
		TNT1 A 0 A_jump(120,"Casing2");
		TNT1 A 0 A_jump(255, "Casing3");
	Casing1:
		CASN AB 2 Bright;
		CASN CDEFGHIJKLMNOPAB 2;
		Goto LightDone;
	Casing2:
		CASN NO 2 Bright;
		CASN PABCDEGHIJKLMNOP 2;
		Goto LightDone;
	Casing3:
		CASN FG 2 Bright;
		CASN HIJKLMNOPABCDEFG 2;
		Goto LightDone;

	AltFire:
// 		BOTR A 2;
// 		BOTR B 3 Bright A_ThrowGrenade("Grenade", 10, 15, 4);
// 		BOTR C 3 Bright;
// 		BOTR D 2 A_ReFire;
// 		Goto Ready;
	Reload:
	ReloadPrepare:
		BOTR EF 2;
		BOTR G 2 A_Startsound("weapons/bolter_reload_full");
	Reloading:
		BOTR HIJKL 3;
	ReloadFull:
		BOTR PQRST 2;
	ReloadOver:
		BOTR MNO 3;
		Goto Ready;
 	Spawn:
		BOTR A -1;
		Stop;
	}
	
	action void FireBolter(){
		bool accurate;

		if (player != null)
		{
			Weapon weap = player.ReadyWeapon;
			if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
			{
				if (!weap.DepleteAmmo (weap.bAltFire, True, 2)){
					return;
				}
	//			player.SetPsprite(PSP_FLASH, weap.FindState('MuzzleFlash'));
			}
	//		player.mo.PlayAttacking2 ();

			accurate = !player.refire;
		}
		else
		{
			accurate = true;
		}
		if (accurate) A_FireBullets(0, 0, 1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"BolterProjectile", 15,10 );
		else A_FireBullets (1.5, 1.5, 1, /*6 * random(3,13)*/ 0, "",FBF_NORANDOM,0,"BolterProjectile", 15,10 );
		A_StartSound ("weapons/bolter_fire", CHAN_AUTO, 0, 1.05);
		
// 		Eject casing
		EjectCasing("Casing");
		
// 		Call delayed sound for casing drop
		AddToSoundQueue(25);

		A_Overlay(-2, "MuzzleFlash");
		A_OverlayPivot(-2, 0.5, 0.5);
		A_OverlayScale(-2, 0.3 + random(-3,3)/100, 0.3 + random(-3,3)/100);
		A_OverlayOffset(-2, 250 + random(-5,5), 40 + random(-5,5));
		A_OverlayRotate(-2, random(0,8)*30, WOF_ADD );
		A_OverlayAlpha(-2, 0.95);
		
		
	}

	
	action void EjectCasing(StateLabel CasingState = "Casing"){
// 		Draw Casing overlay
		A_Overlay(invoker.casingIdx,CasingState);
		A_OverlayScale(invoker.casingIdx,1.7,1.7);
		A_OverlayOffset(invoker.casingIdx, 150, -70);
		invoker.casingTimeElapsed[invoker.casingIdx - 2 ] = 0;
		
// 		Set base eject speed of the casing
		invoker.ejectSpeed_x[invoker.casingIdx - 2 ] = - 12 + frandom(-3,2);
		invoker.ejectSpeed_y[invoker.casingIdx - 2 ] = frandom(-6,0);
		invoker.casingIdx = (invoker.casingIdx + 1) % 5 + 2;
		invoker.shot = True;
	}

	

	action void AddToSoundQueue(int baseDelay = 25){
		invoker.soundDelays[invoker.insertIdx] = baseDelay;
		invoker.insertIdx = (invoker.insertIdx + 1)%invoker.queueLength;
	}
	
	override void Tick(void){
		CasingAnimationTick();
		CasingDropSoundTick();

		super.Tick();
	}
	
	float GetModifiedSpeed(float baseSpeed, float acc, float time, float minSpeed){
		return baseSpeed + time * acc < minSpeed? baseSpeed + time * acc : minSpeed;
	}
	void CasingAnimationTick(){
// 		Shooting check to avoid trying to access an overlay that does not yet exist
		if (!shot){
			super.Tick();
			return;
		}
// 		Move casing layers
		for (int i=0; i<5; i++){
			casingTimeElapsed[i] = casingTimeElapsed[i] + 1;
			owner.A_OverlayOffset(i + 2
				, GetModifiedSpeed(ejectSpeed_x[i],frandom(0.3,0.5),casingTimeElapsed[i],-0.5)
				, ejectSpeed_y[i]+ casingTimeElapsed[i] * 0.9
				, WOF_ADD
				);
		}
	}
	void CasingDropSoundTick(){
// 		Play Delayed sounds for casing

// 		soundDelays is a queue whose elements are time delays of when casing drop sound is played from now. It is a queue
// 		implemented with cyclic array, with pointer currentIdx as head pointer and insertIdx as tail pointer

// 		All elements are deducted by one every tick(min value 0), when the head value is 1, the delayed sound is played, and 
// 		the head moves forward. 0 is viewed as empty, so when head pointer meets a 0, the tail is reset to head. This also 
// 		means that the queue has to be monotonically increasing, or in other words, sound added later must be played later, 
// 		otherwise the sound will stop prematurely

// 		Example: queue [26,12,27,28]
// 		when the head reaches 1, the queue is [1,0,1,2], this means when the headpinter move to index 1, it assumes the queue
// 		is drained, but that's not the case as the sound with delay 12, 27 28 are not played

// 		When trying to play a new delayed sound, a new element of delay value is pushed to the tail 

// 		If the delay is zero, this means entire queue is drained, do nothing other than moving the inset idx up
		if(soundDelays[currentIdx] <= 0){
			insertIdx = currentIdx;
		}
// 		Play sound if current delay is drained, then deduct time for entire queue
		else{
			if(soundDelays[currentIdx] <= 1){
				A_StartSound(casingDropSound, CHAN_AUTO, 0, 0.3);
				currentIdx = (currentIdx + 1) % queueLength;
			}
		}
// 		Deduct time for entire queue
		for (int i = 0; i < queueLength;i++){
			soundDelays[i] = soundDelays[i] - 1 > 0 ? soundDelays[i] - 1 : 0;
		}
	}
}

class BolterProjectile: FastProjectile {
	
	Default
	{
		Radius 6;
		Height 8;
		Speed 120;
		Scale 0.8;
		Damage 11;
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ZDOOMTRANS
// 		SeeSound "weapons/bolter_fire";
		DeathSound "weapons/bolter_impact";
// 		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		BOLT A 1 Bright bolterParticle(15, 80, 13, 5, 4);
		Loop;
	Death:
		BTRE A 2 Bright A_Explode(6 * random(4,7), 40, 0, damagetype="SmallExplosion");
		BTRE BCDEFGHIJKL 2 Bright;
		BTRE MNOPQ 2;
// 		Goto LightDone;
		Stop;
	}
	
// 	convert the facing to a vector
	Vector3 facingToVector(float angle, float pitch, int length){
		vector3 vec = quat.FromAngles(angle, pitch, 0) * (length, 0, 0);
// 		vector3 vec;
// 		vec.x = cos(angle) * sin(-pitch)*length;
// 		vec.y = sin(angle) * sin(-pitch)*length;
// 		vec.z = cos(-pitch)*length;
		return vec;
	}
	void spawnSubdividedtrail(color color1,Vector3 facing, float baseAlpha,float inverval, int div, float fadeAlpha){
		
	}
	void bolterParticle(int subdivide,float baseTTL = 120,float baseTTL_trail=10, float mainSmokeSize = 4, float subSmokeSize=3){
// 		float baseTTL = 120;
		float baseAlpha = 1; //Starting alpha value
		float fadeAlpha = baseAlpha/baseTTL; //Value of alpha decrease each tick
		float interval = fadeAlpha/subdivide; //The difference in alpha for each division in a tick of particle
// 		float baseTTL_trail = 10;
		float baseAlpha_trail = 0.95;
		float fadeAlpha_trail = baseAlpha_trail/baseTTL_trail ;
		float interval_trail = fadeAlpha_trail/subdivide; //The difference in alpha for each division in a tick of particle
		
		int length = Speed/subdivide;
		Vector3 facing = facingToVector(angle,pitch, length);

// 		Spawn center smoke trail
		A_SpawnParticle/*Ex*/("7f7f7f",/*TexMan.CheckForTexture("BOLTTR"),STYLE_Shaded,*/0,baseTTL,mainSmokeSize+frandom(-0.5,0.5), 0
		, 0,0,0
		, 0,0,0, 0,0,0
		, baseAlpha,-1,-0.04);


		double speedx = frandom(-0.15,0.15);
		double speedy = frandom(0.15,0.15);
		double speedz = frandom(0,0.1);
// 		Spawn  smoke puff
		A_SpawnParticleEx("white",TexMan.CheckForTexture("BOLTSK"),STYLE_Shaded,SPF_ROLL,baseTTL*0.5+60
		, 9 + frandom(-1,2), 0
		, 0,0,0
		,speedx,speedy,speedz, -speedx/1500,-speedy/1500,-speedz/1500
		, 0.6,-1,-0.01
		, Random(0,12)*30);
		
// 		Spawn center fire trail yellow - #fac64d  orange - #fc883a
		A_SpawnParticle("fba744",SPF_FULLBRIGHT,baseTTL_trail,mainSmokeSize*1.2, 0
		, 0+frandom(-1,1),0+frandom(-1,1),0+frandom(-1,1)
		, 0,0,0, 0,0,0
		, baseAlpha,-1,-0.04);
		
		for ( int div = 1; div <= subdivide; div++ )  // sid is the sector ID
		{
			
// 			Spawn center fire trail
			A_SpawnParticle("fba744",SPF_FULLBRIGHT,baseTTL_trail,mainSmokeSize, 0
			, -facing.x*div,-facing.y*div,-facing.z*div
			, 0,0,0, 0,0,0
			, baseAlpha_trail - div*interval_trail, fadeAlpha_trail,-0.01);
			
// 			Spawn center smoke trail
			A_SpawnParticle("7f7f7f",0,baseTTL,mainSmokeSize+frandom(-0.5,0.5), 0
			, -facing.x*div+frandom(-0.5,0.5),-facing.y*div+frandom(-0.5,0.5),-facing.z*div+frandom(-0.5,0.5)
			, 0,0,0, 0,0,0
			, baseAlpha - div*interval, fadeAlpha,-0.01);
			

// 			Spawn side smoke trail
			speedx = frandom(-0.1,0.1);
			speedy = frandom(-0.1,0.1);
			speedz = frandom(-0.1,0.1);
			A_SpawnParticle("7f7f7f",0,baseTTL,subSmokeSize+frandom(-0.5,0.5), 0 
			,-facing.x*div+frandom(-0.5,0.5),-facing.y*div+frandom(-0.5,0.5),-facing.z*div+frandom(-0.5,0.5)
			,speedx,speedy,speedz, -speedx/2000,-speedy/2000,-speedz/2000
			,baseAlpha- div*interval*1.5, fadeAlpha*1.5,-0.01);
			
			if(div%3 ==0){
				speedx = frandom(-0.15,0.15);
				speedy = frandom(-0.15,0.15);
				speedz = frandom(0,0.1);
// 				Spawn  smoke puff
				A_SpawnParticleEx("white",TexMan.CheckForTexture("BOLTSK"),STYLE_Shaded,SPF_ROLL,baseTTL*0.5+60
					, 9 + frandom(-1,2), 0
					,-facing.x*div+frandom(-0.3,0.3),-facing.y*div+frandom(-0.3,0.3),-facing.z*div+frandom(-0.3,0.3)
					,speedx,speedy,speedz, -speedx/1500,-speedy/1500,-speedz/1500
					, 0.6, -1 ,-0.01
					, Random(0,12)*30);
			}
			
// 			speedx = frandom(-0.1,0.1);
// 			speedy = frandom(-0.1,0.1);
// 			speedz = frandom(-0.1,0.1);
// 			A_SpawnParticle("7f7f7f",0,baseTTL,subSmokeSize+frandom(-0.5,0.5), 0
// 			,-facing.x*div+frandom(-1,1),-facing.y*div+frandom(-2,2),-facing.z*div+frandom(-2,2)
// 			,speedx,speedy,speedz, -speedx/2000,-speedy/2000,-speedz/2000
// 			,baseAlpha- div*interval*1.5, fadeAlpha*1.5,-0.01);
		}
		
	}
}

// class BolterAmmoLoadedBP : Ammo
// {
// 	Default{
// 		Inventory.Amount 40;
// 		Inventory.MaxAmount 41;
// 		Ammo.BackpackAmount 0;
// 		Ammo.BackpackMaxAmount 41;
// 	}
// }

