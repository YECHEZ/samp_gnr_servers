//==============================================================================
//                            Основные настройки
//==============================================================================

#define MOD55INS 1 //настройка команд /ipban и /ipunban:
//                 //MOD55INS 1 - команды доступны админам 3 и 4 lvl.
//                 //MOD55INS 2 - команды доступны ТОЛЬКО админу (админам) 4 lvl.

#define MOD66INS 0 //настройка команды /cc:
//                 //MOD66INS 0 - БЕЗ использования команды /cc.
//                 //MOD66INS 1 - С использованием команды /cc.

#define MOD77INS 1 //пикапы входов в полицию SF, дом Биг Смоука, интерьер
//                 //напротив мясной фабрики LV, и дом Вузи Му
//                 //MOD77INS 0 - НЕТ пикапов входа.
//                 //MOD77INS 1 - ЕСТЬ пикапы входа.

//   ВНИМАНИЕ !!! после изменения настроек ОБЯЗАТЕЛЬНО откомпилировать !!!
//==============================================================================
#if (MOD55INS < 1)
	#undef MOD55INS
	#define MOD55INS 1
#endif
#if (MOD55INS > 2)
	#undef MOD55INS
	#define MOD55INS 2
#endif
#if (MOD66INS < 0)
	#undef MOD66INS
	#define MOD66INS 0
#endif
#if (MOD66INS > 1)
	#undef MOD66INS
	#define MOD66INS 1
#endif
#if (MOD77INS < 0)
	#undef MOD77INS
	#define MOD77INS 0
#endif
#if (MOD77INS > 1)
	#undef MOD77INS
	#define MOD77INS 1
#endif

#include <a_samp>
#if (MOD77INS == 1)
	#include <streamer>
#endif

#undef MAX_PLAYERS
#define MAX_PLAYERS 101 //максимум игроков на сервере + 1 (если 50 игроков, то пишем 51 !!!)

#if (MAX_PLAYERS > 501)
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 501
#endif

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA

forward DatCor();//коррекция даты
forward TimCor();//коррекция времени
forward ReadCorTime();//чтение файла cortime.ini
forward dopfunction(per);//функция дальнего вызова для чтения коррекции времени
forward ini_GetKey( line[] );
forward ini_GetValue( line[] );
forward FPing2(playerid, para1, para2);
forward FPing3(playerid, para1, para2);
forward Prov1(playerid, para1, para2);
forward Prov2(playerid, para1, para2);
forward Prov3(playerid, para1, para2);
forward Prov4(playerid, para1, para2);
forward Prov5(playerid, para1, para2);
forward Prov6(playerid, para1, para2);
forward ReadData();//чтение файла keyscan.ini
forward SaveData();//запись файла keyscan.ini

forward SendAdminMessage(para1, para2, color, string[]);

new ipper[MAX_PLAYERS][4][32];//массив для команд /ipban и /ipunban
new timecor[8];//переменная коррекции времени 2
new CorTime[5];//переменная коррекции времени 1
new spectate[MAX_PLAYERS];
new mnhp;
new mnon;
new obj[4];
new razresh;
new Float:plarm, Float:plhp;
new pping1, pping2, pping3;
new pler1, pler2;
new plgl;
new plgldist;
new plloc[MAX_PLAYERS];
new pllocdist[MAX_PLAYERS];
#if (MOD77INS == 1)
	new Obj44;//ИД стандартного объекта
	new Pic44[8];//ИДы пикапов
#endif

public OnFilterScriptInit()
{
	print(" ");
	print("--------------------------------------");
	print("         Filterscript Keyscan          ");
	print("--------------------------------------\n");
	ReadCorTime();//чтение коррекции времени

	obj[0] = CreateObject(10826, 0.00, 0.00, 19500.00,   0.00, 0.00, 0.00);
	obj[1] = CreateObject(10826, 1543.85, -1353.98, 14500.00,   0.00, 0.00, 0.00);
	obj[2] = CreateObject(10826, -1981.03, 443.81, 9500.00,   0.00, 0.00, 0.00);
	obj[3] = CreateObject(10826, 2169.05, 1676.22, 4500.00,   0.00, 0.00, 0.00);
#if (MOD77INS == 1)
//  полиция SF
	Pic44[0] = CreateDynamicPickup(19198, 1, -1605.54, 710.57, 14.07, 0, 0, -1, 100.0);//создаём пикап входа
	Pic44[1] = CreateDynamicPickup(19198, 1, 242.54, 107.64, 1003.42, 0, 10, -1, 100.0);//создаём пикап выхода

//  объекты входа в дом Биг Смоука
	Obj44 = CreateObject(17946, 2533.82031, -1290.55469, 36.94530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2951, 2522.38208, -1276.85400, 33.71180,   0.00000, 0.00000, 90.00000, -1, 0, -1, 300.00);
	CreateDynamicObject(2951, 2522.38208, -1271.21252, 33.71180,   0.00000, 0.00000, 90.00000, -1, 0, -1, 300.00);
	CreateDynamicObject(2951, 2561.82544, -1279.31738, 1030.27173,   0.00000, 0.00000, 0.00000, -1, 2, -1, 300.00);
	Pic44[2] = CreateDynamicPickup(19198, 1, 2521.39, -1281.80, 34.85+0.25, 0, 0, -1, 100.0);//создаём пикап входа
	Pic44[3] = CreateDynamicPickup(19198, 1, 2522.85+0.25, -1272.62, 34.94+0.25, 0, 0, -1, 100.0);//создаём пикап выхода

//  интерьер напротив мясной фабрики LV
	Pic44[4] = CreateDynamicPickup(19198, 1, 1055.23-0.25, 2083.73, 10.82+0.25, 0, 0, -1, 100.0);//создаём пикап входа
	Pic44[5] = CreateDynamicPickup(19198, 1, 1056.03+0.25, 2091.85, 10.82+0.25, 0, 0, -1, 100.0);//создаём пикап выхода

//  дом Вузи Му
	Pic44[6] = CreateDynamicPickup(19198, 1, -2156.50+0.25, 645.36, 52.36+0.25, 0, 0, -1, 100.0);//создаём пикап входа
	Pic44[7] = CreateDynamicPickup(19198, 1, -2161.03, 643.11, 1052.37+0.25, 0, 1, -1, 100.0);//создаём пикап выхода
#endif

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		spectate[i] = 600;//отключаем ВСЕМ админам (и игрокам) функцию слежения
		plloc[i] = 0;//отключаем ВСЕМ админам (и игрокам) функцию краш-монитора
	}
	ReadData();//чтение файла keyscan.ini
	mnhp = 0;
	mnon = 0;
	razresh = 0;
	return 1;
}

public OnFilterScriptExit()
{
#if (MOD77INS == 1)
	DestroyObject(Obj44);//удаляем стандартный объект
	for(new i = 0; i < 8; i++)
	{
		DestroyDynamicPickup(Pic44[i]);//удаляем пикапы
	}
#endif
	DestroyObject(obj[0]);
	DestroyObject(obj[1]);
	DestroyObject(obj[2]);
	DestroyObject(obj[3]);
	razresh = 0;
	return 1;
}

