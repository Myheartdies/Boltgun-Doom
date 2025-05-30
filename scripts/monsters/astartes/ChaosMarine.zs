class ChaosMarine : HellKnight
{
	Default
	{
		Mass 600;
		DamageFactor "SmallExplosion", 0.3; //
		DamageFactor "StrongExplosion", 0.65;
	}
// 	Chase but with footstep
	void MarineStep(string footStep, statelabel melee, statelabel missile,int flags = 0){
		A_StartSound(footStep);
		A_Chase(melee, missile, flags);
	}

}