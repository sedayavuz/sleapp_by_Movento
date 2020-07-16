/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MOTOR_H
#define __MOTOR_H

#include "stm32f0xx.h"
#include "misc.h"

#define OperationMode 			0x6060
#define HomingMethod  			0x6098
#define HomeingOffset				0x607C 
#define HomeingConfig 			0x203A  
#define HomeingSpeed				0x6099
#define ControlWord					0x6040
#define StatusWord					0x6041
#define TargetPosition			0x607A 
#define ActualPosition 			0x6064
#define DigitalInputs				0x60FD
#define ProfileVelocity 		0x6081
#define UptimeSeconds				0x230F
#define ErrorWindow					0x6065
#define ErrorTimeOut				0x6066
#define PositionWindow		  0x6067
#define MaxMotorCurrent		  0x2031
#define I2tParameters		    0x203B
#define MotorSubmode		    0x3202
#define MaxMotorSpeed		    0x6080
#define ModesDisplay		    0x6061



#define StepResolution									1800 	//steps per 1mm

// Distance in mm units 
#define Distance1												15
#define Distance2												21
#define Distance3												27
#define Distance4												33
#define Distance5												39
#define Distance6												45
#define Distance7												51
#define Distance8												60


#define SpeedResolution									3 	//RPS

// Speed in 0.1mm/s per value
#define Speed1													8
#define Speed2													13
#define Speed3													18
#define Speed4													23
#define Speed5													28
#define Speed6													33
#define Speed7													38
#define Speed8													40



void AutoSetup(void);
void MotorSettings(void);
void ReadyToSwitchON(void);
void SwitchOn (void);
void OperationEnable (void);
void StartHoming (void);
void SwitchToEnableOperation(void);
void StartPositioningNext (void);
void MotorTurnOFF (void);
void HomingMode(void);
void MotorSetup(void);


#endif /* __MOTOR_H */
