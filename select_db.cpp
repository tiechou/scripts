#include<iostream>
using namespace std;
int main(int args,char **argc)
{	
	if (args<2)
	{
		cout<<"input uid ..."<<endl;
		cout<<"like: ./select_db 264421660"<<endl;
	}
	int user_id=atoi(argc[1]);
	cout<<user_id<<endl;
	int db_num_int = 0,table_num_int = 0;
	db_num_int = (user_id & 0x3C0)>>6;
	table_num_int = (user_id & 0x3FF)>>0;
	cout<<"db_num :"<<db_num_int<<endl;
	cout<<"table_num :"<<table_num_int<<endl;
}
