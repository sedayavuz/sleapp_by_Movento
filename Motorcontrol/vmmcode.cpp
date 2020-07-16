 // In this NanoJ program, we will make the motor turn shortly back and forth.
// The language used for NanoJ programs is C, with a few specific extensions,
// like the mappings (see below).
// Please refer to the product manual for more details about NanoJ and the
// object dictionary.

// You can map frequently used objects to be able to read or write them
// using In.* and Out.*. Here we map the object 6041:00 as "In.StatusWord".
map U16 StatusWord as input 0x6041:00
map U16 ControlWord as output 0x6040:00
map U32 ProfileVelocity as output 0x6081:00
map S32 TargetPosition as output 0x607A:00
map S08	OperationMode as output 0x6060:00
map S32 HomingOffset as output 0x607C:00
map S08 HomingMethod as output 0x6098:00
map U32 MotorSubmode as output 0x3202:00
map U32 MaxMotorCurrent as output 0x2031:00
//map U08 HomingSpeed as output 0x6099:00
//map U32	HomingConfig as output 0x203A:
map U32 MaxMotorSpeed as output 0x6080:00
map U08 InterpolationTime as output 0x60C2:01
map S08 TimeIndex as output 0x60C2:02

//map U32	HomingConfiguration as output 0x203A:01 //A current
//map U32	I2tParameters as output 0x203A:02//B ms

//map U32 MaxMotorCurrent as output 0x2031:01



// Include the definition of NanoJ functions and symbols
#include "wrapper.h"
#include "misc.h"
#include "control.h"


// The user() function is the entry point of the NanoJ program. It is called
// by the firmware of the controller when the NanoJ program is started.
void user()
{
	uint32_t ReadReg;
	
	int i = 0;
	int j=0;
	void Init_GPIO (void);
	void Timer_Init(void);
	void ISSI_Init(void);
	void Init_UART(void);
	
	sleep(1500);
	
	
	// Remember target velocity before overwriting, so we can reset it later.
	//S32 targetVelocity = od_read(0x60FF, 0x00);
	//int i = 1;
	

	//operation mode geht als Zahl
	// Control Word muss 0x4F "enable operation", 0x5F startet Fahrt, 0x6 (enable voltage), 0x7 (switched on)
	// Control Word
	
	
	
	//Auto Setup
	/*Out.ControlWord = 6;
	sleep(5000);
	
	Out.OperationMode = 0xFE;
	sleep(5000);
	
	Out.ControlWord = 7;
	sleep(5000);
	
	Out.ControlWord = 0x0F;
	sleep(5000);	
	
	Out.ControlWord = 0x1F;
	sleep(5000);
	
	Out.ControlWord = 0;
	sleep(5000); 
	/**/
	
	void EXTI_Config(void);
	
	//Motor Settings	
	
	Out.MaxMotorCurrent = int(100); //Maxmotorcurrent ma
	Out.MaxMotorSpeed = int(120); //max Speed in 
	od_write(0x203B, 0x01, int(200)); //i2t equals MaxMotorCurrent in mA
	od_write(0x203B, 0x02, int(100)); //Maximum Duration Of Peak Current in ms
	od_write(0x6065, 0x00, 0x0100);	 //Following Error Window - Sollfehler/ Abweichung von Sollposition
	od_write(0x6066, 0x00, int(2200)); //Following Error Time Out - Zeit bis Sollfehler zu Error führt
	od_write(0x6067, 0x00, int(100)); /*Gibt relativ zur Zielposition einen symmetrischen Bereich an, innerhalb dessen das Ziel als erreicht gilt
										in den Modi Profile Position und Interpolated Position Mode./*/
	Out.MotorSubmode = int(9); //Closed Loop
	od_write(0x203A, 0x01, int(100)); //HomingConfig = max current on Block
	od_write(0x203A, 0x02, 0x00000064); //100mS block pulse time	
	
	sleep(1500);
	
	/*
	Out.ControlWord = 0x06; //Ready to switch on 
	sleep(5000);
	
	Out.ControlWord = 7; //switch on
	sleep(5000);
	
	Out.ControlWord = 0x0F; //Operation Enable
	sleep(5000);
	
	Out.ControlWord= 0x1F; //start homing
	sleep(5000);
	
	Out.ControlWord=0x2F;//switch to enable
	sleep(5000);
	
	Out.ControlWord=0x3F; //start positioning next
	sleep(5000);
	
	
	Out.ControlWord=2; //motor off
	sleep(5000); /**/
	
	
	
	//Homing Mode
	Out.MotorSubmode = int (8); 	// Closed loop
	Out.OperationMode = 1; 		   //Activate Positioning
	Out.TargetPosition = 0x00000E10; //Target Position3600 2mm
	
	
	Out.ProfileVelocity = int (70);
		
		
	Out.MotorSubmode= int(9);		//Closed Loop
	
	//Ready to switch on
	//Out.ControlWord = 0x06; 
	ReadReg = 0;
	Out.ControlWord=0x06;//Ready to switch on
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x21)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	
	
	//Switch on
	//Out.ControlWord = 7; 
	ReadReg = 0;
	Out.ControlWord=7;//switch on
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x23)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	
	
	//Operation enable
	//Out.ControlWord = 0x0F;
	ReadReg = 0;
	Out.ControlWord=0x0F;//Operation enable
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x27)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
		
	
	
	//Start Homing
	//Out.ControlWord= 0x1F;
	ReadReg = 0;
	Out.ControlWord=0x1F;
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0x1400) != 0x1400)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	
	
	
	//Ready to switch on
	//Out.ControlWord = 0x06; //Ready to switch on 
	ReadReg = 0;
	Out.ControlWord=0x06;//Ready to switch on
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x21)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	
	
	
		
	Out.OperationMode = 6;//StartHoming
	Out.HomingMethod =  0xEF;
	Out.HomingOffset = 0xFFFF63C0; //2,2cm
	od_write(0x6099, 0x01, 70); //Geschwindigkeit für die Suche nach dem Schalter angegeben
	od_write(0x6099, 0x02, 70); // (niedrigere) Geschwindigkeit für die Suche nach der Referenzposition
	
	sleep(1500);


	//Ready to Switch on
	//Out.ControlWord = 0x06;	
	ReadReg = 0;
	Out.ControlWord=0x06;
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x21)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	
	
	//switch on
	ReadReg = 0;
	Out.ControlWord=7;
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x23)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	
	
	//Operation enable
	ReadReg = 0;
	Out.ControlWord=0x0F;
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x27)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	
	

	
	//start homing
	ReadReg = 0;	
	Out.ControlWord= 0x1F; 	
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0x1400) != 0x1400)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}
		   
	ReadReg = 0;
	
	//Switch on
	//	Out.ControlWord = 7; 
	//sleep(1500);
	ReadReg = 0;
	Out.ControlWord=7;
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x23)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}		   
	ReadReg = 0;
	

	
