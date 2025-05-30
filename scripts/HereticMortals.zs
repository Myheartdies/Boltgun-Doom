#include "scripts/monsters/mortals/Cultists.zs"
#include "scripts/monsters/mortals/CultistShock.zs"
#include "scripts/monsters/mortals/PLASMA.zs"
#include "scripts/monsters/mortals/CultistHeavy.zs"

class SergeantReplacer : RandomSpawner Replaces ShotgunGuy
{
    Default
    {
        DropItem "PlasmaRenegade";
		DropItem "CultistShock";
    }
}

class CultistSpawner : RandomSpawner Replaces ZombieMan
{
    Default
    {
        DropItem "Cultist1";
        DropItem "Cultist2";
        DropItem "Cultist3";
		DropItem "Cultist4";
    }
}