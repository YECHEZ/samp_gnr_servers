#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 101 //максимум игроков на сервере + 1 (если 50 игроков, то пишем 51 !!!)

#if (MAX_PLAYERS > 501)
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 501
#endif

#define OBRAD 13 //число радио +1

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA

new NRadio[MAX_PLAYERS];//переменная номера подключенного радио
new STRadio[OBRAD][128];//массив URL-ссылок на радио-потоки
new NMRadio[OBRAD][64];//массив названий радио

public OnFilterScriptInit()
{
	print(" ");
	print("--------------------------------------");
	print("        Filterscript Radio - 3         ");
	print("--------------------------------------\n");

	STRadio[1] = "http://www.zaycev.fm:9001/ZaycevFM(128).m3u";//URL ссылки
	STRadio[2] = "http://ep128server.streamr.ru:8030/ep128";
	STRadio[3] = "http://air.radiorecord.ru:8102/sd90_128";
	STRadio[4] = "http://online.nashipesni.ru:8000/nashipesni";
	STRadio[5] = "http://stream05.akaver.com/russkoeradio_hi.mp3";
	STRadio[6] = "http://cast.radiogroup.com.ua:8000/avtoradio";
	STRadio[7] = "http://air.radiorecord.ru:8101/rr_128";
	STRadio[8] = "http://air.radiorecord.ru:8102/dub_128";
	STRadio[9] = "http://air.radiorecord.ru:8102/club_128";
	STRadio[10] = "http://air.radiorecord.ru:8102/mdl_128";
	STRadio[11] = "http://air.radiorecord.ru:8102/gop_128";
	STRadio[12] = "http://streaming.radionomy.com/radio-xtreme---sensation-tubes-garantie";

	NMRadio[1] = "Zaycev-FM";//названия радиостанций
	NMRadio[2] = "Европа +";
	NMRadio[3] = "Супердискотека 90-х";
	NMRadio[4] = "Наши песни";
	NMRadio[5] = "Русское радио";
	NMRadio[6] = "Авторадио";
	NMRadio[7] = "Radio Record";
	NMRadio[8] = "Dubstep";
	NMRadio[9] = "Club";
	NMRadio[10] = "Медляк FM";
	NMRadio[11] = "Гоп FM";
	NMRadio[12] = "Radio Xtreme";

	return 1;
}

public OnFilterScriptExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{//отключение потоков для всех подключенных игороков
		if(IsPlayerConnected(i))
		{
			StopAudioStreamForPlayer(i);
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	NRadio[playerid] = 0;//задаём игроку несуществующий номер подключенного радио
	StopAudioStreamForPlayer(playerid);//отключим любой поток
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	NRadio[playerid] = 0;//задаём игроку несуществующий номер подключенного радио
	StopAudioStreamForPlayer(playerid);//отключим любой поток
	return 1;
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

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(GetPVarInt(playerid, "CComAc2") < 0)
	{
		new dopcis, sstr[256];
		dopcis = FCislit(GetPVarInt(playerid, "CComAc2"));
		switch(dopcis)
		{
			case 0: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунд !", GetPVarInt(playerid, "CComAc2") * -1);
			case 1: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунду !", GetPVarInt(playerid, "CComAc2") * -1);
			case 2: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунды !", GetPVarInt(playerid, "CComAc2") * -1);
		}
		SendClientMessage(playerid, COLOR_RED, sstr);
		return 1;
	}
	SetPVarInt(playerid, "CComAc2", GetPVarInt(playerid, "CComAc2") + 1);
	new string[256];
	new cmd[256];
	new tmp[256];
	new idx;
    new sendername[MAX_PLAYER_NAME];
	cmd = strtok(cmdtext, idx);
	if (strcmp(cmd,"/radon",true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GREY, " Используйте: /radon [радио(1-12)]");
			return 1;
		}
		new para1 = strval(tmp);
		if(para1 < 1 || para1 > 12)
		{
			SendClientMessage(playerid, COLOR_RED, " Такого радио нет !");
			return 1;
		}
		if(NRadio[playerid] != para1)
		{
			NRadio[playerid] = para1;//номер подключаемого радио
			StopAudioStreamForPlayer(playerid);//отключим любой другой поток
			PlayAudioStreamForPlayer(playerid, STRadio[para1]);//подключим поток с музыкой
			format(string, sizeof(string), " Вы включили радио %s", NMRadio[para1]);
			SendClientMessage(playerid, COLOR_GREY, string);
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//доработка для использования Русских ников
			format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
			printf("[radio] Игрок %s включил радио %s .", aa333, NMRadio[para1]);//доработка для использования Русских ников
//			printf("[radio] Игрок %s включил радио %s .", sendername, NMRadio[para1]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " Нельзя, у Вас уже включено это радио !");
		}
	    return 1;
	}
	if (strcmp(cmd,"/radoff",true) == 0)
	{
		if(NRadio[playerid] != 0)
		{
			NRadio[playerid] = 0;//несуществующее радио
			StopAudioStreamForPlayer(playerid);//отключим любой поток
			SendClientMessage(playerid, COLOR_GREY, " Вы выключили радио");
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//доработка для использования Русских ников
			format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
			printf("[radio] Игрок %s выключил радио.", aa333);//доработка для использования Русских ников
//			printf("[radio] Игрок %s выключил радио.", sendername);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " Нельзя, у Вас выключено радио !");
		}
	    return 1;
	}
	if(strcmp(cmd, "/radhelp", true) == 0)
	{
		SendClientMessage(playerid,COLOR_GREY," -------------------------- Помощь по радио -------------------------- ");
		SendClientMessage(playerid,COLOR_GREY,"               /radhelp   /radon [радио(1-12)]   /radoff");
		SendClientMessage(playerid,COLOR_GREY,"   /radall [радио(1-12)]   /radpl [ид игрока] [радио(1-12)]");
		SendClientMessage(playerid,COLOR_GREY," -------------------------------------------------------------------------------- ");

		new soob[2048];
		format(soob, sizeof(soob), "/radhelp - Помощь по радио\
		\n/radon [радио(1-12)] - Включить радио\
		\n/radoff - Выключить радио\
		\n/radall [радио(1-12)] - Включить радио всем игрокам");
		format(soob, sizeof(soob), "%s\n/radpl [ид игрока] [радио(1-12)] - Включить радио отдельному игроку\
		\n\
		\n	Список радио:", soob);
		format(soob, sizeof(soob), "%s\n1 - %s\n2 - %s\n3 - %s\n4 - %s\n5 - %s\n6 - %s\n7 - %s\n8 - %s\
		\n9 - %s\n10 - %s\n11 - %s\n12 - %s", soob, NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4],
		NMRadio[5], NMRadio[6], NMRadio[7], NMRadio[8], NMRadio[9], NMRadio[10], NMRadio[11], NMRadio[12]);
		ShowPlayerDialog(playerid, 2, 0, "Помощь по радио", soob, "OK", "");
		SetPVarInt(playerid, "DlgCont", 2);
    	return 1;
	}
	if (strcmp(cmd,"/radall",true) == 0)
    {
		if(GetPVarInt(playerid, "AdmLvl") >= 3 || IsPlayerAdmin(playerid))
        {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GREY, " Используйте: /radall [радио(1-12)]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 1 || para1 > 12)
			{
				SendClientMessage(playerid, COLOR_RED, " Такого радио нет !");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//доработка для использования Русских ников
			format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if((GetPVarInt(playerid, "AdmLvl") == 3 && GetPVarInt(i, "AdmLvl") <= 3) || GetPVarInt(playerid, "AdmLvl") >= 4)
					{
						NRadio[i] = para1;//номер подключаемого радио
						StopAudioStreamForPlayer(i);//отключим любой другой поток
						PlayAudioStreamForPlayer(i, STRadio[para1]);//подключим поток с музыкой
						format(string, sizeof(string), " *** Админ %s включил всем радио %s ( для выключения введите /radoff )", aa333, NMRadio[para1]);//доработка для использования Русских ников
//						format(string, sizeof(string), " *** Админ %s включил всем радио %s ( для выключения введите /radoff )", sendername, NMRadio[para1]);
						SendClientMessage(i, COLOR_GREY, string);
					}
					if(GetPVarInt(i, "AdmLvl") >= 4 && i != playerid)
					{
						format(string, sizeof(string), " *** Админ %s включил всем радио %s", aa333, NMRadio[para1]);//доработка для использования Русских ников
//						format(string, sizeof(string), " *** Админ %s включил всем радио %s", sendername, NMRadio[para1]);
						SendClientMessage(i, COLOR_GREY, string);
					}
				}
			}
			printf("[radio] Aдмин %s включил всем радио %s .", aa333, NMRadio[para1]);//доработка для использования Русских ников
//			printf("[radio] Aдмин %s включил всем радио %s .", sendername, NMRadio[para1]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
	    return 1;
    }
	if (strcmp(cmd,"/radpl",true) == 0)
    {
		if(GetPVarInt(playerid, "AdmLvl") >= 3 || IsPlayerAdmin(playerid))
        {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GREY, " Используйте: /radpl [ид игрока] [радио(1-12)]");
				return 1;
			}
			new para1 = strval(tmp);
			if(!IsPlayerConnected(para1))
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
				return 1;
			}
			if(para1 == playerid)
			{
				SendClientMessage(playerid, COLOR_RED, " Чтобы включить радио самому себе, используйте: /radon !");
				return 1;
			}
			if(GetPVarInt(playerid, "AdmLvl") == 3 && GetPVarInt(para1, "AdmLvl") >= 4)
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не можете включить радио админу 4-го уровня !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Радио(1-12) !");
				return 1;
			}
			new para2 = strval(tmp);
			if(para2 < 1 || para2 > 12)
			{
				SendClientMessage(playerid, COLOR_RED, " Такого радио нет !");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//доработка для использования Русских ников
			format(aa333, sizeof(aa333), "%s", sendername);//доработка для использования Русских ников
    		new targetname[MAX_PLAYER_NAME];
			GetPlayerName(para1, targetname, sizeof(targetname));
			new aa222[64];//доработка для использования Русских ников
			format(aa222, sizeof(aa222), "%s", targetname);//доработка для использования Русских ников

			NRadio[para1] = para2;//номер подключаемого радио
			StopAudioStreamForPlayer(para1);//отключим любой другой поток
			PlayAudioStreamForPlayer(para1, STRadio[para2]);//подключим поток с музыкой
			format(string, sizeof(string), " *** Админ %s включил Вам радио %s ( для выключения введите /radoff )", aa333, NMRadio[para2]);//доработка для использования Русских ников
//			format(string, sizeof(string), " *** Админ %s включил Вам радио %s ( для выключения введите /radoff )", sendername, NMRadio[para2]);
			SendClientMessage(para1, COLOR_GREY, string);
			format(string, sizeof(string), " *** Aдмин %s включил игроку %s радио %s", aa333, aa222, NMRadio[para2]);//доработка для использования Русских ников
//			format(string, sizeof(string), " *** Aдмин %s включил игроку %s радио %s", sendername, targetname, NMRadio[para2]);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
 					if((GetPVarInt(i, "AdmLvl") >= 1 || IsPlayerAdmin(i)) && i != para1)
   					{
						SendClientMessage(i, COLOR_GREY, string);
					}
				}
			}
			printf("[radio] Aдмин %s включил игроку %s радио %s .", aa333, aa222, NMRadio[para2]);//доработка для использования Русских ников
//			printf("[radio] Aдмин %s включил игроку %s радио %s .", sendername, targetname, NMRadio[para2]);
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

