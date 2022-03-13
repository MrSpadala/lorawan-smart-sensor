
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
  
  pinMode(DIGITAL1, OUTPUT);
  pinMode(DIGITAL5, OUTPUT);
  digitalWrite(DIGITAL1, HIGH);

  // setup lorawan
  USB.println(F("Setup LoRawan..."));
  
  error = LoRaWAN.ON(socket);
  ERR("switch on");
  error = LoRaWAN.setDataRate(3);
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
  //USB.print(F("payload to send: "));
  //USB.println(data);

  // send on lorawan
  USB.print(F("sending data on LoRaWAN..."));
  error = LoRaWAN.sendUnconfirmed(1, data);
  ERR("send lorawan");
  USB.println(F("data on LoRaWAN sent!"));

  // check if there is a downlink
  if (LoRaWAN._dataReceived == true) {
    USB.print(F("Downlink received! Data: "));
    USB.println(LoRaWAN._data);

    digitalWrite(DIGITAL5, HIGH);
    delay(4000);
    digitalWrite(DIGITAL5, LOW);
  }

  // sleep for 1 second
  USB.println(F("sleeping..."));
  delay(7000);
}
