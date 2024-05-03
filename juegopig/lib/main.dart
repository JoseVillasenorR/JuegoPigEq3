import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(JuegoDelPig());
}

class JuegoDelPig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego Pig 🐷',
      theme: ThemeData(

        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PantallaJuegoPig(),
    );
  }
}

class PantallaJuegoPig extends StatefulWidget {
  @override
  _EstadoPantallaJuegoPig createState() => _EstadoPantallaJuegoPig();
}

class _EstadoPantallaJuegoPig extends State<PantallaJuegoPig> {
  int puntajeJugador = 0;
  int puntajeComputadora = 0;
  int puntajeTurnoActual = 0;
  int valorDado = 1;
  bool esTurnoJugador = true;
  bool juegoTerminado = false;

  void _lanzarDado() {
    setState(() {
      valorDado = _generarValorDadoAleatorio();
      puntajeTurnoActual += valorDado;
      if (valorDado == 1) {
        puntajeTurnoActual = 0;
        _finalizarTurno();
      }
    });
  }

  void _finalizarTurno() {
    setState(() {
      if (esTurnoJugador) {
        puntajeJugador += puntajeTurnoActual;
      } else {
        puntajeComputadora += puntajeTurnoActual;
      }

      if (puntajeJugador >= 100 || puntajeComputadora >= 100) {
        juegoTerminado = true;
      } else {
        puntajeTurnoActual = 0;
        esTurnoJugador = !esTurnoJugador;

        if (!esTurnoJugador) {
          _turnoComputadora();
        }
      }
    });
  }

  void _turnoComputadora() {
    while (!esTurnoJugador) {
      int valorDado = _generarValorDadoAleatorio();
      puntajeTurnoActual += valorDado;
      if (valorDado == 1 || puntajeTurnoActual >= 100) {
        break;
      }
    }
    _finalizarTurno();
  }

  int _generarValorDadoAleatorio() {
    return Random().nextInt(6) + 1;
  }

  Widget _construirTablaPuntajes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _construirColumnaPuntaje("Jugador", puntajeJugador),
        _construirColumnaPuntaje("Computadora", puntajeComputadora),
      ],
    );
  }

  Widget _construirColumnaPuntaje(String jugador, int puntaje) {
    return Column(
      children: [
        Text(
          jugador,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          puntaje.toString(),
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego Pig 🐷'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _construirTablaPuntajes(),
            SizedBox(height: 20),
            Text(
              'Puntaje del Turno Actual: $puntajeTurnoActual',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/dice$valorDado.jpeg',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            if (!juegoTerminado && esTurnoJugador)
              ElevatedButton(
                onPressed: () {
                  _lanzarDado();
                },
                child: Text('Lanzar Dado'),
              ),
            SizedBox(height: 10),
            if (!juegoTerminado && esTurnoJugador)
              ElevatedButton(
                onPressed: () {
                  _finalizarTurno();
                },
                child: Text('Terminar Turno'),
              ),
            if (juegoTerminado)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '¡Fin del Juego! ${puntajeJugador >= 100 ? "Jugador" : "Computadora"} gana!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
