//==============================================================================
//             Мод портирования базы данных аккаунтов игроков

// Исходная база данных должна быть расположена в каталоге scriptfiles\.
// Имя файла исходной базы данных (БЕЗ типа (расширения) файла) нужно
// задать в строке 37. Полный путь базы данных: scriptfiles\players1.db
// Портированная база данных должна быть расположена в каталоге scriptfiles\.
// Имя файла портированной базы данных (БЕЗ типа (расширения) файла) нужно
// задать в строке 38. Полный путь базы данных: scriptfiles\players2.db
// Инструкции по портированию читайте в комментариях мода.

//==============================================================================

#include <a_samp>

#pragma dynamic 30000

new DB:player1db;//переменная исходной базы данных аккаунтов игроков
new DB:player2db;//переменная портированной базы данных аккаунтов игроков
new DBResult:query1db;//переменная запросов исходной базы данных аккаунтов игроков
new Name1[32];//имя файла исходной БД (в каталоге scriptfiles)
new Name2[32];//имя файла портированной БД (в каталоге scriptfiles)
new datad[100];//массив целочисленных переменных
new Float:dataf[100];//массив вещественных переменных
new datas[100][256];//массив строковых переменных

main()
{
	print(" ");
	print("\n------------------------------------------------");
	print(" Мод портирования базы данных аккаунтов игроков   ");
	print("------------------------------------------------\n");
}

public OnGameModeInit()
{
	Name1 = "players1";//имя файла исходной БД (в каталоге scriptfiles)
	Name2 = "players2";//имя файла портированной БД (в каталоге scriptfiles)
	SetTimer("Begin", 500, 0);
	return 1;
}

public OnGameModeExit()
{
	db_close(player1db);//отключаем исходную БД от сервера
	db_close(player2db);//отключаем портированную БД от сервера
	return 1;
}

forward Begin();
public Begin()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name1);
	if(!fexist(string))
	{
		print(" ");
		print(" Ошибка ! Исходная база данных не обнаружена !");
		return 1;
	}
	format(string, sizeof(string), "%s.db", Name2);
	if(fexist(string))
	{
		fremove(string);
	}
	print(" ");
	print(" Обнаружена исходная база данных.");
	SetTimer("Portation", 500, 0);
	return 1;
}

