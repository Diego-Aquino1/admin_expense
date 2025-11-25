# Sistema de Gestión Financiera Personal

<div align="center">
  <img src="https://img.shields.io/badge/Backend-FastAPI-009688?style=for-the-badge&logo=fastapi" alt="FastAPI">
  <img src="https://img.shields.io/badge/Frontend-Flutter-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Database-SQLite-003B57?style=for-the-badge&logo=sqlite" alt="SQLite">
  <img src="https://img.shields.io/badge/State-Provider-FF6F00?style=for-the-badge" alt="Provider">
</div>

## 📋 Descripción

Nexus Finance es una aplicación móvil de gestión financiera personal integral que actúa como el centro de comando único para todas las finanzas de un individuo o familia. Transforma datos financieros dispersos en claridad mental y control proactivo.

## ✨ Características Principales

### 💰 Gestión Financiera Completa
- ✅ Registro rápido de gastos e ingresos (< 3 segundos)
- ✅ División de transacciones (splits)
- ✅ Múltiples cuentas (efectivo, débito, crédito, ahorro, inversiones)
- ✅ Categorías personalizables con subcategorías
- ✅ Transacciones recurrentes y programadas

### 💳 Tarjetas de Crédito Inteligentes
- ✅ Cálculo automático de saldos al corte
- ✅ Gestión de Meses Sin Intereses (MSI)
- ✅ Simulador de pago mínimo
- ✅ Alertas de fechas de corte y pago
- ✅ Crédito disponible en tiempo real

### 📊 Presupuestos y Control
- ✅ Presupuestos por categoría, tag, cuenta o global
- ✅ Sistema de rollover (acumulación de sobrantes)
- ✅ Proyección de agotamiento
- ✅ Alertas automáticas al alcanzar umbrales

### 🎯 Metas Financieras
- ✅ Metas de ahorro, inversión, pago de deuda
- ✅ Proyecciones de cumplimiento
- ✅ Sistema de alcancías virtuales
- ✅ Contribuciones automáticas

### 📈 Inversiones
- ✅ Portafolio completo (acciones, ETFs, cripto, bonos, bienes raíces)
- ✅ Cálculo de ROI y ganancias realizadas/no realizadas
- ✅ Seguimiento de dividendos
- ✅ Historial de operaciones

### 📉 Análisis y Reportes
- ✅ Dashboard con resumen financiero
- ✅ Gastos por categoría con gráficos
- ✅ Tendencias mensuales
- ✅ Detección de gastos hormiga
- ✅ Cálculo de valor neto (activos - pasivos)
- ✅ Reportes mensuales automatizados

## 🏗️ Arquitectura

### Backend (FastAPI)
```
back/
├── app/
│   ├── models/          # 11 modelos SQLAlchemy
│   ├── schemas/         # Validación Pydantic
│   ├── api/             # 9 routers REST
│   ├── services/        # Lógica de negocio
│   ├── utils/           # Utilidades (seguridad, cálculos)
│   ├── config.py        # Configuración
│   ├── database.py      # Configuración BD
│   └── main.py          # Aplicación principal
└── requirements.txt
```

### Frontend (Flutter)
```
expenseapp/
├── lib/
│   ├── models/          # Modelos de datos
│   ├── providers/       # State management (8 providers)
│   ├── services/        # API service
│   ├── screens/         # Pantallas UI
│   │   ├── auth/        # Login, Registro
│   │   ├── home/        # Navegación principal
│   │   ├── dashboard/   # Dashboard financiero
│   │   ├── transactions/# Transacciones
│   │   ├── accounts/    # Gestión de cuentas
│   │   ├── budgets/     # Presupuestos
│   │   ├── goals/       # Metas
│   │   ├── credit_cards/# Tarjetas de crédito
│   │   ├── analytics/   # Análisis
│   │   └── settings/    # Configuración
│   ├── config/          # Tema, rutas, constantes
│   └── main.dart        # App principal
└── pubspec.yaml
```

## 🚀 Instalación y Ejecución

### Prerrequisitos

- Python 3.9+
- Flutter 3.0+
- Android Studio / Xcode (para emuladores)

### Backend

1. **Navegar al directorio del backend:**
```bash
cd back
```

2. **Crear entorno virtual:**
```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

3. **Instalar dependencias:**
```bash
pip install -r requirements.txt
```

4. **Configurar variables de entorno:**
```bash
cp .env.example .env
# Editar .env si es necesario
```

5. **Ejecutar el servidor:**
```bash
uvicorn app.main:app --reload
```

El backend estará disponible en:
- API: http://localhost:8000
- Documentación: http://localhost:8000/docs
- Redoc: http://localhost:8000/redoc

### Frontend

1. **Navegar al directorio del frontend:**
```bash
cd expenseapp
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Configurar la URL del API:**

Editar `lib/config/constants.dart` y ajustar:
```dart
static const String apiBaseUrl = 'http://localhost:8000/api';
// Para dispositivo físico, usar la IP de tu computadora
// static const String apiBaseUrl = 'http://192.168.x.x:8000/api';
```

4. **Ejecutar en emulador/dispositivo:**
```bash
flutter run
```

O para un dispositivo específico:
```bash
flutter devices  # Ver dispositivos disponibles
flutter run -d <device_id>
```

