#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 101 //максимум игроков на сервере + 1 (если 50 игроков, то пишем 51 !!!)

#if (MAX_PLAYERS > 501)
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 501
#endif

forward Reklama1();
forward Reklama2();
new reklamatimer1;
new reklamatimer2;

public OnFilterScriptInit()
{
	reklamatimer1 = SetTimer("Reklama1",300000,1);
	reklamatimer2 = SetTimer("Reklama2",360000,1);
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(reklamatimer1);
	KillTimer(reklamatimer2);
	return 1;
}

public Reklama1()
{
	SendClientMessageToAll(0xFFFFFFFF,"На этом месте может быть Ваша реклама.");
	SendClientMessageToAll(0xFFFFFFFF,"На этом месте может быть Ваша реклама.");
	return 1;
}

public Reklama2()
{
	for(new i = 0; i <MAX_PLAYERS; i++)//цикл для всех игроков
	{
		if(IsPlayerConnected(i))//дальнейшее выполняем если игрок в коннекте
		{
			if(GetPVarInt(i, "MnMode") == 1)
			{
				SendClientMessage(i,0xE0B080FF,"Помощь по радио: /radhelp  Помощь по командам сервера: /help  Игровое меню: Y или /menu");
			}
			else
			{
				SendClientMessage(i,0xE0B080FF,"Помощь по радио: /radhelp  Помощь по командам сервера: /help  Игровое меню: левый Alt , ''2'' , или /menu");
			}
		}
	}
	return 1;
}

