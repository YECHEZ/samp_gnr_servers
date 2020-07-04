//==============================================================================
//          Мод добавления к таблице базы данных аккаунтов игроков
//                   дополнительных столбцов (колонок)

// ВНИМАНИЕ !!! Дополнительные столбцы (колонки) можно добавлять ТОЛЬКО
// С ПРАВОЙ стороны таблицы базы данных !!!

// База данных должна быть расположена в каталоге scriptfiles\.
// Имя файла исходной базы данных (БЕЗ типа (расширения) файла) нужно
// задать в строке 34. Полный путь базы данных: scriptfiles\players1.db
// Инструкции по добавлению столбцов (колонок) читайте в комментариях мода.

//==============================================================================

#include <a_samp>

#pragma dynamic 30000

new DB:playerdb;//переменная базы данных аккаунтов игроков
new DBResult:querydb;//переменная запросов базы данных аккаунтов игроков
new Name[32];//имя файла БД (в каталоге scriptfiles)

main()
{
	print(" ");
	print("\n------------------------------------------------");
	print(" Мод добавления к таблице базы данных аккаунтов   ");
	print("   игроков дополнительных столбцов (колонок)      ");
	print("------------------------------------------------\n");
}

public OnGameModeInit()
{
	Name = "players1";//имя файла БД (в каталоге scriptfiles)
	SetTimer("Begin", 500, 0);
	return 1;
}

public OnGameModeExit()
{
	db_close(playerdb);//отключаем БД от сервера
	return 1;
}

forward Begin();
public Begin()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name);
	if(!fexist(string))
	{
		print(" ");
		print(" Ошибка ! База данных не обнаружена !");
		return 1;
	}
	else
	{
		print(" Обнаружена база данных.");
		SetTimer("Portation", 500, 0);
	}
	return 1;
}

forward Portation();
public Portation()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name);
	playerdb = db_open(string);//подключаем БД к серверу

	format(string, sizeof(string), "ALTER TABLE Players ADD COLUMN Data1 INTEGER");//создаём запрос БД
	//на добавление нового столбца целого типа с именем Data1
	querydb = db_query(playerdb, string);//отправляем запрос БД
	db_free_result(querydb);//очищаем результат запроса БД
	format(string, sizeof(string), "UPDATE Players SET Data1 = 10");//создаём запрос БД
	//на заполнение ВСЕГО нового столбца с именем Data1 целым числом 10
	querydb = db_query(playerdb, string);//отправляем запрос БД
	db_free_result(querydb);//очищаем результат запроса БД

	format(string, sizeof(string), "ALTER TABLE Players ADD COLUMN Data2 FLOAT");//создаём запрос БД
	//на добавление нового столбца вещественного типа с именем Data2
	querydb = db_query(playerdb, string);//отправляем запрос БД
	db_free_result(querydb);//очищаем результат запроса БД
	format(string, sizeof(string), "UPDATE Players SET Data2 = 100.378");//создаём запрос БД
	//на заполнение ВСЕГО нового столбца с именем Data2 вещественным числом 100.378
	querydb = db_query(playerdb, string);//отправляем запрос БД
	db_free_result(querydb);//очищаем результат запроса БД

	format(string, sizeof(string), "ALTER TABLE Players ADD COLUMN Data3 VARCHAR(32)");//создаём запрос БД
	//на добавление нового столбца строкового типа с именем Data3
	querydb = db_query(playerdb, string);//отправляем запрос БД
	db_free_result(querydb);//очищаем результат запроса БД
	format(string, sizeof(string), "UPDATE Players SET Data3 = 'free'");//создаём запрос БД
	//на заполнение ВСЕГО нового столбца с именем Data3 строкой "free"
	//Если необходимо заполнить столбец Data3 "пустыми" строками, то нужно
	//отправить запрос БД: "UPDATE Players SET Data3 = ''"
	querydb = db_query(playerdb, string);//отправляем запрос БД
	db_free_result(querydb);//очищаем результат запроса БД

	print(" ");
	print(" Все столбцы (колонки) были добавлены к БД !");
	print(" Можно отключить (закрыть) мод.");
	print(" ");
	db_close(playerdb);//отключаем БД от сервера
	return 1;
}

