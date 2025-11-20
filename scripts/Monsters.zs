#include "scripts/monsters/HereticMortals.zs"
#include "scripts/monsters/HereticAstartes.zs"
#include "scripts/monsters/ChaosDaemons.zs"

// gibs
class GibActor: Actor{
	Default
	{
		Radius 8.0;
		Height 4.0;
		Gravity 0.6;
		Scale 0.6;
		BounceType 'Doom';
		+Missile
		BounceFactor 0.6;
		Friction 0.6;
		+DONTSPLASH
		+NOBLOCKMAP
		+THRUACTORS
		+NOTELEPORT
		+CANBOUNCEWATER
		+FLOORCLIP
		+MOVEWITHSECTOR
		+USEBOUNCESTATE
		+ROLLSPRITE
		+ROLLCENTER
		+INTERPOLATEANGLES
		+FORCEXYBILLBOARD
		+NOTONAUTOMAP
		-SOLID
	}	
}
