#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <time.h>
#include <WiFiManager.h>  // https://github.com/tzapu/WiFiManager
#include <Arduino.h>
#include <ArduinoJson.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/timers.h"
#include "freertos/event_groups.h"
#include <DHT.h>
#include <Adafruit_Sensor.h>
#include <Preferences.h>  //https://github.com/espressif/arduino-esp32/tree/master/libraries/Preferences

// select which pin will trigger the configuration portal when set to LOW
#define TRIGGER_PIN 4   // wifi rest button pin
#define DHTPIN 5        // DHT sensor pin
#define DHTTYPE DHT11   // DHT sensor type
#define MoisturePIN A0  // ESP32 pin GIOP36 (ADC0) that connects to AOUT pin of moisture sensor
#define RELAY_PIN 17    // ESP32 pin GIOP17 that connects to relay

const int timeout = 120;  // seconds to run for

//WiFiManager, Local intialization. Once its business is done, there is no need to keep it around
WiFiManager wm;

// store data
Preferences preferences;

const char* mqtt_server = "82e8080b41ac4fcfbb1a413718a694eb.s2.eu.hivemq.cloud";
const char* mqtt_username = "user1";
const char* mqtt_password = "project-k-mart";
const char* clientId = "k-mart_smart-farm_user1";  // Create a random client ID
const int mqtt_port = 8883;


// temperature humidity  Sensor
DHT dht(DHTPIN, DHTTYPE);

// JSON data buffer
StaticJsonDocument<120> jsonDocument;
char buffer[120];

// DynamicJsonDocument jsonBuffer(200);  // adjust the size according to your needs
// // JsonObject jsonObj = jsonBuffer.to<JsonObject>();

// parse the JSON string into a JSON object
StaticJsonDocument<1024> jsonObj;


// A single, global CertStore which can be used by all connections.
// Needs to stay live the entire time any of the WiFiClientBearSSLs
// are present.
// MQTT client
WiFiClientSecure espClient;
PubSubClient client(espClient);

const char* temp_data = "get/temp";
const char* hum_data = "get/hum";
const char* moi_data = "get/moi";
const char* sensor_data = "get/sensor_data";

const char* farm_settings = "put/settings";
const char* farm_settings_status = "get/settings";

const char* motorState = "put/motorState";
const char* moi_threshoud = "put/moi_threshoud";
const char* is_manual_irrigation = "put/is_manual_irrigation";

// env variable
bool sensor_new_data = false;
float temperature, humidity, moisture, sensor_analog;

TaskHandle_t Task1;
TaskHandle_t Task2;

static const char* root_ca PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----
)EOF";

void connectToWiFi() {

  WiFi.mode(WIFI_STA);  // explicitly set mode, esp defaults to STA+AP
  // put your setup code here, to run once:
  Serial.println("\n Starting");
  digitalWrite(LED_BUILTIN, HIGH);
  digitalWrite(RELAY_PIN, HIGH);

  // Automatically connect using saved credentials,
  // if connection fails, it starts an access point with the specified name ( "AutoConnectAP"),
  // if empty will auto generate SSID, if password is blank it will be anonymous AP (wm.autoConnect())
  // then goes into a blocking loop awaiting configuration and will return success result

  bool res;
  // res = wm.autoConnect(); // auto generated AP name from chipid
  // res = wm.autoConnect("AutoConnectAP"); // anonymous ap
  res = wm.autoConnect("K-Mart(Smart Farm)", "password");  // password protected ap

  if (!res) {
    Serial.println("Failed to connect");
    // ESP.restart();
  } else {
    //if you get here you have connected to the WiFi
    Serial.println("connected to network..");
     digitalWrite(LED_BUILTIN, LOW);
  }
  pinMode(TRIGGER_PIN, INPUT_PULLUP);
}

void setupMQTT() {
  espClient.setCACert(root_ca);
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}


void create_json(char* tag, float value, char* unit) {
  jsonDocument.clear();
  jsonDocument["type"] = tag;
  jsonDocument["value"] = value;
  jsonDocument["unit"] = unit;
  serializeJson(jsonDocument, buffer);
  Serial.println("Buffer:");
  Serial.println(buffer);
}

