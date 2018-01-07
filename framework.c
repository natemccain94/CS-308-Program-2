#include <windows.h>
#include <stdio.h>

static char buf[255];
static char inputLabel[255];

// disables warning for strcpy use.
#pragma warning(disable : 4996)

void getInput(char* inputPrompt, char* bounds, char* result, int maxChars)
{
    puts(inputPrompt);
	puts(bounds);
    gets(buf);
    buf[maxChars - 1] = '\0';
    strcpy(result,buf);
    return;
}


void showOutput(char* outputLabel, char* outputString)
{
    puts(outputLabel);
	puts(outputString);
	return;
}

int sieve(void);

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
    LPSTR lpCmdLine, int nCmdShow)
{
    AllocConsole();
    freopen("CONIN$" , "rb", stdin);
    freopen("CONOUT$", "wb", stdout);

    return sieve();
}