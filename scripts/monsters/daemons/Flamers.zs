class Flamer1 : DoomImp
{
	Default
	{
		Health 75;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 8;
		PainChance 200;
		Monster;
		Scale 0.4;
		DamageFactor "SmallExplosion", 0.5;
		DamageFactor "Bolter", 0.8;
		DamageFactor "StrongExplosion", 0.5;
		+FLOORCLIP
		ReactionTime 4;
// 		MissileChanceMult 0.9;
// 		+FLOAT +NOGRAVITY
		SeeSound "flamer/sight";
		PainSound "flamer/pain";
		DeathSound "flamer/death";
		ActiveSound "flamer/active";
		HitObituary "$OB_IMPHIT";
		Obituary "$OB_IMP";
		Tag "$FN_IMP";
	}
	States
	{
	Spawn:
		FLM1 AB 10 A_Look;
		Loop;
	See:
		FLM1 AABBCCDD 3 {
			A_Chase();
			
		}
		Loop;
	Melee:
		FLM1 HF 8 A_FaceTarget;
		FLM1 G 6 A_CustomMeleeAttack(3 * random(1, 8), "imp/melee");
	Missile:
		FLM1 H 8 A_FaceTarget;
		FLM1 F 8 Bright A_FaceTarget;
// 		FLM1 F 2 Bright A_FaceTarget;
		FLM1 G 6 Bright FlamerMissile_Spread ;
// 		FLM1 G 8 FlamerMissile ;
		Goto See;
	Pain:
		FLM1 J 2;
		FLM1 J 2 A_Pain;
		Goto See;
	Death:
		FLM1 K 8 A_Scream;
		FLM1 L 8;
		FLM1 M 6;
		FLM1 N 6 A_NoBlocking;
		FLM1 O -1;
		Stop;
	XDeath:
		OVKS J 1;
		FLM1 K 5 A_StartSound("flamer/death");
		FLM1 L 5 A_NoBlocking;
		FLM1 M 5;
		FLM1 N 5;
		FLM2 OOO 5;
		OVKS J -1;
		Stop;
// 		OVKS A 5 A_NoBlocking;
// 		OVKS B 5 A_XScream;
// 		OVKS C 5 A_NoBlocking;
// 		OVKS DEFGHI 3;
// 		OVKS J -1;
// 		Stop;
	Raise:
		TROO ML 8;
		TROO KJI 6;
		Goto See;
	}
	void FlamerMissile(){
// 		int deviation  = random(0,1);
		A_SpawnProjectile("FlamerBall", 50);
	}
	
	void FlamerMissile_Spread(){
		int deviation  = random(-2,3);
		let proj1 = FlamerBall(A_SpawnProjectile("FlamerBall", 50, angle:-6.5, flags:CMF_OFFSETPITCH, pitch:0 + deviation));
		proj1.SetEarlyDestroy();
		let proj2 = FlamerBall(A_SpawnProjectile("FlamerBall", 50, angle:6.5, flags:CMF_OFFSETPITCH, pitch:0 - deviation));
		proj2.SetEarlyDestroy();
// 		Set the projectile going upwards and downwards to be destroyed early to reduce visual noise, and because they cant hit the
// 		player anymore anyway
		let proj3 = FlamerBall(A_SpawnProjectile("FlamerBall", 50, angle:0 - deviation, flags:CMF_OFFSETPITCH, pitch:-6.5));
		proj3.SetEarlyDestroy();
		let proj4 = FlamerBall(A_SpawnProjectile("FlamerBall", 50, angle:0 + deviation, flags:CMF_OFFSETPITCH, pitch:6.5 ));
		proj4.SetEarlyDestroy();
	}
}

class Flamer2 : Flamer1
{
	Default
	{
		Scale 0.6;
		MissileChanceMult 0.9;
	}
	States
	{
	Spawn:
		FLM2 AB 10 A_Look;
		Loop;
	See:
		FLM2 AABBCCDD 3 A_Chase;
		Loop;
	Melee:
		FLM2 HF 8 A_FaceTarget;
		FLM2 G 6 A_CustomMeleeAttack(3 * random(1, 8), "imp/melee");
	Missile:
		FLM2 H 8 A_FaceTarget;
		FLM2 F 8 Bright A_FaceTarget;
// 		FLM2 F 2 Bright A_FaceTarget;
		FLM2 G 6 Bright FlamerMissile ;
// 		FLM2 G 8 FlamerMissile ;
		Goto See;
	Pain:
		FLM2 J 2;
		FLM2 J 2 A_Pain;
		Goto See;
	Death:
		FLM2 K 8 A_Scream;
		FLM2 L 8;
		FLM2 M 6;
		FLM2 N 6 A_NoBlocking;
		FLM2 O -1;
		Stop;
	XDeath:
		OVKS J 1;
		FLM2 K 5 A_StartSound("flamer/death");
		FLM2 L 5;
		FLM2 M 5;
		FLM2 N 5 A_NoBlocking;
		FLM2 OOO 5;
		TROO U -1;
		Stop;
	Raise:
		TROO ML 8;
		TROO KJI 6;
		Goto See;
	}

}

class Flamer3 : Flamer1
{
	Default
	{
		Scale 0.6;
	}

	States
	{
	Spawn:
		FLM3 AB 10 A_Look;
		Loop;
	See:
		FLM3 AABBCCDD 3 A_Chase;
		Loop;
	Melee:
		FLM3 HF 8 A_FaceTarget;
		FLM3 G 6 A_CustomMeleeAttack(3 * random(1, 8), "imp/melee");
	Missile:
		FLM3 H 8 A_FaceTarget;
		FLM3 F 8 Bright A_FaceTarget;
// 		FLM3 F 2 Bright A_FaceTarget;
		FLM3 G 6 Bright FlamerMissile ;
		Goto See;
	Pain:
		FLM3 J 2;
		FLM3 J 2 A_Pain;
		Goto See;
	Death:
		FLM3 K 8 A_Scream;
		FLM3 L 8;
		FLM3 M 6;
		FLM3 N 6 A_NoBlocking;
		FLM3 O -1;
		Stop;
	XDeath:
		OVKS J 1;
		FLM3 K 5 A_StartSound("flamer/death");
		FLM3 L 5;
		FLM3 M 5;
		FLM3 N 5 A_NoBlocking;
		FLM3 OOO 5;
		TROO U -1;
		Stop;
	Raise:
		TROO ML 8;
		TROO KJI 6;
		Goto See;
	}

}

class FlamerBall: DoomImpBall{
	int Counter;  //internal counter to help for early destruction and what particle to spawn
	bool EarlyDestroy;
	Default
	{
		SeeSound "flamer/attack";
		Damage 3;
		Speed 8;
		Scale 1.1;
		Alpha 0.3;
		RenderStyle 'Translucent';
// 		FastSpeed 25;
	}
	States
	{
	Spawn:
		BAL1 A 1 BRIGHT FlamerTrailParticles(1);
		BAL1 B 2 BRIGHT {
			FlamerTrailParticles();
			FlameRing();
		}
		Loop;
	Death:
		BAL1 CDE 6 BRIGHT;
		Stop;
	}
	
	void SetEarlyDestroy(){
		EarlyDestroy = True;
	}
	override void Tick(void){
		if (EarlyDestroy && Counter > 45){
			destroy();
		}
		super.Tick();
	}
	// 	TexMan.CheckForTexture("FLMPA0")
	// 	Pale yellow FFEC9F
	void FlameParticle(){
		Counter += 1;
		TextureID txtr;
		if (Counter % 3 == 1)
			txtr = TexMan.CheckForTexture("FLMPA0");
		else
			txtr = TexMan.CheckForTexture("FLMBA0");
// 		TextureID txtr = TexMan.CheckForTexture("FLMBA0");
		A_SpawnParticleEx("",txtr,STYLE_None,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM , 15
		, 35, 0
// 		,0,0,0
		,random(-3,3),random(-3,3),random(-3,3)
		,0,0,0,0,0,0
		, 0.8,0,-2.2
		, Random(0,12)*30, Random(-2,2));
	}
	
	void FlameRing(){
		A_SpawnParticleEx("",TexMan.CheckForTexture("FMRNA0"),STYLE_None,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM , 8
		, 60, 0
		,0,0,0
		,0,0,0,0,0,0
		, 1.0, 0, -5
		, Random(0,12)*30, 3);
	}

	void FlamerTrailParticles(int particle_count = 1){
		for (int i = 0; i < particle_count; i += 1){
			FlameParticle();
		}
		FlameRing();
	}
}

