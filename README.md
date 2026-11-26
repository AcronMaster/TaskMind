# 🧠 TaskMind – Gestor de Tareas con IA

Aplicación móvil de gestión de tareas desarrollada con **Flutter** que combina un almacenamiento local (SQLite) con **inteligencia artificial** (Firebase AI / Gemini) para ofrecer recomendaciones personalizadas sobre cómo priorizar las tareas pendientes.

La app permite crear, editar, completar y eliminar tareas, organizarlas por categoría, prioridad y fecha de vencimiento, y recibir consejos generados por IA para mejorar la productividad.

---

## 📋 Características principales

- ✅ **Gestión completa de tareas**:
  - Crear, editar y eliminar tareas.
  - Marcar tareas como completadas o pendientes.
  - Campos: título, descripción, categoría, prioridad y fecha de vencimiento.
- 📊 **Resumen visual**:
  - Contadores de tareas pendientes y completadas.
  - Tarjetas de resumen (`SummaryCard`).
- 🤖 **Recomendaciones con IA**:
  - La app consulta a **Firebase AI (Gemini)** para obtener un consejo breve (máximo 3 oraciones) sobre cómo priorizar las tareas pendientes.
  - El consejo se muestra en la pantalla principal.
- 🎨 **Interfaz moderna**:
  - Tema oscuro personalizado (`AppTheme.darkTheme`).
  - Tipografías con `google_fonts`.
  - Tarjetas de tareas (`TaskCard`) y resumen (`SummaryCard`).
- 🔐 **Autenticación con Firebase** (dependencia incluida, aunque el flujo de login no se detalla en el código visible).
- 💾 **Persistencia local** con SQLite (`sqflite`), lo que permite usar la app sin conexión.

---

## 🧰 Tecnologías utilizadas

| Tecnología / Paquete | Versión | Uso |
|-----------------------|---------|-----|
| **Flutter**           | SDK ^3.13.7 | Framework principal |
| **Dart**              | —       | Lenguaje |
| **sqflite**           | ^2.4.6  | Base de datos local SQLite |
| **path**              | ^1.9.1  | Manejo de rutas para la BD |
| **intl**              | ^0.20.3 | Formato de fechas |
| **google_fonts**      | ^9.0.0  | Tipografías personalizadas |
| **firebase_core**     | ^5.2.0  | Núcleo de Firebase |
| **firebase_auth**     | ^7.1.0  | Autenticación con Firebase |
| **firebase_ai**       | ^5.2.0  | IA generativa (Gemini) |
| **flutter_lints**     | ^6.0.0  | Reglas de linting |

> ⚠️ La app **requiere configuración de Firebase** (API key, project ID, etc.) para que las funciones de IA y autenticación operen correctamente.

---

## 📂 Estructura del proyecto

```
taskmind/
├── android/                  # Configuración Android
├── ios/                      # Configuración iOS
├── linux/                    # Configuración Linux
├── macos/                    # Configuración macOS
├── web/                      # Configuración Web
├── windows/                  # Configuración Windows
├── assets/                   # (posibles recursos, no visibles)
├── lib/
│   ├── database/
│   │   └── database_helper.dart   # Helper de SQLite (CRUD de tareas)
│   ├── models/
│   │   └── task.dart              # Modelo Task
│   ├── screens/
│   │   ├── home_screen.dart       # Pantalla principal
│   │   └── task_form_screen.dart  # Formulario de creación/edición
│   ├── services/
│   │   └── ai_service.dart        # Servicio de IA (Gemini)
│   ├── theme/
│   │   └── app_theme.dart         # Tema oscuro
│   ├── widgets/
│   │   ├── summary_card.dart      # Tarjeta de resumen
│   │   └── task_card.dart         # Tarjeta de tarea
│   └── main.dart                  # Punto de entrada
├── test/                     # Pruebas (posible)
├── pubspec.yaml
└── README.md
```

---

## 🗄️ Base de datos local

La app utiliza **SQLite** mediante `sqflite`. La base de datos se llama `taskminf.db` (nombre tal como aparece en el código).

### Tabla `tasks`

| Columna      | Tipo    | Descripción |
|--------------|---------|-------------|
| `id`         | INTEGER | Clave primaria autoincremental |
| `title`      | TEXT    | Título de la tarea (obligatorio) |
| `description`| TEXT    | Descripción (opcional) |
| `category`   | TEXT    | Categoría (obligatorio) |
| `priority`   | TEXT    | Prioridad (obligatorio) |
| `duaDate`    | TEXT    | Fecha de vencimiento en formato ISO 8601 (obligatorio) |
| `isComplete` | INTEGER | 0 = pendiente, 1 = completada (por defecto 0) |

> 💡 El nombre `duaDate` parece un typo de `dueDate`, pero se mantiene en el código.

---

