# RADAR_SYSTEM_USING_ARDUINO_UNO
📡 Arduino Radar System using Ultrasonic Sensor &amp; Processing Real-time Arduino radar visualization using ultrasonic sensor and Processing with distance-based alerts.

📖 Overview

This project is an Arduino UNO based Radar System that detects nearby objects using an HC-SR04 ultrasonic sensor and visualizes them in real time using Processing IDE. The radar sweep is simulated from 0° to 180°, and detected objects are displayed on a graphical radar screen.
When an object comes within a critical range, the system triggers: LED alert Buzzer warning On-screen radar warning This project demonstrates embedded systems, serial communication, and real-time visualization.

🧰 Hardware Components
Arduino UNO HC-SR04 Ultrasonic Sensor LED Buzzer Breadboard Jumper Wires
🔌 Circuit Connections Component Arduino Pin Ultrasonic TRIG D9 Ultrasonic ECHO D10 LED D6 Buzzer D5 VCC 5V GND GND ⚙️ Software Requirements
Arduino IDE
Processing IDE
Processing Serial Library

🚀 Features

0°–180° radar sweep simulation (no servo required)
Real-time distance measurement
Object detection up to 40 cm
LED + buzzer alert below 20 cm
On-screen warning below 15 cm
Smooth radar animation with trails
Serial communication (Arduino → Processing)
📂 Project Structure 
Arduino-Radar-System/ │ 
├── Arduino_Code/
│ └── radar_arduino.ino  
├── Processing_Code/ 
│ └── radar_visualization.pde 
│ └── README.md 

▶️ How It Works
Ultrasonic sensor measures object distance.
Arduino simulates radar sweep angle (0–180°).
Arduino sends serial data in format:
