class ExaltedFlamer : Actor
{
	Default
	{
		Health 400;
		Radius 31;
		Height 56;
		Mass 400;
		Speed 8;
		PainChance 100;
		PainThreshold 10;
		Monster;
		Scale 0.44;
		+FLOAT +NOGRAVITY
		DamageFactor "Bolter", 0.6;
		DamageFactor "HeavyBolter", 0.6;
		SeeSound "exflamer/sight";
		PainSound "exflamer/pain";
		DeathSound "exflamer/death";
		ActiveSound "exflamer/active";
		Obituary "$OB_CACO";
		HitObituary "$OB_CACOHIT";
		Tag "$FN_CACO";
	}
	States
	{
	Spawn:
		EFLM UV 8 A_Look;
		Loop;
	See:
		EFLM AABBCCDD 3{
			A_Chase();
// 			BlueFlameParticle();
		}
		Loop;
	Missile:
		EFLM EFG 3 A_FaceTarget;
		EFLM H 5 BRIGHT ExFlamerMissile;
		EFLM I 3;
		Goto See;
	Pain:
		EFLM N 3;
		EFLM O 5 A_Pain;
		Goto See;
	Death:
		EFLM P 8 A_Scream;
		EFLM P 8;
		EFLM Q 8;
		EFLM R 8;
		EFLM S 8 A_NoBlocking;
		EFLM T -1 A_SetFloorClip;
		Stop;
	Raise:
		EFLM T 8 A_UnSetFloorClip;
		EFLM SRQPP 8;
		Goto See;
	}
	void ExFlamerMissile_Spread1()
	{
		let proj1 = FlamerBall(A_SpawnProjectile("ExaltedFlameBall", angle:-12));
		A_CustomComboAttack("ExaltedFlameBall", 32, 10 * random(1, 6));
	}
	void ExFlamerMissile_Spread2()
	{
		let proj1 = FlamerBall(A_SpawnProjectile("ExaltedFlameBall", angle:12));
		A_CustomComboAttack("ExaltedFlameBall", 32, 10 * random(1, 6));
	}
	
	void ExFlamerMissile()
	{
		if (random(0,4) > 1)
		{
			if (random(0,1) == 0)
				ExFlamerMissile_Spread1();
			else
				ExFlamerMissile_Spread2();
		}
		else
			A_CustomComboAttack("ExaltedFlameBall", 32, 10 * random(1, 6));
	}
	
	void BlueFlameParticle()
	{
		for( int i; i<1; i++)
		{ 
			A_SpawnParticleEx("",TexMan.CheckForTexture("XFMGA0"),STYLE_None,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM , 20
			, 30, 0
			,random(-2,2),random(-2,2),random(-2,2)
			,0,0,-0.5,0,0,-0.05
			, 0.9,0,-1
			, Random(0,12)*30, Random(-3,3));
		}
	}
}

class ExaltedFlameBall : Actor
{
	int Counter;
	Default
	{
 		Radius 6;
		Height 8;
		Speed 10;
 		FastSpeed 20;
		Damage 5;
		Projectile;
		+RANDOMIZE
 		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 1;
		SeeSound "exaltedflamer/attack";
 		DeathSound "caco/shotx";
	}
	States
	{
	Spawn:
 		BLFR A 1 BRIGHT ExFlamerTrailParticles(2);
		BLFR B 2 BRIGHT {
			ExFlamerTrailParticles(2);
// 			ExFlameRing();
		}
		Loop;
	Death:
		BLFR CDE 6 BRIGHT;
		Stop;
	}
	void ExFlamerTrailParticles(int particle_count = 1){
		for (int i = 0; i < particle_count; i += 1){
			ExFlameParticle();
		}
		ExFlameRing();
	}
	
	void ExFlameParticle(){
		Counter += 1;
		TextureID txtr;
		if (Counter % 2 == 0)
			txtr = TexMan.CheckForTexture("XFMNA0");
		else
			txtr = TexMan.CheckForTexture("XFMGA0");
// 		txtr = TexMan.CheckForTexture("XFMNA0");
		A_SpawnParticleEx("",txtr,STYLE_None,SPF_ROLL|SPF_FULLBRIGHT|SPF_LOCAL_ANIM , 20
		, 30, 0
// 		,0,0,0
		,random(-5,5),random(-5,5),random(-5,5)
		,0,0,0,0,0,0
		, 0.9,0,-1.5
		, Random(0,12)*30, Random(-3,3));
	}
	void ExFlameRing(){
		A_SpawnParticleEx("",TexMan.CheckForTexture("XFRNA0"),STYLE_None,SPF_ROLL|SPF_FULLBRIGHT , 10
		, 50, 0
		,0,0,0
		,0,0,0,0,0,0
		, 1.0, 0, -2
		, Random(0,12)*30, Random(-10,10));
	}
}
