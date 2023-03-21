
#include <WaspLoRaWAN.h>
#include <WaspFrame.h>

#define ERR(str) if (error != 0) { USB.println(F("ERROR: " #str)); }

uint8_t socket = SOCKET0;
uint8_t error;

// Device parameters for Back-End registration
char DEVICE_EUI[]  = "0000000000000000";
char APP_EUI[] = "0000000000000000";
char APP_KEY[] = "00000000000000000000000000000000";

void setup()
{
  // put your setup code here, to run once
  USB.ON();
  delay(2000);
  
  // high voltage on digital1 pin
  pinMode(DIGITAL1, OUTPUT);
  digitalWrite(DIGITAL1, HIGH);

  // ~~~ setup lorawan
  USB.println(F("Setup LoRawan..."));
  error = LoRaWAN.ON(socket);
  ERR("switch on");
  error = LoRaWAN.setDataRate(5);
  ERR("data rate");
  error = LoRaWAN.setDeviceEUI(DEVICE_EUI);
  ERR("set device eui");
  error = LoRaWAN.setAppEUI(APP_EUI);
  ERR("set app eui");
  error = LoRaWAN.setAppKey(APP_KEY);
  ERR("set app key");
  error = LoRaWAN.joinOTAA();
  ERR("join lorawan otaa");
  error = LoRaWAN.saveConfig();
  ERR("save config");
  USB.println(F("Setup LoRawan done!"));
}


void loop()
{
  // read the light hitting the fotoresistor.
  // The brighter the light the more the measured voltage is high.
  // variable 'val' ranges between 0 and 1023
  int val = analogRead(ANALOG6);

  // display the measured light
  USB.print(F("\nmeasured light intensity: "));
  USB.println(val, DEC);

  // format data 
  char data[32];
  sprintf(data, "%d", val);

  // send on lorawan
  USB.print(F("sending data on LoRaWAN..."));
  error = LoRaWAN.sendUnconfirmed(3, data);
  ERR("send lorawan");
  USB.println(F("data on LoRaWAN sent!"));

  // sleep for 1 second
  USB.println(F("sleeping..."));
  delay(7000);
}
