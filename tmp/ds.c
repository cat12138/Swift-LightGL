#include <stdio.h>
#include <string.h>


#define array_count(arr, size) do { \
size = sizeof(arr)/sizeof(arr[0]);  \
}while(0);

#define array_set(arr, data) do {   \
int size1, size2 = 0;               \
array_count(arr, size1);            \
array_count(arr, size2);            \
if (size2 > size1) {                \
    printf("Error: data is too long\n");    \
} else {                            \
    for (int i=0; i<size2; i++){    \
        arr[i] = data[i];           \
    }                               \
}                                   \
}while(0);

typedef struct _gameObject {
    int id;
} gameObject;



int main(int argc, char** argv)
{
    int g[10];
    int ok[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    int size = 0;
    array_count(g, size);

    array_set(g, ok);
    for(int i=0; i<size; i++){
        printf("%d\n", g[i]);
    }
    return 0;
}
