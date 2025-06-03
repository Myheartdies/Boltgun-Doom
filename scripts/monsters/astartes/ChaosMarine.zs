class ChaosMarine : HellKnight
{
	Default
	{
		Mass 600;
		PainThreshold 6;
		DamageFactor "SmallExplosion", 0.35; //
		DamageFactor "StrongExplosion", 0.7;
	}
// 	Chase but with footstep
	void MarineStep(string footStep, statelabel melee, statelabel missile,int flags = 0){
		A_StartSound(footStep,volume:0.6);
		A_Chase(melee, missile, flags);
	}

}