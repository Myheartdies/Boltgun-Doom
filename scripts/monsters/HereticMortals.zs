#include "scripts/monsters/mortals/Cultists.zs"
#include "scripts/monsters/mortals/CultistShock.zs"
#include "scripts/monsters/mortals/CultistPlasma.zs"
#include "scripts/monsters/mortals/CultistHeavy.zs"

class SergeantReplacer : RandomSpawner Replaces ShotgunGuy
{
    Default
    {
		DropItem "CultistShock", 255, 2;
        DropItem "PlasmaRenegade", 255, 1;
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