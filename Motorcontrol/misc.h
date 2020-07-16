/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MISC_H
#define __MISC_H

#include "stm32f0xx.h"
#include "stm32f0xx_gpio.h"
#include "stm32f0xx_tim.h"

#define MODBUS_TX_MODE									GPIO_SetBits(GPIOA, GPIO_Pin_5)
#define MODBUS_RX_MODE									GPIO_ResetBits(GPIOA, GPIO_Pin_5)

#define ISSI_ADDR												0xE8

#define ISSI_REG_CONFIG  								0x00
#define ISSI_REG_CONFIG_PICTUREMODE 		0x00
#define ISSI_REG_CONFIG_AUTOPLAYMODE 		0x08
#define ISSI_REG_CONFIG_AUDIOPLAYMODE 	0x18

#define ISSI_CONF_PICTUREMODE 					0x00
#define ISSI_CONF_AUTOFRAMEMODE 				0x04
#define ISSI_CONF_AUDIOMODE 						0x08

#define ISSI_REG_PICTUREFRAME  					0x01

#define ISSI_REG_SHUTDOWN 							0x0A
#define ISSI_REG_AUDIOSYNC 							0x06

#define ISSI_COMMANDREGISTER 						0xFD
#define ISSI_BANK_FUNCTIONREG 					0x0B    // helpfully called 'page nine'


#define	SlaveAddress										0x05
#define Encapsulation										0x2B
#define MEI															0x0D
#define Read														0x00
#define Write														0x01
#define NodeID													0x01

#define PRESS_TIME              				4
#define EXPIRE_TIME             				30

#define ON															1
#define OFF															0

#define MaxLevel												9
#define MinLevel												0

#define Idle														0
#define DistanceSet											2
#define SpeedSet												1
#define TimeSet													3
#define MotorEnabled										4
#define MotorDisable										5
#define BlinkOff												6
#define RedBlink												7

#define BlinkAll												0xFF

#define MaxWaitTime											50  //5s	

#define FLASH_USER_1   									((uint32_t)0x08006000)
#define FLASH_USER_2   									((uint32_t)0x08006400)
#define FLASH_USER_3   									((uint32_t)0x08006800)
#define FLASH_FLAG	   									((uint32_t)0x08006C00)
#define INIT_FLAG			 									((uint32_t)0x00000055)

void Init_GPIO (void);
void EXTI_Config(void);
void delay(unsigned int nCount);
void Timer_Init(void);
void Delay_100ms(__IO uint32_t nTime);
void Init_I2C(void);
uint8_t I2C_ReadReg(uint8_t RegName);
void I2C_WriteReg(uint8_t RegName, uint8_t RegValue);
void selectBank(uint8_t bank);
void writeRegister8(uint8_t b, uint8_t reg, uint8_t data);
uint8_t readRegister8(uint8_t bank, uint8_t reg);
void setLEDPWM(uint8_t lednum, uint8_t pwm, uint8_t bank);
void clear(void);
void full(void);
void LED_DIM(void);
void ISSI_Init(void);
uint8_t ConvertValue(uint8_t Value);
void UpdateLEDS (uint8_t Speed, uint8_t Distance, uint8_t Time, uint8_t StateLED);
void Blink(uint8_t SelectBar);
uint16_t CRC16 ( const uint8_t *data, uint16_t length );
void Init_UART(void);
void UART_Send(uint8_t data);
void Modbus_Write( uint8_t SubIndex, uint16_t address, uint8_t DataLength, uint32_t Data );
uint32_t Modbus_Read( uint8_t SubIndex, uint16_t address, uint8_t DataLength);
uint32_t GetLSIFrequency(void);
void RTC_Config(void);
void Alarm_Config(uint8_t AlarmTime);
void DisableAlarm(void);
void WriteToFlash (uint32_t Address, uint32_t Value);
uint32_t ReadFromFlash (uint32_t Address);
void ClearFlashFlag(void);


#endif /* __MISC_H */
