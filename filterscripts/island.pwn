#include <a_samp>
#include <streamer>

#undef MAX_PLAYERS
#define MAX_PLAYERS 101 //максимум игроков на сервере + 1 (если 50 игроков, то пишем 51 !!!)

#if (MAX_PLAYERS > 501)
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 501
#endif

#define MAX_NADP 45 //максимум 3D-текстов

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA

forward SecSpa333(playerid);
forward SendAdminMessage(color, string[]);
forward OneSec();
forward PlaySpa(playerid);
forward PlayKick(playerid);
forward Islon();
forward Isloff();

new Text3D:fantxt;//переменная для хранения 3D-текста с несущесвующим ИД
new ObjGamI[3];
new ObjStrI[321];
new islkl;
new totoff[MAX_PLAYERS];
new timeronesec;
new plmess[MAX_PLAYERS];
new Text:PlNot;
new Text3D:TexNad[MAX_NADP];

public OnFilterScriptInit()
{
	fantxt = Create3DTextLabel(" ",0xFFFFFFAA,0.000,0.000,-4.000,18.0,0,1);//создаём 3D-текст с несущесвующим ИД
	print(" ");
	print("--------------------------------------");
	print("               island                 ");
	print("--------------------------------------\n");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		SetPVarInt(i, "TotPr", 0);
		totoff[i] = 0;
		plmess[i] = 0;
	}

	PlNot = TextDrawCreate(150.000000,200.000000,"RESTRICTED AREA !!!");
	TextDrawAlignment(PlNot,0);
	TextDrawBackgroundColor(PlNot,0x000000ff);
	TextDrawFont(PlNot,1);
	TextDrawLetterSize(PlNot,1.000000,3.000000);
	TextDrawColor(PlNot,0xff0000ff);
	TextDrawSetOutline(PlNot,1);
	TextDrawSetProportional(PlNot,1);
	TextDrawSetShadow(PlNot,1);

	ObjGamI[0] = CreateObject(4866, -18000.13, 18000.04, 10.00,   0.00, 0.00, 135.00);
	ObjGamI[1] = CreateObject(5004, -18557.82, 18809.86, 9.75,   0.00, 0.00, 135.00);
	ObjGamI[2] = CreateObject(6297, -18259.07, 19008.86, 4.09,   2.00, 0.21, 134.70);

