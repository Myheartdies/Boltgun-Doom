
// Profile just contains the most commonly reused information for particles, so no speed, acceleration, offsets
struct Trailprofile{
	float baseAlpha;
	float fadeAlpha;
	float interval;
	Vector3 facing;
	color color1;
	String textureName;
	int style;
	int flags;
	int lifetime;
	double size;
	bool randomposition;
	bool moving;
	int slowdownspeed;
	double startalphaf; double fadestepf; 
	double sizestep;
	double startroll; 
	
}

class TrailedProjectile: FastProjectile {
	private Vector3 facing;
	Trailprofile smokeProfile;
	Trailprofile fireProfile;
	double speedx;
	double speedy;
	double speedz;
	double lastx;
	double lasty;
	double lastz;
	Color col;
	FSpawnParticleParams smokePuffParams;
	override void BeginPlay(){
// 		A_SpawnParticleEx("white",TexMan.CheckForTexture("SMOKA0"),STYLE_Shaded,SPF_ROLL, baseTTL *0.5+60
// 		, 9 + frandom(-1,2), 0
// 		,-facing.x*div + frandom(-0.3,0.3),-facing.y*div+frandom(-0.3,0.3),-facing.z*div+frandom(-0.3,0.3)
// 		,speedx,speedy,speedz, -speedx/1500,-speedy/1500,-speedz/1500
// 		, 0.6,-1,-0.01
// 		, Random(0,12)*30);
// 		col = (255,255,255);
		smokePuffParams.color1 = "white";
		smokePuffParams.texture = TexMan.CheckForTexture("SMOKA0");
		smokePuffParams.flags = SPF_ROLL;
		smokePuffParams.style = STYLE_Shaded;
		smokePuffParams.lifetime = 60;
		smokePuffParams.size = 9;
		smokePuffParams.sizestep = -0.01;
		smokePuffParams.startalpha = 0.6;
		smokePuffParams.fadestep = -1;
		super.BeginPlay();
	}
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
		BOLT A 1 Bright TrailParticle(16, 90, 15, 5, 4);
// 		TNT1 A 0 bolterParticle(16, 90, 15, 20, 20);
		Loop;
	Death:
		BTRE A 2 Bright A_Explode(6 * random(4,7), 40, 0, damagetype="SmallExplosion");
		BTRE BCDEFGHIJKL 2 Bright;
		BTRE MNOPQ 2;
// 		Goto LightDone;
		Stop;
	}
	
	void modify(
		float offsetx1, float offsetx2, float offsety1, float offsety2, float offsetz1, float offsetz2,
		float velx1, float velx2, float vely1, float vely2, float velz1, float velz2
		){
		
	}
	
// 	convert the facing to a vector
	static Vector3 facingToVector(float angle, float pitch, int length){
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

// 	SMOKA0 round_smoke_1
	
	void SpawnTrailedParticle(int subdivide){
		SpawnHeadParticle();
		for ( int div = 1; div <= subdivide; div++ ){
			SpawnSubdividedParticle(div);
		}
	}
	void SpawnHeadParticle(){
		
	}
	void SpawnSubdividedParticle(int div){
		
	}
	void SpawnSmokePuff(float baseTTL, int div = 0){
		speedx = frandom(-0.15,0.15);
		speedy = frandom(0.15,0.15);
		speedz = frandom(0,0.15);
// 		A_SpawnParticleEx("white",TexMan.CheckForTexture("SMOKA0"),STYLE_Shaded,SPF_ROLL, baseTTL *0.5+60
// 		, 9 + frandom(-1,2), 0
// 		,-facing.x*div + frandom(-0.3,0.3),-facing.y*div+frandom(-0.3,0.3),-facing.z*div+frandom(-0.3,0.3)
// 		,speedx,speedy,speedz, -speedx/1500,-speedy/1500,-speedz/1500
// 		, 0.6,-1,-0.01
// 		, Random(0,12)*30);
		Vector3 position = (
			pos.x-facing.x*div + frandom(-0.3,0.3),
			pos.y-facing.y*div + frandom(-0.3,0.3),
			pos.z-facing.z*div + frandom(-0.3,0.3));
		Vector3 speed = (speedx, speedy, speedz);
		Vector3 acceleration = (-speedx/1500,-speedy/1500,-speedz/1500);
		smokePuffParams.pos = position;
		smokePuffParams.vel = speed;
		smokePuffParams.accel = acceleration;
		smokePuffParams.startroll = random(0,12) * 30;
		level.SpawnParticle(smokePuffParams);
	}
	
// 	Spawn trail for one profile
	void TrailParticle_dev (int subdivide
		, float baseTTL = 120,float baseTTL_trail=10
		, float mainSmokeSize = 4, float subSmokeSize=3)
	{
		
	}
	
	
	void TrailParticle(int subdivide
		, float baseTTL = 120,float baseTTL_trail=10
		, float mainSmokeSize = 4, float subSmokeSize=3)
	{
// 		a.color1 = "white";
// 		float baseTTL = 120;
		float baseAlpha = 1; //Starting alpha value
		float fadeAlpha = baseAlpha/baseTTL; //Value of alpha decrease each tick
		float interval = fadeAlpha/subdivide; //The difference in alpha  of particle for each division within a tick
// 		float baseTTL_trail = 10;
		float baseAlpha_trail = 0.95;
		float fadeAlpha_trail = baseAlpha_trail/baseTTL_trail ;
		float interval_trail = fadeAlpha_trail/subdivide; 
		
	
		int length = vel.length()/subdivide;
		facing = facingToVector(angle, pitch, length);
		
		
// 		Spawn center smoke trail
		A_SpawnParticle/*Ex*/("7f7f7f", 0,baseTTL,mainSmokeSize+frandom(-0.5,0.5), 0
		, 0,0,0
		, 0,0,0, 0,0,0
		, baseAlpha,-1,-0.04);

		lastx = pos.x;
		lasty = pos.z;
		lastz = pos.z;
// 		Spawn  smoke puff
		SpawnSmokePuff(baseTTL);
		
// 		Spawn center fire trail yellow - #fac64d  orange - #fc883a average #fba744  bright#fed882
		A_SpawnParticle("fba744",SPF_FULLBRIGHT, baseTTL_trail,mainSmokeSize*1.2, 0
		, 0+frandom(-0.5,0.5),0+frandom(-0.5,0.5),0+frandom(-0.5,0.5)
		, 0,0,0, 0,0,0
		, baseAlpha,-1,-0.1);
		
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
			
// 			Spawn  smoke puff
			if (Speed < 25){ 
				if(div % (subdivide / 2 <= 0 ? 1: subdivide / 2) ==0){
					SpawnSmokePuff(baseTTL, div);
				}
				continue;
			}
			if(div % (subdivide / 6 <= 0 ? 1: subdivide / 6) ==0){
				SpawnSmokePuff(baseTTL, div);
			}
			
		}
		
	}
}