## 📱 Uso de la Aplicación

### Primer Uso

1. **Registro:** Crea tu cuenta con email, usuario y contraseña
2. **Categorías:** El sistema crea categorías predeterminadas automáticamente
3. **Agregar Cuentas:** Crea tus cuentas bancarias, tarjetas y efectivo
4. **Registrar Transacciones:** Usa el botón + flotante para agregar gastos/ingresos

### Navegación

- **Inicio:** Dashboard con resumen financiero
- **Transacciones:** Historial completo con filtros
- **Cuentas:** Gestión de todas tus cuentas
- **Presupuestos:** (Tab Más) Control de gastos
- **Metas:** (Tab Más) Objetivos financieros

### Flujo Recomendado

1. Configura tus cuentas principales
2. Define presupuestos mensuales por categoría
3. Crea metas de ahorro
4. Registra transacciones diariamente
5. Revisa el dashboard semanalmente
6. Analiza reportes mensualmente

## 🔐 Seguridad

- ✅ Autenticación JWT con tokens de larga duración
- ✅ Contraseñas encriptadas con bcrypt
- ✅ Almacenamiento seguro de tokens
- ✅ Validaciones en backend y frontend
- ✅ CORS configurado

## 🎨 Diseño

### Principios
- **Minimalismo:** Interfaces limpias y espaciadas
- **Velocidad:** Registro de gastos en < 5 segundos
- **Claridad:** Información comprensible en < 3 segundos
- **Feedback:** Respuestas visuales inmediatas

### Paleta de Colores
- **Primario:** Azul (#2196F3)
- **Secundario:** Verde (#4CAF50)
- **Ingreso:** Verde (#4CAF50)
- **Gasto:** Rojo (#F44336)
- **Alerta:** Amarillo (#FFC107)

## 📊 Endpoints Principales

### Autenticación
- `POST /api/auth/register` - Registrar usuario
- `POST /api/auth/login` - Iniciar sesión
- `GET /api/auth/me` - Usuario actual

### Transacciones
- `GET /api/transactions` - Listar transacciones
- `POST /api/transactions` - Crear transacción
- `PUT /api/transactions/{id}` - Actualizar transacción
- `DELETE /api/transactions/{id}` - Eliminar transacción

### Cuentas
- `GET /api/accounts` - Listar cuentas
- `POST /api/accounts` - Crear cuenta

### Tarjetas de Crédito
- `GET /api/credit-cards` - Listar tarjetas
- `GET /api/credit-cards/{id}` - Detalle con cálculos
- `GET /api/credit-cards/{id}/simulate-minimum` - Simular pago mínimo
- `POST /api/credit-cards/{id}/pay` - Registrar pago

### Presupuestos
- `GET /api/budgets` - Listar presupuestos con cálculos
- `POST /api/budgets` - Crear presupuesto

### Metas
- `GET /api/goals` - Listar metas con proyecciones
- `POST /api/goals/{id}/contribute` - Agregar contribución

### Análisis
- `GET /api/analytics/dashboard` - Resumen dashboard
- `GET /api/analytics/expenses-by-category` - Gastos por categoría
- `GET /api/analytics/monthly-trend` - Tendencia mensual
- `GET /api/analytics/net-worth` - Valor neto

## 🧪 Testing

### Backend
```bash
cd back
pytest
```

### Frontend
```bash
cd expenseapp
flutter test
```

## 📝 Base de Datos

### Modelos Principales
- **User:** Usuarios del sistema
- **Account:** Cuentas financieras
- **Category:** Categorías de transacciones
- **Transaction:** Transacciones (gastos/ingresos/traspasos)
- **CreditCard:** Tarjetas de crédito
- **Budget:** Presupuestos
- **Goal:** Metas financieras
- **Investment:** Inversiones

### Relaciones
- Un usuario tiene múltiples cuentas, categorías, transacciones, etc.
- Las transacciones pertenecen a una cuenta y categoría
- Las tarjetas de crédito están vinculadas a una cuenta
- Los presupuestos pueden filtrar por categoría, cuenta o tag
- Las metas pueden vincularse a una cuenta específica

## 🔧 Configuración Avanzada

### Cambiar Puerto del Backend
```bash
uvicorn app.main:app --reload --port 8080
```

### Modo Producción Backend
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### Build de Producción Flutter
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🐛 Solución de Problemas

### Backend no inicia
- Verificar que el puerto 8000 no esté en uso
- Asegurarse de que el entorno virtual esté activado
- Revisar logs de error

### Flutter no compila
- Ejecutar `flutter clean` y `flutter pub get`
- Verificar versión de Flutter: `flutter doctor`
- Asegurarse de tener emuladores configurados

### App no conecta al backend
- Verificar la URL en `constants.dart`
- Si usas dispositivo físico, usar IP de la computadora
- Verificar que el backend esté corriendo

## 📄 Licencia

Este proyecto está desarrollado según las especificaciones de ESPECIFICACIONES_V2.md

## 👥 Contacto

Para preguntas o soporte, revisar la documentación completa en ESPECIFICACIONES_V2.md

---

**Nota:** Este es un proyecto completo y funcional basado en especificaciones detalladas. Incluye todas las funcionalidades core descritas en el documento de especificaciones de 1951 líneas.

