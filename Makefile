# Path to STM32Cube MCU Package for STM32F1 series
# You can download it from st.com
PACKAGE_DIR = STM32Cube_FW_F1_V1.8.3

SRC =  main.c
SRC += $(PACKAGE_DIR)/Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/system_stm32f1xx.c
SRC += $(PACKAGE_DIR)/Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/gcc/startup_stm32f103xb.s

CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
RM      = rm
FLASH   = st-flash

CFLAGS  = -O0 -Wall
CFLAGS += -mthumb -mcpu=cortex-m3 -mfloat-abi=soft
CFLAGS += -T $(PACKAGE_DIR)/Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/gcc/linker/STM32F103XB_FLASH.ld
CFLAGS += -Wl,--gc-sections
CFLAGS += -I .
CFLAGS += -I $(PACKAGE_DIR)/Drivers/CMSIS/Core/Include/
CFLAGS += -I $(PACKAGE_DIR)/Drivers/CMSIS/Device/ST/STM32F1xx/Include/

.PHONY: all flash clean 

all: main.bin

main.bin: main.elf
	$(OBJCOPY) -O binary $< $@

main.elf: $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

flash: main.bin
	$(FLASH) --reset write $< 0x08000000

clean:
	$(RM) -f *.o *.elf *.bin
