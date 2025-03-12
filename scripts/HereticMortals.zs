#include "scripts/monsters/Cultists.zs"
#include "scripts/monsters/SimpleEnemies.zs"
#include "scripts/monsters/CultistShock.zs"
#include "scripts/monsters/PLASMA.zs"

#include "scripts/monsters/CultistHeavy.zs"

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