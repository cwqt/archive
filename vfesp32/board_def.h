#define TTGO_T5_2_3 1
#include <GxGDE0213B72B/GxGDE0213B72B.h> // 2.13" b/w

#define SPI_MOSI 23
#define SPI_MISO -1
#define SPI_CLK 18

#define ELINK_SS 5
#define ELINK_BUSY 4
#define ELINK_RESET 16
#define ELINK_DC 17

#define SDCARD_SS 13
#define SDCARD_CLK 14
#define SDCARD_MOSI 15
#define SDCARD_MISO 2

#define BUTTON_3 39
#define BUTTONS_MAP \
    {               \
        39          \
    }

#define SPEAKER_OUT -1
