#include <Time.h>

/* FLOR
  
  Padres:
  Marilyn Nowacka
  Daniel Bruzual
  
  Acta de Nacimiento
*/
//MACROS

//Estados
const int ADENTRO = 1;
const int SALIENDO = 2;
const int AFUERA = 3;
const int TRISTE = 4;

//Movimientos
const int SALIR = 1;
const int TRISTEZA = 2;
const int ENTRAR = 3;
const int ASOMAR = 4;
const int SUBIBAJA = 5;

//Sensor
const int CERCA = 60;

//CONSTANTES

//Leds RGB
const int led1_azul = 2;
const int led1_verde = 3;
const int led1_rojo = 4;
const int led2_azul = 5;
const int led2_verde = 6;
const int led2_rojo = 7;
const int led3_azul = 8;
const int led3_verde = 9;
const int led3_rojo = 10;
const int led4_azul = 11;
const int led4_verde = 12;
const int led4_rojo = 13;

//Pulsadores
const int pulsa4 = 42; // 11 12 13
const int pulsa3 = 43; // 8 9 10
const int pulsa2 = 44; // 5 6 7
const int pulsa1 = 45; //2 3 4

//Motor
const int motor1Pin = 26;    // H-bridge leg 1 (pin 2, 1A)
const int motor2Pin = 24;    // H-bridge leg 2 (pin 7, 2A)
const int enablePin = 27;    // H-bridge enable pin

//Sensor
const int trigger = 37;
const int auput = 36;

//Variables
int estado = ADENTRO;
int valueSensor;
int distancia;
int delayado = 1;
int color;
int momento;
int carinoTriste;
int momentoTriste;
int verde;
int rojo;
int azul;
int azul1;
int verde1;
int rojo1;
int azul2;
int verde2;
int rojo2;
int azul3;
int verde3;
int rojo3;
int azul4;
int verde4;
int rojo4 ;
int cuantas = 80;
int desde;
int TMUERTE = 30;
int VIVA = 30;

void apagarLeds(){
  analogWrite(led1_azul, 255);
  analogWrite(led1_verde, 255);
  analogWrite(led1_rojo, 255);
  analogWrite(led2_azul, 255);
  analogWrite(led2_verde, 255);
  analogWrite(led2_rojo, 255);
  analogWrite(led3_azul, 255);
  analogWrite(led3_verde, 255);
  analogWrite(led3_rojo, 255);
  analogWrite(led4_azul, 255);
  analogWrite(led4_verde, 255);
  analogWrite(led4_rojo, 255);
}

void setup(){
 Serial.begin(9600);
 apagarLeds();
 
 //Sensor
 pinMode(auput, INPUT);
 pinMode(trigger, OUTPUT);
 
 //Motor
 pinMode(motor1Pin, OUTPUT); 
 pinMode(motor2Pin, OUTPUT); 
 pinMode(enablePin, OUTPUT);
 
 //Leds rgb
  pinMode(led1_azul, OUTPUT);
  pinMode(led1_verde, OUTPUT);
  pinMode(led1_rojo, OUTPUT);
  pinMode(led2_azul, OUTPUT);
  pinMode(led2_verde, OUTPUT);
  pinMode(led2_rojo, OUTPUT);
  pinMode(led3_azul, OUTPUT);
  pinMode(led3_verde, OUTPUT);
  pinMode(led3_rojo, OUTPUT);
  pinMode(led4_azul, OUTPUT);
  pinMode(led4_verde, OUTPUT);
  pinMode(led4_rojo, OUTPUT);

//Pulsadores
  pinMode(pulsa1, INPUT);
  pinMode(pulsa2, INPUT);
  pinMode(pulsa3, INPUT);
  pinMode(pulsa4, INPUT);
}

void bajar(int tiempo){
  digitalWrite(motor1Pin, HIGH);   // pata 1 del H-bridge high
  digitalWrite(motor2Pin, LOW);  // pata 2 del H-bridge low
  delay(tiempo);
}

void subir(int tiempo){
  digitalWrite(motor1Pin, LOW);   // pata 1 del H-bridge low
  digitalWrite(motor2Pin, HIGH);  // pata 2 del H-bridge high
  delay(tiempo);
}

int hayAlguien(){
  digitalWrite(trigger, HIGH); //Toma medidas de distancia
  delay(1); 
  digitalWrite(trigger, LOW); 
  valueSensor= pulseIn(auput, HIGH); //Distancia recibida
  distancia = valueSensor/58;
  Serial.print(estado);
  Serial.print(" ");
  Serial.println(distancia); //Si se quiere ver la distancia que se está midiendo. 
  if ( (distancia > 0) && (distancia < CERCA) ) {
    return 1;
  }
  return 0;
    
}

