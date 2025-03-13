# StoreShoes App

Aplicación de tienda en línea para la venta de calzado, desarrollada en Flutter con integración de Firebase.

## Caracteristicas

- Registro e inicio de sesión de usuarios.
- Listado de productos con detalles.
- Integración con Firebase para la gestión de datos.
- Gestion de Inventario
- Proceso de Compra

## Requisitos previos

- Flutter SDK (versión compatible especificada en pubspec.yaml)
- Dart
- Android Studio o Visual Studio Code
- Configuración de Firebase para Android

## Estructura del proyecto

```
├── lib/
│   ├── main.dart               # Punto de entrada principal
│   ├── screens/                # Pantallas de la aplicación
│   └── firebase_options.dart   # Lógica de conexión a Firebase
├── android/                    # Configuración específica de Android
├── ios/                        # Configuración específica de iOS
├── pubspec.yaml                # Dependencias del proyecto
└── firebase.json               # Configuración de Firebase
```

## Instalacion y ejecucion

1. Clona el repositorio:
```bash
git clone https://github.com/usuario/aplication_storeshoes.git
cd aplication_storeshoes
```
2. Instala las dependencias:
```bash
flutter pub get
```
3. Configura Firebase:
- Crea un proyecto en Firebase Console.
- Descarga el archivo google-services.json y colócalo en android/app/.

4. Ejecuta la aplicación:
```bash
flutter run
```

## Funcionalidades principales

- **Inicio de sesión y registro:**: Validación de datos y autenticación con Firebase Authentication.
- **Catalogo de productos:**: Visualización de productos disponibles en la tienda.
- **Gestión de inventario:**: Administrar productos y stock.
- **Proceso de compra:**: Realizar y confirmar compras.
- **Integración con Firebase:**: Autenticación y almacenamiento en la nube.
- **Escaneo con cámara:**: Permite capturar imágenes para facilitar la gestión.
- **Gestión de usuarios:**: Diferenciación entre usuarios normales y administradores con permisos específicos.
- **Facturación:**: Genera detalles del pedido y confirma la compra realizada.
- **Pantalla de bienvenida (Splash Screen):** Introducción animada al iniciar la aplicación.
- **Confirmación de compra:**: Revisión y validación final antes de procesar la compra.

## Tecnologías utilizadas

- Flutter & Dart
- Firebase (Authentication, Firestore, Storage)

## Nota Adicionales

- Asegúrate de tener configuradas las claves de API en google-services.json.
- La aplicación está optimizada para Android, no se garantiza compatibilidad total con iOS.