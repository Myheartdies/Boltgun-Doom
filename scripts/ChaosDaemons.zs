#include "scripts/monsters/Flamers.zs"
#include "scripts/monsters/ExFlamer.zs"
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