public OnPlayerConnect(playerid)
{
	spectate[playerid] = 600;//отключаем админу (игроку) функцию слежения
	plloc[playerid] = 0;//отключаем админу (игроку) функцию краш-монитора
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new string[256];
    new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
	new Float:X, Float:Y, Float:Z;
	new Float:Xc, Float:Yc, Float:Zc, Float:ras;
	GetPlayerPos(playerid, X, Y, Z);
	for(new i = 0; i < MAX_PLAYERS; i++)//отключаем от keyscan игрока, за которым следили
	{
		if(IsPlayerConnected(i))
		{
			if(spectate[i] == playerid)
			{
				spectate[i] = 600;//отключаем от админа игрока, за которым следил админ
				SendClientMessage(i, COLOR_RED, " Игрок, за клавиатурой которого Вы следили,");
				SendClientMessage(i, COLOR_RED, " вышел с сервера, и был отключен от слежения.");
				GetPlayerName(i, sendername, sizeof(sendername));
				format(string, sizeof(string), "* Игрок %s был отключен от слежения за своей клавиатурой со стороны админа %s", giveplayer, sendername);
				print(string);
			}
			GetPlayerPos(i, Xc, Yc, Zc);
			new Float:locX, Float:locY, Float:locZ;
			locX = X - Xc;
			locY = Y - Yc;
			locZ = Z - Zc;
			if((reason == 0 || reason == 2) && playerid != i &&
			(-1000 < locX < 1000 && -1000 < locY < 1000 && -1000 < locZ < 1000))
			{
				ras = floatsqroot(floatmul(locX, locX) + floatmul(locY, locY) + floatmul(locZ, locZ));
				format(string, sizeof(string), "%f", ras);
				new dop1;
				dop1 = strval(string);
				GetPlayerName(i, sendername, sizeof(sendername));
				if(reason == 0)
				{
					format(string, sizeof(string), "* Краш-монитор - игрок ''вылетел'': %s [%d] , игрок рядом: %s [%d] , расстояние: %d", giveplayer, playerid, sendername, i, dop1);
				}
				if(reason == 2)
				{
					format(string, sizeof(string), "* Краш-монитор - игрок ''кик/бан'': %s [%d] , игрок рядом: %s [%d] , расстояние: %d", giveplayer, playerid, sendername, i, dop1);
				}
				if(plgl == 1 && plgldist >= dop1) { print(string); }
				SendAdminMessage(1, dop1, 0xFF6347FF, string);
			}
		}
	}
	spectate[playerid] = 600;//отключаем админу (игроку) функцию слежения
	plloc[playerid] = 0;//отключаем админу (игроку) функцию краш-монитора
	return 1;
}

public OnPlayerSpawn(playerid)
{
    new string[256];
	new giveplayer[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if (spectate[i] == playerid)
		{
			GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
			format(string, sizeof(string), " Игрок: %s [%d] (спавн, респавн)", giveplayer, playerid);
			SendClientMessage(i, COLOR_GREEN, string);
		}
	}
	return 1;
}

public SendAdminMessage(para1, para2, color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(GetPVarInt(i, "AdmLvl") >= 1 || IsPlayerAdmin(i))
		    {
				if(para1 == 0)
				{
					SendClientMessage(i, color, string);
				}
				if(para1 == 1 && plloc[i] == 1 && pllocdist[i] >= para2)
				{
					SendClientMessage(i, color, string);
				}
			}
		}
	}
	return 1;
}

stock ini_GetKey( line[] )
{
	new keyRes[256];
	keyRes[0] = 0;
    if ( strfind( line , "=" , true ) == -1 ) return keyRes;
    strmid( keyRes , line , 0 , strfind( line , "=" , true ) , sizeof( keyRes) );
    return keyRes;
}

