class Cultist : ZombieMan 
{
	Default
	{
		Scale 0.58;
	}
	States
	{
		XDeath:
			OVKS A 5 A_NoBlocking;
			OVKS B 5 A_XScream;
			OVKS C 5 A_NoBlocking;
			OVKS DEFGHI 3;
			OVKS J -1;
			Stop;
	}
 	
}


// class CultistHeavy : ChaingunGuy  Replaces ChaingunGuy
// {
// 	Default
// 	{
// 		Scale 0.62;
// 	}
// 	States
// 	{
// 		XDeath:
// 			OVKS A 5 A_NoBlocking;
// 			OVKS B 5 A_XScream;
// 			OVKS C 5 A_NoBlocking;
// 			OVKS DEFGHI 3;
// 			OVKS J -1;
// 			Stop;
// 	}
 	
// }