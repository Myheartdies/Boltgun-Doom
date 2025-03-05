class BolterPuff : Actor
{
	Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+ALLOWPARTICLES
		+RANDOMIZE
		+ZDOOMTRANS
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.8;
		Scale 0.5;
// 		VSpeed 1;
		Mass 5;
	}
	States
	{
	Spawn:
		BTRE ABCDEFGHIJKL 2 Bright;
		BTRE MNOP 2;
		Stop;
	}
}