void cambiarEstado(int cambio){
  if (cambio == ADENTRO){
    apagarLeds();
    mover(ENTRAR);
    delayado = 0;
  }
  else if (cambio == AFUERA){
    if (desde == ASOMAR){
      mover(SALIR);
    }
    cuantas =80;
    momento = now();
  }
  else if (cambio == TRISTE){
    tristeando(250,128,114);
    carinoTriste = 0;
    momentoTriste = now();
  }
  else if (cambio == SALIENDO){
    mover(ASOMAR);
  }
  estado = cambio;
}

void tristeando(int az, int ro,int ver){
  rgb(az,ro,ver);
  analogWrite(led1_azul, azul);
  analogWrite(led1_rojo, rojo);
  analogWrite(led1_verde, verde);
  analogWrite(led2_azul, azul);
  analogWrite(led2_verde, verde);
  analogWrite(led2_rojo, rojo);
  analogWrite(led3_azul, azul);
  analogWrite(led3_verde, verde);
  analogWrite(led3_rojo, rojo);
  analogWrite(led4_azul, azul);
  analogWrite(led4_verde, verde);
  analogWrite(led4_rojo, rojo);
}

int carino(){
  int buttonState1;
  int buttonState2;
  int buttonState3;
  int buttonState4;
  buttonState1 = digitalRead(pulsa1);
  buttonState2 = digitalRead(pulsa2);
  buttonState3 = digitalRead(pulsa3);
  buttonState4 = digitalRead(pulsa4);
  
  if (buttonState1 == HIGH){
    return 1;
  }
  else if (buttonState2 == HIGH){
    return 2;
  }
  else if (buttonState3 == HIGH) {
    return 3;
  }
  else if (buttonState4 == HIGH) {
    return 4;
  }
  return 0;
}

int muchoTiempo(){
  int tiempo = now() - momento;
  if (tiempo > (VIVA)){
   return 1;
  }
  return 0;
}

int chaoYa(){
  int tiempo = now() - momentoTriste;
  int red = 250 - 250*tiempo/TMUERTE;
  int green = 128 - 128*tiempo/TMUERTE;
  int blue = 114 - 114*tiempo/TMUERTE;
  tristeando(red,green,blue);
  if (tiempo > TMUERTE){
    apagarLeds();
  }  
  if (tiempo > (TMUERTE + 2)){
    apagarLeds();
    return 1;
  }
  return 0;
}

void rgb(int red, int green, int blue){
  rojo = 255 - red;
  azul = 255 - blue;
  verde = 255 - green;
}

void aleatorio() {
  int ran = random(1,20);
  switch (ran){
  case 1: //Prender verde y rojo
    verde = 0;
    rojo = 0;
    azul = 255;
    break;
  case 2: //Prender rojo
    rojo = 0;
    azul = 255;
    verde = 255;
    break;
  case 3: //Prender verde y azul
    verde = 0;
    azul = 0;
    rojo = 255;
    break;
  case 4: //Prender azul
    azul = 0;
    verde = 255;
    rojo = 255;
    break;
  case 5: //Prender rojo y azul
    azul = 0;
    rojo = 0;
    verde = 255;
    break;
  case 6: //Prender verde
    verde = 0;
    azul = 255;
    rojo = 255;
  case 7:
    rgb(255,20,147); //DEEP PINK 
    break;
  case 8:
    rgb (148,0,211); // DARK ORCHID
    break;
  case 9:
     rgb(255,165,0);// ORANGE
     break;
  case 10:
     rgb(124,252,0); // LAWN GREEN
     break;
  case 11:
     rgb(0,255,127); // SPRING GREEN
     break;
  case 12:
     rgb(255,127,0); // NARANJA
     break;
  case 13:
     rgb(255,0,127); // ROSA
     break;
  case 14:
     rgb(127,0,255); //MORADO 
     break;
  case 15:
     rgb(0,127,255); // AZULITO
     break;
  case 16:
     rgb(127,255,0); //AMARILLO 
     break;
  case 17:
     rgb(25,25,112); //AZUL CLARITO
     break;
  case 18:
     rgb(30,144,255); // AZULILLO
     break;
  case 19:
     rgb(124,252,0); // LAWN GREEN (otra vez, porque es bonito)
     break;
  case 20:
    rgb(0,255,127); // SPRING GREEN (otra vez tambien =D)
     break;
  }
}

void prenderColores(){
  aleatorio();
  azul1 = azul;
  verde1 = verde;
  rojo1 = rojo;
  analogWrite(led1_azul, azul);
  analogWrite(led1_verde, verde);
  analogWrite(led1_rojo, rojo);
  aleatorio();
  azul2 = azul;
  verde2 = verde;
  rojo2 = rojo;
  analogWrite(led2_azul, azul);
  analogWrite(led2_verde, verde);
  analogWrite(led2_rojo, rojo);
  aleatorio();
  azul3 = azul;
  verde3 = verde;
  rojo3 = rojo;
  analogWrite(led3_azul, azul);
  analogWrite(led3_verde, verde);
  analogWrite(led3_rojo, rojo);
  aleatorio();
  azul4 = azul;
  verde4 = verde;
  rojo4 = rojo;
  analogWrite(led4_azul, azul);
  analogWrite(led4_verde, verde);
  analogWrite(led4_rojo, rojo);
}

