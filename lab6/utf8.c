#include "utf8.h"
#include <stdint.h>

void decode_utf8(const char *s) {
  int i = 0;

  while (s[i] != '\0') {
    // use unsigned so the bits work properly
    unsigned char first = (unsigned char)s[i];
    uint32_t number = 0;
    uint8_t bytes = 1;

    if ((first & 0x80) == 0) {
      // one byte character
      number = first;
    } else if ((first & 0xE0) == 0xC0) {
      // two bytes
      bytes = 2;
      number = ((uint32_t)(first & 0x1F) << 6) | ((uint32_t)((unsigned char)s[i + 1] & 0x3F));
    } else if ((first & 0xF0) == 0xE0) {
      // three bytes
      bytes = 3;
      number = ((uint32_t)(first & 0x0F) << 12) |
               ((uint32_t)((unsigned char)s[i + 1] & 0x3F) << 6) |
               ((uint32_t)((unsigned char)s[i + 2] & 0x3F));
    } else {
      // four bytes (input is valid UTF-8)
      bytes = 4;
      number = ((uint32_t)(first & 0x07) << 18) |
               ((uint32_t)((unsigned char)s[i + 1] & 0x3F) << 12) |
               ((uint32_t)((unsigned char)s[i + 2] & 0x3F) << 6) |
               ((uint32_t)((unsigned char)s[i + 3] & 0x3F));
    }

    report_character(number, bytes);
    i += bytes;
  }
}
