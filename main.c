#include "stack.h"
#include "includes.h"
#include <stdlib.h>
#include <stdio.h>

int main(){
    union Value value;

    value.valFLOAT = 10;

    printf("%d\n", value.valINT);

    itoa(1);

    return 0;
}