//----------		
	//Homing 2
	Out.OperationMode = 1;
	Out.TargetPosition = 0;
	Out.ProfileVelocity = int(70);
	
	
	ReadReg = 0;
	Out.ControlWord=0x2F;//switchtoenable operation
	ReadReg = od_read(0x6041, 0x00);
	
		while ( (ReadReg & 0xEF) != 0x27)
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}
		   
	ReadReg = 0;
	
	

	ReadReg = 0;
	Out.ControlWord=0x3F; //start positioning next
	ReadReg = od_read(0x6041, 0x00);
	
		while ( ((ReadReg & 0x400) != 0x400) && ((ReadReg & 0x2000) !=0x2000))
		{
		sleep(100);
		ReadReg = od_read(0x6041, 0x00);
		}
		   
	ReadReg = 0;
	
	//End of Homing Mode
	

	
		
	sleep(10000);
	
	
	//Sleep Cycle Modes
	i=1;
	while (i <= 2) {
		modeDeep();
		i++;
	}
	
	i=1;	
	while (i <= 4) {
		modeLight();
		i++;
	}	
	
	i=1;
	while (i <= 1) {
		modeDeep();
		i++;
	}
	
	i=1;	
	while (i <= 3) {
		modeLight();
		i++;
	}	
	
	i=1;
	while (i <= 1) {
		modeDeep();
		i++;
	}
	
	i=1;	
	while (i <= 2) {
		modeLight();
		i++;
	}	
	
	i=1;
	while (i <= 1) {
		modeDeep();
		i++;
	}
		
		
	// Stop the motor
	od_write(0x6040, 0x00, 0x0);

	// Reset the target velocity to its previous value
	//od_write(0x60FF, 0x00, targetVelocity);

	// Stop the NanoJ program. Without this line, the firmware would
	// call user() again as soon as we return.
	od_write(0x2300, 0x00, 0x0);

	}	
	
	//Sleep Cycle
	Out.ControlWord = 2; //motor off
	
	///sleep(30000); //30 sek = 30.000ms



	//Loops Distanz + Zeit	
	
	//1. Loop Mode 2 für 30 min bzw. 30 Sek
	//j = int(30); //interpolationszeit 60C2:01 
	
	
	
/*	Out.OperationMode = 8; ////Set Zyklus MOde
	Out.ProfileVelocity = int(40);//Oder Target Velocity od_write(0x60FF, 0x00, 70);
	Out.TargetPosition = 0xFFFF63C0; //od_write(0x607A, 0x00, 60)
	
	Out.InterpolationTime = 30;
	Out.TimeIndex = -3;*/	
	
	
	
	 	

		
		

	
	
	
	
	
	
	