forward Portation();
public Portation()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name1);
	player1db = db_open(string);//подключаем исходную БД к серверу
	format(string, sizeof(string), "%s.db", Name2);
	player2db = db_open(string);//подключаем портированную БД к серверу

	//определение числа строк в исходной БД
	format(string, sizeof(string), "SELECT * FROM Players WHERE (IDCopy = 1)");//создаём запрос БД
	query1db = db_query(player1db, string);//отправляем запрос БД
	new para1;
	para1 = db_num_rows(query1db);//переведём результат запроса в число найденных строк в БД
	printf(" Число строк в исходной БД: %d", para1);

	//добавим три новых переменных, одну - целочисленную (Data1), одну - вещественную (Data2), и одну - строковую (Data3)
	//в аккаунты всех игроков, и присвоим этим переменным значения: Data1 = 10, Data2 = 100.378, Data3 = 'free' .
	//Три новые переменные расположим между числовой переменной (DEndConY) и строковой переменной (IPAdr)

	//создание новой (пустой) БД
	new ss01[256], ss02[256], ss03[256], ss04[256], ss05[256], ss06[256], ss07[256], ss08[256], ss09[256], ss10[256], ss00[2560];//создаём запрос БД
	format(ss01, 256, "CREATE TABLE Players(IDCopy INTEGER,Name VARCHAR(32),Key VARCHAR(32),TDReg VARCHAR(32),DEndConD INTEGER,");
	format(ss02, 256, "DEndConM INTEGER,DEndConY INTEGER,Data1 INTEGER,Data2 FLOAT,Data3 VARCHAR(32),IPAdr VARCHAR(32),MinLog INTEGER,AdminLevel INTEGER,AdminShadow INTEGER,");
	format(ss03, 256, "AdminLive INTEGER,Registered INTEGER,Prison INTEGER,Prisonsec INTEGER,Muted INTEGER,Mutedsec INTEGER,");
	format(ss04, 256, "Money INTEGER,Kills INTEGER,Deaths INTEGER,VIP INTEGER,Lock INTEGER,Gang INTEGER,GangLvl INTEGER,");
	format(ss05, 256, "Weapon_slot0 INTEGER,Weapon_slot1 INTEGER,Weapon_slot2 INTEGER,Weapon_slot3 INTEGER,Weapon_slot4 INTEGER,");
	format(ss06, 256, "Weapon_slot5 INTEGER,Weapon_slot6 INTEGER,Weapon_slot7 INTEGER,Weapon_slot8 INTEGER,Weapon_slot9 INTEGER,");
	format(ss07, 256, "Weapon_slot10 INTEGER,Weapon_slot11 INTEGER,Weapon_slot12 INTEGER,");
	format(ss08, 256, "Ammo_slot0 INTEGER,Ammo_slot1 INTEGER,Ammo_slot2 INTEGER,Ammo_slot3 INTEGER,Ammo_slot4 INTEGER,");
	format(ss09, 256, "Ammo_slot5 INTEGER,Ammo_slot6 INTEGER,Ammo_slot7 INTEGER,Ammo_slot8 INTEGER,Ammo_slot9 INTEGER,");
	format(ss10, 256, "Ammo_slot10 INTEGER,Ammo_slot11 INTEGER,Ammo_slot12 INTEGER)");
	format(ss00, 2560, "%s%s%s%s%s%s%s%s%s%s", ss01, ss02, ss03, ss04, ss05, ss06, ss07, ss08, ss09, ss10);
	db_query(player2db, ss00);//отправляем запрос на создание новой (пустой) БД

	//создание новых переменных (Data1, Data2, Data3)
	datad[70] = 10;//Data1
	dataf[80] = 100.378;//Data2
	strdel(datas[90], 0, 256);
	strins(datas[90], "free", 0, 256);//Data3

	//портирование БД
	new para2;
	para2 = para1 - 1;
	new para3 = 0;
	new para4 = 0;
	new buffer[32];
	new s01[256], s02[256], s03[256], s04[256], s05[256], s06[256], s07[256], s08[256], s09[256], s10[256], saa[2560];
	new s11[256], s12[256], s13[256], s14[256], s15[256], s16[256], s17[256], s18[256], s19[256], s20[256], sbb[2560];
	new s00[5120];
	print(" Начало портирования. Не отключайте (не закрывайте) мод !!!");
	for(new i = 0; i < para1; i++)
	{
		//чтение одной строки исходной БД
		db_get_field(query1db, 0, buffer, 32); datad[0] = strval(buffer);//IDCopy
		db_get_field(query1db, 1, datas[0], 256);//Name
		db_get_field(query1db, 2, datas[1], 256);//Key
		db_get_field(query1db, 3, datas[2], 256);//TDReg
		db_get_field(query1db, 4, buffer, 32); datad[1] = strval(buffer);//DEndConD
		db_get_field(query1db, 5, buffer, 32); datad[2] = strval(buffer);//DEndConM
		db_get_field(query1db, 6, buffer, 32); datad[3] = strval(buffer);//DEndConY
		db_get_field(query1db, 7, datas[3], 256);//IPAdr
		db_get_field(query1db, 8, buffer, 32); datad[4] = strval(buffer);//MinLog
		db_get_field(query1db, 9, buffer, 32); datad[5] = strval(buffer);//AdminLevel
		db_get_field(query1db, 10, buffer, 32); datad[6] = strval(buffer);//AdminShadow
		db_get_field(query1db, 11, buffer, 32); datad[7] = strval(buffer);//AdminLive
		db_get_field(query1db, 12, buffer, 32); datad[8] = strval(buffer);//Registered
		db_get_field(query1db, 13, buffer, 32); datad[9] = strval(buffer);//Prison
		db_get_field(query1db, 14, buffer, 32); datad[10] = strval(buffer);//Prisonsec
		db_get_field(query1db, 15, buffer, 32); datad[11] = strval(buffer);//Muted
		db_get_field(query1db, 16, buffer, 32); datad[12] = strval(buffer);//Mutedsec
		db_get_field(query1db, 17, buffer, 32); datad[13] = strval(buffer);//Money
		db_get_field(query1db, 18, buffer, 32); datad[14] = strval(buffer);//Kills
		db_get_field(query1db, 19, buffer, 32); datad[15] = strval(buffer);//Deaths
		db_get_field(query1db, 20, buffer, 32); datad[16] = strval(buffer);//VIP
		db_get_field(query1db, 21, buffer, 32); datad[18] = strval(buffer);//Lock
		db_get_field(query1db, 22, buffer, 32); datad[18] = strval(buffer);//Gang
		db_get_field(query1db, 23, buffer, 32); datad[19] = strval(buffer);//GangLvl
		db_get_field(query1db, 24, buffer, 32); datad[20] = strval(buffer);//Weapon_slot0
		db_get_field(query1db, 25, buffer, 32); datad[21] = strval(buffer);//Weapon_slot1
		db_get_field(query1db, 26, buffer, 32); datad[22] = strval(buffer);//Weapon_slot2
		db_get_field(query1db, 27, buffer, 32); datad[23] = strval(buffer);//Weapon_slot3
		db_get_field(query1db, 28, buffer, 32); datad[24] = strval(buffer);//Weapon_slot4
		db_get_field(query1db, 29, buffer, 32); datad[25] = strval(buffer);//Weapon_slot5
		db_get_field(query1db, 30, buffer, 32); datad[26] = strval(buffer);//Weapon_slot6
		db_get_field(query1db, 31, buffer, 32); datad[27] = strval(buffer);//Weapon_slot7
		db_get_field(query1db, 32, buffer, 32); datad[28] = strval(buffer);//Weapon_slot8
		db_get_field(query1db, 33, buffer, 32); datad[29] = strval(buffer);//Weapon_slot9
		db_get_field(query1db, 34, buffer, 32); datad[30] = strval(buffer);//Weapon_slot10
		db_get_field(query1db, 35, buffer, 32); datad[31] = strval(buffer);//Weapon_slot11
		db_get_field(query1db, 36, buffer, 32); datad[32] = strval(buffer);//Weapon_slot12
		db_get_field(query1db, 37, buffer, 32); datad[33] = strval(buffer);//Ammo_slot0
		db_get_field(query1db, 38, buffer, 32); datad[34] = strval(buffer);//Ammo_slot1
		db_get_field(query1db, 39, buffer, 32); datad[35] = strval(buffer);//Ammo_slot2
		db_get_field(query1db, 40, buffer, 32); datad[36] = strval(buffer);//Ammo_slot3
		db_get_field(query1db, 41, buffer, 32); datad[37] = strval(buffer);//Ammo_slot4
		db_get_field(query1db, 42, buffer, 32); datad[38] = strval(buffer);//Ammo_slot5
		db_get_field(query1db, 43, buffer, 32); datad[39] = strval(buffer);//Ammo_slot6
		db_get_field(query1db, 44, buffer, 32); datad[40] = strval(buffer);//Ammo_slot7
		db_get_field(query1db, 45, buffer, 32); datad[41] = strval(buffer);//Ammo_slot8
		db_get_field(query1db, 46, buffer, 32); datad[42] = strval(buffer);//Ammo_slot9
		db_get_field(query1db, 47, buffer, 32); datad[43] = strval(buffer);//Ammo_slot10
		db_get_field(query1db, 48, buffer, 32); datad[44] = strval(buffer);//Ammo_slot11
		db_get_field(query1db, 49, buffer, 32); datad[45] = strval(buffer);//Ammo_slot12
//		db_get_field(query1db, 50, buffer, 32); dataf[0] = floatstr(buffer);//вариант чтения вещественной переменной из БД

		//добавление одной строки в портированную БД
		format(s01, 256, "INSERT INTO Players (IDCopy,Name,Key,TDReg,DEndConD,DEndConM,DEndConY,Data1,Data2,Data3,IPAdr,MinLog,AdminLevel,");
		format(s02, 256, "AdminShadow,AdminLive,Registered,Prison,Prisonsec,Muted,Mutedsec,Money,Kills,Deaths,VIP,Lock,Gang,");
		format(s03, 256, "GangLvl,Weapon_slot0,Weapon_slot1,Weapon_slot2,Weapon_slot3,Weapon_slot4,Weapon_slot5,Weapon_slot6,");
		format(s04, 256, "Weapon_slot7,Weapon_slot8,Weapon_slot9,Weapon_slot10,Weapon_slot11,Weapon_slot12,Ammo_slot0,");
		format(s05, 256, "Ammo_slot1,Ammo_slot2,Ammo_slot3,Ammo_slot4,Ammo_slot5,Ammo_slot6,Ammo_slot7,Ammo_slot8,Ammo_slot9,");
		format(s06, 256, "Ammo_slot10,Ammo_slot11,Ammo_slot12) ");
		format(s07, 256, "VALUES (%d,'%s','%s','%s',",datad[0],datas[0],datas[1],datas[2]);//IDCopy,Name,Key,TDReg
		format(s08, 256, "%d,%d,%d,%d,%f,'%s','%s',",datad[1],datad[2],datad[3],datad[70],dataf[80],datas[90],datas[3]);//DEndConD,DEndConM,DEndConY,Data1,Data2,Data3,IPAdr
		format(s09, 256, "%d,%d,%d,",datad[4],datad[5],datad[6]);//MinLog,AdminLevel,AdminShadow
		format(s10, 256, "%d,%d,%d,",datad[7],datad[8],datad[9]);//AdminLive,Registered,Prison
		format(s11, 256, "%d,%d,%d,",datad[10],datad[11],datad[12]);//Prisonsec,Muted,Mutedsec
		format(s12, 256, "%d,%d,%d,",datad[13],datad[14],datad[15]);//Money,Kills,Deaths
		format(s13, 256, "%d,%d,%d,%d,",datad[16],datad[17],datad[18],datad[19]);//VIP,Lock,Gang,GangLvl
		format(s14, 256, "%d,%d,%d,%d,",datad[20],datad[21],datad[22],datad[23]);//Weapon_slot0,Weapon_slot1,Weapon_slot2,Weapon_slot3
		format(s15, 256, "%d,%d,%d,%d,",datad[24],datad[25],datad[26],datad[27]);//Weapon_slot4,Weapon_slot5,Weapon_slot6,Weapon_slot7
		format(s16, 256, "%d,%d,%d,%d,",datad[28],datad[29],datad[30],datad[31]);//Weapon_slot8,Weapon_slot9,Weapon_slot10,Weapon_slot11
		format(s17, 256, "%d,%d,%d,%d,",datad[32],datad[33],datad[34],datad[35]);//Weapon_slot12,Ammo_slot0,Ammo_slot1,Ammo_slot2
		format(s18, 256, "%d,%d,%d,%d,",datad[36],datad[37],datad[38],datad[39]);//Ammo_slot3,Ammo_slot4,Ammo_slot5,Ammo_slot6
		format(s19, 256, "%d,%d,%d,%d,",datad[40],datad[41],datad[42],datad[43]);//Ammo_slot7,Ammo_slot8,Ammo_slot9,Ammo_slot10
		format(s20, 256, "%d,%d)",datad[44],datad[45]);//Ammo_slot11,Ammo_slot12
		format(saa, 2560, "%s%s%s%s%s%s%s%s%s%s", s01, s02, s03, s04, s05, s06, s07, s08, s09, s10);
		format(sbb, 2560, "%s%s%s%s%s%s%s%s%s%s", s11, s12, s13, s14, s15, s16, s17, s18, s19, s20);
		format(s00, 5120, "%s%s", saa, sbb);
		db_query(player2db, s00);//отправляем запрос на добавление одной строки в портированную БД

		if(i != para2)//если была портирована НЕ последняя строка, то:
		{
			db_next_row(query1db);//переходим к следующей строке исходной БД
		}
		para3++;
		para4++;
		if(para4 >= 100)
		{
			para4 = 0;
			printf(" Портировано %d строк БД.", para3);

		}
	}
	db_free_result(query1db);//очищаем результат запроса БД
	print(" ");
	print(" Вся исходная БД портирована ! Можно отключить (закрыть) мод.");
	print(" ");
	db_close(player1db);//отключаем исходную БД от сервера
	db_close(player2db);//отключаем портированную БД от сервера
	return 1;
}

