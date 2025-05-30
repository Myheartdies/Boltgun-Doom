#include "scripts/monsters/daemons/Flamers.zs"
#include "scripts/monsters/daemons/ExFlamer.zs"
#include "scripts/monsters/daemons/BlueHorror.zs"
class FlamerSpawner : RandomSpawner Replaces DoomImp
{
    Default
    {
        DropItem "Flamer1";
		DropItem "Flamer2";
		DropItem "Flamer3";
    }
}

class ExaltedFlamerSpawner : RandomSpawner Replaces Cacodemon
{
    Default
    {
        DropItem "ExaltedFlamer";
    }
}