#include "scripts/TrailedProjectile.zs"
#include "scripts/monsters/astartes/ChaosMarine.zs"
#include "scripts/monsters/astartes/TCSM.zs"
#include "scripts/monsters/astartes/PCSM.zs"
#include "scripts/monsters/astartes/Champion.zs"
#include "scripts/monsters/astartes/Terminator.zs"

class LegionarySpawner : RandomSpawner Replaces Hellknight
{
    Default
    {
        DropItem "LegionaryPlasma";
        DropItem "Legionary";
    }
}