#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 101 //�������� ������� �� ������� + 1 (���� 50 �������, �� ����� 51 !!!)

#if (MAX_PLAYERS > 501)
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 501
#endif

#define OBRAD 13 //����� ����� +1

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA

new NRadio[MAX_PLAYERS];//���������� ������ ������������� �����
new STRadio[OBRAD][128];//������ URL-������ �� �����-������
new NMRadio[OBRAD][64];//������ �������� �����

public OnFilterScriptInit()
{
	print(" ");
	print("--------------------------------------");
	print("        Filterscript Radio - 3         ");
	print("--------------------------------------\n");

	STRadio[1] = "http://www.zaycev.fm:9001/ZaycevFM(128).m3u";//URL ������
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

	NMRadio[1] = "Zaycev-FM";//�������� ������������
	NMRadio[2] = "������ +";
	NMRadio[3] = "�������������� 90-�";
	NMRadio[4] = "���� �����";
	NMRadio[5] = "������� �����";
	NMRadio[6] = "���������";
	NMRadio[7] = "Radio Record";
	NMRadio[8] = "Dubstep";
	NMRadio[9] = "Club";
	NMRadio[10] = "������ FM";
	NMRadio[11] = "��� FM";
	NMRadio[12] = "Radio Xtreme";

	return 1;
}

public OnFilterScriptExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{//���������� ������� ��� ���� ������������ ��������
		if(IsPlayerConnected(i))
		{
			StopAudioStreamForPlayer(i);
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	NRadio[playerid] = 0;//����� ������ �������������� ����� ������������� �����
	StopAudioStreamForPlayer(playerid);//�������� ����� �����
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	NRadio[playerid] = 0;//����� ������ �������������� ����� ������������� �����
	StopAudioStreamForPlayer(playerid);//�������� ����� �����
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
			case 0: format(sstr, sizeof(sstr), " ���� � ���� (��� � ��������) !   ���������� ����� %d ������ !", GetPVarInt(playerid, "CComAc2") * -1);
			case 1: format(sstr, sizeof(sstr), " ���� � ���� (��� � ��������) !   ���������� ����� %d ������� !", GetPVarInt(playerid, "CComAc2") * -1);
			case 2: format(sstr, sizeof(sstr), " ���� � ���� (��� � ��������) !   ���������� ����� %d ������� !", GetPVarInt(playerid, "CComAc2") * -1);
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
			SendClientMessage(playerid, COLOR_GREY, " �����������: /radon [�����(1-12)]");
			return 1;
		}
		new para1 = strval(tmp);
		if(para1 < 1 || para1 > 12)
		{
			SendClientMessage(playerid, COLOR_RED, " ������ ����� ��� !");
			return 1;
		}
		if(NRadio[playerid] != para1)
		{
			NRadio[playerid] = para1;//����� ������������� �����
			StopAudioStreamForPlayer(playerid);//�������� ����� ������ �����
			PlayAudioStreamForPlayer(playerid, STRadio[para1]);//��������� ����� � �������
			format(string, sizeof(string), " �� �������� ����� %s", NMRadio[para1]);
			SendClientMessage(playerid, COLOR_GREY, string);
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//��������� ��� ������������� ������� �����
			format(aa333, sizeof(aa333), "%s", sendername);//��������� ��� ������������� ������� �����
			printf("[radio] ����� %s ������� ����� %s .", aa333, NMRadio[para1]);//��������� ��� ������������� ������� �����
//			printf("[radio] ����� %s ������� ����� %s .", sendername, NMRadio[para1]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " ������, � ��� ��� �������� ��� ����� !");
		}
	    return 1;
	}
	if (strcmp(cmd,"/radoff",true) == 0)
	{
		if(NRadio[playerid] != 0)
		{
			NRadio[playerid] = 0;//�������������� �����
			StopAudioStreamForPlayer(playerid);//�������� ����� �����
			SendClientMessage(playerid, COLOR_GREY, " �� ��������� �����");
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//��������� ��� ������������� ������� �����
			format(aa333, sizeof(aa333), "%s", sendername);//��������� ��� ������������� ������� �����
			printf("[radio] ����� %s �������� �����.", aa333);//��������� ��� ������������� ������� �����
//			printf("[radio] ����� %s �������� �����.", sendername);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " ������, � ��� ��������� ����� !");
		}
	    return 1;
	}
	if(strcmp(cmd, "/radhelp", true) == 0)
	{
		SendClientMessage(playerid,COLOR_GREY," -------------------------- ������ �� ����� -------------------------- ");
		SendClientMessage(playerid,COLOR_GREY,"               /radhelp   /radon [�����(1-12)]   /radoff");
		SendClientMessage(playerid,COLOR_GREY,"   /radall [�����(1-12)]   /radpl [�� ������] [�����(1-12)]");
		SendClientMessage(playerid,COLOR_GREY," -------------------------------------------------------------------------------- ");

		new soob[2048];
		format(soob, sizeof(soob), "/radhelp - ������ �� �����\
		\n/radon [�����(1-12)] - �������� �����\
		\n/radoff - ��������� �����\
		\n/radall [�����(1-12)] - �������� ����� ���� �������");
		format(soob, sizeof(soob), "%s\n/radpl [�� ������] [�����(1-12)] - �������� ����� ���������� ������\
		\n\
		\n	������ �����:", soob);
		format(soob, sizeof(soob), "%s\n1 - %s\n2 - %s\n3 - %s\n4 - %s\n5 - %s\n6 - %s\n7 - %s\n8 - %s\
		\n9 - %s\n10 - %s\n11 - %s\n12 - %s", soob, NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4],
		NMRadio[5], NMRadio[6], NMRadio[7], NMRadio[8], NMRadio[9], NMRadio[10], NMRadio[11], NMRadio[12]);
		ShowPlayerDialog(playerid, 2, 0, "������ �� �����", soob, "OK", "");
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
				SendClientMessage(playerid, COLOR_GREY, " �����������: /radall [�����(1-12)]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 1 || para1 > 12)
			{
				SendClientMessage(playerid, COLOR_RED, " ������ ����� ��� !");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//��������� ��� ������������� ������� �����
			format(aa333, sizeof(aa333), "%s", sendername);//��������� ��� ������������� ������� �����
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if((GetPVarInt(playerid, "AdmLvl") == 3 && GetPVarInt(i, "AdmLvl") <= 3) || GetPVarInt(playerid, "AdmLvl") >= 4)
					{
						NRadio[i] = para1;//����� ������������� �����
						StopAudioStreamForPlayer(i);//�������� ����� ������ �����
						PlayAudioStreamForPlayer(i, STRadio[para1]);//��������� ����� � �������
						format(string, sizeof(string), " *** ����� %s ������� ���� ����� %s ( ��� ���������� ������� /radoff )", aa333, NMRadio[para1]);//��������� ��� ������������� ������� �����
//						format(string, sizeof(string), " *** ����� %s ������� ���� ����� %s ( ��� ���������� ������� /radoff )", sendername, NMRadio[para1]);
						SendClientMessage(i, COLOR_GREY, string);
					}
					if(GetPVarInt(i, "AdmLvl") >= 4 && i != playerid)
					{
						format(string, sizeof(string), " *** ����� %s ������� ���� ����� %s", aa333, NMRadio[para1]);//��������� ��� ������������� ������� �����
//						format(string, sizeof(string), " *** ����� %s ������� ���� ����� %s", sendername, NMRadio[para1]);
						SendClientMessage(i, COLOR_GREY, string);
					}
				}
			}
			printf("[radio] A���� %s ������� ���� ����� %s .", aa333, NMRadio[para1]);//��������� ��� ������������� ������� �����
