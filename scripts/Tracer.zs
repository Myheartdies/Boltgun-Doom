Actor Tracer: FastProjectile
{
	Projectile
	+RANDOMIZE
	+FORCEXYBILLBOARD
	+DONTSPLASH
	+NOEXTREMEDEATH
	damage 0
	radius 2
	height 2
	speed 140
	alpha 0.9
	scale .15
	states
	{
	Spawn:
		TRAC A 1 BRIGHT
		Loop

	Death:
		TNT1 A 0
		TNT1 A 1
		//TNT1 A 0 A_JumpIfInTargetInventory("IsTacticalClass", 1, "Tactical")
		tnt1 a 2
		Stop

	XDeath:
		TNT1 A 0
		Stop

	}
}