## 🚀 Instalación y ejecución

### Requisitos previos

- **Flutter SDK** (versión compatible con Dart ^3.13.7).
- Un emulador o dispositivo físico (Android, iOS, Web, etc.).
- **Cuenta de Firebase** con un proyecto configurado (para IA y autenticación).

### Pasos

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/AcronMaster/TaskMind.git
   cd TaskMind
   ```

2. **Obtener dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).
   - Habilita **Firebase AI Logic** (Gemini) y **Authentication** (si se usa).
   - En `lib/main.dart`, reemplaza las credenciales de ejemplo:
     ```dart
     await Firebase.initializeApp(
       options: const FirebaseOptions(
         apiKey: 'TU_API_KEY',
         appId: '1:439496111766:android:b743b97bb24e624129b4b7',
         messagingSenderId: '439496111766',
         projectId: 'taskmind-e0775',
       ),
     );
     ```
     Usa los valores reales de tu proyecto.

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```
   O para una plataforma específica:
   ```bash
   flutter run -d chrome    # Web
   flutter run -d emulator-5554  # Android
   ```

5. **Compilar para producción** (opcional)
   ```bash
   flutter build apk      # Android
   flutter build ios      # iOS
   flutter build web      # Web
   ```

---

## 🖥️ Uso de la aplicación

### Pantalla principal (`HomeScreen`)

- Muestra la lista de tareas ordenadas por fecha de vencimiento ascendente.
- **Tarjetas de resumen**:
  - Total de tareas pendientes.
  - Total de tareas completadas.
- **Recomendación de IA**:
  - Si hay tareas pendientes, se consulta automáticamente a Gemini y se muestra un consejo para priorizarlas.
- **Acciones sobre tareas**:
  - Tocar una tarea para editarla.
  - Botón para marcar como completada/pendiente (`_toggleTask`).
  - Botón para eliminar con confirmación (`_deleteTask`).
- **Botón flotante** para agregar una nueva tarea.

### Formulario de tarea (`TaskFormScreen`)

- Campos: título, descripción, categoría, prioridad y fecha de vencimiento.
- Permite crear una tarea nueva o editar una existente.

### Servicio de IA (`AiService`)

- Utiliza **Firebase AI** con el modelo `gemini-3-flash-preview` (configurable).
- Genera un prompt con las tareas pendientes (título, prioridad y fecha) y pide un consejo de máximo 3 oraciones.
- Si no hay tareas pendientes, devuelve un mensaje de felicitación.

---

## 🏗️ Arquitectura

```
main.dart
 ├── Firebase.initializeApp()
 └── TaskMindApp
      └── HomeScreen (StatefulWidget)
           ├── DatabaseHelper (SQLite)
           ├── AiService (Firebase AI)
           ├── SummaryCard
           ├── TaskCard
           └── TaskFormScreen
```

### Componentes clave

| Componente | Responsabilidad |
|------------|-----------------|
| `DatabaseHelper` | Singleton que gestiona la conexión SQLite y operaciones CRUD (`insertTask`, `getTask`, `updateTask`, `deleteTask`). |
| `Task` | Modelo de datos con campos `id`, `title`, `description`, `category`, `priority`, `duaDate`, `isComplete`. |
| `AiService` | Se comunica con Firebase AI (Gemini) para generar recomendaciones. |
| `HomeScreen` | Orquesta la UI, carga tareas, gestiona estado y llama a los servicios. |
| `TaskFormScreen` | Formulario para crear/editar tareas. |
| `AppTheme` | Define el tema oscuro y estilos globales. |

---

## 📌 Notas y limitaciones

- **Firebase requerido**: la app no funcionará correctamente sin un proyecto de Firebase configurado (especialmente para `firebase_ai` y `firebase_auth`).
- **Credenciales de ejemplo**: el archivo `main.dart` contiene credenciales de ejemplo (`TU_API_KEY`); deben ser reemplazadas por las reales.
- **Nombre de BD**: el archivo se llama `taskminf.db` (posible typo).
- **Campo `duaDate`**: el modelo y la BD usan `duaDate` en lugar de `dueDate`.
- **Autenticación**: aunque `firebase_auth` está en dependencias, no se observa una pantalla de login en el código visible; podría estar en desarrollo.
- **Pruebas**: el proyecto incluye una carpeta `test/`, pero no se detallan pruebas unitarias.
- **Compatibilidad**: el proyecto incluye carpetas para Android, iOS, Web, Linux, macOS y Windows, pero no se ha verificado su funcionamiento en todas las plataformas.

---

## 👨‍💻 Autor

**Luis Adrián Cauich Dzul**  
GitHub: [@AcronMaster](https://github.com/AcronMaster)

---

## 📄 Licencia

Proyecto de uso educativo. Si deseas reutilizarlo, contacta al autor para conocer las condiciones.