//			printf("[radio] A���� %s ������� ���� ����� %s .", sendername, NMRadio[para1]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " � ��� ��� ���� �� ������������� ���� ������� !");
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
				SendClientMessage(playerid, COLOR_GREY, " �����������: /radpl [�� ������] [�����(1-12)]");
				return 1;
			}
			new para1 = strval(tmp);
			if(!IsPlayerConnected(para1))
			{
				SendClientMessage(playerid, COLOR_RED, " ������ [�� ������] �� ������� ��� !");
				return 1;
			}
			if(para1 == playerid)
			{
				SendClientMessage(playerid, COLOR_RED, " ����� �������� ����� ������ ����, �����������: /radon !");
				return 1;
			}
			if(GetPVarInt(playerid, "AdmLvl") == 3 && GetPVarInt(para1, "AdmLvl") >= 4)
			{
				SendClientMessage(playerid, COLOR_RED, " �� �� ������ �������� ����� ������ 4-�� ������ !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " �����(1-12) !");
				return 1;
			}
			new para2 = strval(tmp);
			if(para2 < 1 || para2 > 12)
			{
				SendClientMessage(playerid, COLOR_RED, " ������ ����� ��� !");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new aa333[64];//��������� ��� ������������� ������� �����
			format(aa333, sizeof(aa333), "%s", sendername);//��������� ��� ������������� ������� �����
    		new targetname[MAX_PLAYER_NAME];
			GetPlayerName(para1, targetname, sizeof(targetname));
			new aa222[64];//��������� ��� ������������� ������� �����
			format(aa222, sizeof(aa222), "%s", targetname);//��������� ��� ������������� ������� �����

			NRadio[para1] = para2;//����� ������������� �����
			StopAudioStreamForPlayer(para1);//�������� ����� ������ �����
			PlayAudioStreamForPlayer(para1, STRadio[para2]);//��������� ����� � �������
			format(string, sizeof(string), " *** ����� %s ������� ��� ����� %s ( ��� ���������� ������� /radoff )", aa333, NMRadio[para2]);//��������� ��� ������������� ������� �����
//			format(string, sizeof(string), " *** ����� %s ������� ��� ����� %s ( ��� ���������� ������� /radoff )", sendername, NMRadio[para2]);
			SendClientMessage(para1, COLOR_GREY, string);
			format(string, sizeof(string), " *** A���� %s ������� ������ %s ����� %s", aa333, aa222, NMRadio[para2]);//��������� ��� ������������� ������� �����
//			format(string, sizeof(string), " *** A���� %s ������� ������ %s ����� %s", sendername, targetname, NMRadio[para2]);
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
			printf("[radio] A���� %s ������� ������ %s ����� %s .", aa333, aa222, NMRadio[para2]);//��������� ��� ������������� ������� �����
//			printf("[radio] A���� %s ������� ������ %s ����� %s .", sendername, targetname, NMRadio[para2]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " � ��� ��� ���� �� ������������� ���� ������� !");
		}
	    return 1;
    }
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(GetPVarInt(playerid, "DlgCont") == -600)//���� �� ������������ �� �������, ��:
	{
		return 1;//��������� �������
	}
	if(dialogid == 2)
    {
		if(dialogid != GetPVarInt(playerid, "DlgCont"))
		{
			SetPVarInt(playerid, "DlgCont", -600);//�� ������������ �� �������
			return 1;
		}
		SetPVarInt(playerid, "DlgCont", -600);//�� ������������ �� �������
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

