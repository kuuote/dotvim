#include <ctype.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

void str_tolower(char *str) {
  while (*str) {
    *str = tolower(*str);
    str++;
  }
}

int main(int argc, char **argv) {
  for (int argn = 1; argn < argc; argn++) {
    str_tolower(argv[argn]);
  }
  struct stat st;

  int ifd = open("/tmp/vimsel.lst", O_RDONLY);
  fstat(ifd, &st);
  char *imap = mmap(NULL, st.st_size + 1, PROT_READ | PROT_WRITE, MAP_PRIVATE, ifd, 0);
  char *imax = imap + st.st_size;

  int ofd = open("/tmp/vimsel.out", O_CREAT | O_TRUNC | O_RDWR, 0666);

  if (argc == 1) {
    write(ofd, imap, strlen(imap));
    return 0;
  }

  char *buf = mmap(NULL, st.st_size + 1, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
  char *cur = buf;

  char *token = strtok(imap, "\n");
  do {
    str_tolower(token);
    int match = true;
    for (int argn = 1; argn < argc; argn++) {
      if (strstr(token, argv[argn]) == NULL) {
        match = false;
      }
    }
    if (match) {
      int len = strlen(token);
      strcpy(cur, token);
      cur += len;
      *cur++ = '\n';
    }
  } while ((token = strtok(NULL, "\n")) != NULL);
  write(ofd, buf, strlen(buf));
  return 0;
}
