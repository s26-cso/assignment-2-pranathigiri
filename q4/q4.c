#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>

int main(){

    char op[6];
    int a,b;

    while(1){

        int count=scanf("%s %d %d",op,&a,&b);

        if(count!=3){
            break;
        }
        char libname[26];

        strcpy(libname,"./lib");
        strcat(libname,op);
        strcat(libname,".so");

        void* library=dlopen(libname,RTLD_LAZY);

        int(*func)(int,int)=dlsym(library,op);    // dlsym looks up a function by name inside loaded library

        int result=func(a,b);
        printf("%d\n",result);

        dlclose(library);
    }

    return 0;
}