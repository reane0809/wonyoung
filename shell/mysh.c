/*MYSHELL progammed by WonYoung Jeong 32154240 reane0809@gmail.com */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/wait.h>
#include <sys/types.h>

struct COMMAND{		//내부명령어를 위한 구조체 선언
	char* name;	//명령어 이름	
	char* desc;	//명령어 설명
	bool ( *func)(int argc, char* argv[]); //명령어 동작 함수
};

bool cmd_cd(int argc, char *argv[]);	//디렉터리 변경함수
bool cmd_help(int argc, char *argv[]);  //도움말 함수
bool cmd_exit(int argc, char *argv[]);	//쉘의 종료 함수


struct COMMAND builtin_cmds[] ={	//내부명령어->배열로 선언한 구조체
	{"cd", "change directory", cmd_cd},	//cd	//name, desc, func
	{"help", "show help", cmd_help},	//help	
	{"exit", "exit shell", cmd_exit}	//exit
};

bool cmd_cd(int argc, char *argv[]){	//디렉터리 이동함수
	if(argc == 1)	//잘못입력시
		printf("예시:cd [dir]\n");	//사용법출력
	else if(argc == 2){	//디렉터리 이동
		if( chdir(argv[1]))
			printf("디렉터리가 없습니다!");
}
	else printf("예시:cd [dir]\n");	//사용법 출력
	return true;
}

bool cmd_exit(int argc, char *argv[]){	//쉘 종료 함수
	return false;
}

bool cmd_help(int argc, char *argv[]){	//도움말 함수
	printf("----------------------------\n");
	printf("|MYSHELL                   |\n");
	printf("|--------------------------|\n");
	printf("|cd: change directory      |\n");
	printf("|help: show help           |\n");
	printf("|exit: exit MYSHELL        |\n");
	printf("|--------------------------|\n");
	printf("|if you want to feedback or|\n");
	printf("|touch to me,give a mail to|\n");
	printf("|reane0809@gmail.com       |\n");
	printf("----------------------------\n");
}

int tokenize(char *buf,char *delims,char *tokens[],int maxTokens){	//parsing
	//buf 입력된 명령어,delims 구분자,tokens 토큰을 주소로 부를때 저장변수
	//maxTokens최대토큰수
	char *token;
	int token_cnt = 0;
	buf[strlen(buf)-1]='\0';//오류방지
	token=strtok(buf,delims);//구분자 기준으로 토큰 분리
				 
	for(token_cnt;token != NULL && token_cnt < maxTokens; token_cnt++){	//while문의 경우 오류남
		tokens[token_cnt]=token; 	//토큰을 배열에 저장
		token=strtok(NULL,delims);	//구분 함수 루프
		}
		tokens[token_cnt] = NULL;	//토큰배열의 끝에 NULL을 붙힘
		return token_cnt;	//토큰 갯수 반환
}


bool run(char *line){
	int token_cnt, i, status;
	char *tokens[128];
	char *tokencp[128]={NULL};//재지정을 위한 변수
	char *delims =" \n\t"; //줄바꿈 tap을 구분자에
	bool back = false;	//백그라운드 실행을 위한 선언
	pid_t child;	//자식 구별 선언

	for(i=0; i<strlen(line); i++){	//백그라운드 실행시 사용
		if(line[i] == '&'){
			back = true;
			line[i] = '\0';	//set string end
			break;		//wait()을 사용하지 않는다
		}
	}

	token_cnt = tokenize(line, delims, tokens, sizeof(tokens)/sizeof(char*));

	if (token_cnt == 0)
		return true;
	for(i=0; i<sizeof(builtin_cmds)/sizeof(struct COMMAND); i++){
		//내부명령어일 경우 내부에서 처리
	if(strcmp(builtin_cmds[i].name, tokens[0]) == 0)
		return builtin_cmds[i].func(token_cnt,tokens);
}		//외부 명령어일 경우 fork이용

	if( (child = fork())==0){
		for(i=0; i<token_cnt; i++){
			if(!strcmp(tokens[i],">"))	//재지정명령어 있을 경우
				break;
					
		tokencp[i]=tokens[i];	// 바로 이전 명령어까지 토큰 변수에 저장
}					

	if(i!=token_cnt){	//재지정명령어 존재시
		if(strcmp(tokens[i],">")==0){
			if(freopen(tokens[i+1],"w",stdout) == NULL)
				printf("에러!:redirecting stdout!!\n");
				}
	
		else{	//재지정명령어라면 읽기모드로 입력을 받음
				if(freopen(tokens[i+1],"r",stdin) == NULL)
					printf("에러:redirecting stdin!\n");
				}
			}
	execvp(tokens[0], tokencp); //외부명령어 실행시 execvp이용	
	printf("NO SUCH FILE\n");	//잘못된 실행일시 출력되는 부분
	_exit(0);	//_exit()으로 커널복귀 (수분반의 눈물)
}
else if (child<0){	//fork 실패시
	printf("fork 실패!");	//출력
	_exit(0);
}
else	wait(&status);	//자식이 끝날때까지 대기
	return true;

}//run의 종료 지점

int main(){
	char line[1024];
	while(1){
		printf("JWY:$");	//사용자가 볼 출력 내용
		fgets(line,sizeof(line)-1,stdin);//키보드입력을 라인 삽입
		if(run(line)==false) //run함수가 false반환시까지 무한루프
			break;
}
	return 0;
}