stock ini_GetValue( line[] )
{
	new valRes[256];
	valRes[0]=0;
	if ( strfind( line , "=" , true ) == -1 ) return valRes;
	strmid( valRes , line , strfind( line , "=" , true )+1 , strlen( line ) , sizeof( valRes ) );
	return valRes;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[30];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

public OnPlayerText(playerid, text[])
{
    new string[256];
	new giveplayer[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if (spectate[i] == playerid)
		{
			GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
			format(string, sizeof(string), " Игрок: %s [%d] (чат) - %s", giveplayer, playerid, text);
			SendClientMessage(i, COLOR_GREEN, string);
		}
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(GetPVarInt(playerid, "CComAc1") < 0)
	{
		new dopcis, sstr[256];
		dopcis = FCislit(GetPVarInt(playerid, "CComAc1"));
		switch(dopcis)
		{
			case 0: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунд !", GetPVarInt(playerid, "CComAc1") * -1);
			case 1: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунду !", GetPVarInt(playerid, "CComAc1") * -1);
			case 2: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунды !", GetPVarInt(playerid, "CComAc1") * -1);
		}
		SendClientMessage(playerid, COLOR_RED, sstr);
		return 1;
	}
	SetPVarInt(playerid, "CComAc1", GetPVarInt(playerid, "CComAc1") + 1);
	new idx;
	idx = 0;
	new string[256];
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new cmd[256];
	new tmp[256];
	cmd = strtok(cmdtext, idx);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if (spectate[i] == playerid)
		{
			GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
			format(string, sizeof(string), " Игрок: %s [%d] (команда) - %s", giveplayer, playerid, cmdtext);
			SendClientMessage(i, COLOR_GREEN, string);
		}
	}
	if(strcmp(cmd, "/a2help", true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid,COLOR_GREY," -------------------------- Дополнительные команды -------------------------- ");
			SendClientMessage(playerid,COLOR_GREY,"   /a2help   /lctp[1-3]   /grtp[1-4]   /keyon [ид игрока]   /keyoff");
			SendClientMessage(playerid,COLOR_GREY,"   /tshp [ид игрока] ( дополнительно [корректор пинга(10-1000)] )");
			SendClientMessage(playerid,COLOR_GREY,"   /allonline [0- чат, 1- сервер-лог]   /scan [0- выкл., 1- вкл.]");
#if (MOD66INS == 0)
			SendClientMessage(playerid,COLOR_GREY,"   /ipban [IP-адрес]   /ipunban [IP-адрес]");
#endif
#if (MOD66INS == 1)
			SendClientMessage(playerid,COLOR_GREY,"   /ipban [IP-адрес]   /ipunban [IP-адрес]   /cc");
#endif
			SendClientMessage(playerid,COLOR_GREY,"   /plcmon [0- чат, 1- сервер-лог] [0- выкл., 1- вкл., 2- просмотреть настройки]");
			SendClientMessage(playerid,COLOR_GREY,"   ( дополнительно [дальность определения(10-1000)] )");
			SendClientMessage(playerid,COLOR_GREY," ---------------------------------------------------------------------------------------------- ");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
//------------------------------------------------------------------------------
//  примеры команд дополнительных телепортов
/*
	if (strcmp(cmd,"/tlp01",true) == 0)
	{
		if(GetPVarInt(playerid, "SecPris") > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
			return 1;
		}
		if(GetPVarInt(playerid, "PlFrost") == 1)
		{
			SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заморожены !");
			return 1;
		}
		SetPVarInt(playerid, "PlCRTp", 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 0.00, 0.00, 5.00);
		SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать на tlp01 !");
		return 1;
	}
	if (strcmp(cmd,"/tlp02",true) == 0)
	{
		if(GetPVarInt(playerid, "SecPris") > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
			return 1;
		}
		if(GetPVarInt(playerid, "PlFrost") == 1)
		{
			SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заморожены !");
			return 1;
		}
		SetPVarInt(playerid, "PlCRTp", 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 0.00, 0.00, 5.00);
		SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать на tlp02 !");
		return 1;
	}
	if (strcmp(cmd,"/tlp03",true) == 0)
	{
		if(GetPVarInt(playerid, "SecPris") > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
			return 1;
		}
		if(GetPVarInt(playerid, "PlFrost") == 1)
		{
			SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заморожены !");
			return 1;
		}
		SetPVarInt(playerid, "PlCRTp", 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 0.00, 0.00, 5.00);
		SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать на tlp03 !");
		return 1;
	}
*/
	if(strcmp(cmd, "/help2", true) == 0)
	{
		SendClientMessage(playerid,COLOR_GREY," -------------------------- Помощь по командам - 2 -------------------------- ");
		SendClientMessage(playerid,COLOR_GREEN,"   /help2   /ghelp   /rhelp   /mphelp   /dshelp   /bshelp   ...следующая команда...");
		SendClientMessage(playerid,COLOR_GREEN,"   ...следующая строка команд...");
		SendClientMessage(playerid,COLOR_GREEN,"   ...следующая строка команд...");
		SendClientMessage(playerid,COLOR_GREY," ------------------------------------------------------------------------------------------ ");

		new soob[2048];
		format(soob, sizeof(soob), "/help2 - Помощь по командам - 2\
		\n/ghelp - Помощь по Системе гаражей\
		\n/rhelp - Помощь по Системе гонок\
		\n/mphelp - Помощь по Системе мероприятий");
		format(soob, sizeof(soob), "%s\n/dshelp - Помощь по Системе дерби-сумо\
		\n/bshelp - Помощь по Системе динамических баз\
		\n...следующая строка...\
		\n...следующая строка...", soob);
		format(soob, sizeof(soob), "%s\n...следующая строка...\
		\n...следующая строка...\
		\n...следующая строка...\
		\n...следующая строка...", soob);
		format(soob, sizeof(soob), "%s\n...следующая строка...\
		\n...следующая строка...\
		\n...следующая строка...\
		\n...следующая строка...", soob);
		ShowPlayerDialog(playerid, 2, 0, "Помощь по командам - 2", soob, "OK", "");
		SetPVarInt(playerid, "DlgCont", 2);

    	return 1;
	}
	if (strcmp(cmd,"/lctp1",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -737.78, 486.74, 1371.98+1);
			SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать в Либерти Сити - 1 !");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/lctp2",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -785.24, 495.22, 1376.20+1);
			SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать в Либерти Сити - 2 !");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/lctp3",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -834.33, 503.97, 1358.30+1);
			SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать в Либерти Сити - 3 !");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/grtp1",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 0.00, 0.00, 19516.98+1);
			SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать на площадку - 1 !");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/grtp2",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1543.85, -1353.98, 14516.98+1);
			SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать на площадку - 2 !");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/grtp3",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -1981.03, 443.81, 9516.98+1);
			SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать на площадку - 3 !");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/grtp4",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2169.05, 1676.22, 4516.98+1);
			SendClientMessage(playerid, COLOR_GREEN, " Добро пожаловать на площадку - 4 !");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/keyon",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /keyon [ид игрока]");
				return 1;
			}
			new para1 = strval(tmp);
			if(GetPVarInt(playerid, "AdmLvl") <= 3 && GetPVarInt(para1, "AdmLvl") >= 4)
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не можете следить за клавиатурой админа 4-го уровня !");
				return 1;
			}
			if(IsPlayerConnected(para1))
			{
				if(spectate[playerid] == para1)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы уже следите за клавиатурой выбранного игрока !");
					return 1;
				}
				spectate[playerid] = para1;
				GetPlayerName(playerid, sendername, sizeof(sendername));
				GetPlayerName(para1, giveplayer, sizeof(giveplayer));
				format(string, sizeof(string), " *** Админ %s включил слежение за клавиатурой игрока %s .", sendername, giveplayer);
				print(string);
				SendAdminMessage(0, 0, COLOR_YELLOW, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/keyoff",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			spectate[playerid] = 600;
			GetPlayerName(playerid, sendername, sizeof(sendername));
			format(string, sizeof(string), " *** Админ %s отключил слежение за клавиатурой.", sendername);
			print(string);
			SendAdminMessage(0, 0, COLOR_RED, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/tshp",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /tshp [ид игрока] ( дополнительно [корректор пинга(10-1000)] )");
				return 1;
			}
			new para1 = strval(tmp);
			tmp = strtok(cmdtext, idx);
			new para2;
			if(!strlen(tmp))
			{
				para2 = 50;
			}
			else
			{
				para2 = strval(tmp);
			}
			if(para2 < 10 || para2 > 1000)
			{
				SendClientMessage(playerid, COLOR_RED, " Корректор пинга от 10 до 1000 !");
				return 1;
			}
			if(IsPlayerConnected(para1))
			{
				if(mnhp == 1)
				{
					SendClientMessage(playerid, COLOR_RED, " Команда занята другим админом !");
					return 1;
				}
				mnhp = 1;
				pler1 = 0;
				pler2 = 0;
				SendClientMessage(playerid, COLOR_GREEN, " Начало теста...");
				GetPlayerArmour(para1, plarm);
				GetPlayerHealth(para1, plhp);
				pping1 = GetPlayerPing(para1);
				SetTimerEx("FPing2", 500, 0, "iii", playerid, para1, para2);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/allonline",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /allonline [0- чат, 1- сервер-лог]");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(para1 < 0 || para1 > 1)
			{
				SendClientMessage(playerid, COLOR_RED, " 0- чат, 1- сервер-лог !");
				return 1;
			}
			if (para1 == 1 && (GetPVarInt(playerid, "AdmLvl") >= 1 && GetPVarInt(playerid, "AdmLvl") <= 3))
			{
				SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой опции !");
				return 1;
			}
			if(mnon == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Команда занята другим админом !");
				return 1;
			}
			mnon = 1;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(para1 == 0)
					{
						GetPlayerName(i, giveplayer, sizeof(giveplayer));
						format(string, sizeof(string), " *** ID: [%d] - %s", i, giveplayer);
						SendClientMessage(playerid, COLOR_GREEN, string);
					}
					else
					{
						GetPlayerName(i, giveplayer, sizeof(giveplayer));
						new aa333[64];//доработка для использования Русских ников
						format(aa333, sizeof(aa333), "%s", giveplayer);//доработка для использования Русских ников
						printf(" *** ID: [%d] - %s", i, aa333);//доработка для использования Русских ников
//						printf(" *** ID: [%d] - %s", i, giveplayer);
					}
				}
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			if(para1 == 0)
			{
				format(string, sizeof(string), " *** Админ %s создал список on-line игроков в собственном чате.", sendername);
			}
			else
			{
				format(string, sizeof(string), " *** Админ %s создал список on-line игроков в сервер-логе.", sendername);
			}
			print(string);
			SendAdminMessage(0, 0, COLOR_GREEN, string);
			mnon = 0;
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/scan",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 4 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /scan [0- выкл., 1- вкл.]");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(para1 < 0 || para1 > 1)
			{
				SendClientMessage(playerid, COLOR_RED, " 0- выкл., 1- вкл. !");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//доработка для использования Русских ников
			format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
			if(para1 == 0)
			{
			    if(razresh == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Скан функций уже выключен !");
					return 1;
				}
				else
				{
					print("--------------------------------------------------");
					print("--------------------------------------------------");
					print("--------------------------------------------------");
					printf("[KeyScan] *** Админ %s выключил скан функций.", aa333);//доработка для использования Русских ников
//					printf("[KeyScan] *** Админ %s выключил скан функций.", sendername);
					print("--------------------------------------------------");
					print("--------------------------------------------------");
					print("--------------------------------------------------");
					SendClientMessage(playerid, COLOR_RED, " Вы выключили скан функций.");
					razresh = 0;
				}
			}
			if(para1 == 1)
			{
			    if(razresh == 1)
				{
					SendClientMessage(playerid, COLOR_RED, " Скан функций уже включен !");
					return 1;
				}
				else
				{
					print("++++++++++++++++++++++++++++++++++++++++++++++++++");
					print("++++++++++++++++++++++++++++++++++++++++++++++++++");
					print("++++++++++++++++++++++++++++++++++++++++++++++++++");
					printf("[KeyScan] *** Админ %s выключил скан функций.", aa333);//доработка для использования Русских ников
//					printf("[KeyScan] *** Админ %s выключил скан функций.", sendername);
					print("++++++++++++++++++++++++++++++++++++++++++++++++++");
					print("++++++++++++++++++++++++++++++++++++++++++++++++++");
					print("++++++++++++++++++++++++++++++++++++++++++++++++++");
					SendClientMessage(playerid, COLOR_GREEN, " Вы включили скан функций.");
					razresh = 1;
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/ipban",true) == 0)
	{
#if (MOD55INS == 1)
		if (GetPVarInt(playerid, "AdmLvl") >= 3 || IsPlayerAdmin(playerid))
#endif
#if (MOD55INS == 2)
		if (GetPVarInt(playerid, "AdmLvl") >= 4 || IsPlayerAdmin(playerid))
#endif
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /ipban [IP-адрес]");
				return 1;
			}
			new dltmp;
			dltmp = strlen(tmp);
			if(dltmp < 7 || dltmp > 15)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина IP-адреса должна быть от 7 до 15 символов !");
				return 1;
			}
			new dopper111 = 0;
			new dopper222 = 0;
			for(new i = 0; i < dltmp; i++)
			{
				if((tmp[i] < 48 || tmp[i] > 57) && tmp[i] != '.' && tmp[i] != '*') {dopper111 = 1;}
				if(tmp[i] == '.') {dopper222++;}
			}
			if(dopper111 == 1 || dopper222 != 3)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			for(new i = 0; i < 4; i++)//очистка локальной части массива ipper
			{
				for(new j = 0; j < 32; j++)
				{
					ipper[playerid][i][j] = 0;
				}
			}
			new ind1, ind2;//разделение IP-адреса
			ind1 = -1;
			for(new i = 0; i < 4; i++)
			{
				ind1++;
				ind2 = 0;
				while(tmp[ind1] != '.')
				{
					if(ind1 > dltmp)
					{
						break;
					}
					ipper[playerid][i][ind2] = tmp[ind1];
					ind1++;
					ind2++;
				}
			}
			dopper111 = 0;
			for(new i = 0; i < 4; i++)
			{
				if(strlen(ipper[playerid][i]) < 1 || strlen(ipper[playerid][i]) > 3) {dopper111 = 1;}
			}
    		if(dopper111 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
    		if(strfind(ipper[playerid][0], "*", true) != -1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   IP-адрес НЕ может начинаться с шаблона !");
				return 1;
			}
    		if(strval(ipper[playerid][0]) > 255)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
    		if((strfind(ipper[playerid][1], "*", true) == -1 && strfind(ipper[playerid][2], "*", true) != -1 && strfind(ipper[playerid][3], "*", true) == -1) ||
			(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 && strfind(ipper[playerid][3], "*", true) == -1) ||
			(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 && strfind(ipper[playerid][3], "*", true) != -1) ||
			(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) != -1 && strfind(ipper[playerid][3], "*", true) == -1))
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
			new ind3 = 1;//проверка местоположения "*" в каждой из групп цифр,
			new ind4 = 0;//И проверка каждой группы цифр на максимально допустимый адрес
			new ind5 = 0;
			while(ind3 < 4)
			{
				if(strlen(ipper[playerid][ind3]) == 2)
				{
					if(ipper[playerid][ind3][0] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
				}
				if(strlen(ipper[playerid][ind3]) == 3)
				{
					if(ipper[playerid][ind3][0] == '*' || ipper[playerid][ind3][1] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
					if(ipper[playerid][ind3][2] == '*')
					{
    					if(strval(ipper[playerid][ind3]) > 25) {ind4 = 1;}
					}
					if(ipper[playerid][ind3][2] != '*')
					{
    					if(strval(ipper[playerid][ind3]) > 255) {ind5 = 1;}
					}
				}
				ind3++;
			}
    		if(ind4 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
    		if(ind5 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			for(new i = 1; i < 4; i++)//замена символов "*" на символы "C"
			{
				new mm;
				mm = strlen(ipper[playerid][i]);
				for(new j = 0; j < mm; j++)
				{
					if(ipper[playerid][i][j] == '*') {ipper[playerid][i][j] = 'C';}
				}
			}
			new ip333[128];//сборка имени файла
			format(ip333, sizeof(ip333), "%s_%s_%s_%s", ipper[playerid][0], ipper[playerid][1], ipper[playerid][2], ipper[playerid][3]);

			GetPlayerName(playerid, sendername, sizeof(sendername));
			new string222[256];
			new reason[128];//запись в бан-лист
			format(reason, 128, "(команда /ipban) --- Админ: [ %s ]", sendername);//формируем метку админа
			gettime(timecor[0], timecor[1]);
			getdate(timecor[2], timecor[3], timecor[4]);
			TimCor();//коррекция времени
			DatCor();//коррекция даты
			new stringdop[256];
			format(stringdop,256,"[%02d:%02d | %02d/%02d/%04d] - %s",timecor[0],timecor[1],timecor[4],timecor[3],timecor[2],reason);
			format(string222,sizeof(string222),"banlist/ipadr/%s.ini",ip333);
			new File: hFile = fopen(string222, io_write);//запись файла
			if (hFile)
			{
				new var[256];
				format(var, 256, "Data=%s\n",stringdop);fwrite(hFile, var);
				fclose(hFile);
			}

			new dopper33[256];//бан IP-адреса
			strdel(dopper33, 0, 256);
			strcat(dopper33, "banip ");
			strcat(dopper33, tmp);
			SendRconCommand(dopper33);
			SendRconCommand("reloadbans");
			format(string, sizeof(string), " *** Админ %s забанил IP адрес: [%s]", sendername, tmp);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if (strcmp(cmd,"/ipunban",true) == 0)
	{
#if (MOD55INS == 1)
		if (GetPVarInt(playerid, "AdmLvl") >= 3 || IsPlayerAdmin(playerid))
#endif
#if (MOD55INS == 2)
		if (GetPVarInt(playerid, "AdmLvl") >= 4 || IsPlayerAdmin(playerid))
#endif
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /ipunban [IP-адрес]");
				return 1;
			}
			new dltmp;
			dltmp = strlen(tmp);
			if(dltmp < 7 || dltmp > 15)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина IP-адреса должна быть от 7 до 15 символов !");
				return 1;
			}
			new dopper111 = 0;
			new dopper222 = 0;
			for(new i = 0; i < dltmp; i++)
			{
				if((tmp[i] < 48 || tmp[i] > 57) && tmp[i] != '.' && tmp[i] != '*') {dopper111 = 1;}
				if(tmp[i] == '.') {dopper222++;}
			}
			if(dopper111 == 1 || dopper222 != 3)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			for(new i = 0; i < 4; i++)//очистка локальной части массива ipper
			{
				for(new j = 0; j < 32; j++)
				{
					ipper[playerid][i][j] = 0;
				}
			}
			new ind1, ind2;//разделение IP-адреса
			ind1 = -1;
			for(new i = 0; i < 4; i++)
			{
				ind1++;
				ind2 = 0;
				while(tmp[ind1] != '.')
				{
					if(ind1 > dltmp)
					{
						break;
					}
					ipper[playerid][i][ind2] = tmp[ind1];
					ind1++;
					ind2++;
				}
			}
			dopper111 = 0;
			for(new i = 0; i < 4; i++)
			{
				if(strlen(ipper[playerid][i]) < 1 || strlen(ipper[playerid][i]) > 3) {dopper111 = 1;}
			}
    		if(dopper111 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
    		if(strfind(ipper[playerid][0], "*", true) != -1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   IP-адрес НЕ может начинаться с шаблона !");
				return 1;
			}
    		if(strval(ipper[playerid][0]) > 255)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
    		if((strfind(ipper[playerid][1], "*", true) == -1 && strfind(ipper[playerid][2], "*", true) != -1 && strfind(ipper[playerid][3], "*", true) == -1) ||
			(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 && strfind(ipper[playerid][3], "*", true) == -1) ||
			(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 && strfind(ipper[playerid][3], "*", true) != -1) ||
			(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) != -1 && strfind(ipper[playerid][3], "*", true) == -1))
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
			new ind3 = 1;//проверка местоположения "*" в каждой из групп цифр,
			new ind4 = 0;//И проверка каждой группы цифр на максимально допустимый адрес
			new ind5 = 0;
			while(ind3 < 4)
			{
				if(strlen(ipper[playerid][ind3]) == 2)
				{
					if(ipper[playerid][ind3][0] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
				}
				if(strlen(ipper[playerid][ind3]) == 3)
				{
					if(ipper[playerid][ind3][0] == '*' || ipper[playerid][ind3][1] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
					if(ipper[playerid][ind3][2] == '*')
					{
    					if(strval(ipper[playerid][ind3]) > 25) {ind4 = 1;}
					}
					if(ipper[playerid][ind3][2] != '*')
					{
    					if(strval(ipper[playerid][ind3]) > 255) {ind5 = 1;}
					}
				}
				ind3++;
			}
    		if(ind4 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
    		if(ind5 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			for(new i = 1; i < 4; i++)//замена символов "*" на символы "C"
			{
				new mm;
				mm = strlen(ipper[playerid][i]);
				for(new j = 0; j < mm; j++)
				{
					if(ipper[playerid][i][j] == '*') {ipper[playerid][i][j] = 'C';}
				}
			}
			new ip333[128];//сборка имени файла
			format(ip333, sizeof(ip333), "%s_%s_%s_%s", ipper[playerid][0], ipper[playerid][1], ipper[playerid][2], ipper[playerid][3]);
			new dopper33[256];//разбан IP-адреса
			strdel(dopper33, 0, 256);
			strcat(dopper33, "unbanip ");
			strcat(dopper33, tmp);
			SendRconCommand(dopper33);
			SendRconCommand("reloadbans");
			GetPlayerName(playerid, sendername, sizeof(sendername));
			format(string, sizeof(string), " *** Админ %s разбанил IP адрес: [%s]", sendername, tmp);
			print(string);
			SendClientMessageToAll(COLOR_GREEN, string);

			new string222[256];
			format(string222,sizeof(string222),"banlist/ipadr/%s.ini",ip333);
			if(fexist(string222))
			{
				fremove(string222);//удаляем IP-адрес из бан-листа
				format(string,sizeof(string)," ( IP-адрес [%s] был удалён из бан-листа ) !", tmp);
				print(string);
				SendClientMessage(playerid, COLOR_GREEN, string);
			}

		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
#if (MOD66INS == 1)
	if (strcmp(cmd,"/cc",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			for(new i=0; i<150; i++)
			{
				SendClientMessageToAll(0xFFFFFFFF, " ");
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			format(string, sizeof(string), " *** Админ %s очистил чат сервера !", sendername);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
#endif
	if (strcmp(cmd,"/plcmon",true) == 0)
	{
		if (GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /plcmon [0- чат, 1- сервер-лог] [0- выкл., 1- вкл.,");
				SendClientMessage(playerid, COLOR_GRAD2, " 2- просмотреть настройки] ( дополнительно [дальность определения(10-1000)] )");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(para1 < 0 || para1 > 1)
			{
				SendClientMessage(playerid, COLOR_RED, " 0- чат, 1- сервер-лог !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			new para2;
			para2 = strval(tmp);
			if(para2 < 0 || para2 > 2)
			{
				SendClientMessage(playerid, COLOR_RED, " 0- выкл., 1- вкл., 2- просмотреть настройки !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			new para3;
			new para4;
			if(!strlen(tmp))
			{
				para3 = 500;
				para4 = 0;
			}
			else
			{
				para3 = strval(tmp);
				para4 = 1;
			}
			if(para3 < 10 || para3 > 1000)
			{
				SendClientMessage(playerid, COLOR_RED, " Дальность определения от 10 до 1000 !");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//доработка для использования Русских ников
			format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
			if(para1 == 0)
			{
				if(para2 == 0)
				{
					if(plloc[playerid] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Краш-монитор в чате уже отключен !");
						return 1;
					}
					else
					{
						plloc[playerid] = 0;
						format(string, sizeof(string), " *** Админ %s отключил краш-монитор в чате.", aa333);
						print(string);
						SendAdminMessage(0, 0, COLOR_RED, string);
						return 1;
					}
				}
				if(para2 == 1)
				{
					if(plloc[playerid] == 1 && para4 == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Вы не задали дальность определения !");
						return 1;
					}
					if(plloc[playerid] == 1 && para4 == 1 && pllocdist[playerid] == para3)
					{
						SendClientMessage(playerid, COLOR_RED, " Вы задали старую дальность определения !");
						return 1;
					}
					if(plloc[playerid] == 1 && para4 == 1 && pllocdist[playerid] != para3)
					{
						pllocdist[playerid] = para3;
						format(string, sizeof(string), " *** Админ %s изменил дальность определения для краш-монитора в чате на %d", aa333, pllocdist[playerid]);
						print(string);
						SendAdminMessage(0, 0, COLOR_GREEN, string);
						return 1;
					}
					if(plloc[playerid] == 0)
					{
						plloc[playerid] = 1;
						pllocdist[playerid] = para3;
						format(string, sizeof(string), " *** Админ %s включил краш-монитор в чате, с дальностью определения %d", aa333, pllocdist[playerid]);
						print(string);
						SendAdminMessage(0, 0, COLOR_GREEN, string);
						return 1;
					}
				}
				if(para2 == 2)
				{
					if(plloc[playerid] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Краш-монитор в чате отключен.");
						return 1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_YELLOW, "--------------------------------------------------");
						SendClientMessage(playerid, COLOR_GREEN, " Краш-монитор в чате включен.");
						format(string, sizeof(string), " Дальность определения: {FFFF00}%d .", pllocdist[playerid]);
						SendClientMessage(playerid, COLOR_GREEN, string);
						SendClientMessage(playerid, COLOR_YELLOW, "--------------------------------------------------");
						printf(" *** Админ %s просмотрел настройки краш-монитора в чате.", aa333);
						return 1;
					}
				}
			}
			if(para1 == 1)
			{
				if(GetPVarInt(playerid, "AdmLvl") <= 3)
				{
					SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой опции !");
					return 1;
				}
				if(para2 == 0)
				{
					if(plgl == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Краш-монитор в сервер-логе уже отключен !");
						return 1;
					}
					else
					{
						plgl = 0;
						SaveData();//запись файла keyscan.ini
						format(string, sizeof(string), " *** Админ %s отключил краш-монитор в сервер-логе.", aa333);
						print(string);
						SendAdminMessage(0, 0, COLOR_RED, string);
						return 1;
					}
				}
				if(para2 == 1)
				{
					if(plgl == 1 && para4 == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Вы не задали дальность определения !");
						return 1;
					}
					if(plgl == 1 && para4 == 1 && plgldist == para3)
					{
						SendClientMessage(playerid, COLOR_RED, " Вы задали старую дальность определения !");
						return 1;
					}
					if(plgl == 1 && para4 == 1 && plgldist != para3)
					{
						plgldist = para3;
						SaveData();//запись файла keyscan.ini
						format(string, sizeof(string), " *** Админ %s изменил дальность определения для краш-монитора в сервер-логе на %d", aa333, plgldist);
						print(string);
						SendAdminMessage(0, 0, COLOR_GREEN, string);
						return 1;
					}
					if(plgl == 0)
					{
						plgl = 1;
						plgldist = para3;
						SaveData();//запись файла keyscan.ini
						format(string, sizeof(string), " *** Админ %s включил краш-монитор в сервер-логе, с дальностью определения %d", aa333, plgldist);
						print(string);
						SendAdminMessage(0, 0, COLOR_GREEN, string);
						return 1;
					}
				}
				if(para2 == 2)
				{
					if(plgl == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Краш-монитор в сервер-логе отключен.");
						return 1;
					}
					else
					{
						SendClientMessage(playerid, COLOR_YELLOW, "--------------------------------------------------");
						SendClientMessage(playerid, COLOR_GREEN, " Краш-монитор в сервер-логе включен.");
						format(string, sizeof(string), " Дальность определения: {FFFF00}%d .", plgldist);
						SendClientMessage(playerid, COLOR_GREEN, string);
						SendClientMessage(playerid, COLOR_YELLOW, "--------------------------------------------------");
						printf(" *** Админ %s просмотрел настройки краш-монитора в сервер-логе.", aa333);
						return 1;
					}
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(GetPVarInt(playerid, "DlgCont") == -600)//если НЕ существующий ИД диалога, то:
	{
		return 1;//завершаем функцию
	}
	if(dialogid == 2)
	{
		if(dialogid != GetPVarInt(playerid, "DlgCont"))
		{
			SetPVarInt(playerid, "DlgCont", -600);//не существующий ИД диалога
			return 1;
		}
		SetPVarInt(playerid, "DlgCont", -600);//не существующий ИД диалога
		return 1;
	}
	return 0;
}

public FPing2(playerid, para1, para2)
{
	pping2 = GetPlayerPing(para1);
	SetTimerEx("FPing3", 500, 0, "iii", playerid, para1, para2);
	return 1;
}

public FPing3(playerid, para1, para2)
{
	pping3 = GetPlayerPing(para1);
	new string[256];
	new dopper;
	dopper = (((pping1 + pping2 + pping3) / 3) * 2) + para2;
	format(string, sizeof(string), " Средний пинг: %d (при тесте: %d)", (dopper - para2) / 2, dopper);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	SetPlayerArmour(para1, 90.00);
	SetTimerEx("Prov1", dopper, 0, "iii", playerid, para1, dopper);
	return 1;
}

public Prov1(playerid, para1, para2)
{
	new Float:dopper;
	GetPlayerArmour(para1, dopper);
	if(dopper <= 87.00 || dopper >= 93.00)
	{
		pler1 = 1;
	}
	SetPlayerArmour(para1, 60.00);
	SetTimerEx("Prov2", para2, 0, "iii", playerid, para1, para2);
	return 1;
}

public Prov2(playerid, para1, para2)
{
	new Float:dopper;
	GetPlayerArmour(para1, dopper);
	if(dopper <= 57.00 || dopper >= 63.00)
	{
		pler1 = 1;
	}
	SetPlayerArmour(para1, 30.00);
	SetTimerEx("Prov3", para2, 0, "iii", playerid, para1, para2);
	return 1;
}

public Prov3(playerid, para1, para2)
{
	new Float:dopper;
	GetPlayerArmour(para1, dopper);
	if(dopper <= 27.00 || dopper >= 33.00)
	{
		pler1 = 1;
	}
	SetPlayerHealth(para1, 90.00);
	SetTimerEx("Prov4", para2, 0, "iii", playerid, para1, para2);
	return 1;
}

public Prov4(playerid, para1, para2)
{
	new Float:dopper;
	GetPlayerHealth(para1, dopper);
	if(dopper <= 87.00 || dopper >= 93.00)
	{
		pler2 = 1;
	}
	SetPlayerHealth(para1, 60.00);
	SetTimerEx("Prov5", para2, 0, "iii", playerid, para1, para2);
	return 1;
}

public Prov5(playerid, para1, para2)
{
	new Float:dopper;
	GetPlayerHealth(para1, dopper);
	if(dopper <= 57.00 || dopper >= 63.00)
	{
		pler2 = 1;
	}
	SetPlayerHealth(para1, 30.00);
	SetTimerEx("Prov6", para2, 0, "iii", playerid, para1, para2);
	return 1;
}

public Prov6(playerid, para1, para2)
{
	new Float:dopper;
	GetPlayerHealth(para1, dopper);
	if(dopper <= 27.00 || dopper >= 33.00)
	{
		pler2 = 1;
	}
	SetPlayerArmour(para1, plarm);
	SetPlayerHealth(para1, plhp);
	new string[256];
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	GetPlayerName(para1, giveplayer, sizeof(giveplayer));
	format(string, sizeof(string), " *** Админ %s протестировал игрока %s на hp.", sendername, giveplayer);
	print(string);
	SendAdminMessage(0, 0, COLOR_YELLOW, string);
	if(pler1 == 0 && pler2 == 0)
	{
		format(string, sizeof(string), " Игрок %s [%d]: {33AA33}броня - ок, жизнь - ок", giveplayer, para1);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		mnhp = 0;
		return 1;
	}
	if(pler1 == 1 && pler2 == 0)
	{
		format(string, sizeof(string), " Игрок %s [%d]: {AA3333}броня - ошибка, {33AA33}жизнь - ок", giveplayer, para1);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		mnhp = 0;
		return 1;
	}
	if(pler1 == 0 && pler2 == 1)
	{
		format(string, sizeof(string), " Игрок %s [%d]: {33AA33}броня - ок, {AA3333}жизнь - ошибка", giveplayer, para1);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		mnhp = 0;
		return 1;
	}
	if(pler1 == 1 && pler2 == 1)
	{
		format(string, sizeof(string), " Игрок %s [%d]: {AA3333}броня - ошибка, жизнь - ошибка", giveplayer, para1);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		mnhp = 0;
		return 1;
	}
	return 1;
}

#if (MOD77INS == 1)
	public OnPlayerPickUpDynamicPickup(playerid, pickupid)
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(pickupid == Pic44[0])//вход в полицию SF
			{
	 			SetPlayerInterior(playerid, 10);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, 246.38, 109.25, 1003.22);
				SetPlayerFacingAngle(playerid, 0.00);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(pickupid == Pic44[1])//выход из полиции SF
			{
	 			SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, -1605.8, 717.13, 12.03);
				SetPlayerFacingAngle(playerid, 0.00);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(pickupid == Pic44[2])//вход в дом Биг Смоука
			{
	 			SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, 2529.81, -1272.87, 34.95+1);
				SetPlayerFacingAngle(playerid, 271.52);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(pickupid == Pic44[3])//выход из дома Биг Смоука
			{
	 			SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, 2519.56, -1272.70, 34.88+1);
				SetPlayerFacingAngle(playerid, 2.05);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(pickupid == Pic44[4])//вход в интерьер напротив мясной фабрики LV
			{
	 			SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, 1062.26, 2083.99, 10.82+1);
				SetPlayerFacingAngle(playerid, 271.82);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(pickupid == Pic44[5])//выход из интерьера напротив мясной фабрики LV
			{
	 			SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, 1050.04, 2092.07, 10.82+1);
				SetPlayerFacingAngle(playerid, 88.92);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(pickupid == Pic44[6])//вход в дом Вузи Му
			{
	 			SetPlayerInterior(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, -2165.17, 641.88, 1052.37+1);
				SetPlayerFacingAngle(playerid, 89.47);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(pickupid == Pic44[7])//выход из дома Вузи Му
			{
	 			SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, -2154.09, 640.23, 52.36+1);
				SetPlayerFacingAngle(playerid, 179.58);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
		}
		return 1;
	}
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(razresh == 1)
	{
    	new sendername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new aa333[64];//доработка для использования Русских ников
		format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
		printf("[KeyScan][key] %s [%d] - %d ... %d", aa333, playerid, newkeys, oldkeys);//доработка для использования Русских ников
//		printf("[KeyScan][key] %s [%d] - %d ... %d", sendername, playerid, newkeys, oldkeys);
	}
    new string[256];
	new giveplayer[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if (spectate[i] == playerid)
		{
			new data;
			data = newkeys - oldkeys;
			if (data > 0)
			{
				GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
				switch(data)
				{
					case 1: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Действие", giveplayer, playerid);
					case 2: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Присесть", giveplayer, playerid);
					case 4: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Огонь", giveplayer, playerid);
					case 8: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Бежать", giveplayer, playerid);
					case 16: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Вторичная атака", giveplayer, playerid);
					case 32: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Прыжок", giveplayer, playerid);
					case 64: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Смотреть вправо", giveplayer, playerid);
					case 128: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Ручной тормоз, (назад или вправо)", giveplayer, playerid);
					case 132: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - {FFFF00}Ручной тормоз-2", giveplayer, playerid);
					case 256: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Смотреть влево", giveplayer, playerid);
					case 512: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Субмиссия или смотреть назад", giveplayer, playerid);
					case 1024: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Идти шагом", giveplayer, playerid);
					case 2048: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Вверх (цифр. клав.)", giveplayer, playerid);
					case 4096: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Вниз (цифр. клав.)", giveplayer, playerid);
					case 8192: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Влево (цифр. клав.)", giveplayer, playerid);
					case 16384: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Вправо (цифр. клав.)", giveplayer, playerid);
					case 65408: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Вперёд или влево", giveplayer, playerid);
					case 65536: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - {FFFF00}Ответ: ДА", giveplayer, playerid);
					case 131072: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - {FFFF00}Ответ: НЕТ", giveplayer, playerid);
					case 262144: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - Контроль группы", giveplayer, playerid);
					case 264192: format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - {FFFF00}Радио вниз", giveplayer, playerid);
				}
				if (data == 1 || data == 2 || data == 4 || data == 8 || data == 16 || data == 32 || data == 64 || data == 128 ||
				data == 132 || data == 256 || data == 512 || data == 1024 || data == 2048 || data == 4096 || data == 8192 ||
				data == 16384 || data == 65408 || data == 65536 || data == 131072 || data == 262144 || data == 264192)
				{
					SendClientMessage(i, COLOR_GREEN, string);
				}
				if (data != 1 && data != 2 && data != 4 && data != 8 && data != 16 && data != 32 && data != 64 && data != 128 &&
				data != 132 && data != 256 && data != 512 && data != 1024 && data != 2048 && data != 4096 && data != 8192 &&
				data != 16384 && data != 65408 && data != 65536 && data != 131072 && data != 262144 && data != 264192 &&
				(data > 0 && data < 8192))
				{
					format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - {FFFF00}Совмещённый код (%d)", giveplayer, playerid, data);
					SendClientMessage(i, COLOR_GREEN, string);
				}
				if (data != 1 && data != 2 && data != 4 && data != 8 && data != 16 && data != 32 && data != 64 && data != 128 &&
				data != 132 && data != 256 && data != 512 && data != 1024 && data != 2048 && data != 4096 && data != 8192 &&
				data != 16384 && data != 65408 && data != 65536 && data != 131072 && data != 262144 && data != 264192 &&
				data > 8192)
				{
					format(string, sizeof(string), " Игрок: %s [%d] (клавиатура) - {FF0000}Неопределённый код (%d)", giveplayer, playerid, data);
					SendClientMessage(i, COLOR_GREEN, string);
				}
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(razresh == 1)
	{
    	new sendername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new aa333[64];//доработка для использования Русских ников
		format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
		printf("[KeyScan][click] %s [%d] - %d ... %d", aa333, playerid, clickedplayerid, source);//доработка для использования Русских ников
//		printf("[KeyScan][click] %s [%d] - %d ... %d", sendername, playerid, clickedplayerid, source);
	}
    new string[256];
	new giveplayer[MAX_PLAYER_NAME];
	new targetname[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if (spectate[i] == playerid)
		{
			GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
			GetPlayerName(clickedplayerid, targetname, sizeof(targetname));
			format(string, sizeof(string), " Игрок: %s [%d] {FF0000}(клик по игроку){33AA33} - %s [%d]", giveplayer, playerid, targetname, clickedplayerid);
			SendClientMessage(i, COLOR_GREEN, string);
		}
	}
	return 1;
}

public DatCor()
{
	new Float:flyear;
	timecor[3] = timecor[3] + CorTime[3];//обработка месяца
	timecor[5] = 0;//перенос на год
	if(timecor[3] < 1)
	{
		timecor[3] = 12 + timecor[3];
		timecor[5] = -1;//перенос на год
	}
	if(timecor[3] > 12)
	{
		timecor[3] = timecor[3] - 12;
		timecor[5] = 1;//перенос на год
	}
	timecor[2] = timecor[2] + CorTime[4] + timecor[5];//обработка года
	flyear = float(timecor[2]);
	flyear = floatdiv(flyear, 4);
	flyear = floatfract(flyear);
	if(flyear != 0){timecor[7] = 0;}//НЕ високосный год
	if(flyear == 0){timecor[7] = 1;}//високосный год
	timecor[4] = timecor[4] + CorTime[2] + timecor[6];//обработка числа
	timecor[5] = 0;//перенос на месяц
	if(timecor[4] < 1 && timecor[3] == 3 && timecor[7] == 0)
	{
		timecor[4] = 28 + timecor[4];
		timecor[5] = -1;//перенос на месяц
	}
	if(timecor[4] < 1 && timecor[3] == 3 && timecor[7] == 1)
	{
		timecor[4] = 29 + timecor[4];
		timecor[5] = -1;//перенос на месяц
	}
	if(timecor[4] < 1 && (timecor[3] == 5 || timecor[3] == 7 || timecor[3] == 10 || timecor[3] == 12))
	{
		timecor[4] = 30 + timecor[4];
		timecor[5] = -1;//перенос на месяц
	}
	if(timecor[4] < 1 && (timecor[3] == 2 || timecor[3] == 4 || timecor[3] == 6 || timecor[3] == 8 || timecor[3] == 9 || timecor[3] == 11 || timecor[3] == 1))
	{
		timecor[4] = 31 + timecor[4];
		timecor[5] = -1;//перенос на месяц
	}
	if(timecor[4] > 28 && timecor[3] == 2 && timecor[7] == 0)
	{
		timecor[4] = timecor[4] - 28;
		timecor[5] = 1;//перенос на месяц
	}
	if(timecor[4] > 29 && timecor[3] == 2 && timecor[7] == 1)
	{
		timecor[4] = timecor[4] - 29;
		timecor[5] = 1;//перенос на месяц
	}
	if(timecor[4] > 30 && (timecor[3] == 4 || timecor[3] == 6 || timecor[3] == 9 || timecor[3] == 11))
	{
		timecor[4] = timecor[4] - 30;
		timecor[5] = 1;//перенос на месяц
	}
	if(timecor[4] > 31 && (timecor[3] == 1 || timecor[3] == 3 || timecor[3] == 5 || timecor[3] == 7 || timecor[3] == 8 || timecor[3] == 10 || timecor[3] == 12))
	{
		timecor[4] = timecor[4] - 31;
		timecor[5] = 1;//перенос на месяц
	}
	timecor[3] = timecor[3] + timecor[5];//коррекция месяца
	timecor[5] = 0;//перенос на год
	if(timecor[3] < 1)
	{
		timecor[3] = 12 + timecor[3];
		timecor[5] = -1;//перенос на год
	}
	if(timecor[3] > 12)
	{
		timecor[3] = timecor[3] - 12;
		timecor[5] = 1;//перенос на год
	}
	timecor[2] = timecor[2] + timecor[5];//коррекция года
	return 1;
}

public TimCor()
{
	timecor[1] = timecor[1] + CorTime[1];//обработка минут
	timecor[5] = 0;//перенос на час
	if(timecor[1] < 0)
	{
		timecor[1] = 60 + timecor[1];
		timecor[5] = -1;//перенос на час
	}
	if(timecor[1] > 59)
	{
		timecor[1] = timecor[1] - 60;
		timecor[5] = 1;//перенос на час
	}
	timecor[0] = timecor[0] + CorTime[0] + timecor[5];//обработка часов
	timecor[6] = 0;//перенос на день
	if(timecor[0] < 0)
	{
		timecor[0] = 24 + timecor[0];
		timecor[6] = -1;//перенос на день
	}
	if(timecor[0] > 23)
	{
		timecor[0] = timecor[0] - 24;
		timecor[6] = 1;//перенос на день
	}
	return 1;
}

public ReadCorTime()
{
	new string[256];
	format(string,sizeof(string),"data/cortime.ini");
	new File: UserFile = fopen(string, io_read);//чтение файла
	new key[ 256 ] , val[ 256 ];
	new Data[ 256 ];
	while ( fread( UserFile , Data , sizeof( Data ) ) )
	{
		key = ini_GetKey( Data );
		if( strcmp( key , "hour" , true ) == 0 ) { val = ini_GetValue( Data ); CorTime[0] = strval( val ); }
		if( strcmp( key , "minute" , true ) == 0 ) { val = ini_GetValue( Data ); CorTime[1] = strval( val ); }
		if( strcmp( key , "day" , true ) == 0 ) { val = ini_GetValue( Data ); CorTime[2] = strval( val ); }
		if( strcmp( key , "month" , true ) == 0 ) { val = ini_GetValue( Data ); CorTime[3] = strval( val ); }
		if( strcmp( key , "year" , true ) == 0 ) { val = ini_GetValue( Data ); CorTime[4] = strval( val ); }
	}
	fclose(UserFile);
	return 1;
}

public dopfunction(per)
{
	SetTimer("ReadCorTime",500,0);//задержка чтения (на время записи файла cortime.ini модом)
	return 1;
}

public ReadData()
{
	new string[256];
	format(string,sizeof(string),"data/keyscan.ini");
	new File: UserFile = fopen(string, io_read);//чтение файла
	new key[ 256 ] , val[ 256 ];
	new Data[ 256 ];
	while ( fread( UserFile , Data , sizeof( Data ) ) )
	{
		key = ini_GetKey( Data );
		if( strcmp( key , "SLMon" , true ) == 0 ) { val = ini_GetValue( Data ); plgl = strval( val ); }
		if( strcmp( key , "SLMonDist" , true ) == 0 ) { val = ini_GetValue( Data ); plgldist = strval( val ); }
	}
	fclose(UserFile);
	return 1;
}

public SaveData()
{
	new string[256];
	format(string,sizeof(string),"data/keyscan.ini");
	new File: hFile = fopen(string, io_write);//запись файла
	if (hFile)
	{
		new var[32];
		format(var, 32, "SLMon=%d\n",plgl);fwrite(hFile, var);
		format(var, 32, "SLMonDist=%d\n",plgldist);fwrite(hFile, var);
		fclose(hFile);
	}
	return 1;
}

forward FCislit(cislo);
public FCislit(cislo)
{
	new para, para22, string[256], string22[4], string33[4];
	strdel(string22, 0, 4);
	strdel(string33, 0, 4);
	format(string, sizeof(string), "%d", cislo);
	para22 = strlen(string);
	if(para22 == 1)
	{
		strmid(string22, string, para22-1, para22, sizeof(string22));
	}
	else
	{
	    strmid(string22, string, para22-1, para22, sizeof(string22));
	    strmid(string33, string, para22-2, para22-1, sizeof(string33));
	}
	para22 = strval(string33);
	if(para22 > 1) { para22 = 0; }
	para22 = para22 * 10 + strval(string22);
	switch(para22)
	{
		case 0,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19: para = 0;
		case 1: para = 1;
		case 2,3,4: para = 2;
	}
	return para;
}

