class TrailedProjectile: FastProjectile {
	Vector3 facing;
	Default
	{
		Radius 6;
		Height 4;
		Speed 120;
		Scale 0.8;
		Damage 11;
		Projectile;
		+RANDOMIZE
		+DEHEXPLOSION
		+ZDOOMTRANS
		DeathSound "weapons/bolter_impact";
// 		Obituary "$OB_MPROCKET";
	}
	States
	{
	Spawn:
		BOLT A 1 Bright bolterParticle(16, 90, 15, 4, 3);
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
// 	The particle that is at current position at current tick
	void SpawnTrailHead(color color1, int flags, int lifetime, double size, 
		double velx, double vely, double velz, double accelx, double accely, double accelz, 
		double startalphaf = 1, double fadestepf = -1, double sizestep = 0, int div = 0) //div means the division it is in
	{
		A_SpawnParticle(color1, flags, lifetime, size
		, 0, 0, 0, 0 //offset and angle are all zero
		, velx, vely, velz, accelx, accely, accelz
		, startalphaf, fadestepf, sizestep);
	}
// 	The simulated particle that should exist between current tick and last tick
	void SpawnTrailSubDivided(){}
	void bolterParticle(int subdivide
		, float baseTTL = 120,float baseTTL_trail=10
		, float mainSmokeSize = 4, float subSmokeSize=3)
	{
// 		float baseTTL = 120;
		float baseAlpha = 1; //Starting alpha value
		float fadeAlpha = baseAlpha/baseTTL; //Value of alpha decrease each tick
		float interval = fadeAlpha/subdivide; //The difference in alpha for each division in a tick of particle
// 		float baseTTL_trail = 10;
		float baseAlpha_trail = 0.95;
		float fadeAlpha_trail = baseAlpha_trail/baseTTL_trail ;
		float interval_trail = fadeAlpha_trail/subdivide; //The difference in alpha for each division in a tick of particle
		
		int length = vel.length()/subdivide;
		facing = facingToVector(angle,pitch, length);

// 		Spawn center smoke trail
		A_SpawnParticle/*Ex*/("7f7f7f",/*null,STYLE_Add,*/ 0,baseTTL,mainSmokeSize+frandom(-0.5,0.5), 0
		, 0,0,0
		, 0,0,0, 0,0,0
		, baseAlpha,-1,-0.04);


		double speedx = frandom(-0.15,0.15);
		double speedy = frandom(0.15,0.15);
		double speedz = frandom(0,0.1);
// 		Spawn  smoke puff
		A_SpawnParticleEx("white",TexMan.CheckForTexture("SMOKA0"),STYLE_Shaded,SPF_ROLL,baseTTL*0.5+60
		, 9 + frandom(-1,2), 0
		, 0,0,0
		,speedx,speedy,speedz, -speedx/1500,-speedy/1500,-speedz/1500
		, 0.6,-1,-0.01
		, Random(0,12)*30);
		
// 		Spawn center fire trail yellow - #fac64d  orange - #fc883a average #fba744
		A_SpawnParticle("fba744",SPF_FULLBRIGHT, baseTTL_trail,mainSmokeSize*1.2, 0
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
			A_SpawnParticle("7f7f7f", 0, baseTTL, mainSmokeSize+frandom(-0.5,0.5), 0
			, -facing.x*div+frandom(-0.5,0.5),-facing.y*div+frandom(-0.5,0.5),-facing.z*div+frandom(-0.5,0.5)
			, 0,0,0, 0,0,0
			, baseAlpha - div*interval, fadeAlpha,-0.01);
			

// 			Spawn side smoke trail
			speedx = frandom(-0.1,0.1);
			speedy = frandom(-0.1,0.1);
			speedz = frandom(-0.1,0.1);
			A_SpawnParticle("7f7f7f",0,baseTTL,subSmokeSize+frandom(-0.5,0.5), 0
			,-facing.x*div+frandom(-0.3,0.3),-facing.y*div+frandom(-0.3,0.3),-facing.z*div+frandom(-0.3,0.3)
			,speedx,speedy,speedz, -speedx/2000,-speedy/2000,-speedz/2000
			,baseAlpha- div*interval*1.5, fadeAlpha*1.5,-0.01);
			
			if(div % (subdivide / 5) ==0){
				speedx = frandom(-0.15,0.15);
				speedy = frandom(-0.15,0.15);
				speedz = frandom(0,0.1);
// 				Spawn  smoke puff
				A_SpawnParticleEx("white",TexMan.CheckForTexture("SMOKA0"),STYLE_Shaded,SPF_ROLL,baseTTL*0.5+60
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