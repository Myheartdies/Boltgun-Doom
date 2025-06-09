#include "scripts/monsters/daemons/Flamers.zs"
#include "scripts/monsters/daemons/ExFlamer.zs"
#include "scripts/monsters/daemons/BlueHorror.zs"
class FlamerSpawner : RandomSpawner Replaces DoomImp
{
    Default
    {
// 	1/3 possibility to get Flamer1 which shoots spreading flame
        DropItem "Flamer1", 255, 3;
		DropItem "Flamer2", 255, 3;
		DropItem "Flamer3", 255, 3;
    }
}

class ExaltedFlamerSpawner : RandomSpawner Replaces Cacodemon
{
    Default
    {
        DropItem "ExaltedFlamer";
    }
}