void create_json_new(float temp, float hum, float moi) {
  jsonDocument.clear();
  jsonDocument["temp"] = temp;
  jsonDocument["hum"] = hum;
  jsonDocument["moi"] = moi;
  jsonDocument["client_id"] = clientId;
  serializeJson(jsonDocument, buffer);
  Serial.println("Buffer:");
  Serial.println(buffer);
}

void create_setting_json() {
  jsonDocument.clear();
  jsonDocument["motorState"] = preferences.getInt("motorState", 0);
  ;
  jsonDocument["irrigationType"] = preferences.getInt("is_manual", 0);
  ;
  jsonDocument["client_id"] = clientId;
  serializeJson(jsonDocument, buffer);
  Serial.println("Buffer:");
  Serial.println(buffer);
}

//=======================================
// This void is called every time we have a message from the broker

void callback(char* topic, byte* payload, unsigned int length) {
  String incommingMessage = "";

  for (int i = 0; i < length; i++)
    incommingMessage += (char)payload[i];

  Serial.println(" \n Message arrived [" + String(topic) + "] : " + incommingMessage);
  Serial.println("topic : " + String(topic));

  if (String(topic) == farm_settings) {

    const char* json = incommingMessage.c_str();

    DeserializationError err = deserializeJson(jsonObj, json);

    if (err) {
      Serial.print(F("deserializeJson() failed: "));
      Serial.println(err.c_str());
    } else {

      Serial.println("im here 1");
      Serial.println("Motor state: " + String(jsonObj["motorState"].as<int>()));
      Serial.println("Irrigation type: " + String(jsonObj["irrigationType"].as<int>()));
      Serial.println("Moisture threshold: " + String(jsonObj["moistureThreshold"].as<float>()));
      Serial.println("Client ID: " + String(jsonObj["clientID"].as<String>()));

      if (String(jsonObj["clientID"].as<String>()) == clientId) {
        digitalWrite(LED_BUILTIN, HIGH);
        Serial.println("im here 2");
        preferences.putFloat("moi_threshoud", jsonObj["moistureThreshold"].as<float>());
        preferences.putInt("is_manual", jsonObj["irrigationType"].as<int>());
        preferences.putInt("motorState", jsonObj["motorState"].as<int>());

        if (jsonObj["motorState"].as<int>() == 1) {
          Serial.print("manualy turn pump ON");
          digitalWrite(RELAY_PIN, LOW);
        } else {
          Serial.print("manualy turn pump OFF");
          digitalWrite(RELAY_PIN, HIGH);
        }
        delay(500);
        digitalWrite(LED_BUILTIN, LOW);
      }
    }

  } else if (String(topic) == moi_threshoud) {
    preferences.putFloat("moi_threshoud", incommingMessage.toFloat());
  } else if (String(topic) == is_manual_irrigation) {
    preferences.putInt("is_manual", incommingMessage.toInt());
  } else if (String(topic) == motorState) {
    preferences.putInt("motorState", incommingMessage.toInt());

    if (incommingMessage.toInt() == 1) {
      Serial.print("manualy turn pump ON");
      digitalWrite(RELAY_PIN, LOW);
    } else {
      Serial.print("manualy turn pump OFF");
      digitalWrite(RELAY_PIN, HIGH);
    }
  }
  // check for other commands
  /* else if( strcmp(topic,command2_topic) == 0){
if (incommingMessage.equals("1")) { } // do something else
}
*/
}

//======================================= publising as string
void publishMessage(const char* topic, String payload, boolean retained) {
  if (client.publish(topic, payload.c_str(), true))
    Serial.println("Message publised [" + String(topic) + "]: " + payload);
}

