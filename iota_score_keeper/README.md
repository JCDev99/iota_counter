# IOTA Score Keeper

Una aplicación Flutter para llevar el conteo de las puntuaciones del juego de mesa IOTA.

## Características

- Registro de puntuaciones individuales por turno.
- Sumatoria automática de puntos en tiempo real.
- Edición y eliminación de puntuaciones.
- Historial de partidas guardadas localmente.
- Modo oscuro y claro.
- Estadísticas básicas (máxima puntuación, promedio).

## Requisitos Previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
- Un dispositivo Android/iOS conectado o un emulador configurado.

## Instalación y Ejecución

1.  **Clonar el repositorio** (si aplica) o descargar el código.

2.  **Instalar dependencias:**
    Ejecuta el siguiente comando en la raíz del proyecto para descargar las librerías necesarias:
    ```bash
    flutter pub get
    ```

3.  **Generar adaptadores de Hive (Opcional):**
    Si modificas los modelos en `lib/models/`, necesitarás regenerar los adaptadores de la base de datos local:
    ```bash
    flutter pub run build_runner build
    ```
    *Nota: Los archivos generados (.g.dart) ya están incluidos en el repositorio, por lo que este paso no es necesario para ejecutar la app inicialmente.*

4.  **Ejecutar la aplicación:**
    Conecta tu dispositivo o inicia un emulador y corre:
    ```bash
    flutter run
    ```

## Estructura del Proyecto

- `lib/models/`: Modelos de datos (Player, Game) y adaptadores de Hive.
- `lib/providers/`: Gestión de estado con Riverpod (GameNotifier, HistoryNotifier, ThemeNotifier).
- `lib/views/`: Pantallas de la aplicación (Home, NewGame, Game, Results).
- `lib/main.dart`: Punto de entrada y configuración inicial.

## Tecnologías Utilizadas

- **Flutter & Dart**
- **Riverpod**: Gestión de estado.
- **Hive**: Base de datos local ligera y rápida.
- **Intl**: Formato de fechas.
