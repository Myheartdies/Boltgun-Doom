class ShellEjectingWeapon : DoomWeapon
{
// 	For animating casing ejection overlay
	protected Array<float> casingTimeElapsed; //Time elapsed after a casing has ejected in ticks 
	protected Array<float> ejectSpeed_x; //The inital x speed of casing
	protected Array<float> ejectSpeed_y; //The inital y speed of casing
	protected int maxCasingCount;
	protected float extraOffset_x; 	//How much offset does the spawn position deviate from bolter's ejection position, positive is right negative is left
	protected float extraOffset_y;	//positive is down negative is up
	protected int casingIdx;
	
// 	For playing casing drop sound
	protected Array<int> soundDelays; // The queue for delayed sound
	protected String casingDropSound;
	protected int currentIdx; //The slot for the oldest delayed sound
	protected int insertIdx; //The idx of the slot the new delayed sound is inserted
	protected int queueLength;
	protected float dropSoundVolume;
	
	protected float offsetCompensationx;
	protected float offsetCompensationy;
	
	Property MaxCasingCount : maxCasingCount;
	Property CasingDropSound : casingDropSound;
	Property DropSoundVolume : dropSoundVolume;
	bool shot;
	bool isHeld;
	

	override void BeginPlay(){
// 		Initialize base value
		if (queueLength == 0) 
			queueLength = 20;
// 		Initialize variable for casing animation and sound
		for (int i=0; i< maxCasingCount; i++){
			casingTimeElapsed.push(0);
			ejectSpeed_x.push(-10 + frandom(-4,2));
			ejectSpeed_y.push(frandom(-4,1));
		}
		for (int i = 0; i < queueLength; i++){
			soundDelays.push(0);
		}
		
		currentIdx = 0;
		insertIdx = 0;
		casingIdx = 2;
		offsetCompensationX = 0;
		offsetCompensationY = 0;
		shot = False;
		isHeld = False;
		super.BeginPlay();
	}
	Default
	{	
		ShellEjectingWeapon.MaxCasingCount 6;
		ShellEjectingWeapon.CasingDropSound "TCSM/melee";
		ShellEjectingWeapon.DropSoundVolume 0.5;
		
	}
	States
	{
	Ready:
		TNT1 A 10;
		Loop;
	Deselect:
		TNT1 A 1;
		Loop;
	Select:
		TNT1 A 1;
		Loop;
	Fire:
		TNT1 A 1;
		Stop;
	Casing:
		CASN FG 2 Bright;
		CASN HIJKLMNOPABCDEFG 2;
		Goto LightDone;
 	Spawn:
		PIST A -1;
		Stop;
	}

	
	
// 	====================================================
// 	Call these two actions at the frame of casing eject to initialize a casing ejection
// 	====================================================
	
	action void EjectCasing(StateLabel CasingState = "Casing", float casingScale = 1.7 ,float baseSpeedx = -12, float maxSpeedy = -6){
// 		Draw Casing overlay
		A_Overlay(invoker.casingIdx, CasingState);
		A_OverlayPivot(invoker.casingIdx, 0.5, 0.5);
		A_OverlayScale(invoker.casingIdx, casingScale, casingScale);
		A_OverlayOffset(invoker.casingIdx, 302 + invoker.extraOffset_x, 30 + invoker.extraOffset_y);
		invoker.casingTimeElapsed[invoker.casingIdx - 2] = 0;
		
// 		Set base eject speed of the casing
		invoker.ejectSpeed_x[invoker.casingIdx - 2 ] = baseSpeedx + frandom(-3,2);
		invoker.ejectSpeed_y[invoker.casingIdx - 2 ] = frandom(maxSpeedy,0);
		invoker.casingIdx = (invoker.casingIdx + 1) % invoker.maxCasingCount + 2;
		invoker.shot = True;
	}

	action void AddToSoundQueue(int baseDelay = 25){
		invoker.soundDelays[invoker.insertIdx] = baseDelay;
		invoker.insertIdx = (invoker.insertIdx + 1)%invoker.queueLength;
	}
	action void OverlayRecoil(int offsetX, int offsetY){
		A_WeaponOffset(offsetX, offsetY, WOF_ADD);
		CompensateOffset(-offsetX, -offsetY);
	}
	
// 	Compensate the movement of casing overlay when recoil moves the weapon offset
	action void CompensateOffset(int compensationX = 0, int compensationY = 0){
		invoker.offsetCompensationX = invoker.offsetCompensationX + compensationX;
		invoker.offsetCompensationY = invoker.offsetCompensationY + compensationY;
	}
	


// 	====================================================
// 	The "CasingAnimationTick" and "CasingDropSoundTick" function needs to be called every tick
// 	====================================================
// 	override void Tick(void){
// 		CasingAnimationTick();
// 		CasingDropSoundTick(dropSoundVolume);
// 		super.Tick();
// 	}
	
	float GetModifiedSpeed(float baseSpeed, float acc, float time, float minSpeed){
		return baseSpeed + time * acc < minSpeed? baseSpeed + time * acc : minSpeed;
	}
	
// 	casingLayerReady and Exit must be called on select and deselect to turn on/off the tick
// 	Otherwise the tick() will always run even after a weapon is lowered , causing two weapons to change casing overlay offset
// 	at the same time.
	action void CasingLayerReady(){
		invoker.isHeld = True;
	}
	
	action void CasingLayerExit(){
		invoker.isHeld = False;
	}
	
	void CasingAnimationTick(){
		if(!isHeld) return;
// 		Shooting check to avoid trying to access an overlay that does not yet exist
		if (!shot){
			return;
		}
// 		Move casing layers
		for (int i=0; i < maxCasingCount; i++){
			casingTimeElapsed[i] = casingTimeElapsed[i] + 1;
			// If too much time has passed, so obviously there is no longer a casing to move, don't move it
			if (casingTimeElapsed[i] > 40)
				continue;
// 			owner.A_OverlayOffset(i + 2
// 				, GetModifiedSpeed(ejectSpeed_x[i],frandom(0.3,0.5),casingTimeElapsed[i],-0.5) + offsetCompensationX
// 				, ejectSpeed_y[i]+ casingTimeElapsed[i] * 0.9 + offsetCompensationY
// 				, WOF_ADD
// 				);
			owner.A_OverlayOffset(i + 2
				, GetModifiedSpeed(ejectSpeed_x[i],frandom(0.3,0.5),casingTimeElapsed[i],-0.5) + offsetCompensationX
				, ejectSpeed_y[i]+ casingTimeElapsed[i] * 0.9 + offsetCompensationY
				, WOF_ADD
				);
		}
		offsetCompensationX = 0;
		offsetCompensationY = 0;
	}

	void CasingDropSoundTick(float dropSoundVolume = 0.3){
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
				A_StartSound(casingDropSound, CHAN_AUTO, 0, dropSoundVolume,ATTN_NONE );
				currentIdx = (currentIdx + 1) % queueLength;
			}
		}
// 		Deduct time for entire queue
		for (int i = 0; i < queueLength;i++){
			soundDelays[i] = soundDelays[i] - 1 > 0 ? soundDelays[i] - 1 : 0;
		}
	}
}


