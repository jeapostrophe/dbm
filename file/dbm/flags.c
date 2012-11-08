#include <fcntl.h>
#include <ndbm.h>

int main() {
  printf("DBM_INSERT: %d\n", DBM_INSERT);
  printf("DBM_REPLACE: %d\n", DBM_REPLACE);
  printf("O_RDWR: %d\n", O_RDWR);
  printf("O_CREAT: %d\n", O_CREAT);
  printf("O_SYMLINK: %d\n", O_SYMLINK);
  printf("MODE: %d\n", 0660);
}