void reconnect() {
  // Loop until we’re reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection…");
    //clientId += String(random(0xffff), HEX);
    // Attempt to connect
    // clientId.c_str()
    if (client.connect(clientId, mqtt_username, mqtt_password)) {
      Serial.println("connected");

      client.subscribe(motorState);            // subscribe the topics here
      client.subscribe(moi_threshoud);         // subscribe the topics here
      client.subscribe(is_manual_irrigation);  // subscribe the topics here
      client.subscribe(farm_settings);         // subscribe the topics here

    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");  // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void read_moisture_data(void* parameter) {
  for (;;) {
    sensor_analog = analogRead(MoisturePIN);
    moisture = (100 - ((sensor_analog / 4095.00) * 100));
    Serial.println("Read moisture data (Task 2) :" + String(moisture));

    float THRESHOLD = preferences.getFloat("moi_threshoud", 0.0);
    int is_manual = preferences.getInt("is_manual", 0);

    Serial.println("saved preference THRESHOLD value :" + String(THRESHOLD));
    Serial.println("saved preference is_manual value :" + String(is_manual));

    if (is_manual == 0 && THRESHOLD != 0.0) {
      if (moisture < THRESHOLD) {
        if (digitalRead(RELAY_PIN) != LOW) {
          Serial.println("The soil is DRY => turn pump ON ");
          digitalWrite(RELAY_PIN, LOW);

          preferences.putInt("motorState", 1);

          create_setting_json();
          publishMessage(farm_settings_status, buffer, true);
        }
      } else if (digitalRead(RELAY_PIN) != HIGH) {
        Serial.println("The soil is WET => turn pump OFF ");
        digitalWrite(RELAY_PIN, HIGH);

        preferences.putInt("motorState", 0);

        create_setting_json();
        publishMessage(farm_settings_status, buffer, true);
      }
    }

    // delay the task
    //delay(40000);
    vTaskDelay(40000 / portTICK_PERIOD_MS);
  }
}

void read_sensor_data(void* parameter) {
  for (;;) {
    temperature = dht.readTemperature();
    humidity = dht.readHumidity();
    sensor_analog = analogRead(MoisturePIN);
    moisture = (100 - ((sensor_analog / 4095.00) * 100));
    Serial.println("Read sensor data");
    sensor_new_data = true;

    // delay the task
    //delay(60000);
    vTaskDelay(60000 / portTICK_PERIOD_MS);
  }
}

void setup_task() {

  xTaskCreatePinnedToCore(read_sensor_data, "Read sensor data", 6000, NULL, 1, &Task1, 0);
  delay(500);
  xTaskCreatePinnedToCore(read_moisture_data, "Read moisture data", 6000, NULL, 1, &Task2, 1);
  delay(500);

  // xTaskCreate(
  //   read_sensor_data,
  //   "Read sensor data",   // Name of the task (for debugging)
  //   1000,            // Stack size (bytes)
  //   NULL,            // Parameter to pass
  //   1,               // Task priority
  //   NULL             // Task handle
  // );

  // xTaskCreate(
  //   read_moisture_data,
  //   "Read moisture data",   // Name of the task (for debugging)
  //   1000,            // Stack size (bytes)
  //   NULL,            // Parameter to pass
  //   2,               // Task priority
  //   NULL             // Task handle
  // );
}


void setup() {
  pinMode(LED_BUILTIN, OUTPUT);  // Initialize the LED_BUILTIN pin as an output
  pinMode(RELAY_PIN, OUTPUT);    // Initialize the relay pin as output

  delay(500);
  // When opening the Serial Monitor, select 9600 Baud
  Serial.begin(9600);
  preferences.begin("my-app", false);
  //preferences.putFloat("moi_threshoud", 30.0);
  delay(500);
  connectToWiFi();  // connect to wifi
  delay(1000);
  setupMQTT();  // setup MQTT protocol
  delay(1000);
  setup_task();  // create task for reading data
  delay(3000);
  digitalWrite(RELAY_PIN, HIGH);
}

void loop() {
  // is configuration portal requested?
  if (digitalRead(TRIGGER_PIN) == LOW) {
    // reset settings - for testing
    wm.resetSettings();

    //Serial.println("failed to connect and hit timeout");
    delay(3000);
    //reset and try again, or maybe put it to deep sleep
    ESP.restart();
    delay(5000);
  } else {
    if (!client.connected())
      reconnect();
    client.loop();
    //delay(10000);
    if (sensor_new_data == true) {
      sensor_new_data = false;

      //create_json("temperature",temperature, "°C");
      // publishMessage(temp_data, buffer, true);
      //create_json("humidity", humidity, "%");
      // publishMessage(hum_data, buffer, true);
      //create_json("moisture", moisture, "%");
      // publishMessage(moi_data, buffer, true);

      create_json_new(temperature, humidity, moisture);
      publishMessage(sensor_data, buffer, true);
    }
  }
}