void mover(int donde){
  digitalWrite(enablePin, HIGH);
  if (donde == SALIR){
    Serial.println("salir");
    if (desde == ASOMAR){
      subir(2000);
    }
  }
  else if (donde == ENTRAR) {
    Serial.println("entrar");
    if (desde == TRISTEZA){
      bajar(3400);
    }else if (desde == ASOMAR){
      bajar(1200);
    }
  }
  else if (donde == SUBIBAJA){
    Serial.println("subibaja");
    bajar(700);
    subir(950);
    delay(3000);
  }
  else if (donde == ASOMAR){
    Serial.println("asomar");
    subir(1000);
  }
  digitalWrite(enablePin, LOW);
}

void fijarColor(int car){
  
  Serial.println("PETALO NUMERO");
  Serial.println(car);
  
  if (car == 1){
    analogWrite(led2_azul, azul1);
    analogWrite(led2_verde, verde1);
    analogWrite(led2_rojo, rojo1);
    analogWrite(led3_azul, azul1);
    analogWrite(led3_verde, verde1);
    analogWrite(led3_rojo, rojo1);
    analogWrite(led4_azul, azul1);
    analogWrite(led4_verde, verde1);
    analogWrite(led4_rojo, rojo1);
  } 
  else if (car == 2) {
    analogWrite(led1_azul, azul2);
    analogWrite(led1_verde, verde2);
    analogWrite(led1_rojo, rojo2);
    analogWrite(led3_azul, azul2);
    analogWrite(led3_verde, verde2);
    analogWrite(led3_rojo, rojo2);
    analogWrite(led4_azul, azul2);
    analogWrite(led4_verde, verde2);
    analogWrite(led4_rojo, rojo2);
  }
  else if (car == 3) {
    analogWrite(led1_azul, azul3);
    analogWrite(led1_verde, verde3);
    analogWrite(led1_rojo, rojo3);
    analogWrite(led2_azul, azul3);
    analogWrite(led2_verde, verde3);
    analogWrite(led2_rojo, rojo3);
    analogWrite(led4_azul, azul3);
    analogWrite(led4_verde, verde3);
    analogWrite(led4_rojo, rojo3);
  }
  else if (car == 4){
    analogWrite(led1_azul, azul4);
    analogWrite(led1_verde, verde4);
    analogWrite(led1_rojo, rojo4);
    analogWrite(led2_azul, azul4);
    analogWrite(led2_verde, verde4);
    analogWrite(led2_rojo, rojo4);
    analogWrite(led3_azul, azul4);
    analogWrite(led3_verde, verde4);
    analogWrite(led3_rojo, rojo4);
  }
  
}

void loop(){
  int car;
  if (estado == ADENTRO){
    if (delayado){ //Ya espere 1/2 min    
      
      if ( hayAlguien() ) { //Si hay alguien
        cambiarEstado(SALIENDO);
      } else {
        delay(100);
      }
      
    } else {//No he esperado el medio minuto
      delay(30000);
      delayado = 1;
    }
  }
  
  else if (estado == SALIENDO){
    if ( hayAlguien() ){
      delay(10000); //Espero 10 seg
      if ( hayAlguien() ) {
        desde = ASOMAR;
        cambiarEstado(AFUERA);
      }
      else{
        desde = ASOMAR;
        cambiarEstado(ADENTRO);     
      }  
    } else {
      desde = ASOMAR;
      cambiarEstado(ADENTRO);
    } 
  }
  
  else if (estado == AFUERA){ 
    if (cuantas == 80){
      prenderColores();
      cuantas = 0;
    } else {
      cuantas++;
    }
    car = carino();
    if( car ){
        fijarColor(car);
        mover(SUBIBAJA);
        momento = now();
    } else {
        if (muchoTiempo() ){
          cambiarEstado(TRISTE);
        } else{
          delay(30);
        }
   }    
}
  
  else if (estado == TRISTE){
     apagarLeds();
     if (hayAlguien()) {
       if ( carino() ){
           desde = TRISTEZA;
           cambiarEstado(AFUERA);      
       } else {
         if(chaoYa()){
           desde = TRISTEZA;
           cambiarEstado(ADENTRO);
         } else {
           delay(100);
         }
       }
     } else {
       if(chaoYa()){
         desde = TRISTEZA;
         cambiarEstado(ADENTRO);
        } else {
          delay(100);
        }
     }

  }
  
}

