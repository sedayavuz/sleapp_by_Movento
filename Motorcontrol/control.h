void modeDeep (void) {
	
		// Set mode "Profile velocity"
		Out.OperationMode = 3;
					
		// Set the target velocity 
		od_write(0x60FF, 0x00, 100); //speed um auf target zuzufahren
	
	 	// Request state "Ready to switch on"
	 	Out.ControlWord = 0x06;
			
		// Wait until the requested state is reached
		while ( (In.StatusWord & 0xEF) != 0x21) {
			yield(); // Wait for the next cycle (1ms)
		}
	
		// Request the state "Switched on"
		Out.ControlWord = 0x07;
		
		// Wait until the requested state is reached
		while ( (In.StatusWord & 0xEF) != 0x23) {
			yield();
		}
	
		// Request the state "Operation enabled"
		Out.ControlWord = 0xF;
	
		// Wait until the requested state is reached
		while ( (In.StatusWord & 0xEF) != 0x27) {
			yield();
		}
		
		// Let the motor run for a while
		sleep(15000);
		
		od_write(0x60FF, 0x00, 0);
		
		sleep(1000);
		
		// Set the target velocity to run in the opposite direction
		od_write(0x60FF, 0x00, -100);
		
	
		// Let the motor run for a while
		sleep(15000);
		
		od_write(0x60FF, 0x00, 0);
		
		sleep(1000);
			
}



void modeLight (void) {
	
		// Set mode "Profile velocity"
		Out.OperationMode = 3;
					
		// Set the target velocity 
		od_write(0x60FF, 0x00, 50); //speed um auf target zuzufahren
	
	 	// Request state "Ready to switch on"
	 	Out.ControlWord = 0x06;
			
		// Wait until the requested state is reached
		while ( (In.StatusWord & 0xEF) != 0x21) {
			yield(); // Wait for the next cycle (1ms)
		}
	
		// Request the state "Switched on"
		Out.ControlWord = 0x07;
		
		// Wait until the requested state is reached
		while ( (In.StatusWord & 0xEF) != 0x23) {
			yield();
		}
	
		// Request the state "Operation enabled"
		Out.ControlWord = 0xF;
	
		// Wait until the requested state is reached
		while ( (In.StatusWord & 0xEF) != 0x27) {
			yield();
		}
		
		// Let the motor run for a while
		sleep(15000);
		
		od_write(0x60FF, 0x00, 0);
		
		sleep(1000);
		
		// Set the target velocity to run in the opposite direction
		od_write(0x60FF, 0x00, -50);
		
	
		// Let the motor run for a while
		sleep(15000);
		
		od_write(0x60FF, 0x00, 0);
		
		sleep(1000);
}