//	ObjStrI[0] = CreateDynamicObject(4866, -18000.13, 18000.04, 10.00,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[1] = CreateDynamicObject(4865, -17890.71, 18106.74, 10.00,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[2] = CreateDynamicObject(5002, -18194.64, 18177.54, 10.00,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[3] = CreateDynamicObject(4867, -18077.19, 18295.56, 10.00,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[4] = CreateDynamicObject(5004, -18385.13, 18339.97, 9.75,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[5] = CreateDynamicObject(5003, -18258.37, 18450.38, 16.24,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[6] = CreateDynamicObject(4847, -17802.57, 17909.89, -0.14,   0.99, 0.00, 45.00, -1, -1, -1, 500);
	ObjStrI[7] = CreateDynamicObject(4842, -17774.43, 18091.21, 0.70,   0.00, 0.00, 136.44, -1, -1, -1, 500);
	ObjStrI[8] = CreateDynamicObject(16122, -17676.99, 18040.88, -2.77,   0.00, 0.00, 84.00, -1, -1, -1, 500);
	ObjStrI[9] = CreateDynamicObject(16122, -17744.7, 18037.79, 1.95,   -12.07, 0.00, -18.00, -1, -1, -1, 500);
	ObjStrI[10] = CreateDynamicObject(4832, -17875.82, 18205.58, 40.27,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[11] = CreateDynamicObject(4832, -18131.87, 18455.78, 48.15,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[12] = CreateDynamicObject(4847, -17964.89, 18377.11, 0.01,   0.78, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[13] = CreateDynamicObject(16122, -17857.02, 18232.51, -1.54,   -11.00, 0.00, -11.00, -1, -1, -1, 500);
	ObjStrI[14] = CreateDynamicObject(16122, -18123.84, 18467.3, 0.92,   -10.00, 0.00, -11.00, -1, -1, -1, 500);
	ObjStrI[15] = CreateDynamicObject(16122, -18167.09, 18461.78, -0.69,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[16] = CreateDynamicObject(4847, -18063.58, 17906.95, 0.69,   0.00, 0.00, -45.00, -1, -1, -1, 500);
	ObjStrI[17] = CreateDynamicObject(4847, -18311.78, 18155.54, 0.69,   0.00, 0.00, -45.00, -1, -1, -1, 500);
	ObjStrI[18] = CreateDynamicObject(4847, -18574.26, 18379.27, 0.70,   0.00, 0.00, -44.42, -1, -1, -1, 500);
	ObjStrI[19] = CreateDynamicObject(16122, -18218.78, 18512.36, -0.69,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[20] = CreateDynamicObject(16122, -18280.26, 18553.36, -0.69,   0.00, 0.00, 113.00, -1, -1, -1, 500);
	ObjStrI[21] = CreateDynamicObject(16122, -18342.18, 18541.39, -0.79,   0.00, 0.00, 149.00, -1, -1, -1, 500);
	ObjStrI[22] = CreateDynamicObject(16122, -18432.09, 18271.27, -3.23,   -18.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[23] = CreateDynamicObject(4651, -18449.14, 18518.42, 10.05,   0.00, 0.00, 142.00, -1, -1, -1, 500);
	ObjStrI[24] = CreateDynamicObject(16122, -18390.33, 18499.06, -0.79,   0.00, 0.00, 149.00, -1, -1, -1, 500);
	ObjStrI[25] = CreateDynamicObject(16122, -18475.39, 18428.66, -0.58,   0.00, 0.00, 149.00, -1, -1, -1, 500);
	ObjStrI[26] = CreateDynamicObject(4651, -18431.33, 18665, 10.05,   0.00, 0.00, -37.54, -1, -1, -1, 500);
	ObjStrI[27] = CreateDynamicObject(16122, -18530.87, 18400.52, -1.69,   0.00, 0.00, 62.00, -1, -1, -1, 500);
	ObjStrI[28] = CreateDynamicObject(16122, -18592.35, 18460.65, -1.69,   0.00, 0.00, 62.00, -1, -1, -1, 500);
	ObjStrI[29] = CreateDynamicObject(16122, -18646.67, 18517.44, -1.69,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[30] = CreateDynamicObject(16122, -18682.25, 18520.42, -2.83,   -14.00, 0.00, 156.00, -1, -1, -1, 500);
	ObjStrI[31] = CreateDynamicObject(5004, -18399.51, 18968.46, 9.75,   0.00, 0.00, -45.00, -1, -1, -1, 500);
	ObjStrI[32] = CreateDynamicObject(5004, -18478.75, 18889.13, 9.747,   0.00, 0.00, 135.00, -1, -1, -1, 500);
//	ObjStrI[33] = CreateDynamicObject(5004, -18557.82, 18809.86, 9.75,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[34] = CreateDynamicObject(16122, -17909.63, 17787.33, -1.36,   0.00, 0.00, 33.00, -1, -1, -1, 500);
	ObjStrI[35] = CreateDynamicObject(16122, -17952.37, 17827.41, -0.30,   0.00, 18.00, 171.00, -1, -1, -1, 500);
	ObjStrI[36] = CreateDynamicObject(16122, -17961.59, 17781.25, -3.76,   0.00, 0.00, -47.00, -1, -1, -1, 500);
	ObjStrI[37] = CreateDynamicObject(16122, -18450, 18527.44, -4.00,   0.00, 0.00, 200.00, -1, -1, -1, 500);
	ObjStrI[38] = CreateDynamicObject(16122, -18490.36, 18490.37, -4.00,   0.00, 0.00, 224.94, -1, -1, -1, 500);
	ObjStrI[39] = CreateDynamicObject(16122, -18425.08, 18581.28, -4.00,   0.00, 0.00, 178.00, -1, -1, -1, 500);
	ObjStrI[40] = CreateDynamicObject(16122, -18479.63, 18562.42, -4.00,   0.00, 0.00, 181.88, -1, -1, -1, 500);
	ObjStrI[41] = CreateDynamicObject(16122, -18457.32, 18598.89, -4.00,   0.00, 0.00, -4.00, -1, -1, -1, 500);
	ObjStrI[42] = CreateDynamicObject(16122, -18400.14, 18625.89, -4.00,   0.00, 0.00, 4.00, -1, -1, -1, 500);
	ObjStrI[43] = CreateDynamicObject(16122, -18430.33, 18660.53, -4.00,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[44] = CreateDynamicObject(16122, -18390.2, 18694.84, -4.00,   0.00, 0.00, 47.30, -1, -1, -1, 500);
	ObjStrI[45] = CreateDynamicObject(898, -18485.55, 18475.28, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[46] = CreateDynamicObject(898, -18480.78, 18465.44, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[47] = CreateDynamicObject(898, -18459.67, 18513.03, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[48] = CreateDynamicObject(898, -18458.01, 18524.44, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[49] = CreateDynamicObject(898, -18485.71, 18541.4, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[50] = CreateDynamicObject(898, -18489.45, 18527.46, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[51] = CreateDynamicObject(898, -18454.71, 18536.84, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[52] = CreateDynamicObject(898, -18424.68, 18649.67, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[53] = CreateDynamicObject(898, -18422.26, 18659.99, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[54] = CreateDynamicObject(898, -18420.89, 18671.89, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[55] = CreateDynamicObject(898, -18395.37, 18640.74, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[56] = CreateDynamicObject(898, -18391.7, 18651.04, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
//	ObjStrI[57] = CreateDynamicObject(6297, -18259.07, 19008.86, 4.09,   2.00, 0.21, 134.70, -1, -1, -1, 500);
	ObjStrI[58] = CreateDynamicObject(6281, -18347.4, 19115.22, 3.63,   2.00, 0.21, 134.70, -1, -1, -1, 500);
	ObjStrI[59] = CreateDynamicObject(16109, -18570.79, 19063.23, 27.97,   -1.44, 0.00, 120.00, -1, -1, -1, 500);
	ObjStrI[60] = CreateDynamicObject(898, -18390.45, 18659.43, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[61] = CreateDynamicObject(898, -18389.49, 18666.68, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[62] = CreateDynamicObject(11533, -18459.72, 19051.53, -25.46,   0.00, 0.00, -33.00, -1, -1, -1, 500);
	ObjStrI[63] = CreateDynamicObject(11533, -18439.74, 19042.43, -25.87,   0.00, 0.00, -55.00, -1, -1, -1, 500);
	ObjStrI[64] = CreateDynamicObject(16122, -18434.79, 19096.44, 0.06,   0.00, 0.00, 222.00, -1, -1, -1, 500);
	ObjStrI[65] = CreateDynamicObject(11533, -18440.41, 19120.44, 12.30,   0.00, 0.00, -55.00, -1, -1, -1, 500);
	ObjStrI[66] = CreateDynamicObject(11533, -18409.76, 19177.09, 12.31,   0.00, 0.00, -55.00, -1, -1, -1, 500);
	ObjStrI[67] = CreateDynamicObject(16122, -18448.11, 19107.14, 10.25,   0.00, 0.00, 14.00, -1, -1, -1, 500);
	ObjStrI[68] = CreateDynamicObject(16122, -18482.85, 19121.7, 20.81,   0.00, 0.00, 18.00, -1, -1, -1, 500);
	ObjStrI[69] = CreateDynamicObject(11533, -18503.81, 19151.03, 12.30,   0.00, 0.00, -113.00, -1, -1, -1, 500);
	ObjStrI[70] = CreateDynamicObject(11533, -18567.04, 19149.58, 7.69,   0.00, 0.00, -84.00, -1, -1, -1, 500);
	ObjStrI[71] = CreateDynamicObject(11533, -18624.68, 19115.54, 7.69,   0.00, 0.00, -91.00, -1, -1, -1, 500);
	ObjStrI[72] = CreateDynamicObject(11533, -18640.69, 19100.1, 7.69,   0.00, 0.00, -62.00, -1, -1, -1, 500);
	ObjStrI[73] = CreateDynamicObject(11533, -18701.76, 19075.39, 28.44,   0.00, 0.00, -105.00, -1, -1, -1, 500);
	ObjStrI[74] = CreateDynamicObject(7601, -18745.99, 19053.68, 49.84,   0.00, 0.00, 120.00, -1, -1, -1, 500);
	ObjStrI[75] = CreateDynamicObject(7601, -18726.49, 19019.67, 49.84,   0.00, 0.00, 120.00, -1, -1, -1, 500);
	ObjStrI[76] = CreateDynamicObject(7601, -18706.8, 18985.65, 49.84,   0.00, 0.00, 120.00, -1, -1, -1, 500);
	ObjStrI[77] = CreateDynamicObject(16122, -18687.95, 19088.79, 46.39,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[78] = CreateDynamicObject(898, -18684.51, 19064.66, 50.83,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[79] = CreateDynamicObject(11533, -18653.48, 18916.28, 17.23,   0.00, 0.00, -69.00, -1, -1, -1, 500);
	ObjStrI[80] = CreateDynamicObject(16122, -18653.28, 19018.52, 44.77,   0.00, 0.00, 229.00, -1, -1, -1, 500);
	ObjStrI[81] = CreateDynamicObject(16122, -18659.85, 19014.65, 44.77,   0.00, 0.00, 229.00, -1, -1, -1, 500);
	ObjStrI[82] = CreateDynamicObject(16122, -18665.39, 19010.81, 44.77,   0.00, 0.00, 229.00, -1, -1, -1, 500);
	ObjStrI[83] = CreateDynamicObject(11533, -18625.72, 18963.48, 17.23,   0.00, 0.00, 11.00, -1, -1, -1, 500);
	ObjStrI[84] = CreateDynamicObject(11533, -18663.92, 18976.54, 17.23,   0.00, 0.00, 84.00, -1, -1, -1, 500);
	ObjStrI[85] = CreateDynamicObject(898, -18679.76, 19002.36, 52.80,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[86] = CreateDynamicObject(898, -18678.2, 18992.62, 52.80,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[87] = CreateDynamicObject(898, -18677.56, 18985.15, 52.80,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[88] = CreateDynamicObject(898, -18682.66, 18984.03, 59.35,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[89] = CreateDynamicObject(898, -18683.93, 18992.34, 59.35,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[90] = CreateDynamicObject(898, -18681.45, 19002.36, 59.35,   0.00, 0.00, 25.00, -1, -1, -1, 500);
	ObjStrI[91] = CreateDynamicObject(11533, -18703.65, 18957.27, 17.23,   0.00, 0.00, 84.00, -1, -1, -1, 500);
	ObjStrI[92] = CreateDynamicObject(11533, -18741.65, 18946.65, 17.23,   0.00, 0.00, 4.00, -1, -1, -1, 500);
	ObjStrI[93] = CreateDynamicObject(11533, -18770.05, 18986.05, 17.23,   0.00, 0.00, 4.00, -1, -1, -1, 500);
	ObjStrI[94] = CreateDynamicObject(11533, -18784.81, 19013.56, 17.23,   0.00, 0.00, 4.00, -1, -1, -1, 500);
	ObjStrI[95] = CreateDynamicObject(11533, -18812.4, 19055.98, 17.23,   0.00, 0.00, -105.00, -1, -1, -1, 500);
	ObjStrI[96] = CreateDynamicObject(11533, -18772.44, 19079.1, 17.23,   0.00, 0.00, -105.00, -1, -1, -1, 500);
	ObjStrI[97] = CreateDynamicObject(11533, -18743.02, 18886.76, 17.23,   0.00, 0.00, -91.00, -1, -1, -1, 500);
	ObjStrI[98] = CreateDynamicObject(11533, -18802.8, 18933.61, 17.23,   0.00, 0.00, -142.00, -1, -1, -1, 500);
	ObjStrI[99] = CreateDynamicObject(11533, -18831.94, 18982.87, 17.23,   0.00, 0.00, -142.00, -1, -1, -1, 500);
	ObjStrI[100] = CreateDynamicObject(11533, -18841.07, 19053.99, 17.23,   0.00, 0.00, -207.00, -1, -1, -1, 500);
	ObjStrI[101] = CreateDynamicObject(11533, -18813.11, 19130.07, 17.23,   0.00, 0.00, -236.00, -1, -1, -1, 500);
	ObjStrI[102] = CreateDynamicObject(11533, -18730.91, 19153.34, 17.23,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[103] = CreateDynamicObject(11533, -18679.15, 19160.31, 27.06,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[104] = CreateDynamicObject(11533, -18624.51, 19195.57, 9.47,   0.00, 0.00, 98.00, -1, -1, -1, 500);
	ObjStrI[105] = CreateDynamicObject(11533, -18549.03, 19220.81, 8.93,   0.00, 0.00, 84.00, -1, -1, -1, 500);
	ObjStrI[106] = CreateDynamicObject(11533, -18469.11, 19221.98, 10.38,   0.00, 0.00, 62.00, -1, -1, -1, 500);
	ObjStrI[107] = CreateDynamicObject(11533, -18436.83, 19234.48, 12.95,   0.00, 0.00, 84.00, -1, -1, -1, 500);
	ObjStrI[108] = CreateDynamicObject(11533, -18426.3, 19255.46, 12.95,   0.00, 0.00, 84.00, -1, -1, -1, 500);
	ObjStrI[109] = CreateDynamicObject(11533, -18393.59, 19251.71, 12.95,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[110] = CreateDynamicObject(11533, -18651.44, 19144.39, 30.54,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[111] = CreateDynamicObject(898, -18400.84, 18719.23, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[112] = CreateDynamicObject(898, -18407.17, 18728.86, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[113] = CreateDynamicObject(16122, -18465.43, 18700, -4.00,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[114] = CreateDynamicObject(898, -18431.8, 18710.67, 9.92,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[115] = CreateDynamicObject(16122, -18513.05, 18683.87, -4.00,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[116] = CreateDynamicObject(16122, -18562.44, 18735.46, -4.00,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[117] = CreateDynamicObject(16122, -18611.99, 18782.89, -4.00,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[118] = CreateDynamicObject(16122, -18658.43, 18829.16, -4.00,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[119] = CreateDynamicObject(898, -18694.41, 18871.4, 9.88,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[120] = CreateDynamicObject(16122, -18645.85, 18833.53, 3.22,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[121] = CreateDynamicObject(16122, -18600.68, 18792.13, 3.22,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[122] = CreateDynamicObject(16122, -18551.05, 18748, 3.22,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[123] = CreateDynamicObject(16122, -18504.05, 18693.07, 3.22,   0.00, 0.00, 69.00, -1, -1, -1, 500);
	ObjStrI[124] = CreateDynamicObject(16122, -18473.34, 18706.7, 3.22,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[125] = CreateDynamicObject(16122, -18370.91, 18790.43, -4.00,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[126] = CreateDynamicObject(16122, -18323.29, 18843.39, -4.00,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[127] = CreateDynamicObject(16122, -18280, 18887.96, -4.00,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[128] = CreateDynamicObject(16122, -18236.59, 18931.2, -4.00,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[129] = CreateDynamicObject(16122, -18186.23, 18972.79, -4.00,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[130] = CreateDynamicObject(16122, -18247.93, 18940.82, 3.22,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[131] = CreateDynamicObject(16122, -18290.62, 18897.63, 3.22,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[132] = CreateDynamicObject(16122, -18330.54, 18853.41, 3.22,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[133] = CreateDynamicObject(16122, -18372.96, 18807.36, 3.22,   0.00, 0.00, 164.00, -1, -1, -1, 500);
	ObjStrI[134] = CreateDynamicObject(3646, -18440.58, 19020.08, 12.33,   0.00, 0.00, 91.00, -1, -1, -1, 500);
	ObjStrI[135] = CreateDynamicObject(3589, -18466.43, 19019.1, 12.44,   0.00, 0.00, -178.00, -1, -1, -1, 500);
	ObjStrI[136] = CreateDynamicObject(3649, -18494.2, 19015.1, 12.42,   0.00, 0.00, 105.00, -1, -1, -1, 500);
	ObjStrI[137] = CreateDynamicObject(3648, -18519.32, 19000.38, 12.59,   0.00, 0.00, 135.00, -1, -1, -1, 500);
	ObjStrI[138] = CreateDynamicObject(3556, -18535.82, 18981.43, 12.45,   0.00, 0.00, -135.00, -1, -1, -1, 500);
	ObjStrI[139] = CreateDynamicObject(3582, -18575.99, 18933.24, 12.60,   0.00, 0.00, -135.00, -1, -1, -1, 500);
	ObjStrI[140] = CreateDynamicObject(3558, -18593.13, 18911.71, 12.74,   0.00, 0.00, -135.00, -1, -1, -1, 500);
	ObjStrI[141] = CreateDynamicObject(3646, -18609.73, 18880.65, 12.33,   0.00, 0.00, -185.00, -1, -1, -1, 500);
	ObjStrI[142] = CreateDynamicObject(3589, -18604.74, 18848.76, 12.44,   0.00, 0.00, -62.00, -1, -1, -1, 500);
	ObjStrI[143] = CreateDynamicObject(3649, -18584.84, 18826.15, 12.42,   0.00, 0.00, -135.00, -1, -1, -1, 500);
	ObjStrI[144] = CreateDynamicObject(3648, -18565.08, 18807.51, 12.59,   0.00, 0.00, -135.00, -1, -1, -1, 500);
	ObjStrI[145] = CreateDynamicObject(3556, -18545.51, 18789.2, 12.45,   0.00, 0.00, -44.56, -1, -1, -1, 500);
	ObjStrI[146] = CreateDynamicObject(3582, -18528.82, 18771.52, 12.60,   0.00, 0.00, -44.89, -1, -1, -1, 500);
	ObjStrI[147] = CreateDynamicObject(3558, -18510.17, 18753.29, 12.74,   0.00, 0.00, -44.22, -1, -1, -1, 500);
	ObjStrI[148] = CreateDynamicObject(3646, -18491.6, 18733.63, 12.33,   0.00, 0.00, -135.00, -1, -1, -1, 500);
	ObjStrI[149] = CreateDynamicObject(3589, -18433.27, 18782.01, 12.44,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[150] = CreateDynamicObject(3649, -18417.23, 18802.23, 12.42,   0.00, 0.00, -43.00, -1, -1, -1, 500);
	ObjStrI[151] = CreateDynamicObject(3648, -18399.58, 18820.8, 12.59,   0.00, 0.00, -43.11, -1, -1, -1, 500);
	ObjStrI[152] = CreateDynamicObject(3556, -18382.72, 18838.68, 12.45,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[153] = CreateDynamicObject(3582, -18368.63, 18854.13, 12.60,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[154] = CreateDynamicObject(3558, -18354.44, 18871.15, 12.74,   0.00, 0.00, 48.55, -1, -1, -1, 500);
	ObjStrI[155] = CreateDynamicObject(3646, -18337.93, 18888.8, 12.33,   0.00, 0.00, -42.00, -1, -1, -1, 500);
	ObjStrI[156] = CreateDynamicObject(3589, -18321.71, 18905.22, 12.44,   0.00, 0.00, 47.00, -1, -1, -1, 500);
	ObjStrI[157] = CreateDynamicObject(3649, -18305.78, 18923.76, 12.42,   0.00, 0.00, -42.89, -1, -1, -1, 500);
	ObjStrI[158] = CreateDynamicObject(3525, -18689.69, 19052.5, 50.53,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[159] = CreateDynamicObject(3525, -18681.5, 19038.44, 50.53,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[160] = CreateDynamicObject(9831, -18740.22, 19072.11, 52.18,   0.00, 0.00, -142.00, -1, -1, -1, 500);
	ObjStrI[161] = CreateDynamicObject(3461, -18740.53, 19076.49, 54.00,   89.00, 25.00, 0.00, -1, -1, -1, 500);
	ObjStrI[162] = CreateDynamicObject(3461, -18740.89, 19076.39, 54.00,   89.00, 25.00, 0.00, -1, -1, -1, 500);
	ObjStrI[163] = CreateDynamicObject(3461, -18741.24, 19076.26, 54.03,   89.00, 25.00, 0.00, -1, -1, -1, 500);
	ObjStrI[164] = CreateDynamicObject(3461, -18741.57, 19076.18, 54.04,   89.00, 25.00, 0.00, -1, -1, -1, 500);
	ObjStrI[165] = CreateDynamicObject(3461, -18741.91, 19076.07, 54.09,   89.00, 25.00, 0.00, -1, -1, -1, 500);
	ObjStrI[166] = CreateDynamicObject(3461, -18742.31, 19075.93, 54.10,   89.00, 25.00, 0.00, -1, -1, -1, 500);
	ObjStrI[167] = CreateDynamicObject(3461, -18742.69, 19075.82, 54.17,   89.00, 25.00, 0.00, -1, -1, -1, 500);
	ObjStrI[168] = CreateDynamicObject(7916, -18688.04, 19016.48, 51.73,   0.00, 0.00, -105.00, -1, -1, -1, 500);
	ObjStrI[169] = CreateDynamicObject(7916, -18704.51, 18974.95, 51.71,   0.00, 0.00, -164.00, -1, -1, -1, 500);
	ObjStrI[170] = CreateDynamicObject(7916, -18741.76, 18976.86, 51.87,   0.00, 0.00, -236.00, -1, -1, -1, 500);
	ObjStrI[171] = CreateDynamicObject(7916, -18767.51, 19017.05, 51.67,   0.00, 0.00, -244.00, -1, -1, -1, 500);
	ObjStrI[172] = CreateDynamicObject(7916, -18770.67, 19053.9, 51.68,   0.00, 0.00, 33.00, -1, -1, -1, 500);
	ObjStrI[173] = CreateDynamicObject(6965, -18447.29, 18899.42, 13.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[174] = CreateDynamicObject(6965, -18415.13, 18930.49, 13.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[175] = CreateDynamicObject(6965, -18480.65, 18867.86, 13.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[176] = CreateDynamicObject(6965, -18494.43, 18914.4, 13.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[177] = CreateDynamicObject(6965, -18458.35, 18948.6, 13.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[178] = CreateDynamicObject(6965, -18437.24, 18853.34, 13.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[179] = CreateDynamicObject(6965, -18404.51, 18884.13, 13.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[180] = CreateDynamicObject(9833, -18553.27, 18977.29, 12.24,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[181] = CreateDynamicObject(9833, -18576.89, 18953.3, 12.24,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[182] = CreateDynamicObject(3515, -18344.1, 19004.49, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[183] = CreateDynamicObject(3515, -18360.82, 19016.57, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[184] = CreateDynamicObject(3515, -18366.79, 19022.6, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[185] = CreateDynamicObject(3515, -18373.15, 19028.91, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[186] = CreateDynamicObject(3515, -18379.65, 19035.53, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[187] = CreateDynamicObject(3515, -18386.1, 19042.04, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[188] = CreateDynamicObject(3515, -18285.71, 18952.92, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[189] = CreateDynamicObject(3515, -18316.9, 18989, 9.78,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[190] = CreateDynamicObject(3515, -18392.77, 19048.73, 10.39,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[191] = CreateDynamicObject(19122, -18360.83, 19016.58, 11.25,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[192] = CreateDynamicObject(19123, -18366.82, 19022.61, 11.25,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[193] = CreateDynamicObject(19124, -18373.14, 19028.92, 11.25,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[194] = CreateDynamicObject(19125, -18379.66, 19035.57, 11.25,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[195] = CreateDynamicObject(19126, -18386.12, 19042.05, 11.25,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[196] = CreateDynamicObject(19127, -18392.81, 19048.71, 11.25,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[197] = CreateDynamicObject(11413, -18415.54, 18930.63, 11.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[198] = CreateDynamicObject(11413, -18405.67, 18884.63, 11.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[199] = CreateDynamicObject(11413, -18448.04, 18899.33, 11.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[200] = CreateDynamicObject(11413, -18458.5, 18948.46, 11.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[201] = CreateDynamicObject(11413, -18494.73, 18914.42, 11.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[202] = CreateDynamicObject(11413, -18480.85, 18868.18, 11.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[203] = CreateDynamicObject(11413, -18437.29, 18853.77, 11.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[204] = CreateDynamicObject(821, -18555.4, 18991.8, 15.01,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[205] = CreateDynamicObject(821, -18550.97, 18999.11, 16.46,   0.00, 0.00, 0.21, -1, -1, -1, 500);
	ObjStrI[206] = CreateDynamicObject(821, -18546.68, 19005.5, 17.96,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[207] = CreateDynamicObject(714, -18537.76, 19018.84, 17.83,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[208] = CreateDynamicObject(714, -18515.71, 19056.39, 24.52,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[209] = CreateDynamicObject(714, -18496.65, 19090.42, 28.60,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[210] = CreateDynamicObject(714, -18540.12, 19131.71, 32.79,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[211] = CreateDynamicObject(714, -18576.35, 19070.27, 41.32,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[212] = CreateDynamicObject(714, -18616.4, 18988.08, 37.42,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[213] = CreateDynamicObject(714, -18618.15, 19069.57, 45.38,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[214] = CreateDynamicObject(621, -18633.22, 19094.88, 48.67,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[215] = CreateDynamicObject(621, -18642.59, 19088.69, 49.14,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[216] = CreateDynamicObject(621, -18637.35, 19028.5, 42.02,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[217] = CreateDynamicObject(621, -18635.25, 19036.38, 42.02,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[218] = CreateDynamicObject(621, -18631.06, 19045.1, 42.02,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[219] = CreateDynamicObject(620, -18711.57, 19002.8, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[220] = CreateDynamicObject(620, -18723.37, 19002.17, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[221] = CreateDynamicObject(620, -18727.13, 19008.45, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[222] = CreateDynamicObject(620, -18735.82, 19011.81, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[223] = CreateDynamicObject(620, -18730.38, 19021.09, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[224] = CreateDynamicObject(620, -18733.25, 19037.54, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[225] = CreateDynamicObject(620, -18756.63, 19030.13, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[226] = CreateDynamicObject(620, -18749.52, 19043.38, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[227] = CreateDynamicObject(620, -18738.77, 19055.43, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[228] = CreateDynamicObject(620, -18725.13, 19061.27, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[229] = CreateDynamicObject(620, -18710.89, 19060.6, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[230] = CreateDynamicObject(620, -18695.46, 19023.54, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[231] = CreateDynamicObject(620, -18701.42, 19009.06, 48.70,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[232] = CreateDynamicObject(826, -18354.7, 19004.82, 11.56,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[233] = CreateDynamicObject(826, -18346.44, 18995.01, 11.56,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[234] = CreateDynamicObject(19126, -18725.72, 19061.2, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[235] = CreateDynamicObject(19126, -18739.28, 19055.35, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[236] = CreateDynamicObject(19126, -18711.71, 19060.54, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[237] = CreateDynamicObject(19126, -18750.23, 19043.27, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[238] = CreateDynamicObject(19126, -18733.89, 19037.48, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[239] = CreateDynamicObject(19126, -18757.29, 19030.1, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[240] = CreateDynamicObject(19126, -18731, 19021.15, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[241] = CreateDynamicObject(19126, -18736.43, 19011.86, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[242] = CreateDynamicObject(19126, -18727.84, 19008.54, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[243] = CreateDynamicObject(19126, -18723.99, 19002.21, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[244] = CreateDynamicObject(19126, -18712.33, 19002.87, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[245] = CreateDynamicObject(19126, -18702.14, 19009.09, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[246] = CreateDynamicObject(19126, -18696.16, 19023.61, 49.91,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[247] = CreateDynamicObject(714, -18400.48, 18996.64, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[248] = CreateDynamicObject(714, -18365.82, 18970.65, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[249] = CreateDynamicObject(714, -18335.18, 18938.71, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[250] = CreateDynamicObject(714, -18432.83, 18987.17, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[251] = CreateDynamicObject(714, -18378.66, 18920.74, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[252] = CreateDynamicObject(714, -18480.88, 18763.03, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[253] = CreateDynamicObject(714, -18520.24, 18803.08, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[254] = CreateDynamicObject(714, -18563.36, 18849.9, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[255] = CreateDynamicObject(714, -18541.14, 18897.18, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[256] = CreateDynamicObject(714, -18455.26, 18813.98, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[257] = CreateDynamicObject(714, -18503.96, 18958.18, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[258] = CreateDynamicObject(714, -18408.04, 18851.06, 9.63,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[259] = CreateDynamicObject(621, -18485.09, 18825.74, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[260] = CreateDynamicObject(621, -18498.25, 18839.14, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[261] = CreateDynamicObject(621, -18513.74, 18855.71, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[262] = CreateDynamicObject(621, -18521.74, 18879.74, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[263] = CreateDynamicObject(621, -18455.2, 18874.04, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[264] = CreateDynamicObject(621, -18426.82, 18828.94, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[265] = CreateDynamicObject(621, -18473.8, 18896.64, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[266] = CreateDynamicObject(621, -18466.52, 18918.95, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[267] = CreateDynamicObject(621, -18441.71, 18926.47, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[268] = CreateDynamicObject(621, -18423.3, 18905.16, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[269] = CreateDynamicObject(621, -18431.16, 18880.85, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[270] = CreateDynamicObject(621, -18370.16, 18890.7, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[271] = CreateDynamicObject(621, -18381.61, 18945.78, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[272] = CreateDynamicObject(621, -18421.15, 18964.6, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[273] = CreateDynamicObject(621, -18461.16, 18987.25, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[274] = CreateDynamicObject(621, -18486.75, 18976.05, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[275] = CreateDynamicObject(621, -18547.09, 18930.57, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[276] = CreateDynamicObject(621, -18570.52, 18895.8, 9.20,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[277] = CreateDynamicObject(619, -18197.57, 19001.99, 1.14,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[278] = CreateDynamicObject(619, -18356.17, 19173.6, 1.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[279] = CreateDynamicObject(619, -18363.19, 19164.65, 1.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[280] = CreateDynamicObject(619, -18370.56, 19155.88, 1.61,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[281] = CreateDynamicObject(619, -18208.49, 18995.37, 1.14,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[282] = CreateDynamicObject(619, -18217.11, 18988.43, 1.14,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[283] = CreateDynamicObject(620, -18353.46, 19017.21, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[284] = CreateDynamicObject(620, -18358.81, 19022.79, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[285] = CreateDynamicObject(620, -18364.58, 19029.17, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[286] = CreateDynamicObject(620, -18371.2, 19036.31, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[287] = CreateDynamicObject(620, -18378.06, 19042.78, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[288] = CreateDynamicObject(620, -18384.51, 19049.31, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[289] = CreateDynamicObject(620, -18391.43, 19056.24, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[290] = CreateDynamicObject(620, -18397.79, 19061.96, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[291] = CreateDynamicObject(620, -18404.44, 19069.15, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[292] = CreateDynamicObject(620, -18410.94, 19077.86, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[293] = CreateDynamicObject(620, -18413.78, 19086.64, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[294] = CreateDynamicObject(620, -18410.62, 19097, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[295] = CreateDynamicObject(620, -18413.59, 19107.45, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[296] = CreateDynamicObject(620, -18389.93, 19113.7, 6.88,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[297] = CreateDynamicObject(620, -18355.73, 19071.72, 6.88,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[298] = CreateDynamicObject(620, -18348.98, 19032.9, 6.88,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[299] = CreateDynamicObject(620, -18385.22, 19078.41, 6.88,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[300] = CreateDynamicObject(620, -18333.24, 18989.09, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[301] = CreateDynamicObject(620, -18303.11, 18998.67, 7.79,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[302] = CreateDynamicObject(620, -18293.39, 18988.78, 7.79,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[303] = CreateDynamicObject(620, -18313.86, 18967.75, 8.51,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[304] = CreateDynamicObject(620, -18271.36, 18961.25, 7.79,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[305] = CreateDynamicObject(3461, -18667.46, 18485.36, 3.78,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[306] = CreateDynamicObject(3461, -18667.32, 18485.28, 3.80,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[307] = CreateDynamicObject(3461, -18667.18, 18485.18, 3.81,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[308] = CreateDynamicObject(3461, -18667.33, 18485.45, 3.83,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[309] = CreateDynamicObject(3461, -18667.18, 18485.35, 3.84,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[310] = CreateDynamicObject(3461, -18667.46, 18485.2, 3.77,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[311] = CreateDynamicObject(3461, -18667.33, 18485.11, 3.77,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[312] = CreateDynamicObject(3461, -18667.17, 18485.51, 3.87,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[313] = CreateDynamicObject(3461, -18667.03, 18485.26, 3.83,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[314] = CreateDynamicObject(3461, -18667.21, 18485.01, 3.77,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[315] = CreateDynamicObject(3461, -18667.47, 18485.04, 3.72,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[316] = CreateDynamicObject(3461, -18667.61, 18485.27, 3.73,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[317] = CreateDynamicObject(3461, -18667.47, 18485.53, 3.81,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[318] = CreateDynamicObject(3461, -18667.03, 18485.43, 3.86,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[319] = CreateDynamicObject(3461, -18667.07, 18485.09, 3.80,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[320] = CreateDynamicObject(3461, -18667.34, 18484.96, 3.75,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[0] = CreateDynamicObject(3461, -18667.59, 18485.14, 3.73,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[33] = CreateDynamicObject(3461, -18667.59, 18485.42, 3.77,   0.00, 0.00, 0.00, -1, -1, -1, 500);
	ObjStrI[57] = CreateDynamicObject(3461, -18667.31, 18485.61, 3.85,   0.00, 0.00, 0.00, -1, -1, -1, 500);

	TexNad[0] = CreateDynamic3DTextLabel("Источник энергии сервера\n'' вода и пламя ''", 0xFF0000FF, -18738.44, 19069.92, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[1] = CreateDynamic3DTextLabel("Ты сам придумал сказку,\nи вдохновлённый мечтой , ...", 0x00FF00FF, -18693.81, 19015.34, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[2] = CreateDynamic3DTextLabel("... подогреваемый желанием\nбросился на её поиски ...", 0x00FF00FF, -18692.94, 19003.41, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[3] = CreateDynamic3DTextLabel("... Мы просто хотели узнать,\nк чему тебя приведёт твоя внутренняя мотивация -- ...", 0x00FF00FF, -18696.44, 18993.57, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[4] = CreateDynamic3DTextLabel("... -- что этот остров - часть\nчудовищной административной лжи ? ...", 0x00FF00FF, -18708.37, 18979.09, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[5] = CreateDynamic3DTextLabel("... -- или величайшему дару\nданному человеку - ...", 0x00FF00FF, -18718.72, 18971.83, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[6] = CreateDynamic3DTextLabel("... способности гнаться\nза своей мечтой ? ...", 0x00FF00FF, -18728.32, 18970.66, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[7] = CreateDynamic3DTextLabel("... Брайан Олдис -\n'' Суперигрушек хватает на всё лето '' (1969 год)", 0x00FF00FF, -18738.70, 18981.63, 50.75, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[8] = CreateDynamic3DTextLabel("_PeNGuIn_\n(f. Genko_Leiman)", 0xF9E245FF, -18353.20, 19018.06, 10.74, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[9] = CreateDynamic3DTextLabel("EightingKey.kinder\n(f. kinder)", 0xF9E245FF, -18358.91, 19023.74, 10.71, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[10] = CreateDynamic3DTextLabel("dima_WN\n(f. dima)", 0xF9E245FF, -18351.44, 19030.29, 10.92, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[11] = CreateDynamic3DTextLabel("Aleksey_Perevalov", 0xF9E245FF, -18364.49, 19030.12, 10.66, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[12] = CreateDynamic3DTextLabel("M@KsIk_ak47", 0xF9E245FF, -18357.08, 19036.27, 10.88, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[13] = CreateDynamic3DTextLabel("lolololllka", 0xF9E245FF, -18371.42, 19037.27, 10.63, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[14] = CreateDynamic3DTextLabel("UDFJuIcE", 0xF9E245FF, -18364.64, 19044.00, 10.85, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[15] = CreateDynamic3DTextLabel("Brooklyn", 0xF9E245FF, -18377.97, 19043.73, 10.61, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[16] = CreateDynamic3DTextLabel("BlackNero\n(f. Chris_Nighter)", 0xF9E245FF, -18371.07, 19050.82, 10.29, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[17] = CreateDynamic3DTextLabel("Kesha_Ultra\n(f. SLAVA999)", 0xF9E245FF, -18384.21, 19050.12, 10.57, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[18] = CreateDynamic3DTextLabel("36_Rus\n(f. Sergei_Gunin)", 0xF9E245FF, -18377.68, 19056.79, 10.28, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[19] = CreateDynamic3DTextLabel("imx", 0xF9E245FF, -18391.09, 19056.97, 10.54, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[20] = CreateDynamic3DTextLabel("Jon_Smith007\n(f. Jon007)", 0xF9E245FF, -18384.71, 19064.07, 10.23, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[21] = CreateDynamic3DTextLabel("Nikita_Baskov", 0xF9E245FF, -18397.73, 19062.92, 11.33, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[22] = CreateDynamic3DTextLabel("SnIkErS", 0xF9E245FF, -18390.48, 19070.17, 10.20, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[23] = CreateDynamic3DTextLabel("alexs655", 0xF9E245FF, -18404.63, 19070.11, 11.26, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[24] = CreateDynamic3DTextLabel("Igor_Newman", 0xF9E245FF, -18396.91, 19077.36, 10.14, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[25] = CreateDynamic3DTextLabel("OksanaPff", 0xF9E245FF, -18410.58, 19078.38, 10.82, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[26] = CreateDynamic3DTextLabel("Asik26\n(f. DoM)", 0xF9E245FF, -18402.72, 19083.61, 10.10, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[27] = CreateDynamic3DTextLabel("Nastya_Karamelko", 0xF9E245FF, -18413.42, 19086.69, 10.54, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[28] = CreateDynamic3DTextLabel("ser", 0xF9E245FF, -18401.66, 19093.09, 9.82, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[29] = CreateDynamic3DTextLabel("CyXaPiK\n(f. Guy_Fox.)", 0xF9E245FF, -18410.49, 19096.08, 10.28, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[30] = CreateDynamic3DTextLabel("Morphin\n(f. FOGGYMAN)", 0xF9E245FF, -18401.58, 19105.52, 9.48, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[31] = CreateDynamic3DTextLabel("Woody\n(f. Uzun_Ilya)", 0xF9E245FF, -18413.72, 19108.40, 10.44, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[32] = CreateDynamic3DTextLabel("Igor_Naumov\n(f. iga_iga_Dja)", 0xF9E245FF, -18402.66, 19116.60, 9.14, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[33] = CreateDynamic3DTextLabel("evgenii_dja", 0xF9E245FF, -18395.27, 19108.90, 9.16, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[34] = CreateDynamic3DTextLabel("Ivan_susanin", 0xF9E245FF, -18396.97, 19100.47, 9.52, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[35] = CreateDynamic3DTextLabel("chernomor05", 0xF9E245FF, -18389.28, 19102.22, 9.11, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[36] = CreateDynamic3DTextLabel("Next", 0xF9E245FF, -18390.62, 19093.83, 9.56, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[37] = CreateDynamic3DTextLabel("Sevgeny", 0xF9E245FF, -18382.15, 19094.28, 9.05, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[38] = CreateDynamic3DTextLabel("MegaMlok", 0xF9E245FF, -18382.43, 19085.21, 9.61, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[39] = CreateDynamic3DTextLabel("EBGEHbI4)", 0xF9E245FF, -18372.46, 19084.39, 9.03, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[40] = CreateDynamic3DTextLabel("Igor_Dobra", 0xF9E245FF, -18373.43, 19076.26, 9.65, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[41] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18364.32, 19076.73, 8.83, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[42] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18366.41, 19068.38, 9.71, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[43] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18357.04, 19069.55, 8.87, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[44] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18349.84, 19062.02, 8.91, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);

	islkl = 1;
	timeronesec = SetTimer("OneSec", 981, 1);
	return 1;
}

public OnFilterScriptExit()
{
	Delete3DTextLabel(fantxt);//удаляем 3D-текст с несущесвующим ИД
	new string[256];
	new pname[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "TotPr") == 1)
			{
				GetPlayerName(i,pname,sizeof(pname));
				format(string, sizeof(string), "* Игрок %s лишился защитного тотема острова (выгрузка скрипта) .", pname);
				SendAdminMessage(COLOR_RED, string);
				SendClientMessage(i, COLOR_RED, "* Вы лишились защитного тотема острова (выгрузка скрипта) .");
				new aa333[64];//доработка для использования Русских ников
				format(aa333, sizeof(aa333), "%s", pname);//доработка для использования Русских ников
				printf("[island] Игрок %s лишился защитного тотема острова (выгрузка скрипта) .", aa333);//доработка для использования Русских ников
//				printf("[island] Игрок %s лишился защитного тотема острова (выгрузка скрипта) .", pname);
			}
			TextDrawHideForPlayer(i, PlNot);
			DeletePVar(i, "TotPr");
			totoff[i] = 0;
			plmess[i] = 0;
		}
	}
	for(new i = 0; i < MAX_NADP; i++)
	{
		DestroyDynamic3DTextLabel(TexNad[i]);
	}
	for(new i = 0; i < 321; i++)
	{
	    DestroyDynamicObject(ObjStrI[i]);
	}
	for(new i = 0; i < 3; i++)
	{
	    DestroyObject(ObjGamI[i]);
	}
	KillTimer(timeronesec);
	return 1;
}

public OnPlayerConnect(playerid)
{
	TextDrawHideForPlayer(playerid, PlNot);
	SetPVarInt(playerid, "TotPr", 0);
	totoff[playerid] = 0;
	plmess[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(GetPVarInt(playerid, "TotPr") == 1)
	{
		new string[256];
		new pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid,pname,sizeof(pname));
		format(string, sizeof(string), "* Игрок %s лишился защитного тотема острова (вышел с сервера) .", pname);
		SendAdminMessage(COLOR_RED, string);
		new aa333[64];//доработка для использования Русских ников
		format(aa333, sizeof(aa333), "%s", pname);//доработка для использования Русских ников
		printf("[island] Игрок %s лишился защитного тотема острова (вышел с сервера) .", aa333);//доработка для использования Русских ников
//		printf("[island] Игрок %s лишился защитного тотема острова (вышел с сервера) .", pname);
	}
	TextDrawHideForPlayer(playerid, PlNot);
	DeletePVar(playerid, "TotPr");
	totoff[playerid] = 0;
	plmess[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawHideForPlayer(playerid, PlNot);
	SetTimerEx("PlaySpa", 1000, 0, "i", playerid);
	return 1;
}

public SendAdminMessage(color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    if(GetPVarInt(i, "AdmLvl") >= 1)
		    {
				SendClientMessage(i, color, string);
			}
		}
	}
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
	if(GetPVarInt(playerid, "CComAc3") < 0)
	{
		new dopcis, sstr[256];
		dopcis = FCislit(GetPVarInt(playerid, "CComAc3"));
		switch(dopcis)
		{
			case 0: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунд !", GetPVarInt(playerid, "CComAc3") * -1);
			case 1: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунду !", GetPVarInt(playerid, "CComAc3") * -1);
			case 2: format(sstr, sizeof(sstr), " Спам в чате (или в командах) !   Попробуйте через %d секунды !", GetPVarInt(playerid, "CComAc3") * -1);
		}
		SendClientMessage(playerid, COLOR_RED, sstr);
		return 1;
	}
	SetPVarInt(playerid, "CComAc3", GetPVarInt(playerid, "CComAc3") + 1);
	new string[256];
	new cmd[256];
	new tmp[256];
	new idx;
    new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	new aa333[64];//доработка для использования Русских ников
	format(aa333, sizeof(aa333), "%s", pname);//доработка для использования Русских ников
	cmd = strtok(cmdtext, idx);
	if (strcmp(cmd,"/islhelp",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid,COLOR_GREY," -------------------------------- Помощь по острову --------------------------------- ");
			SendClientMessage(playerid,COLOR_GREY,"                    /islhelp   /isltpa   /isltpv   /isltpb   /islon   /isloff");
			SendClientMessage(playerid,COLOR_GREY,"   /isltotmon [ид игрока]   /isltoton [ид игрока]   /isltotoff [ид игрока]");
			SendClientMessage(playerid,COLOR_GREY," ------------------------------------------------------------------------------------------------ ");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
    }
	if (strcmp(cmd,"/isltpa",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
		{
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команда не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
  			SetPlayerPos(playerid,-17938.05,17906.82,11.00+1);
			printf("[island] Админ %s телепортировался на взлётку острова.", aa333);//доработка для использования Русских ников
//			printf("[island] Админ %s телепортировался на взлётку острова.", pname);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
    }
	if (strcmp(cmd,"/isltpv",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
        {
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команда не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
  			SetPlayerPos(playerid,-18492.83,18791.13,10.98+1);
			printf("[island] Админ %s телепортировался в посёлок острова.", aa333);//доработка для использования Русских ников
//			printf("[island] Админ %s телепортировался в посёлок острова.", pname);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
    }
	if (strcmp(cmd,"/isltpb",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
        {
			if(GetPVarInt(playerid, "SecPris") > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме команда не работают !");
				return 1;
			}
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
  			SetPlayerPos(playerid,-18278.98,19014.87,7.00+1);
			printf("[island] Админ %s телепортировался на пляж острова.", aa333);//доработка для использования Русских ников
//			printf("[island] Админ %s телепортировался на пляж острова.", pname);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
    }
	if (strcmp(cmd,"/islon",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
        {
			new Float:PosX, Float:PosY, Float:PosZ;
			GetPlayerPos(playerid, PosX, PosY, PosZ);
			if((20000 >= PosX > -17500 && -20000 <= PosY <= 20000) ||
			(20000 >= PosX >= -20000 && -20000 <= PosY < 17500))
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, вы не на острове !");
				return 1;
			}
			if(islkl == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, остров уже на поверхности !");
				return 1;
			}
			Islon();
			islkl = 1;
  	   		format(string, sizeof(string), " *** Админ %s вернул остров на поверхность.", pname);
			SendAdminMessage(COLOR_GREEN, string);
			printf("[island] Админ %s вернул остров на поверхность.", aa333);//доработка для использования Русских ников
//			printf("[island] Админ %s вернул остров на поверхность.", pname);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
    }
	if (strcmp(cmd,"/isloff",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
        {
			new Float:PosX, Float:PosY, Float:PosZ;
			GetPlayerPos(playerid, PosX, PosY, PosZ);
			if((20000 >= PosX > -17500 && -20000 <= PosY <= 20000) ||
			(20000 >= PosX >= -20000 && -20000 <= PosY < 17500))
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, вы не на острове !");
				return 1;
			}
			if(islkl == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, остров уже скрыт !");
				return 1;
			}
			Isloff();
			islkl = 0;
  	   		format(string, sizeof(string), " *** Админ %s скрыл остров.", pname);
			SendAdminMessage(COLOR_RED, string);
			printf("[island] Админ %s скрыл остров.", aa333);//доработка для использования Русских ников
//			printf("[island] Админ %s скрыл остров.", pname);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
    }
	if (strcmp(cmd,"/isltotmon",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
        {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GREY, " Используйте: /isltatmon [ид игрока]");
				return 1;
			}
			new para1 = strval(tmp);
   			if(IsPlayerConnected(para1))
		    {
				if(GetPVarInt(para1, "AdmLvl") >= 1)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок - админ !");
					return 1;
				}
				if(GetPVarInt(para1, "TotPr") == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " У выбранного игрока нет защитного тотема.");
				}
				else
				{
					SendClientMessage(playerid, COLOR_GREEN, " У выбранного игрока есть защитный тотем.");
				}
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
	if (strcmp(cmd,"/isltoton",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
        {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GREY, " Используйте: /isltaton [ид игрока]");
				return 1;
			}
			new para1 = strval(tmp);
   			if(IsPlayerConnected(para1))
		    {
				if(GetPVarInt(para1, "AdmLvl") >= 1)
				{
					SendClientMessage(playerid, COLOR_RED, " Админ не нуждается в защитном тотеме !");
					return 1;
				}
				if(GetPVarInt(para1, "TotPr") == 1)
				{
					SendClientMessage(playerid, COLOR_RED, " У выбранного игрока уже есть защитный тотем !");
					return 1;
				}
				SetPVarInt(para1, "TotPr", 1);
    			new sendername[MAX_PLAYER_NAME];
				GetPlayerName(para1,sendername,sizeof(sendername));
  	   			format(string, sizeof(string), " *** Админ %s дал игроку %s защитный тотем острова.", pname, sendername);
				SendAdminMessage(COLOR_YELLOW, string);
  	   			format(string, sizeof(string), " *** Админ %s дал Вам защитный тотем острова.", pname);
				SendClientMessage(para1, COLOR_YELLOW, string);
				new aa222[64];//доработка для использования Русских ников
				format(aa222, sizeof(aa222), "%s", sendername);//доработка для использования Русских ников
				printf("[island] Админ %s дал игроку %s защитный тотем острова.", aa333, aa222);//доработка для использования Русских ников
//				printf("[island] Админ %s дал игроку %s защитный тотем острова.", pname, sendername);
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
	if (strcmp(cmd,"/isltotoff",true) == 0)
	{
		if(GetPVarInt(playerid, "AdmLvl") >= 1 || IsPlayerAdmin(playerid))
        {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GREY, " Используйте: /isltatoff [ид игрока]");
				return 1;
			}
			new para1 = strval(tmp);
   			if(IsPlayerConnected(para1))
		    {
				if(GetPVarInt(para1, "AdmLvl") >= 1)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы не можете забрать у админа защитный тотем !");
					return 1;
				}
				if(GetPVarInt(para1, "TotPr") == 0 || totoff[para1] == 1)
				{
					SendClientMessage(playerid, COLOR_RED, " У выбранного игрока уже нет защитного тотема !");
					return 1;
				}
				new Float:PosX, Float:PosY, Float:PosZ;
				GetPlayerPos(para1, PosX, PosY, PosZ);
				if((20000 >= PosX > -15500 && -20000 <= PosY <= 20000) ||
				(20000 >= PosX >= -20000 && -20000 <= PosY < 15500))
				{
					SetPVarInt(para1, "TotPr", 0);
				}
				else
				{
					totoff[para1] = 1;
					SecSpa333(para1);
				}
    			new sendername[MAX_PLAYER_NAME];
				GetPlayerName(para1,sendername,sizeof(sendername));
  	   			format(string, sizeof(string), " *** Админ %s лишил игрока %s защитного тотема острова.", pname, sendername);
				SendAdminMessage(COLOR_RED, string);
  	   			format(string, sizeof(string), " *** Админ %s лишил Вас защитного тотема острова.", pname);
				SendClientMessage(para1, COLOR_RED, string);
				new aa222[64];//доработка для использования Русских ников
				format(aa222, sizeof(aa222), "%s", sendername);//доработка для использования Русских ников
				printf("[island] Админ %s лишил игрока %s защитного тотема острова.", aa333, aa222);//доработка для использования Русских ников
//				printf("[island] Админ %s лишил игрока %s защитного тотема острова.", pname, sendername);
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
	return 0;
}

public OneSec()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "AdmLvl") == 0 && GetPVarInt(i, "TotPr") == 0)
			{
				new Float:PosX, Float:PosY, Float:PosZ;
				GetPlayerPos(i, PosX, PosY, PosZ);
				if((20000 >= PosX > -15500 && -20000 <= PosY <= 20000) ||
				(20000 >= PosX >= -20000 && -20000 <= PosY < 15500))
				{
					TextDrawHideForPlayer(i, PlNot);
					plmess[i] = 0;
				}
				if((-15500 >= PosX > -16500 && 15500 <= PosY <= 20000) ||
				(-15500 >= PosX >= -20000 && 15500 <= PosY < 16500))
				{
					TextDrawHideForPlayer(i, PlNot);
					TextDrawShowForPlayer(i, PlNot);
					if(plmess[i] == 0)
					{
						SendClientMessage(i, COLOR_RED, " Внимание !!! Вы на запрещённой территории !!! Поверните назад !!!");
						SendClientMessage(i, COLOR_RED, " Иначе, система защиты отправит Вас на респавн !!!");
						SendClientMessage(i, COLOR_RED, " Деньги за утраченный транспорт возвращаться НЕ БУДУТ !!!");
						plmess[i] = 1;
					}
				}
				if((-16500 >= PosX > -17500 && 16500 <= PosY <= 20000) ||
				(-16500 >= PosX >= -20000 && 16500 <= PosY < 17500))
				{
					TextDrawHideForPlayer(i, PlNot);
					if(IsPlayerInAnyVehicle(i))
					{
						new Float:x, Float:y, Float:z;
						GetPlayerPos(i,x,y,z);
						SetPlayerPos(i,x,y,z+5);
						SetTimerEx("SecSpa333", 300, 0, "i", i);
					}
					else
					{
						SecSpa333(i);
					}
				}
				if(-17500 >= PosX >= -20000 && 17500 <= PosY <= 20000)
				{
					TextDrawHideForPlayer(i, PlNot);
					SecSpa333(i);
					new string[256],pname[MAX_PLAYER_NAME];
					GetPlayerName(i,pname,sizeof(pname));
					format(string,sizeof(string),"* Игрок %s [%d] был кикнут, за проникновение на запрещённую территорию без допуска !",pname,i);
					SendClientMessageToAll(COLOR_RED,string);
					new aa333[64];//доработка для использования Русских ников
					format(aa333, sizeof(aa333), "%s", pname);//доработка для использования Русских ников
					printf("[island] Игрок %s [%d] был кикнут, за проникновение на запрещённую территорию без допуска !",aa333,i);//доработка для использования Русских ников
//					printf("[island] Игрок %s [%d] был кикнут, за проникновение на запрещённую территорию без допуска !",pname,i);
					SetTimerEx("PlayKick", 300, 0, "i", i);
				}
			}
		}
	}
	return 1;
}

public PlaySpa(playerid)
{
	if(totoff[playerid] == 1)
	{
		SetPVarInt(playerid, "TotPr", 0);
		totoff[playerid] = 0;
	}
	return 1;
}

public SecSpa333(playerid)
{
	CallRemoteFunction("SecSpa", "d", playerid);
	return 1;
}

public PlayKick(playerid)
{
	Kick(playerid);
	return 1;
}

public Islon()
{
	MoveObject(ObjGamI[0], -18000.13, 18000.04, 10.00, 5, 0.00, 0.00, 135.00);
	MoveObject(ObjGamI[1], -18557.82, 18809.86, 9.75, 5, 0.00, 0.00, 135.00);
	MoveObject(ObjGamI[2], -18259.07, 19008.86, 4.09, 5, 2.00, 0.21, 134.70);

//	MoveDynamicObject(ObjStrI[0], -18000.13, 18000.04, 10.00, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[1], -17890.71, 18106.74, 10.00, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[2], -18194.64, 18177.54, 10.00, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[3], -18077.19, 18295.56, 10.00, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[4], -18385.13, 18339.97, 9.75, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[5], -18258.37, 18450.38, 16.24, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[6], -17802.57, 17909.89, -0.14, 5); //   0.99, 0.00, 45.00);
	MoveDynamicObject(ObjStrI[7], -17774.43, 18091.21, 0.70, 5); //   0.00, 0.00, 136.44);
	MoveDynamicObject(ObjStrI[8], -17676.99, 18040.88, -2.77, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[9], -17744.7, 18037.79, 1.95, 5); //   -12.07, 0.00, -18.00);
	MoveDynamicObject(ObjStrI[10], -17875.82, 18205.58, 40.27, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[11], -18131.87, 18455.78, 48.15, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[12], -17964.89, 18377.11, 0.01, 5); //   0.78, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[13], -17857.02, 18232.51, -1.54, 5); //   -11.00, 0.00, -11.00);
	MoveDynamicObject(ObjStrI[14], -18123.84, 18467.3, 0.92, 5); //   -10.00, 0.00, -11.00);
	MoveDynamicObject(ObjStrI[15], -18167.09, 18461.78, -0.69, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[16], -18063.58, 17906.95, 0.69, 5); //   0.00, 0.00, -45.00);
	MoveDynamicObject(ObjStrI[17], -18311.78, 18155.54, 0.69, 5); //   0.00, 0.00, -45.00);
	MoveDynamicObject(ObjStrI[18], -18574.26, 18379.27, 0.70, 5); //   0.00, 0.00, -44.42);
	MoveDynamicObject(ObjStrI[19], -18218.78, 18512.36, -0.69, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[20], -18280.26, 18553.36, -0.69, 5); //   0.00, 0.00, 113.00);
	MoveDynamicObject(ObjStrI[21], -18342.18, 18541.39, -0.79, 5); //   0.00, 0.00, 149.00);
	MoveDynamicObject(ObjStrI[22], -18432.09, 18271.27, -3.23, 5); //   -18.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[23], -18449.14, 18518.42, 10.05, 5); //   0.00, 0.00, 142.00);
	MoveDynamicObject(ObjStrI[24], -18390.33, 18499.06, -0.79, 5); //   0.00, 0.00, 149.00);
	MoveDynamicObject(ObjStrI[25], -18475.39, 18428.66, -0.58, 5); //   0.00, 0.00, 149.00);
	MoveDynamicObject(ObjStrI[26], -18431.33, 18665, 10.05, 5); //   0.00, 0.00, -37.54);
	MoveDynamicObject(ObjStrI[27], -18530.87, 18400.52, -1.69, 5); //   0.00, 0.00, 62.00);
	MoveDynamicObject(ObjStrI[28], -18592.35, 18460.65, -1.69, 5); //   0.00, 0.00, 62.00);
	MoveDynamicObject(ObjStrI[29], -18646.67, 18517.44, -1.69, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[30], -18682.25, 18520.42, -2.83, 5); //   -14.00, 0.00, 156.00);
	MoveDynamicObject(ObjStrI[31], -18399.51, 18968.46, 9.75, 5); //   0.00, 0.00, -45.00);
	MoveDynamicObject(ObjStrI[32], -18478.75, 18889.13, 9.747, 5); //   0.00, 0.00, 135.00);
//	MoveDynamicObject(ObjStrI[33], -18557.82, 18809.86, 9.75, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[34], -17909.63, 17787.33, -1.36, 5); //   0.00, 0.00, 33.00);
	MoveDynamicObject(ObjStrI[35], -17952.37, 17827.41, -0.30, 5); //   0.00, 18.00, 171.00);
	MoveDynamicObject(ObjStrI[36], -17961.59, 17781.25, -3.76, 5); //   0.00, 0.00, -47.00);
	MoveDynamicObject(ObjStrI[37], -18450, 18527.44, -4.00, 5); //   0.00, 0.00, 200.00);
	MoveDynamicObject(ObjStrI[38], -18490.36, 18490.37, -4.00, 5); //   0.00, 0.00, 224.94);
	MoveDynamicObject(ObjStrI[39], -18425.08, 18581.28, -4.00, 5); //   0.00, 0.00, 178.00);
	MoveDynamicObject(ObjStrI[40], -18479.63, 18562.42, -4.00, 5); //   0.00, 0.00, 181.88);
	MoveDynamicObject(ObjStrI[41], -18457.32, 18598.89, -4.00, 5); //   0.00, 0.00, -4.00);
	MoveDynamicObject(ObjStrI[42], -18400.14, 18625.89, -4.00, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[43], -18430.33, 18660.53, -4.00, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[44], -18390.2, 18694.84, -4.00, 5); //   0.00, 0.00, 47.30);
	MoveDynamicObject(ObjStrI[45], -18485.55, 18475.28, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[46], -18480.78, 18465.44, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[47], -18459.67, 18513.03, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[48], -18458.01, 18524.44, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[49], -18485.71, 18541.4, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[50], -18489.45, 18527.46, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[51], -18454.71, 18536.84, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[52], -18424.68, 18649.67, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[53], -18422.26, 18659.99, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[54], -18420.89, 18671.89, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[55], -18395.37, 18640.74, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[56], -18391.7, 18651.04, 9.92, 5); //   0.00, 0.00, 0.00);
//	MoveDynamicObject(ObjStrI[57], -18259.07, 19008.86, 4.09, 5); //   2.00, 0.21, 134.70);
	MoveDynamicObject(ObjStrI[58], -18347.4, 19115.22, 3.63, 5); //   2.00, 0.21, 134.70);
	MoveDynamicObject(ObjStrI[59], -18570.79, 19063.23, 27.97, 5); //   -1.44, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[60], -18390.45, 18659.43, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[61], -18389.49, 18666.68, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[62], -18459.72, 19051.53, -25.46, 5); //   0.00, 0.00, -33.00);
	MoveDynamicObject(ObjStrI[63], -18439.74, 19042.43, -25.87, 5); //   0.00, 0.00, -55.00);
	MoveDynamicObject(ObjStrI[64], -18434.79, 19096.44, 0.06, 5); //   0.00, 0.00, 222.00);
	MoveDynamicObject(ObjStrI[65], -18440.41, 19120.44, 12.30, 5); //   0.00, 0.00, -55.00);
	MoveDynamicObject(ObjStrI[66], -18409.76, 19177.09, 12.31, 5); //   0.00, 0.00, -55.00);
	MoveDynamicObject(ObjStrI[67], -18448.11, 19107.14, 10.25, 5); //   0.00, 0.00, 14.00);
	MoveDynamicObject(ObjStrI[68], -18482.85, 19121.7, 20.81, 5); //   0.00, 0.00, 18.00);
	MoveDynamicObject(ObjStrI[69], -18503.81, 19151.03, 12.30, 5); //   0.00, 0.00, -113.00);
	MoveDynamicObject(ObjStrI[70], -18567.04, 19149.58, 7.69, 5); //   0.00, 0.00, -84.00);
	MoveDynamicObject(ObjStrI[71], -18624.68, 19115.54, 7.69, 5); //   0.00, 0.00, -91.00);
	MoveDynamicObject(ObjStrI[72], -18640.69, 19100.1, 7.69, 5); //   0.00, 0.00, -62.00);
	MoveDynamicObject(ObjStrI[73], -18701.76, 19075.39, 28.44, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[74], -18745.99, 19053.68, 49.84, 5); //   0.00, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[75], -18726.49, 19019.67, 49.84, 5); //   0.00, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[76], -18706.8, 18985.65, 49.84, 5); //   0.00, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[77], -18687.95, 19088.79, 46.39, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[78], -18684.51, 19064.66, 50.83, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[79], -18653.48, 18916.28, 17.23, 5); //   0.00, 0.00, -69.00);
	MoveDynamicObject(ObjStrI[80], -18653.28, 19018.52, 44.77, 5); //   0.00, 0.00, 229.00);
	MoveDynamicObject(ObjStrI[81], -18659.85, 19014.65, 44.77, 5); //   0.00, 0.00, 229.00);
	MoveDynamicObject(ObjStrI[82], -18665.39, 19010.81, 44.77, 5); //   0.00, 0.00, 229.00);
	MoveDynamicObject(ObjStrI[83], -18625.72, 18963.48, 17.23, 5); //   0.00, 0.00, 11.00);
	MoveDynamicObject(ObjStrI[84], -18663.92, 18976.54, 17.23, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[85], -18679.76, 19002.36, 52.80, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[86], -18678.2, 18992.62, 52.80, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[87], -18677.56, 18985.15, 52.80, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[88], -18682.66, 18984.03, 59.35, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[89], -18683.93, 18992.34, 59.35, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[90], -18681.45, 19002.36, 59.35, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[91], -18703.65, 18957.27, 17.23, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[92], -18741.65, 18946.65, 17.23, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[93], -18770.05, 18986.05, 17.23, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[94], -18784.81, 19013.56, 17.23, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[95], -18812.4, 19055.98, 17.23, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[96], -18772.44, 19079.1, 17.23, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[97], -18743.02, 18886.76, 17.23, 5); //   0.00, 0.00, -91.00);
	MoveDynamicObject(ObjStrI[98], -18802.8, 18933.61, 17.23, 5); //   0.00, 0.00, -142.00);
	MoveDynamicObject(ObjStrI[99], -18831.94, 18982.87, 17.23, 5); //   0.00, 0.00, -142.00);
	MoveDynamicObject(ObjStrI[100], -18841.07, 19053.99, 17.23, 5); //   0.00, 0.00, -207.00);
	MoveDynamicObject(ObjStrI[101], -18813.11, 19130.07, 17.23, 5); //   0.00, 0.00, -236.00);
	MoveDynamicObject(ObjStrI[102], -18730.91, 19153.34, 17.23, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[103], -18679.15, 19160.31, 27.06, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[104], -18624.51, 19195.57, 9.47, 5); //   0.00, 0.00, 98.00);
	MoveDynamicObject(ObjStrI[105], -18549.03, 19220.81, 8.93, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[106], -18469.11, 19221.98, 10.38, 5); //   0.00, 0.00, 62.00);
	MoveDynamicObject(ObjStrI[107], -18436.83, 19234.48, 12.95, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[108], -18426.3, 19255.46, 12.95, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[109], -18393.59, 19251.71, 12.95, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[110], -18651.44, 19144.39, 30.54, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[111], -18400.84, 18719.23, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[112], -18407.17, 18728.86, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[113], -18465.43, 18700, -4.00, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[114], -18431.8, 18710.67, 9.92, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[115], -18513.05, 18683.87, -4.00, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[116], -18562.44, 18735.46, -4.00, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[117], -18611.99, 18782.89, -4.00, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[118], -18658.43, 18829.16, -4.00, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[119], -18694.41, 18871.4, 9.88, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[120], -18645.85, 18833.53, 3.22, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[121], -18600.68, 18792.13, 3.22, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[122], -18551.05, 18748, 3.22, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[123], -18504.05, 18693.07, 3.22, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[124], -18473.34, 18706.7, 3.22, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[125], -18370.91, 18790.43, -4.00, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[126], -18323.29, 18843.39, -4.00, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[127], -18280, 18887.96, -4.00, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[128], -18236.59, 18931.2, -4.00, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[129], -18186.23, 18972.79, -4.00, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[130], -18247.93, 18940.82, 3.22, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[131], -18290.62, 18897.63, 3.22, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[132], -18330.54, 18853.41, 3.22, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[133], -18372.96, 18807.36, 3.22, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[134], -18440.58, 19020.08, 12.33, 5); //   0.00, 0.00, 91.00);
	MoveDynamicObject(ObjStrI[135], -18466.43, 19019.1, 12.44, 5); //   0.00, 0.00, -178.00);
	MoveDynamicObject(ObjStrI[136], -18494.2, 19015.1, 12.42, 5); //   0.00, 0.00, 105.00);
	MoveDynamicObject(ObjStrI[137], -18519.32, 19000.38, 12.59, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[138], -18535.82, 18981.43, 12.45, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[139], -18575.99, 18933.24, 12.60, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[140], -18593.13, 18911.71, 12.74, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[141], -18609.73, 18880.65, 12.33, 5); //   0.00, 0.00, -185.00);
	MoveDynamicObject(ObjStrI[142], -18604.74, 18848.76, 12.44, 5); //   0.00, 0.00, -62.00);
	MoveDynamicObject(ObjStrI[143], -18584.84, 18826.15, 12.42, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[144], -18565.08, 18807.51, 12.59, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[145], -18545.51, 18789.2, 12.45, 5); //   0.00, 0.00, -44.56);
	MoveDynamicObject(ObjStrI[146], -18528.82, 18771.52, 12.60, 5); //   0.00, 0.00, -44.89);
	MoveDynamicObject(ObjStrI[147], -18510.17, 18753.29, 12.74, 5); //   0.00, 0.00, -44.22);
	MoveDynamicObject(ObjStrI[148], -18491.6, 18733.63, 12.33, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[149], -18433.27, 18782.01, 12.44, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[150], -18417.23, 18802.23, 12.42, 5); //   0.00, 0.00, -43.00);
	MoveDynamicObject(ObjStrI[151], -18399.58, 18820.8, 12.59, 5); //   0.00, 0.00, -43.11);
	MoveDynamicObject(ObjStrI[152], -18382.72, 18838.68, 12.45, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[153], -18368.63, 18854.13, 12.60, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[154], -18354.44, 18871.15, 12.74, 5); //   0.00, 0.00, 48.55);
	MoveDynamicObject(ObjStrI[155], -18337.93, 18888.8, 12.33, 5); //   0.00, 0.00, -42.00);
	MoveDynamicObject(ObjStrI[156], -18321.71, 18905.22, 12.44, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[157], -18305.78, 18923.76, 12.42, 5); //   0.00, 0.00, -42.89);
	MoveDynamicObject(ObjStrI[158], -18689.69, 19052.5, 50.53, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[159], -18681.5, 19038.44, 50.53, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[160], -18740.22, 19072.11, 52.18, 5); //   0.00, 0.00, -142.00);
	MoveDynamicObject(ObjStrI[161], -18740.53, 19076.49, 54.00, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[162], -18740.89, 19076.39, 54.00, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[163], -18741.24, 19076.26, 54.03, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[164], -18741.57, 19076.18, 54.04, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[165], -18741.91, 19076.07, 54.09, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[166], -18742.31, 19075.93, 54.10, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[167], -18742.69, 19075.82, 54.17, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[168], -18688.04, 19016.48, 51.73, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[169], -18704.51, 18974.95, 51.71, 5); //   0.00, 0.00, -164.00);
	MoveDynamicObject(ObjStrI[170], -18741.76, 18976.86, 51.87, 5); //   0.00, 0.00, -236.00);
	MoveDynamicObject(ObjStrI[171], -18767.51, 19017.05, 51.67, 5); //   0.00, 0.00, -244.00);
	MoveDynamicObject(ObjStrI[172], -18770.67, 19053.9, 51.68, 5); //   0.00, 0.00, 33.00);
	MoveDynamicObject(ObjStrI[173], -18447.29, 18899.42, 13.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[174], -18415.13, 18930.49, 13.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[175], -18480.65, 18867.86, 13.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[176], -18494.43, 18914.4, 13.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[177], -18458.35, 18948.6, 13.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[178], -18437.24, 18853.34, 13.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[179], -18404.51, 18884.13, 13.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[180], -18553.27, 18977.29, 12.24, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[181], -18576.89, 18953.3, 12.24, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[182], -18344.1, 19004.49, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[183], -18360.82, 19016.57, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[184], -18366.79, 19022.6, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[185], -18373.15, 19028.91, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[186], -18379.65, 19035.53, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[187], -18386.1, 19042.04, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[188], -18285.71, 18952.92, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[189], -18316.9, 18989, 9.78, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[190], -18392.77, 19048.73, 10.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[191], -18360.83, 19016.58, 11.25, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[192], -18366.82, 19022.61, 11.25, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[193], -18373.14, 19028.92, 11.25, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[194], -18379.66, 19035.57, 11.25, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[195], -18386.12, 19042.05, 11.25, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[196], -18392.81, 19048.71, 11.25, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[197], -18415.54, 18930.63, 11.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[198], -18405.67, 18884.63, 11.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[199], -18448.04, 18899.33, 11.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[200], -18458.5, 18948.46, 11.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[201], -18494.73, 18914.42, 11.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[202], -18480.85, 18868.18, 11.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[203], -18437.29, 18853.77, 11.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[204], -18555.4, 18991.8, 15.01, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[205], -18550.97, 18999.11, 16.46, 5); //   0.00, 0.00, 0.21);
	MoveDynamicObject(ObjStrI[206], -18546.68, 19005.5, 17.96, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[207], -18537.76, 19018.84, 17.83, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[208], -18515.71, 19056.39, 24.52, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[209], -18496.65, 19090.42, 28.60, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[210], -18540.12, 19131.71, 32.79, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[211], -18576.35, 19070.27, 41.32, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[212], -18616.4, 18988.08, 37.42, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[213], -18618.15, 19069.57, 45.38, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[214], -18633.22, 19094.88, 48.67, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[215], -18642.59, 19088.69, 49.14, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[216], -18637.35, 19028.5, 42.02, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[217], -18635.25, 19036.38, 42.02, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[218], -18631.06, 19045.1, 42.02, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[219], -18711.57, 19002.8, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[220], -18723.37, 19002.17, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[221], -18727.13, 19008.45, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[222], -18735.82, 19011.81, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[223], -18730.38, 19021.09, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[224], -18733.25, 19037.54, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[225], -18756.63, 19030.13, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[226], -18749.52, 19043.38, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[227], -18738.77, 19055.43, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[228], -18725.13, 19061.27, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[229], -18710.89, 19060.6, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[230], -18695.46, 19023.54, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[231], -18701.42, 19009.06, 48.70, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[232], -18354.7, 19004.82, 11.56, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[233], -18346.44, 18995.01, 11.56, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[234], -18725.72, 19061.2, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[235], -18739.28, 19055.35, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[236], -18711.71, 19060.54, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[237], -18750.23, 19043.27, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[238], -18733.89, 19037.48, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[239], -18757.29, 19030.1, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[240], -18731, 19021.15, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[241], -18736.43, 19011.86, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[242], -18727.84, 19008.54, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[243], -18723.99, 19002.21, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[244], -18712.33, 19002.87, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[245], -18702.14, 19009.09, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[246], -18696.16, 19023.61, 49.91, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[247], -18400.48, 18996.64, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[248], -18365.82, 18970.65, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[249], -18335.18, 18938.71, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[250], -18432.83, 18987.17, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[251], -18378.66, 18920.74, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[252], -18480.88, 18763.03, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[253], -18520.24, 18803.08, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[254], -18563.36, 18849.9, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[255], -18541.14, 18897.18, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[256], -18455.26, 18813.98, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[257], -18503.96, 18958.18, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[258], -18408.04, 18851.06, 9.63, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[259], -18485.09, 18825.74, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[260], -18498.25, 18839.14, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[261], -18513.74, 18855.71, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[262], -18521.74, 18879.74, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[263], -18455.2, 18874.04, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[264], -18426.82, 18828.94, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[265], -18473.8, 18896.64, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[266], -18466.52, 18918.95, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[267], -18441.71, 18926.47, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[268], -18423.3, 18905.16, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[269], -18431.16, 18880.85, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[270], -18370.16, 18890.7, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[271], -18381.61, 18945.78, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[272], -18421.15, 18964.6, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[273], -18461.16, 18987.25, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[274], -18486.75, 18976.05, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[275], -18547.09, 18930.57, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[276], -18570.52, 18895.8, 9.20, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[277], -18197.57, 19001.99, 1.14, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[278], -18356.17, 19173.6, 1.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[279], -18363.19, 19164.65, 1.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[280], -18370.56, 19155.88, 1.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[281], -18208.49, 18995.37, 1.14, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[282], -18217.11, 18988.43, 1.14, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[283], -18353.46, 19017.21, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[284], -18358.81, 19022.79, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[285], -18364.58, 19029.17, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[286], -18371.2, 19036.31, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[287], -18378.06, 19042.78, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[288], -18384.51, 19049.31, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[289], -18391.43, 19056.24, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[290], -18397.79, 19061.96, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[291], -18404.44, 19069.15, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[292], -18410.94, 19077.86, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[293], -18413.78, 19086.64, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[294], -18410.62, 19097, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[295], -18413.59, 19107.45, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[296], -18389.93, 19113.7, 6.88, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[297], -18355.73, 19071.72, 6.88, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[298], -18348.98, 19032.9, 6.88, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[299], -18385.22, 19078.41, 6.88, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[300], -18333.24, 18989.09, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[301], -18303.11, 18998.67, 7.79, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[302], -18293.39, 18988.78, 7.79, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[303], -18313.86, 18967.75, 8.51, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[304], -18271.36, 18961.25, 7.79, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[305], -18667.46, 18485.36, 3.78, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[306], -18667.32, 18485.28, 3.80, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[307], -18667.18, 18485.18, 3.81, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[308], -18667.33, 18485.45, 3.83, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[309], -18667.18, 18485.35, 3.84, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[310], -18667.46, 18485.2, 3.77, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[311], -18667.33, 18485.11, 3.77, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[312], -18667.17, 18485.51, 3.87, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[313], -18667.03, 18485.26, 3.83, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[314], -18667.21, 18485.01, 3.77, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[315], -18667.47, 18485.04, 3.72, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[316], -18667.61, 18485.27, 3.73, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[317], -18667.47, 18485.53, 3.81, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[318], -18667.03, 18485.43, 3.86, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[319], -18667.07, 18485.09, 3.80, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[320], -18667.34, 18484.96, 3.75, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[0], -18667.59, 18485.14, 3.73, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[33], -18667.59, 18485.42, 3.77, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[57], -18667.31, 18485.61, 3.85, 5); //   0.00, 0.00, 0.00);

	TexNad[0] = CreateDynamic3DTextLabel("Источник энергии сервера\n'' вода и пламя ''", 0xFF0000FF, -18738.44, 19069.92, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[1] = CreateDynamic3DTextLabel("Ты сам придумал сказку,\nи вдохновлённый мечтой , ...", 0x00FF00FF, -18693.81, 19015.34, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[2] = CreateDynamic3DTextLabel("... подогреваемый желанием\nбросился на её поиски ...", 0x00FF00FF, -18692.94, 19003.41, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[3] = CreateDynamic3DTextLabel("... Мы просто хотели узнать,\nк чему тебя приведёт твоя внутренняя мотивация -- ...", 0x00FF00FF, -18696.44, 18993.57, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[4] = CreateDynamic3DTextLabel("... -- что этот остров - часть\nчудовищной административной лжи ? ...", 0x00FF00FF, -18708.37, 18979.09, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[5] = CreateDynamic3DTextLabel("... -- или величайшему дару\nданному человеку - ...", 0x00FF00FF, -18718.72, 18971.83, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[6] = CreateDynamic3DTextLabel("... способности гнаться\nза своей мечтой ? ...", 0x00FF00FF, -18728.32, 18970.66, 50.93, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[7] = CreateDynamic3DTextLabel("... Брайан Олдис -\n'' Суперигрушек хватает на всё лето '' (1969 год)", 0x00FF00FF, -18738.70, 18981.63, 50.75, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[8] = CreateDynamic3DTextLabel("_PeNGuIn_\n(f. Genko_Leiman)", 0xF9E245FF, -18353.20, 19018.06, 10.74, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[9] = CreateDynamic3DTextLabel("EightingKey.kinder\n(f. kinder)", 0xF9E245FF, -18358.91, 19023.74, 10.71, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[10] = CreateDynamic3DTextLabel("dima_WN\n(f. dima)", 0xF9E245FF, -18351.44, 19030.29, 10.92, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[11] = CreateDynamic3DTextLabel("Aleksey_Perevalov", 0xF9E245FF, -18364.49, 19030.12, 10.66, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[12] = CreateDynamic3DTextLabel("M@KsIk_ak47", 0xF9E245FF, -18357.08, 19036.27, 10.88, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[13] = CreateDynamic3DTextLabel("lolololllka", 0xF9E245FF, -18371.42, 19037.27, 10.63, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[14] = CreateDynamic3DTextLabel("UDFJuIcE", 0xF9E245FF, -18364.64, 19044.00, 10.85, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[15] = CreateDynamic3DTextLabel("Brooklyn", 0xF9E245FF, -18377.97, 19043.73, 10.61, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[16] = CreateDynamic3DTextLabel("BlackNero\n(f. Chris_Nighter)", 0xF9E245FF, -18371.07, 19050.82, 10.29, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[17] = CreateDynamic3DTextLabel("Kesha_Ultra\n(f. SLAVA999)", 0xF9E245FF, -18384.21, 19050.12, 10.57, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[18] = CreateDynamic3DTextLabel("36_Rus\n(f. Sergei_Gunin)", 0xF9E245FF, -18377.68, 19056.79, 10.28, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[19] = CreateDynamic3DTextLabel("imx", 0xF9E245FF, -18391.09, 19056.97, 10.54, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[20] = CreateDynamic3DTextLabel("Jon_Smith007\n(f. Jon007)", 0xF9E245FF, -18384.71, 19064.07, 10.23, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[21] = CreateDynamic3DTextLabel("Nikita_Baskov", 0xF9E245FF, -18397.73, 19062.92, 11.33, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[22] = CreateDynamic3DTextLabel("SnIkErS", 0xF9E245FF, -18390.48, 19070.17, 10.20, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[23] = CreateDynamic3DTextLabel("alexs655", 0xF9E245FF, -18404.63, 19070.11, 11.26, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[24] = CreateDynamic3DTextLabel("Igor_Newman", 0xF9E245FF, -18396.91, 19077.36, 10.14, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[25] = CreateDynamic3DTextLabel("OksanaPff", 0xF9E245FF, -18410.58, 19078.38, 10.82, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[26] = CreateDynamic3DTextLabel("Asik26\n(f. DoM)", 0xF9E245FF, -18402.72, 19083.61, 10.10, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[27] = CreateDynamic3DTextLabel("Nastya_Karamelko", 0xF9E245FF, -18413.42, 19086.69, 10.54, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[28] = CreateDynamic3DTextLabel("ser", 0xF9E245FF, -18401.66, 19093.09, 9.82, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[29] = CreateDynamic3DTextLabel("CyXaPiK\n(f. Guy_Fox.)", 0xF9E245FF, -18410.49, 19096.08, 10.28, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[30] = CreateDynamic3DTextLabel("Morphin\n(f. FOGGYMAN)", 0xF9E245FF, -18401.58, 19105.52, 9.48, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[31] = CreateDynamic3DTextLabel("Woody\n(f. Uzun_Ilya)", 0xF9E245FF, -18413.72, 19108.40, 10.44, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[32] = CreateDynamic3DTextLabel("Igor_Naumov\n(f. iga_iga_Dja)", 0xF9E245FF, -18402.66, 19116.60, 9.14, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[33] = CreateDynamic3DTextLabel("evgenii_dja", 0xF9E245FF, -18395.27, 19108.90, 9.16, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[34] = CreateDynamic3DTextLabel("Ivan_susanin", 0xF9E245FF, -18396.97, 19100.47, 9.52, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[35] = CreateDynamic3DTextLabel("chernomor05", 0xF9E245FF, -18389.28, 19102.22, 9.11, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[36] = CreateDynamic3DTextLabel("Next", 0xF9E245FF, -18390.62, 19093.83, 9.56, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[37] = CreateDynamic3DTextLabel("Sevgeny", 0xF9E245FF, -18382.15, 19094.28, 9.05, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[38] = CreateDynamic3DTextLabel("MegaMlok", 0xF9E245FF, -18382.43, 19085.21, 9.61, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[39] = CreateDynamic3DTextLabel("EBGEHbI4)", 0xF9E245FF, -18372.46, 19084.39, 9.03, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[40] = CreateDynamic3DTextLabel("Igor_Dobra", 0xF9E245FF, -18373.43, 19076.26, 9.65, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[41] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18364.32, 19076.73, 8.83, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[42] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18366.41, 19068.38, 9.71, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[43] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18357.04, 19069.55, 8.87, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	TexNad[44] = CreateDynamic3DTextLabel(" ", 0xF9E245FF, -18349.84, 19062.02, 8.91, 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
	return 1;
}

public Isloff()
{
	MoveObject(ObjGamI[0], -18000.13, 18000.04, -155, 5, 0.00, 0.00, 135.00);
	MoveObject(ObjGamI[1], -18557.82, 18809.86, -155.25, 5, 0.00, 0.00, 135.00);
	MoveObject(ObjGamI[2], -18259.07, 19008.86, -160.91, 5, 2.00, 0.21, 134.70);

//	MoveDynamicObject(ObjStrI[0], -18000.13, 18000.04, -155, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[1], -17890.71, 18106.74, -155, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[2], -18194.64, 18177.54, -155, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[3], -18077.19, 18295.56, -155, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[4], -18385.13, 18339.97, -155.25, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[5], -18258.37, 18450.38, -148.76, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[6], -17802.57, 17909.89, -165.14, 5); //   0.99, 0.00, 45.00);
	MoveDynamicObject(ObjStrI[7], -17774.43, 18091.21, -164.3, 5); //   0.00, 0.00, 136.44);
	MoveDynamicObject(ObjStrI[8], -17676.99, 18040.88, -167.77, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[9], -17744.7, 18037.79, -163.05, 5); //   -12.07, 0.00, -18.00);
	MoveDynamicObject(ObjStrI[10], -17875.82, 18205.58, -124.73, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[11], -18131.87, 18455.78, -116.85, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[12], -17964.89, 18377.11, -164.99, 5); //   0.78, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[13], -17857.02, 18232.51, -166.54, 5); //   -11.00, 0.00, -11.00);
	MoveDynamicObject(ObjStrI[14], -18123.84, 18467.3, -164.08, 5); //   -10.00, 0.00, -11.00);
	MoveDynamicObject(ObjStrI[15], -18167.09, 18461.78, -165.69, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[16], -18063.58, 17906.95, -164.31, 5); //   0.00, 0.00, -45.00);
	MoveDynamicObject(ObjStrI[17], -18311.78, 18155.54, -164.31, 5); //   0.00, 0.00, -45.00);
	MoveDynamicObject(ObjStrI[18], -18574.26, 18379.27, -164.3, 5); //   0.00, 0.00, -44.42);
	MoveDynamicObject(ObjStrI[19], -18218.78, 18512.36, -165.69, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[20], -18280.26, 18553.36, -165.69, 5); //   0.00, 0.00, 113.00);
	MoveDynamicObject(ObjStrI[21], -18342.18, 18541.39, -165.79, 5); //   0.00, 0.00, 149.00);
	MoveDynamicObject(ObjStrI[22], -18432.09, 18271.27, -168.23, 5); //   -18.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[23], -18449.14, 18518.42, -154.95, 5); //   0.00, 0.00, 142.00);
	MoveDynamicObject(ObjStrI[24], -18390.33, 18499.06, -165.79, 5); //   0.00, 0.00, 149.00);
	MoveDynamicObject(ObjStrI[25], -18475.39, 18428.66, -165.58, 5); //   0.00, 0.00, 149.00);
	MoveDynamicObject(ObjStrI[26], -18431.33, 18665, -154.95, 5); //   0.00, 0.00, -37.54);
	MoveDynamicObject(ObjStrI[27], -18530.87, 18400.52, -166.69, 5); //   0.00, 0.00, 62.00);
	MoveDynamicObject(ObjStrI[28], -18592.35, 18460.65, -166.69, 5); //   0.00, 0.00, 62.00);
	MoveDynamicObject(ObjStrI[29], -18646.67, 18517.44, -166.69, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[30], -18682.25, 18520.42, -167.83, 5); //   -14.00, 0.00, 156.00);
	MoveDynamicObject(ObjStrI[31], -18399.51, 18968.46, -155.25, 5); //   0.00, 0.00, -45.00);
	MoveDynamicObject(ObjStrI[32], -18478.75, 18889.13, -155.247, 5); //   0.00, 0.00, 135.00);
//	MoveDynamicObject(ObjStrI[33], -18557.82, 18809.86, -155.25, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[34], -17909.63, 17787.33, -166.36, 5); //   0.00, 0.00, 33.00);
	MoveDynamicObject(ObjStrI[35], -17952.37, 17827.41, -165.3, 5); //   0.00, 18.00, 171.00);
	MoveDynamicObject(ObjStrI[36], -17961.59, 17781.25, -168.76, 5); //   0.00, 0.00, -47.00);
	MoveDynamicObject(ObjStrI[37], -18450, 18527.44, -169, 5); //   0.00, 0.00, 200.00);
	MoveDynamicObject(ObjStrI[38], -18490.36, 18490.37, -169, 5); //   0.00, 0.00, 224.94);
	MoveDynamicObject(ObjStrI[39], -18425.08, 18581.28, -169, 5); //   0.00, 0.00, 178.00);
	MoveDynamicObject(ObjStrI[40], -18479.63, 18562.42, -169, 5); //   0.00, 0.00, 181.88);
	MoveDynamicObject(ObjStrI[41], -18457.32, 18598.89, -169, 5); //   0.00, 0.00, -4.00);
	MoveDynamicObject(ObjStrI[42], -18400.14, 18625.89, -169, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[43], -18430.33, 18660.53, -169, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[44], -18390.2, 18694.84, -169, 5); //   0.00, 0.00, 47.30);
	MoveDynamicObject(ObjStrI[45], -18485.55, 18475.28, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[46], -18480.78, 18465.44, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[47], -18459.67, 18513.03, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[48], -18458.01, 18524.44, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[49], -18485.71, 18541.4, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[50], -18489.45, 18527.46, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[51], -18454.71, 18536.84, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[52], -18424.68, 18649.67, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[53], -18422.26, 18659.99, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[54], -18420.89, 18671.89, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[55], -18395.37, 18640.74, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[56], -18391.7, 18651.04, -155.08, 5); //   0.00, 0.00, 0.00);
//	MoveDynamicObject(ObjStrI[57], -18259.07, 19008.86, -160.91, 5); //   2.00, 0.21, 134.70);
	MoveDynamicObject(ObjStrI[58], -18347.4, 19115.22, -161.37, 5); //   2.00, 0.21, 134.70);
	MoveDynamicObject(ObjStrI[59], -18570.79, 19063.23, -137.03, 5); //   -1.44, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[60], -18390.45, 18659.43, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[61], -18389.49, 18666.68, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[62], -18459.72, 19051.53, -190.46, 5); //   0.00, 0.00, -33.00);
	MoveDynamicObject(ObjStrI[63], -18439.74, 19042.43, -190.87, 5); //   0.00, 0.00, -55.00);
	MoveDynamicObject(ObjStrI[64], -18434.79, 19096.44, -164.94, 5); //   0.00, 0.00, 222.00);
	MoveDynamicObject(ObjStrI[65], -18440.41, 19120.44, -152.7, 5); //   0.00, 0.00, -55.00);
	MoveDynamicObject(ObjStrI[66], -18409.76, 19177.09, -152.69, 5); //   0.00, 0.00, -55.00);
	MoveDynamicObject(ObjStrI[67], -18448.11, 19107.14, -154.75, 5); //   0.00, 0.00, 14.00);
	MoveDynamicObject(ObjStrI[68], -18482.85, 19121.7, -144.19, 5); //   0.00, 0.00, 18.00);
	MoveDynamicObject(ObjStrI[69], -18503.81, 19151.03, -152.7, 5); //   0.00, 0.00, -113.00);
	MoveDynamicObject(ObjStrI[70], -18567.04, 19149.58, -157.31, 5); //   0.00, 0.00, -84.00);
	MoveDynamicObject(ObjStrI[71], -18624.68, 19115.54, -157.31, 5); //   0.00, 0.00, -91.00);
	MoveDynamicObject(ObjStrI[72], -18640.69, 19100.1, -157.31, 5); //   0.00, 0.00, -62.00);
	MoveDynamicObject(ObjStrI[73], -18701.76, 19075.39, -136.56, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[74], -18745.99, 19053.68, -115.16, 5); //   0.00, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[75], -18726.49, 19019.67, -115.16, 5); //   0.00, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[76], -18706.8, 18985.65, -115.16, 5); //   0.00, 0.00, 120.00);
	MoveDynamicObject(ObjStrI[77], -18687.95, 19088.79, -118.61, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[78], -18684.51, 19064.66, -114.17, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[79], -18653.48, 18916.28, -147.77, 5); //   0.00, 0.00, -69.00);
	MoveDynamicObject(ObjStrI[80], -18653.28, 19018.52, -120.23, 5); //   0.00, 0.00, 229.00);
	MoveDynamicObject(ObjStrI[81], -18659.85, 19014.65, -120.23, 5); //   0.00, 0.00, 229.00);
	MoveDynamicObject(ObjStrI[82], -18665.39, 19010.81, -120.23, 5); //   0.00, 0.00, 229.00);
	MoveDynamicObject(ObjStrI[83], -18625.72, 18963.48, -147.77, 5); //   0.00, 0.00, 11.00);
	MoveDynamicObject(ObjStrI[84], -18663.92, 18976.54, -147.77, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[85], -18679.76, 19002.36, -112.2, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[86], -18678.2, 18992.62, -112.2, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[87], -18677.56, 18985.15, -112.2, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[88], -18682.66, 18984.03, -105.65, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[89], -18683.93, 18992.34, -105.65, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[90], -18681.45, 19002.36, -105.65, 5); //   0.00, 0.00, 25.00);
	MoveDynamicObject(ObjStrI[91], -18703.65, 18957.27, -147.77, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[92], -18741.65, 18946.65, -147.77, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[93], -18770.05, 18986.05, -147.77, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[94], -18784.81, 19013.56, -147.77, 5); //   0.00, 0.00, 4.00);
	MoveDynamicObject(ObjStrI[95], -18812.4, 19055.98, -147.77, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[96], -18772.44, 19079.1, -147.77, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[97], -18743.02, 18886.76, -147.77, 5); //   0.00, 0.00, -91.00);
	MoveDynamicObject(ObjStrI[98], -18802.8, 18933.61, -147.77, 5); //   0.00, 0.00, -142.00);
	MoveDynamicObject(ObjStrI[99], -18831.94, 18982.87, -147.77, 5); //   0.00, 0.00, -142.00);
	MoveDynamicObject(ObjStrI[100], -18841.07, 19053.99, -147.77, 5); //   0.00, 0.00, -207.00);
	MoveDynamicObject(ObjStrI[101], -18813.11, 19130.07, -147.77, 5); //   0.00, 0.00, -236.00);
	MoveDynamicObject(ObjStrI[102], -18730.91, 19153.34, -147.77, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[103], -18679.15, 19160.31, -137.94, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[104], -18624.51, 19195.57, -155.53, 5); //   0.00, 0.00, 98.00);
	MoveDynamicObject(ObjStrI[105], -18549.03, 19220.81, -156.07, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[106], -18469.11, 19221.98, -154.62, 5); //   0.00, 0.00, 62.00);
	MoveDynamicObject(ObjStrI[107], -18436.83, 19234.48, -152.05, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[108], -18426.3, 19255.46, -152.05, 5); //   0.00, 0.00, 84.00);
	MoveDynamicObject(ObjStrI[109], -18393.59, 19251.71, -152.05, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[110], -18651.44, 19144.39, -134.46, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[111], -18400.84, 18719.23, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[112], -18407.17, 18728.86, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[113], -18465.43, 18700, -169, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[114], -18431.8, 18710.67, -155.08, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[115], -18513.05, 18683.87, -169, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[116], -18562.44, 18735.46, -169, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[117], -18611.99, 18782.89, -169, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[118], -18658.43, 18829.16, -169, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[119], -18694.41, 18871.4, -155.12, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[120], -18645.85, 18833.53, -161.78, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[121], -18600.68, 18792.13, -161.78, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[122], -18551.05, 18748, -161.78, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[123], -18504.05, 18693.07, -161.78, 5); //   0.00, 0.00, 69.00);
	MoveDynamicObject(ObjStrI[124], -18473.34, 18706.7, -161.78, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[125], -18370.91, 18790.43, -169, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[126], -18323.29, 18843.39, -169, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[127], -18280, 18887.96, -169, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[128], -18236.59, 18931.2, -169, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[129], -18186.23, 18972.79, -169, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[130], -18247.93, 18940.82, -161.78, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[131], -18290.62, 18897.63, -161.78, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[132], -18330.54, 18853.41, -161.78, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[133], -18372.96, 18807.36, -161.78, 5); //   0.00, 0.00, 164.00);
	MoveDynamicObject(ObjStrI[134], -18440.58, 19020.08, -152.67, 5); //   0.00, 0.00, 91.00);
	MoveDynamicObject(ObjStrI[135], -18466.43, 19019.1, -152.56, 5); //   0.00, 0.00, -178.00);
	MoveDynamicObject(ObjStrI[136], -18494.2, 19015.1, -152.58, 5); //   0.00, 0.00, 105.00);
	MoveDynamicObject(ObjStrI[137], -18519.32, 19000.38, -152.41, 5); //   0.00, 0.00, 135.00);
	MoveDynamicObject(ObjStrI[138], -18535.82, 18981.43, -152.55, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[139], -18575.99, 18933.24, -152.4, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[140], -18593.13, 18911.71, -152.26, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[141], -18609.73, 18880.65, -152.67, 5); //   0.00, 0.00, -185.00);
	MoveDynamicObject(ObjStrI[142], -18604.74, 18848.76, -152.56, 5); //   0.00, 0.00, -62.00);
	MoveDynamicObject(ObjStrI[143], -18584.84, 18826.15, -152.58, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[144], -18565.08, 18807.51, -152.41, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[145], -18545.51, 18789.2, -152.55, 5); //   0.00, 0.00, -44.56);
	MoveDynamicObject(ObjStrI[146], -18528.82, 18771.52, -152.4, 5); //   0.00, 0.00, -44.89);
	MoveDynamicObject(ObjStrI[147], -18510.17, 18753.29, -152.26, 5); //   0.00, 0.00, -44.22);
	MoveDynamicObject(ObjStrI[148], -18491.6, 18733.63, -152.67, 5); //   0.00, 0.00, -135.00);
	MoveDynamicObject(ObjStrI[149], -18433.27, 18782.01, -152.56, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[150], -18417.23, 18802.23, -152.58, 5); //   0.00, 0.00, -43.00);
	MoveDynamicObject(ObjStrI[151], -18399.58, 18820.8, -152.41, 5); //   0.00, 0.00, -43.11);
	MoveDynamicObject(ObjStrI[152], -18382.72, 18838.68, -152.55, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[153], -18368.63, 18854.13, -152.4, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[154], -18354.44, 18871.15, -152.26, 5); //   0.00, 0.00, 48.55);
	MoveDynamicObject(ObjStrI[155], -18337.93, 18888.8, -152.67, 5); //   0.00, 0.00, -42.00);
	MoveDynamicObject(ObjStrI[156], -18321.71, 18905.22, -152.56, 5); //   0.00, 0.00, 47.00);
	MoveDynamicObject(ObjStrI[157], -18305.78, 18923.76, -152.58, 5); //   0.00, 0.00, -42.89);
	MoveDynamicObject(ObjStrI[158], -18689.69, 19052.5, -114.47, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[159], -18681.5, 19038.44, -114.47, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[160], -18740.22, 19072.11, -112.82, 5); //   0.00, 0.00, -142.00);
	MoveDynamicObject(ObjStrI[161], -18740.53, 19076.49, -111, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[162], -18740.89, 19076.39, -111, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[163], -18741.24, 19076.26, -110.97, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[164], -18741.57, 19076.18, -110.96, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[165], -18741.91, 19076.07, -110.91, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[166], -18742.31, 19075.93, -110.9, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[167], -18742.69, 19075.82, -110.83, 5); //   89.00, 25.00, 0.00);
	MoveDynamicObject(ObjStrI[168], -18688.04, 19016.48, -113.27, 5); //   0.00, 0.00, -105.00);
	MoveDynamicObject(ObjStrI[169], -18704.51, 18974.95, -113.29, 5); //   0.00, 0.00, -164.00);
	MoveDynamicObject(ObjStrI[170], -18741.76, 18976.86, -113.13, 5); //   0.00, 0.00, -236.00);
	MoveDynamicObject(ObjStrI[171], -18767.51, 19017.05, -113.33, 5); //   0.00, 0.00, -244.00);
	MoveDynamicObject(ObjStrI[172], -18770.67, 19053.9, -113.32, 5); //   0.00, 0.00, 33.00);
	MoveDynamicObject(ObjStrI[173], -18447.29, 18899.42, -151.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[174], -18415.13, 18930.49, -151.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[175], -18480.65, 18867.86, -151.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[176], -18494.43, 18914.4, -151.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[177], -18458.35, 18948.6, -151.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[178], -18437.24, 18853.34, -151.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[179], -18404.51, 18884.13, -151.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[180], -18553.27, 18977.29, -152.76, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[181], -18576.89, 18953.3, -152.76, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[182], -18344.1, 19004.49, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[183], -18360.82, 19016.57, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[184], -18366.79, 19022.6, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[185], -18373.15, 19028.91, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[186], -18379.65, 19035.53, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[187], -18386.1, 19042.04, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[188], -18285.71, 18952.92, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[189], -18316.9, 18989, -155.22, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[190], -18392.77, 19048.73, -154.61, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[191], -18360.83, 19016.58, -153.75, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[192], -18366.82, 19022.61, -153.75, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[193], -18373.14, 19028.92, -153.75, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[194], -18379.66, 19035.57, -153.75, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[195], -18386.12, 19042.05, -153.75, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[196], -18392.81, 19048.71, -153.75, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[197], -18415.54, 18930.63, -153.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[198], -18405.67, 18884.63, -153.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[199], -18448.04, 18899.33, -153.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[200], -18458.5, 18948.46, -153.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[201], -18494.73, 18914.42, -153.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[202], -18480.85, 18868.18, -153.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[203], -18437.29, 18853.77, -153.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[204], -18555.4, 18991.8, -149.99, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[205], -18550.97, 18999.11, -148.54, 5); //   0.00, 0.00, 0.21);
	MoveDynamicObject(ObjStrI[206], -18546.68, 19005.5, -147.04, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[207], -18537.76, 19018.84, -147.17, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[208], -18515.71, 19056.39, -140.48, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[209], -18496.65, 19090.42, -136.4, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[210], -18540.12, 19131.71, -132.21, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[211], -18576.35, 19070.27, -123.68, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[212], -18616.4, 18988.08, -127.58, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[213], -18618.15, 19069.57, -119.62, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[214], -18633.22, 19094.88, -116.33, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[215], -18642.59, 19088.69, -115.86, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[216], -18637.35, 19028.5, -122.98, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[217], -18635.25, 19036.38, -122.98, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[218], -18631.06, 19045.1, -122.98, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[219], -18711.57, 19002.8, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[220], -18723.37, 19002.17, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[221], -18727.13, 19008.45, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[222], -18735.82, 19011.81, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[223], -18730.38, 19021.09, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[224], -18733.25, 19037.54, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[225], -18756.63, 19030.13, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[226], -18749.52, 19043.38, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[227], -18738.77, 19055.43, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[228], -18725.13, 19061.27, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[229], -18710.89, 19060.6, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[230], -18695.46, 19023.54, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[231], -18701.42, 19009.06, -116.3, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[232], -18354.7, 19004.82, -153.44, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[233], -18346.44, 18995.01, -153.44, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[234], -18725.72, 19061.2, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[235], -18739.28, 19055.35, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[236], -18711.71, 19060.54, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[237], -18750.23, 19043.27, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[238], -18733.89, 19037.48, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[239], -18757.29, 19030.1, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[240], -18731, 19021.15, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[241], -18736.43, 19011.86, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[242], -18727.84, 19008.54, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[243], -18723.99, 19002.21, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[244], -18712.33, 19002.87, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[245], -18702.14, 19009.09, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[246], -18696.16, 19023.61, -115.09, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[247], -18400.48, 18996.64, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[248], -18365.82, 18970.65, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[249], -18335.18, 18938.71, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[250], -18432.83, 18987.17, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[251], -18378.66, 18920.74, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[252], -18480.88, 18763.03, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[253], -18520.24, 18803.08, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[254], -18563.36, 18849.9, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[255], -18541.14, 18897.18, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[256], -18455.26, 18813.98, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[257], -18503.96, 18958.18, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[258], -18408.04, 18851.06, -155.37, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[259], -18485.09, 18825.74, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[260], -18498.25, 18839.14, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[261], -18513.74, 18855.71, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[262], -18521.74, 18879.74, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[263], -18455.2, 18874.04, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[264], -18426.82, 18828.94, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[265], -18473.8, 18896.64, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[266], -18466.52, 18918.95, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[267], -18441.71, 18926.47, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[268], -18423.3, 18905.16, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[269], -18431.16, 18880.85, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[270], -18370.16, 18890.7, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[271], -18381.61, 18945.78, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[272], -18421.15, 18964.6, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[273], -18461.16, 18987.25, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[274], -18486.75, 18976.05, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[275], -18547.09, 18930.57, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[276], -18570.52, 18895.8, -155.8, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[277], -18197.57, 19001.99, -163.86, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[278], -18356.17, 19173.6, -163.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[279], -18363.19, 19164.65, -163.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[280], -18370.56, 19155.88, -163.39, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[281], -18208.49, 18995.37, -163.86, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[282], -18217.11, 18988.43, -163.86, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[283], -18353.46, 19017.21, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[284], -18358.81, 19022.79, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[285], -18364.58, 19029.17, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[286], -18371.2, 19036.31, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[287], -18378.06, 19042.78, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[288], -18384.51, 19049.31, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[289], -18391.43, 19056.24, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[290], -18397.79, 19061.96, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[291], -18404.44, 19069.15, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[292], -18410.94, 19077.86, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[293], -18413.78, 19086.64, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[294], -18410.62, 19097, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[295], -18413.59, 19107.45, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[296], -18389.93, 19113.7, -158.12, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[297], -18355.73, 19071.72, -158.12, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[298], -18348.98, 19032.9, -158.12, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[299], -18385.22, 19078.41, -158.12, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[300], -18333.24, 18989.09, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[301], -18303.11, 18998.67, -157.21, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[302], -18293.39, 18988.78, -157.21, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[303], -18313.86, 18967.75, -156.49, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[304], -18271.36, 18961.25, -157.21, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[305], -18667.46, 18485.36, -161.22, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[306], -18667.32, 18485.28, -161.2, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[307], -18667.18, 18485.18, -161.19, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[308], -18667.33, 18485.45, -161.17, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[309], -18667.18, 18485.35, -161.16, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[310], -18667.46, 18485.2, -161.23, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[311], -18667.33, 18485.11, -161.23, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[312], -18667.17, 18485.51, -161.13, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[313], -18667.03, 18485.26, -161.17, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[314], -18667.21, 18485.01, -161.23, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[315], -18667.47, 18485.04, -161.28, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[316], -18667.61, 18485.27, -161.27, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[317], -18667.47, 18485.53, -161.19, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[318], -18667.03, 18485.43, -161.14, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[319], -18667.07, 18485.09, -161.2, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[320], -18667.34, 18484.96, -161.25, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[0], -18667.59, 18485.14, -161.27, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[33], -18667.59, 18485.42, -161.23, 5); //   0.00, 0.00, 0.00);
	MoveDynamicObject(ObjStrI[57], -18667.31, 18485.61, -161.15, 5); //   0.00, 0.00, 0.00);

	for(new i = 0; i < MAX_NADP; i++)
	{
		DestroyDynamic3DTextLabel(TexNad[i]);
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

