# NEXUS FINANCE — Especificación Funcional Completa v2.0

> **Documento de Producto (PRD)**  
> **Versión:** 2.0 — Edición Exhaustiva  
> **Clasificación:** Diseño Conceptual & Lógica de Negocio  
> **Enfoque:** 100% Usuario, Funcionalidad y Experiencia (Agnóstico a Tecnología)

---

# PARTE I: VISIÓN Y FUNDAMENTOS

---

## 1. Descripción General de la Aplicación

### 1.1 ¿Qué es Nexus Finance?

**Nexus Finance** es una aplicación móvil de gestión financiera personal integral que actúa como el **centro de comando único** para todas las finanzas de un individuo o familia. No es simplemente un registro de gastos: es un ecosistema inteligente que unifica cuentas bancarias, tarjetas de crédito, efectivo, inversiones, deudas y metas en una sola interfaz coherente.

La aplicación transforma datos financieros dispersos en **claridad mental y control proactivo**, permitiendo al usuario no solo saber "en qué gastó", sino predecir "qué pasará con su dinero" en las próximas semanas y meses.

### 1.2 El Problema que Resuelve

**Fragmentación Financiera:**
- Los usuarios tienen múltiples cuentas bancarias, varias tarjetas de crédito, inversiones en diferentes plataformas, deudas pendientes y metas de ahorro. Esta información vive en silos separados (apps de cada banco, hojas de Excel, notas mentales).
- Resultado: Incertidumbre constante sobre el estado real de las finanzas.

**Sorpresas en Tarjetas de Crédito:**
- Las fechas de corte, fechas de pago, intereses por pago mínimo y compras a meses sin intereses crean una complejidad que la mayoría de usuarios no domina.
- Resultado: Pagos de intereses evitables, sobreendeudamiento, estrés financiero.

**Desconexión entre Presente y Futuro:**
- Las apps tradicionales muestran lo que ya pasó, pero no proyectan el impacto de las decisiones actuales.
- Resultado: Gastos impulsivos que comprometen obligaciones futuras.

**Fricción en el Registro:**
- Registrar un gasto en la mayoría de apps requiere demasiados pasos, lo que lleva al abandono.
- Resultado: Datos incompletos, reportes inútiles, pérdida de hábito.

### 1.3 Propuesta de Valor Única

| Aspecto | Apps Tradicionales | Nexus Finance |
|---------|-------------------|---------------|
| Enfoque temporal | Retrospectivo (qué pasó) | Prospectivo (qué pasará) |
| Tarjetas de crédito | Saldo actual simple | Simulación completa de ciclos, cortes, intereses |
| Registro | Formularios largos | Entrada en 3 segundos o menos |
| Patrimonio | Solo gastos | Activos + Pasivos + Inversiones = Valor Neto |
| Inteligencia | Manual | Detección de patrones, alertas predictivas |

### 1.4 Público Objetivo

**Usuario Primario: El Profesional Consciente (25-45 años)**
- Tiene ingresos estables pero siente que "el dinero se le escapa".
- Maneja 2-4 tarjetas de crédito y no entiende completamente sus ciclos.
- Quiere ahorrar e invertir pero no sabe cuánto puede permitirse.
- Valora la estética y la simplicidad; abandona apps complicadas.

**Usuario Secundario: El Inversor Organizado (30-55 años)**
- Ya tiene control básico de gastos.
- Necesita visibilidad de su patrimonio total (activos líquidos + inversiones).
- Quiere proyecciones y simulaciones ("si ahorro X más al mes, ¿cuándo llego a mi meta?").

**Usuario Terciario: La Familia Coordinada**
- Pareja o familia que necesita visibilidad compartida.
- Presupuestos familiares, gastos de hijos, planificación conjunta.

---

## 2. Objetivos del Producto

### 2.1 Objetivo Principal (North Star Metric)

> **Reducir el tiempo de gestión financiera diaria a menos de 90 segundos, mientras se maximiza la visibilidad y control del usuario sobre su salud financiera presente y futura.**

### 2.2 Objetivos Estratégicos

| ID | Objetivo | Indicador de Éxito Conceptual |
|----|----------|------------------------------|
| O1 | Crear el hábito de registro | Usuario registra al menos 1 transacción diaria durante 30 días consecutivos |
| O2 | Eliminar sorpresas en tarjetas | Usuario conoce su "Saldo a Pagar" con 15 días de anticipación |
| O3 | Fomentar el ahorro consciente | Usuario define y avanza hacia al menos 1 meta financiera |
| O4 | Unificar la visión patrimonial | Usuario puede ver su "Valor Neto" actualizado en menos de 2 taps |
| O5 | Educar sin sermonear | Usuario comprende conceptos financieros a través de la interfaz, no de tutoriales |

### 2.3 Objetivos de Experiencia de Usuario

1. **Velocidad:** Abrir la app y registrar un gasto en menos de 5 segundos.
2. **Claridad:** Cualquier pantalla debe ser comprensible en menos de 3 segundos.
3. **Confianza:** El usuario debe sentir que sus datos están seguros y son precisos.
4. **Satisfacción:** Pequeñas recompensas visuales al completar acciones (micro-interacciones).

---

## 3. Principios de Diseño

### 3.1 Filosofía General

**"Potencia Oculta, Simplicidad Visible"**

La superficie de la aplicación es minimalista y limpia. La complejidad existe, pero está estratificada: el usuario casual ve lo esencial; el usuario avanzado puede profundizar infinitamente.

### 3.2 Principios UX

| Principio | Descripción | Ejemplo de Aplicación |
|-----------|-------------|----------------------|
| **Entrada sin Fricción** | Cada tap adicional es una barrera. Minimizar pasos. | Registro de gasto: Monto → Categoría → Listo (3 taps) |
| **Profundidad Progresiva** | La información se revela en capas. | Dashboard simple → Tap en categoría → Desglose → Transacción individual |
| **Feedback Inmediato** | Cada acción tiene respuesta visual instantánea. | Al guardar gasto, la barra de presupuesto se actualiza con animación |
| **Anticipación Inteligente** | La app predice lo que el usuario necesita. | Al abrir después de las 8pm, sugiere "¿Registrar gasto de cena?" |
| **Perdón de Errores** | Fácil deshacer, editar, corregir. | Swipe en transacción para editar/eliminar; historial de cambios |

### 3.3 Principios UI

| Principio | Descripción |
|-----------|-------------|
| **Color Semántico** | Verde = positivo/ingreso. Rojo = negativo/alerta. Amarillo = precaución. Azul = informativo/neutral. |
| **Tipografía Jerárquica** | Montos grandes y prominentes. Etiquetas secundarias sutiles. |
| **Espaciado Generoso** | Aire visual para reducir carga cognitiva. |
| **Iconografía Consistente** | Cada categoría tiene un ícono único y memorable. |
| **Modo Oscuro Nativo** | No es un "extra"; ambos modos están diseñados desde el inicio. |

### 3.4 Principios de Accesibilidad

- Contraste mínimo 4.5:1 para texto.
- Tamaños de fuente escalables según preferencias del sistema.
- Alternativas a códigos de color (íconos de apoyo para daltonismo).
- Soporte para lectores de pantalla en elementos críticos.
- Áreas táctiles mínimas de 44x44 puntos.

---

# PARTE II: FUNCIONALIDADES DETALLADAS

---

## 4. Catálogo Exhaustivo de Funcionalidades

### 4.A — Registro de Gastos e Ingresos

#### 4.A.1 Entrada Rápida (Quick Entry)

**Descripción:** Método principal de registro, optimizado para velocidad.

**Flujo:**
1. Usuario toca botón flotante "+" (siempre visible).
2. Aparece teclado numérico de pantalla completa.
3. Usuario ingresa monto.
4. Aparece carrusel horizontal de categorías frecuentes.
5. Usuario selecciona categoría.
6. Transacción guardada con fecha/hora actual y cuenta por defecto.

**Tiempo objetivo:** < 3 segundos.

**Comportamiento inteligente:**
- Si el usuario siempre registra "Café" a las 8am, esa categoría aparece primera a esa hora.
- El teclado recuerda el último monto para gastos recurrentes similares.

#### 4.A.2 Entrada Detallada (Full Entry)

**Descripción:** Formulario completo para transacciones que requieren más contexto.

**Campos disponibles:**

| Campo | Obligatorio | Descripción |
|-------|-------------|-------------|
| Monto | Sí | Valor numérico con decimales |
| Tipo | Sí | Gasto / Ingreso / Traspaso |
| Cuenta | Sí | De qué cuenta sale o entra el dinero |
| Categoría | Sí | Clasificación principal |
| Subcategoría | No | Clasificación secundaria |
| Fecha | Sí (default: hoy) | Fecha de la transacción |
| Hora | No | Hora específica |
| Comercio/Pagador | No | Nombre del establecimiento o persona |
| Notas | No | Texto libre |
| Etiquetas | No | Tags personalizados (#viaje, #trabajo) |
| Ubicación | No | GPS o entrada manual |
| Foto de recibo | No | Imagen adjunta |
| Recurrencia | No | Configurar como gasto fijo |
| Cuotas | No | Diferir en meses (para tarjetas) |
| Reembolsable | No | Marcar como gasto a recuperar |

#### 4.A.3 Entrada por Voz

**Descripción:** Dictado natural que se parsea automáticamente.

**Ejemplo de entrada:** "Gasté quinientos pesos en Uber ayer con mi Visa"

**Parseo esperado:**
- Monto: 500
- Categoría: Transporte (detectado por "Uber")
- Fecha: Ayer
- Cuenta: Visa

**Comportamiento:** Muestra preview antes de confirmar; usuario puede corregir.

#### 4.A.4 Entrada por Texto Natural (Smart Input)

**Descripción:** Campo de texto único que interpreta lenguaje natural.

**Ejemplos:**
- "Cena 800 Amex" → Gasto 800, Categoría Comida, Cuenta Amex
- "Nómina 25000" → Ingreso 25000, Categoría Salario
- "Transferí 5000 de BBVA a Efectivo" → Traspaso

#### 4.A.5 División de Transacciones (Split)

**Descripción:** Un solo pago se divide en múltiples categorías.

**Caso de uso:** Supermercado $1,500 → Alimentos $900 + Limpieza $400 + Cuidado Personal $200

**Regla:** La suma de las partes debe igualar el total original.

#### 4.A.6 Transacciones Programadas

**Descripción:** Crear transacciones que se registrarán automáticamente en el futuro.

**Opciones de recurrencia:**
- Diaria
- Semanal (día específico)
- Quincenal
- Mensual (día específico o "último día del mes")
- Bimestral
- Trimestral
- Semestral
- Anual
- Personalizada (cada X días)

**Configuración adicional:**
- Fecha de inicio
- Fecha de fin (o "indefinido")
- Monto fijo o variable (si variable, notificar para confirmar)
- Cuenta de cargo

#### 4.A.7 Plantillas de Gastos Frecuentes

**Descripción:** Accesos directos a gastos que se repiten con mismos parámetros.

**Ejemplo:** "Café Starbucks" → Toca una vez → Registra $85 en Comida con tarjeta BBVA.

**Gestión:** Usuario puede crear, editar, eliminar y reordenar plantillas.

#### 4.A.8 Importación de Transacciones

**Descripción:** Cargar histórico desde archivos externos.

**Formatos soportados conceptualmente:**
- CSV con mapeo de columnas
- Excel básico
- Exportaciones de otros gestores de gastos

---

### 4.B — Visualización Gráfica

#### 4.B.1 Gráfico de Dona Multinivel (Sunburst)

**Descripción:** Visualización circular donde el anillo interno muestra categorías principales y los anillos externos muestran subcategorías.

**Interacción:**
- Tap en segmento → Expande esa categoría.
- Tap en centro → Regresa al nivel anterior.
- Long press → Muestra tooltip con monto y porcentaje.

#### 4.B.2 Gráfico de Barras Comparativo

**Descripción:** Barras verticales u horizontales comparando periodos.

**Modos:**
- Este mes vs. mes anterior
- Últimos 6 meses
- Año actual vs. año anterior
- Comparativo por categoría

#### 4.B.3 Línea de Tendencia de Saldo

**Descripción:** Gráfico de línea que muestra la evolución del saldo a lo largo del tiempo.

**Características:**
- Línea sólida: Datos reales (histórico).
- Línea punteada: Proyección basada en gastos fijos programados.
- Marcadores: Eventos importantes (pagos de tarjeta, nómina).

#### 4.B.4 Mapa de Calor de Gastos

**Descripción:** Calendario donde cada día tiene un color según intensidad de gasto.

**Escala:** Blanco (sin gastos) → Verde claro → Amarillo → Naranja → Rojo (gasto alto).

**Interacción:** Tap en día → Lista de transacciones de ese día.

#### 4.B.5 Gráfico de Flujo de Caja (Sankey)

**Descripción:** Visualización de flujos donde se ve de dónde viene el dinero (ingresos) y hacia dónde va (categorías de gasto).

#### 4.B.6 Indicador de Velocidad de Gasto

**Descripción:** Velocímetro visual que muestra si el ritmo de gasto actual agotará el presupuesto antes de fin de mes.

**Estados:**
- Verde: "A este ritmo, te sobrarán $X"
- Amarillo: "Vas justo, cuidado los últimos días"
- Rojo: "Te quedarás sin presupuesto el día X"

#### 4.B.7 Gráfico de Patrimonio Neto Histórico

**Descripción:** Línea de tiempo mostrando la evolución del Valor Neto (Activos - Pasivos).

**Desglose opcional:** Apilar áreas para ver composición (efectivo, inversiones, deudas).

---

### 4.C — Control de Tarjetas de Crédito (Módulo Core)

#### 4.C.1 Configuración de Tarjeta

**Datos requeridos por tarjeta:**

| Campo | Descripción |
|-------|-------------|
| Nombre personalizado | "Visa Oro BBVA", "Amex Platino" |
| Últimos 4 dígitos | Para identificación visual |
| Línea de crédito total | Monto máximo autorizado |
| Día de corte | Día del mes (1-28) en que cierra el periodo |
| Día límite de pago | Día del mes para pagar sin intereses |
| Tasa de interés anual | Para cálculo de intereses por pago mínimo |
| Porcentaje de pago mínimo | Típicamente 5-10% del saldo |
| Color/Ícono | Personalización visual |

#### 4.C.2 Estados de la Tarjeta

**Visualización de barra segmentada:**

```
[███████████░░░░░░░░░░░░░░] 
 Saldo Corte | Post-Corte | Disponible
   $8,000    |   $2,500   |   $9,500
```

**Definiciones:**
- **Saldo al Corte:** Lo que se debe pagar antes de la fecha límite (periodo cerrado).
- **Consumos Post-Corte:** Gastos después del corte; se pagarán el mes siguiente.
- **Disponible Real:** Línea total - Saldo Corte - Post-Corte.

#### 4.C.3 Gestión de Compras a Meses Sin Intereses (MSI)

**Flujo de registro:**
1. Usuario registra gasto con tarjeta.
2. Activa toggle "Diferir pago".
3. Selecciona número de cuotas (3, 6, 9, 12, 18, 24 meses).
4. Sistema calcula monto por cuota.

**Comportamiento del sistema:**
- Crea la primera cuota en el periodo actual.
- Programa cuotas futuras en los días de corte correspondientes.
- Reduce el crédito disponible por el monto TOTAL inmediatamente.
- En reportes de "Gastos del Mes", solo suma la cuota del mes, no el total.
- Mantiene registro de "Deuda Diferida Total" por separado.

**Visualización:**
- Lista de compras diferidas activas.
- Cuotas restantes por cada una.
- Proyección de cuánto se pagará en cada mes futuro por MSI.

#### 4.C.4 Simulador de Pago Mínimo

**Descripción:** Si el usuario indica que pagará solo el mínimo, el sistema calcula:
- Interés que se generará.
- Nuevo saldo proyectado para el siguiente mes.
- Tiempo estimado para liquidar la deuda pagando solo mínimos.

**Alerta:** Notificación educativa sobre el costo real de pagar mínimos.

#### 4.C.5 Calendario de Tarjetas

**Descripción:** Vista de calendario mostrando:
- Días de corte de cada tarjeta (marcados con color de la tarjeta).
- Días límite de pago.
- Alertas 3 días antes de cada fecha límite.

#### 4.C.6 Registro de Pago de Tarjeta

**Descripción:** Acción especial que NO es un gasto, sino un traspaso.

**Flujo:**
1. Usuario selecciona "Pagar Tarjeta".
2. Selecciona tarjeta a pagar.
3. Sistema muestra opciones: Pago Total / Pago Mínimo / Monto Personalizado.
4. Usuario confirma cuenta de origen (banco).
5. Sistema registra traspaso: Banco → Tarjeta.

**Efecto:**
- Reduce saldo de cuenta bancaria.
- Reduce deuda de tarjeta.
- NO afecta reportes de gastos por categoría (el gasto ya se registró cuando se hizo la compra).

#### 4.C.7 Promociones y Beneficios (Opcional Avanzado)

**Descripción:** Registro de promociones activas por tarjeta.
- "10% de bonificación en restaurantes este mes"
- "MSI en tiendas departamentales"

**Uso:** Sugerencias al momento de registrar gasto ("Esta compra califica para MSI con tu Amex").

---

### 4.D — Gastos Fijos y Suscripciones

#### 4.D.1 Catálogo de Gastos Fijos

**Tipos:**
- **Fijos Obligatorios:** Renta, hipoteca, servicios básicos.
- **Fijos Discrecionales:** Gimnasio, streaming, suscripciones.
- **Variables Estimados:** Gasolina, supermercado (monto promedio).

**Datos por gasto fijo:**

| Campo | Descripción |
|-------|-------------|
| Nombre | "Netflix", "Renta departamento" |
| Monto | Cantidad (fija o estimada) |
| Frecuencia | Mensual, anual, etc. |
| Día de cargo | Día del mes |
| Cuenta de cargo | Tarjeta o cuenta |
| Categoría | Para reportes |
| Recordatorio | Días antes para alertar |
| Auto-registro | ¿Registrar automáticamente o solo recordar? |

#### 4.D.2 Detector de Suscripciones

**Descripción:** Análisis del historial para identificar patrones recurrentes.

**Ejemplo:** "Detectamos un cargo de $199 a 'Spotify' cada día 15. ¿Deseas agregarlo como suscripción?"

#### 4.D.3 Vista de Suscripciones Activas

**Información mostrada:**
- Lista de suscripciones con logo/ícono.
- Monto mensual y anual acumulado.
- Próxima fecha de renovación.
- Días para cancelar (si aplica periodo de prueba).

**Cálculo destacado:** "Gastas $2,500/mes en suscripciones = $30,000/año"

#### 4.D.4 Calendario de Obligaciones

**Descripción:** Vista de calendario mostrando solo pagos obligatorios futuros.

**Incluye:**
- Gastos fijos programados.
- Cuotas de MSI.
- Pagos de tarjetas.
- Fechas de vencimiento de servicios.

---

### 4.E — Inversiones

#### 4.E.1 Portafolio de Inversiones

**Tipos de activos soportados:**
- Acciones (individuales o ETFs)
- Fondos de inversión
- Criptomonedas
- Bonos / CETES / Instrumentos de deuda
- Bienes raíces (valor estimado)
- Otros activos (arte, coleccionables, etc.)

#### 4.E.2 Registro de Inversión

**Datos por activo:**

| Campo | Descripción |
|-------|-------------|
| Nombre/Ticker | "AAPL", "Bitcoin", "Departamento Centro" |
| Tipo de activo | Categorización |
| Fecha de compra | Cuándo se adquirió |
| Cantidad | Unidades, acciones, m² |
| Precio de compra unitario | Costo por unidad |
| Precio actual | Manual o (conceptualmente) actualizable |
| Cuenta/Broker | Dónde está custodiado |
| Notas | Información adicional |

#### 4.E.3 Cálculos Automáticos

- **Valor de Mercado:** Cantidad × Precio Actual
- **Costo Base:** Cantidad × Precio de Compra
- **Ganancia/Pérdida No Realizada:** Valor de Mercado - Costo Base
- **Rendimiento Porcentual:** (Ganancia / Costo Base) × 100
- **Ganancia Realizada:** Cuando se vende, diferencia entre venta y costo

#### 4.E.4 Vista de Portafolio

**Elementos:**
- Valor total del portafolio.
- Desglose por tipo de activo (gráfico de dona).
- Lista de activos ordenable por: valor, rendimiento, fecha.
- Indicadores de ganancia/pérdida con color semántico.

#### 4.E.5 Registro de Dividendos/Rendimientos

**Descripción:** Ingresos pasivos generados por inversiones.

**Flujo:** Se registran como ingreso especial vinculado al activo que lo generó.

#### 4.E.6 Historial de Operaciones

**Registro de:**
- Compras
- Ventas
- Dividendos recibidos
- Splits / Ajustes

---

### 4.F — Presupuestos

#### 4.F.1 Tipos de Presupuesto

| Tipo | Descripción |
|------|-------------|
| Por Categoría | "Máximo $5,000 en Comida este mes" |
| Por Etiqueta | "Máximo $3,000 en gastos con #trabajo" |
| Global | "Máximo $25,000 en gastos totales" |
| Por Cuenta | "Máximo $2,000 con tarjeta X" |

#### 4.F.2 Configuración de Presupuesto

**Campos:**

| Campo | Descripción |
|-------|-------------|
| Nombre | Identificador |
| Tipo | Categoría/Etiqueta/Global/Cuenta |
| Monto límite | Cantidad máxima |
| Periodo | Semanal / Quincenal / Mensual / Anual |
| Día de inicio | Para periodos personalizados |
| Rollover | ¿El sobrante se acumula al siguiente periodo? |
| Alerta temprana | Notificar al llegar a X% |

#### 4.F.3 Visualización de Presupuesto

**Barra de progreso:**
```
Comida: ████████░░░░░░░░ $4,200 / $5,000 (84%)
        ▲ Ritmo: Agotarás el día 25
```

**Estados visuales:**
- 0-70%: Verde (en control)
- 70-90%: Amarillo (precaución)
- 90-100%: Naranja (casi agotado)
- >100%: Rojo (excedido)

#### 4.F.4 Presupuesto con Rollover

**Descripción:** El monto no gastado se suma al siguiente periodo.

**Ejemplo:**
- Enero: Presupuesto $5,000, Gastado $4,200, Sobrante $800
- Febrero: Presupuesto base $5,000 + Rollover $800 = $5,800 disponibles

**Configuración:** Límite máximo de acumulación (ej. máximo 2 meses).

#### 4.F.5 Presupuesto Flexible/Dinámico

**Descripción:** El presupuesto se ajusta automáticamente según ingresos.

**Ejemplo:** "Destinar 30% de mis ingresos a Gastos Variables"
- Si ingreso $30,000 → Presupuesto = $9,000
- Si ingreso $25,000 → Presupuesto = $7,500

---

### 4.G — Metas Financieras

#### 4.G.1 Tipos de Metas

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| Ahorro | Acumular cantidad específica | "Ahorrar $50,000 para viaje" |
| Pago de Deuda | Liquidar un pasivo | "Pagar tarjeta Amex" |
| Inversión | Alcanzar monto invertido | "Tener $100,000 en acciones" |
| Patrimonio | Valor neto objetivo | "Patrimonio de $1,000,000" |

#### 4.G.2 Configuración de Meta

**Campos:**

| Campo | Descripción |
|-------|-------------|
| Nombre | "Viaje a Europa" |
| Tipo | Ahorro/Deuda/Inversión/Patrimonio |
| Monto objetivo | Cantidad a alcanzar |
| Fecha límite | Cuándo quiero lograrlo (opcional) |
| Monto inicial | Si ya hay avance previo |
| Cuenta vinculada | Dónde se "aparta" el dinero |
| Contribución automática | Monto periódico a destinar |
| Prioridad | Alta/Media/Baja |
| Ícono/Color | Personalización |

#### 4.G.3 Alcancías Virtuales

**Descripción:** El dinero "apartado" para una meta se resta del "Saldo Disponible para Gastar".

**Ejemplo:**
- Saldo en banco: $50,000
- Meta "Viaje" con $20,000 apartados
- Saldo Disponible Real: $30,000

**Importante:** El dinero no se mueve físicamente; es una separación lógica/mental.

#### 4.G.4 Proyección de Meta

**Cálculos mostrados:**
- Progreso actual: $20,000 de $50,000 (40%)
- Ritmo actual de ahorro: $3,000/mes
- Tiempo estimado para completar: 10 meses
- Fecha proyectada: Marzo 2026
- Para cumplir en fecha límite: Necesitas ahorrar $4,500/mes

#### 4.G.5 Contribuciones a Meta

**Métodos:**
- **Manual:** Usuario registra aportación.
- **Automática:** Cada quincena, transferir $X a la meta.
- **Redondeo:** Redondear gastos al siguiente $10 y destinar diferencia a meta.

---

### 4.H — Reportes y Análisis

#### 4.H.1 Reporte Mensual Automático

**Contenido:**
- Resumen de ingresos vs. gastos
- Top 5 categorías de gasto
- Comparativo con mes anterior
- Estado de presupuestos
- Avance en metas
- Próximos pagos importantes
- "Insights" destacados

**Entrega:** Notificación el día 1 de cada mes con acceso al reporte.

#### 4.H.2 Análisis de Tendencias

**Visualizaciones:**
- Evolución de gasto por categoría (últimos 6-12 meses)
- Estacionalidad (¿gasto más en diciembre?)
- Promedio móvil de gastos

#### 4.H.3 Reporte de "Fugas" (Gastos Hormiga)

**Descripción:** Identificación de pequeños gastos frecuentes que suman cantidades significativas.

**Ejemplo:** "Gastaste $3,200 en cafés este mes (45 transacciones promedio $71)"

#### 4.H.4 Comparativo de Periodos

**Opciones:**
- Este mes vs. mes anterior
- Este mes vs. mismo mes año anterior
- Este trimestre vs. trimestre anterior
- Este año vs. año anterior
- Periodo personalizado vs. periodo personalizado

#### 4.H.5 Reporte de Valor Neto

**Contenido:**
- Valor Neto actual (Activos - Pasivos)
- Composición de activos (efectivo, inversiones, propiedades)
- Composición de pasivos (tarjetas, préstamos)
- Evolución histórica del Valor Neto
- Proyección a 1 año si se mantiene el ritmo actual

#### 4.H.6 Exportación de Reportes

**Formatos:**
- PDF (visual, para imprimir o compartir)
- CSV (datos crudos para análisis externo)
- Excel (tablas formateadas)

**Alcance:** Seleccionar rango de fechas y tipos de datos a incluir.

---

### 4.I — Alertas y Recordatorios

#### 4.I.1 Tipos de Alertas

| Categoría | Alerta | Momento |
|-----------|--------|---------|
| Tarjetas | Fecha de corte próxima | 3 días antes |
| Tarjetas | Fecha límite de pago | 5 días antes, 1 día antes |
| Tarjetas | Crédito disponible bajo | Al superar 80% de uso |
| Presupuestos | Presupuesto al 80% | Al alcanzar umbral |
| Presupuestos | Presupuesto excedido | Al superar 100% |
| Gastos Fijos | Cargo próximo | 2 días antes |
| Metas | Contribución pendiente | Según frecuencia configurada |
| Metas | Meta alcanzada | Al completar |
| General | Resumen semanal | Domingo por la noche |
| General | No has registrado hoy | 8pm si no hay transacciones |
| Inversiones | Variación significativa | Si un activo sube/baja >5% |

#### 4.I.2 Configuración de Notificaciones

**Por tipo de alerta:**
- Activar/desactivar
- Hora preferida de entrega
- Días de anticipación
- Canal (push, email, ambos)

#### 4.I.3 Recordatorios Personalizados

**Descripción:** Usuario puede crear recordatorios propios.

**Ejemplo:** "Recordarme revisar inversiones cada viernes a las 6pm"

---

### 4.J — Filtros Avanzados

#### 4.J.1 Criterios de Filtrado

| Criterio | Opciones |
|----------|----------|
| Fecha | Rango personalizado, Hoy, Esta semana, Este mes, Este año |
| Tipo | Gasto, Ingreso, Traspaso |
| Cuenta | Una o varias cuentas |
| Categoría | Una o varias categorías |
| Subcategoría | Nivel secundario |
| Etiquetas | Una o varias tags |
| Monto | Rango (mínimo - máximo) |
| Comercio | Nombre contiene... |
| Notas | Texto contiene... |
| Ubicación | Radio desde punto |
| Recurrente | Sí / No |
| Con foto | Sí / No |
| Reembolsable | Sí / No / Pendiente / Cobrado |

#### 4.J.2 Combinación de Filtros

**Operadores:**
- Y (AND): Todos los criterios deben cumplirse
- O (OR): Al menos un criterio debe cumplirse

**Ejemplo:** "Gastos en Comida O Entretenimiento, mayores a $500, de este mes"

#### 4.J.3 Filtros Guardados

**Descripción:** Guardar combinaciones frecuentes para acceso rápido.

**Ejemplos predefinidos:**
- "Gastos de trabajo" (etiqueta #trabajo)
- "Compras grandes" (monto > $1,000)
- "Hormiga" (monto < $100)

#### 4.J.4 Búsqueda Global

**Descripción:** Campo de búsqueda que busca en:
- Notas de transacciones
- Nombres de comercios
- Montos (búsqueda exacta)
- Nombres de cuentas
- Nombres de categorías

---

### 4.K — Perfiles, Preferencias y Personalización

#### 4.K.1 Configuración de Perfil

**Datos:**
- Nombre (opcional, para personalización)
- Moneda base
- Formato de fecha preferido
- Primer día de la semana (para reportes)
- Día de inicio de mes financiero (si es diferente al 1)

#### 4.K.2 Gestión de Categorías

**Acciones:**
- Crear categorías personalizadas
- Crear subcategorías
- Editar nombre, ícono, color
- Reordenar categorías
- Ocultar categorías no usadas
- Fusionar categorías (reasignar transacciones)

**Categorías predeterminadas sugeridas:**
- Alimentación (Supermercado, Restaurantes, Café, Delivery)
- Transporte (Gasolina, Uber/Taxi, Transporte Público, Estacionamiento)
- Hogar (Renta/Hipoteca, Servicios, Mantenimiento, Muebles)
- Entretenimiento (Streaming, Salidas, Hobbies, Viajes)
- Salud (Médicos, Medicinas, Gimnasio, Bienestar)
- Educación (Cursos, Libros, Materiales)
- Ropa y Accesorios
- Tecnología (Gadgets, Apps, Servicios digitales)
- Finanzas (Comisiones, Intereses, Seguros)
- Regalos y Donaciones
- Mascotas
- Otros

#### 4.K.3 Gestión de Cuentas

**Tipos de cuenta:**
- Efectivo
- Cuenta de débito
- Tarjeta de crédito
- Cuenta de ahorro
- Inversiones
- Préstamo (pasivo)
- Cuenta por cobrar (activo temporal)

**Acciones:**
- Crear, editar, archivar (no eliminar para preservar histórico)
- Definir cuenta por defecto
- Ordenar cuentas
- Asignar color/ícono

#### 4.K.4 Temas y Apariencia

**Opciones:**
- Modo claro / Modo oscuro / Automático (según sistema)
- Acento de color (color principal de la app)
- Densidad de información (compacto / normal / espaciado)

#### 4.K.5 Privacidad y Seguridad

**Opciones:**
- Bloqueo de app (PIN, biométrico)
- Tiempo de auto-bloqueo
- Ocultar montos (modo discreto)
- Borrar datos al desinstalar

#### 4.K.6 Datos y Respaldo

**Opciones:**
- Exportar todos los datos
- Importar respaldo
- Frecuencia de respaldo automático
- Ubicación de respaldo (local, nube personal)

---

### 4.L — Funcionalidades Innovadoras

#### 4.L.1 "¿Puedo Gastar Esto?"

**Descripción:** Antes de una compra, el usuario ingresa un monto y la app responde si es viable.

**Análisis:**
- ¿Hay saldo disponible?
- ¿Afecta algún presupuesto crítico?
- ¿Compromete el pago de tarjetas del mes?
- ¿Impacta alguna meta de ahorro?

**Respuesta:** "Sí, puedes gastar $3,000. Tu saldo disponible real quedará en $8,500 y no afectarás tus presupuestos."

#### 4.L.2 Modo Viaje

**Descripción:** Configuración temporal para viajes.

**Características:**
- Moneda secundaria activa
- Tipo de cambio del momento
- Presupuesto específico del viaje
- Etiqueta automática #viaje en todos los gastos
- Resumen al finalizar el viaje

#### 4.L.3 Retos Financieros

**Descripción:** Desafíos gamificados para mejorar hábitos.

**Ejemplos:**
- "Semana sin delivery"
- "30 días registrando todos los gastos"
- "Reducir categoría X en 20%"

**Recompensa:** Badges, estadísticas de logros.

#### 4.L.4 Comparador de Decisiones

**Descripción:** Simular el impacto de decisiones financieras.

**Ejemplo:** "¿Qué pasa si cancelo Netflix y Spotify?"
- Ahorro mensual: $350
- Ahorro anual: $4,200
- Impacto en meta "Viaje": Llegarías 2 meses antes

#### 4.L.5 Detección de Anomalías

**Descripción:** Alertas cuando algo parece inusual.

**Ejemplos:**
- "Gastaste 3x más en Transporte esta semana vs. tu promedio"
- "Detectamos un cargo de $5,000 en una categoría que nunca usas"
- "Llevas 5 días sin registrar gastos, ¿todo bien?"

#### 4.L.6 Asistente de Conciliación

**Descripción:** Ayuda para cuadrar saldos con la realidad.

**Flujo:**
1. Usuario indica: "Mi banco dice que tengo $15,000"
2. App muestra: "Según tus registros, deberías tener $15,340"
3. Diferencia: $340
4. Opciones: Crear ajuste / Buscar transacción faltante / Ignorar

#### 4.L.7 Modo Compartido (Futuro)

**Descripción:** Cuentas o presupuestos compartidos entre usuarios.

**Casos de uso:**
- Pareja con gastos comunes
- Familia con presupuesto compartido
- Roommates dividiendo servicios

---

# PARTE III: EXPERIENCIA DE USUARIO

---

## 5. Flujo Completo del Usuario

### 5.1 Onboarding (Primera Vez)

**Pantalla 1: Bienvenida**
- Mensaje: "Bienvenido a Nexus Finance. Vamos a configurar tu centro de control financiero."
- Acción: Continuar

**Pantalla 2: Moneda Base**
- Pregunta: "¿Cuál es tu moneda principal?"
- Selector de moneda con banderas
- Nota: "Podrás agregar otras monedas después"

**Pantalla 3: Cuentas Iniciales**
- Mensaje: "¿Con qué cuentas manejas tu dinero?"
- Lista de sugerencias: Efectivo, Cuenta Bancaria, Tarjeta de Crédito
- Usuario puede agregar múltiples, saltarse o personalizar
- Para cada cuenta: Nombre y Saldo Inicial

**Pantalla 4: Configuración de Tarjetas (si aplica)**
- Mensaje: "Las tarjetas de crédito tienen fechas importantes. Configurarlas bien te evitará sorpresas."
- Por cada tarjeta: Día de corte, Día de pago, Línea de crédito
- Ayuda contextual: "¿Dónde encuentro esta información?"

**Pantalla 5: Categorías**
- Mensaje: "Usamos estas categorías para organizar tus gastos. Puedes personalizarlas cuando quieras."
- Vista de categorías predeterminadas
- Opción: Usar estas / Personalizar ahora

**Pantalla 6: Notificaciones**
- Mensaje: "¿Quieres que te avisemos de fechas importantes?"
- Toggle para activar notificaciones
- Breve lista de qué notificaremos

**Pantalla 7: Listo**
- Mensaje: "¡Todo configurado! Registra tu primer gasto."
- Botón prominente: "Registrar Gasto"
- Enlace secundario: "Explorar la app primero"

### 5.2 Ciclo Diario (Uso Regular)

**Mañana (Opcional):**
- Notificación suave: "Buenos días. Tu saldo disponible es $X."

**Durante el día:**
1. Usuario hace una compra.
2. Abre app (o usa widget/atajo).
3. Toca "+" → Ingresa monto → Selecciona categoría → Listo.
4. Tiempo total: 3-5 segundos.

**Noche:**
- Si no ha registrado nada: "¿Día sin gastos? Genial. ¿O se te olvidó registrar algo?"
- Si registró: Silencio (no molestar).

### 5.3 Ciclo Semanal

**Domingo por la noche:**
- Notificación: "Resumen semanal disponible"
- Contenido: Gastaste $X esta semana. Top categorías. Comparativo con semana anterior.

### 5.4 Ciclo Mensual

**Día 1 del mes:**
- Reporte mensual completo disponible.
- Reseteo de presupuestos (o rollover si está configurado).

**Días previos a cortes de tarjeta:**
- Alertas de corte inminente.
- Información de saldo a pagar.

**Días previos a fechas límite de pago:**
- Recordatorio de pago.
- Acceso directo a "Registrar Pago de Tarjeta".

### 5.5 Uso Avanzado

**Análisis profundo:**
- Usuario entra a sección de Análisis.
- Aplica filtros: "Últimos 6 meses, solo categoría Entretenimiento".
- Ve tendencia, identifica que gasta más en diciembre.
- Decide crear presupuesto especial para diciembre próximo.

**Planificación:**
- Usuario crea meta: "Fondo de emergencia $100,000".
- Configura aportación automática de $5,000/mes.
- Revisa proyección: "Completarás en 20 meses".

**Simulación:**
- Usuario pregunta: "¿Puedo comprar una laptop de $25,000?"
- App analiza: "Sí, pero retrasará tu meta 'Viaje' por 3 meses. ¿Proceder?"

---

## 6. Casos de Uso Detallados

### Caso de Uso 1: Registro de Compra en Supermercado con División

**Actor:** María, usuaria regular.

**Contexto:** María compra en el supermercado y paga $2,500 con su tarjeta de débito. La compra incluye alimentos, productos de limpieza y un regalo de cumpleaños.

**Flujo:**
1. María abre Nexus Finance.
2. Toca el botón "+".
3. Ingresa "2500" en el teclado numérico.
4. En lugar de seleccionar una categoría, toca "Dividir".
5. Aparece interfaz de división:
   - Agrega línea: $1,800 → Alimentación > Supermercado
   - Agrega línea: $400 → Hogar > Limpieza
   - Agrega línea: $300 → Regalos
6. El sistema valida que la suma ($2,500) coincide con el total.
7. María confirma.
8. Se crean 3 transacciones vinculadas, todas con la misma fecha/hora y referencia al pago original.

**Resultado:** Los reportes muestran correctamente el desglose por categoría, no un solo bloque de "Supermercado".

---

### Caso de Uso 2: Compra a 12 Meses Sin Intereses

**Actor:** Carlos, usuario con tarjeta de crédito.

**Contexto:** Carlos compra una televisión de $18,000 a 12 MSI con su tarjeta Visa.

**Flujo:**
1. Carlos registra gasto de $18,000.
2. Selecciona cuenta "Visa Platinum".
3. Activa toggle "Pago diferido".
4. Selecciona "12 meses sin intereses".
5. Sistema muestra: "Se registrarán 12 cuotas de $1,500".
6. Carlos confirma.

**Resultado en el sistema:**
- Se crea transacción de $1,500 en el periodo actual (categoría: Electrónica).
- Se programan 11 transacciones futuras de $1,500 cada una, en los días de corte de los siguientes 11 meses.
- El crédito disponible de la tarjeta se reduce en $18,000 inmediatamente.
- En "Deuda Diferida" aparece: "TV Samsung - 11 cuotas restantes - $16,500 pendiente".

**Visualización mensual:**
- Enero (actual): Gastos del mes incluyen $1,500 de la TV.
- Febrero a Diciembre: Cada mes incluirá automáticamente $1,500.

---

### Caso de Uso 3: Viaje de Negocios con Gastos Reembolsables

**Actor:** Ana, empleada que viaja por trabajo.

**Contexto:** Ana viaja a una conferencia. Paga hotel ($5,000), comidas ($1,200) y transporte ($800) con su tarjeta personal. La empresa le reembolsará todo.

**Flujo de registro:**
1. Por cada gasto, Ana:
   - Registra el monto y categoría normalmente.
   - Activa checkbox "Gasto reembolsable".
   - Opcionalmente, selecciona "Pagador: Empresa XYZ".
   - Toma foto del recibo.

**Resultado en el sistema:**
- Los gastos se registran en la tarjeta (aumentan la deuda real).
- Los gastos NO se descuentan de los presupuestos personales de Ana.
- Se crea una "Cuenta por Cobrar" temporal con saldo de $7,000.
- En el dashboard, Ana ve: "Tienes $7,000 por cobrar de Empresa XYZ".

**Flujo de reembolso (2 semanas después):**
1. Ana recibe transferencia de $7,000 de la empresa.
2. En Nexus, registra: Tipo "Traspaso", De "Empresa XYZ (por cobrar)", A "Banco BBVA".
3. Sistema cierra la cuenta por cobrar.

**Resultado final:**
- El dinero entró al banco de Ana.
- No se registró como "Ingreso" (porque no es ganancia, es recuperación).
- Los reportes de gastos personales no fueron afectados.
- La deuda de la tarjeta sigue ahí hasta que Ana la pague (otro traspaso).

---

### Caso de Uso 4: Pago de Tarjeta de Crédito

**Actor:** Roberto, usuario con múltiples tarjetas.

**Contexto:** Es día 18, fecha límite de pago de su tarjeta BBVA. El saldo al corte es $12,500.

**Flujo:**
1. Roberto recibe notificación: "Hoy vence el pago de BBVA. Saldo: $12,500".
2. Abre la app, va a la tarjeta BBVA.
3. Toca "Pagar Tarjeta".
4. Sistema muestra opciones:
   - Pago Total: $12,500
   - Pago Mínimo: $625 (5%)
   - Pago Personalizado: [____]
5. Roberto selecciona "Pago Total".
6. Selecciona cuenta de origen: "BBVA Débito".
7. Confirma.

**Resultado:**
- Se registra TRASPASO de $12,500 de "BBVA Débito" a "BBVA Crédito".
- Saldo de cuenta débito: -$12,500.
- Saldo de tarjeta crédito: -$12,500 (deuda reducida).
- NO se afectan categorías de gasto (esos gastos ya se registraron cuando se hicieron las compras).
- Estado de tarjeta: "Saldo al Corte: $0. Consumos post-corte: $X".

---

### Caso de Uso 5: Creación y Seguimiento de Meta de Ahorro

**Actor:** Lucía, usuaria que quiere viajar.

**Contexto:** Lucía quiere ahorrar $80,000 para un viaje a Europa en 18 meses.

**Flujo de creación:**
1. Lucía va a "Metas" → "Nueva Meta".
2. Nombre: "Viaje Europa 2027"
3. Monto objetivo: $80,000
4. Fecha límite: Junio 2027 (18 meses)
5. Monto inicial: $5,000 (ya tiene algo ahorrado)
6. Contribución automática: $4,500/mes (calculado para llegar a tiempo)
7. Cuenta vinculada: "Cuenta de Ahorro BBVA"
8. Confirma.

**Resultado inmediato:**
- Meta creada con 6.25% de progreso ($5,000 de $80,000).
- Saldo disponible de Lucía se reduce en $5,000 (apartado mentalmente).
- Proyección: "Al ritmo actual, completarás en Junio 2027".

**Flujo mensual:**
- Cada mes, Lucía recibe recordatorio de aportar $4,500.
- Puede registrar la aportación manualmente o configurar que sea automática.
- El progreso se actualiza visualmente.

**Escenario variable:**
- En mes 6, Lucía solo puede aportar $2,000.
- Sistema recalcula: "Para llegar a tiempo, ahora necesitas $5,100/mes los próximos 12 meses".
- Lucía puede ajustar fecha límite o monto objetivo.

---

### Caso de Uso 6: Análisis de Gastos Hormiga

**Actor:** Pedro, usuario que siente que "el dinero se le va".

**Contexto:** Pedro quiere entender por qué nunca le alcanza el dinero.

**Flujo:**
1. Pedro va a "Análisis" → "Reporte de Fugas".
2. Sistema analiza últimos 3 meses.
3. Presenta hallazgos:
   - "Cafés y snacks: $4,200/mes (62 transacciones, promedio $68)"
   - "Delivery de comida: $3,800/mes (18 transacciones, promedio $211)"
   - "Suscripciones activas: $1,890/mes"
   - "Comisiones bancarias: $450/mes"
4. Total de "fugas": $10,340/mes = $124,080/año
5. Sistema sugiere: "Si redujeras cafés a la mitad y cocinaras 2 veces más por semana, ahorrarías ~$5,000/mes".

**Acción de Pedro:**
- Crea presupuesto de $2,000 para "Café y Snacks".
- Crea reto: "2 semanas sin delivery".
- Revisa suscripciones y cancela 2 que no usa.

---

### Caso de Uso 7: Devolución de Compra en Mes Posterior

**Actor:** Sofía, usuaria que devuelve un producto.

**Contexto:** Sofía compró zapatos de $2,500 en Enero con tarjeta. En Febrero, los devuelve y le hacen reembolso a la tarjeta.

**Flujo:**
1. Sofía va al gasto original de Enero.
2. Toca "Opciones" → "Registrar Devolución".
3. Ingresa monto devuelto: $2,500 (puede ser parcial).
4. Fecha de devolución: 15 de Febrero.
5. Confirma.

**Resultado:**
- Se crea un "gasto negativo" de -$2,500 en la categoría "Ropa" con fecha de Febrero.
- El reporte de Febrero muestra: Ropa: -$2,500 (o se resta de otros gastos de ropa).
- La deuda de la tarjeta se reduce en $2,500.
- El gasto original de Enero queda marcado como "Devuelto" pero no se modifica (preserva historia).

**Alternativa (si no encuentra el gasto original):**
- Sofía registra ingreso de $2,500 tipo "Reembolso/Devolución" en la tarjeta.
- Categoría: Ropa (para que reste del acumulado de esa categoría).

---

# PARTE IV: ESPECIFICACIONES TÉCNICAS CONCEPTUALES

---

## 7. Requerimientos Funcionales

### Gestión de Cuentas

| ID | Requerimiento |
|----|---------------|
| RF-001 | El sistema debe permitir crear cuentas de tipo: Efectivo, Débito, Crédito, Ahorro, Inversión, Préstamo, Por Cobrar. |
| RF-002 | El sistema debe permitir definir un saldo inicial para cada cuenta al momento de crearla. |
| RF-003 | El sistema debe calcular automáticamente el saldo actual de cada cuenta basándose en el saldo inicial más/menos todas las transacciones. |
| RF-004 | El sistema debe permitir archivar cuentas sin eliminarlas, preservando el historial de transacciones. |
| RF-005 | El sistema debe permitir definir una cuenta por defecto para nuevas transacciones. |
| RF-006 | El sistema debe soportar múltiples monedas, con una moneda base definida por el usuario. |
| RF-007 | El sistema debe almacenar el tipo de cambio utilizado en cada transacción en moneda extranjera. |

### Transacciones

| ID | Requerimiento |
|----|---------------|
| RF-010 | El sistema debe soportar tres tipos de transacción: Gasto, Ingreso, Traspaso. |
| RF-011 | Cada transacción debe tener obligatoriamente: monto, tipo, cuenta, categoría, fecha. |
| RF-012 | El sistema debe permitir campos opcionales: subcategoría, comercio, notas, etiquetas, ubicación, foto, hora. |
| RF-013 | El sistema debe permitir dividir una transacción en múltiples categorías, validando que la suma iguale el total. |
| RF-014 | El sistema debe permitir marcar transacciones como "reembolsables" y gestionar su ciclo de vida hasta el cobro. |
| RF-015 | El sistema debe permitir programar transacciones recurrentes con frecuencias: diaria, semanal, quincenal, mensual, bimestral, trimestral, semestral, anual, personalizada. |
| RF-016 | El sistema debe permitir editar cualquier campo de una transacción después de creada. |
| RF-017 | El sistema debe permitir eliminar transacciones con confirmación. |
| RF-018 | El sistema debe registrar la fecha/hora de creación y última modificación de cada transacción. |

### Tarjetas de Crédito

| ID | Requerimiento |
|----|---------------|
| RF-020 | Para cuentas tipo Crédito, el sistema debe requerir: día de corte, día límite de pago, línea de crédito. |
| RF-021 | El sistema debe calcular automáticamente el "Saldo al Corte" sumando transacciones entre fechas de corte. |
| RF-022 | El sistema debe calcular el "Crédito Disponible" como: Línea - Saldo al Corte - Consumos Post-Corte. |
| RF-023 | El sistema debe soportar compras diferidas (MSI), creando automáticamente las cuotas futuras. |
| RF-024 | Para compras diferidas, el sistema debe reducir el crédito disponible por el monto TOTAL inmediatamente. |
| RF-025 | El sistema debe permitir registrar "Pago de Tarjeta" como traspaso especial que reduce la deuda. |
| RF-026 | El sistema debe calcular el pago mínimo basándose en el porcentaje configurado. |
| RF-027 | El sistema debe simular el interés generado si se paga solo el mínimo, usando la tasa configurada. |
| RF-028 | El sistema debe alertar X días antes de la fecha de corte y fecha límite de pago (configurable). |

### Categorías

| ID | Requerimiento |
|----|---------------|
| RF-030 | El sistema debe proveer un conjunto de categorías predeterminadas al inicio. |
| RF-031 | El sistema debe permitir crear, editar, eliminar y reordenar categorías. |
| RF-032 | El sistema debe soportar subcategorías (un nivel de anidación). |
| RF-033 | Cada categoría debe tener: nombre, ícono, color. |
| RF-034 | El sistema debe permitir ocultar categorías sin eliminarlas. |
| RF-035 | El sistema debe permitir fusionar categorías, reasignando todas las transacciones. |

### Presupuestos

| ID | Requerimiento |
|----|---------------|
| RF-040 | El sistema debe permitir crear presupuestos por: categoría, etiqueta, cuenta, o global. |
| RF-041 | Cada presupuesto debe tener: monto límite, periodo (semanal/quincenal/mensual/anual). |
| RF-042 | El sistema debe calcular en tiempo real el porcentaje consumido de cada presupuesto. |
| RF-043 | El sistema debe soportar "rollover" opcional, acumulando el sobrante al siguiente periodo. |
| RF-044 | El sistema debe alertar cuando un presupuesto alcance umbrales configurables (ej. 80%, 100%). |
| RF-045 | El sistema debe calcular la "velocidad de gasto" y proyectar la fecha de agotamiento. |

### Metas Financieras

| ID | Requerimiento |
|----|---------------|
| RF-050 | El sistema debe permitir crear metas de tipo: ahorro, pago de deuda, inversión, patrimonio. |
| RF-051 | Cada meta debe tener: nombre, monto objetivo, fecha límite (opcional), monto inicial. |
| RF-052 | El sistema debe calcular el progreso como porcentaje del objetivo. |
| RF-053 | El sistema debe proyectar la fecha de cumplimiento basándose en el ritmo de aportaciones. |
| RF-054 | El sistema debe soportar contribuciones automáticas periódicas a metas. |
| RF-055 | El dinero "apartado" en metas debe restarse del "Saldo Disponible para Gastar". |

### Inversiones

| ID | Requerimiento |
|----|---------------|
| RF-060 | El sistema debe permitir registrar activos de inversión con: nombre, tipo, cantidad, precio de compra, fecha. |
| RF-061 | El sistema debe permitir actualizar el precio actual de cada activo (manual). |
| RF-062 | El sistema debe calcular: valor de mercado, ganancia/pérdida no realizada, rendimiento porcentual. |
| RF-063 | El sistema debe permitir registrar ventas de activos, calculando ganancia/pérdida realizada. |
| RF-064 | El sistema debe permitir registrar dividendos/rendimientos vinculados a activos. |

### Reportes y Análisis

| ID | Requerimiento |
|----|---------------|
| RF-070 | El sistema debe generar reporte mensual automático con: ingresos, gastos, balance, top categorías. |
| RF-071 | El sistema debe permitir comparar periodos: mes vs mes, año vs año, personalizado. |
| RF-072 | El sistema debe calcular el "Valor Neto" como suma de activos menos suma de pasivos. |
| RF-073 | El sistema debe identificar y reportar "gastos hormiga" (alta frecuencia, bajo monto). |
| RF-074 | El sistema debe permitir exportar datos en formatos: CSV, PDF. |
| RF-075 | El sistema debe generar gráficos: dona/pie, barras, líneas, calendario de calor. |

### Búsqueda y Filtros

| ID | Requerimiento |
|----|---------------|
| RF-080 | El sistema debe permitir buscar transacciones por texto en: notas, comercio, categoría. |
| RF-081 | El sistema debe permitir filtrar por: fecha, tipo, cuenta, categoría, etiqueta, monto, comercio. |
| RF-082 | El sistema debe permitir combinar múltiples filtros con operadores AND/OR. |
| RF-083 | El sistema debe permitir guardar combinaciones de filtros como "filtros favoritos". |

### Notificaciones

| ID | Requerimiento |
|----|---------------|
| RF-090 | El sistema debe enviar notificaciones push para: cortes de tarjeta, pagos próximos, presupuestos. |
| RF-091 | El sistema debe permitir configurar qué notificaciones recibir y cuáles silenciar. |
| RF-092 | El sistema debe permitir configurar la hora preferida para notificaciones no urgentes. |
| RF-093 | El sistema debe enviar resumen semanal opcional. |

---

## 8. Requerimientos No Funcionales

### Rendimiento

| ID | Requerimiento |
|----|---------------|
| RNF-001 | La app debe abrir y estar lista para uso en menos de 2 segundos. |
| RNF-002 | El registro de una transacción simple debe completarse en menos de 500ms. |
| RNF-003 | Las búsquedas deben retornar resultados en menos de 1 segundo para bases de hasta 10,000 transacciones. |
| RNF-004 | Los gráficos deben renderizarse en menos de 1 segundo. |
| RNF-005 | La app debe funcionar fluidamente con 5+ años de datos históricos. |

### Disponibilidad

| ID | Requerimiento |
|----|---------------|
| RNF-010 | La app debe funcionar 100% offline para todas las funciones de registro y consulta. |
| RNF-011 | Los datos deben persistir localmente y sobrevivir a cierres inesperados. |
| RNF-012 | La app debe sincronizar datos cuando haya conexión (si aplica backend). |

### Seguridad Conceptual

| ID | Requerimiento |
|----|---------------|
| RNF-020 | La app debe soportar bloqueo por PIN o biométrico. |
| RNF-021 | La app debe ofrecer "modo discreto" para ocultar montos en lugares públicos. |
| RNF-022 | Los datos sensibles deben almacenarse de forma segura en el dispositivo. |
| RNF-023 | La app no debe enviar datos financieros a servidores externos sin consentimiento explícito. |

### Usabilidad

| ID | Requerimiento |
|----|---------------|
| RNF-030 | Cualquier función principal debe ser accesible en máximo 3 taps desde el dashboard. |
| RNF-031 | Los mensajes de error deben ser claros y sugerir soluciones. |
| RNF-032 | La app debe soportar modo oscuro y modo claro. |
| RNF-033 | La app debe respetar configuraciones de accesibilidad del sistema (tamaño de fuente, contraste). |
| RNF-034 | La navegación debe ser consistente en todas las secciones. |

### Mantenibilidad

| ID | Requerimiento |
|----|---------------|
| RNF-040 | Los datos deben poder exportarse completamente para respaldo. |
| RNF-041 | Los datos deben poder importarse desde un respaldo. |
| RNF-042 | El usuario debe poder eliminar todos sus datos permanentemente. |

---

## 9. Mapeo de Pantallas

### 9.1 Navegación Principal (Bottom Navigation)

| Posición | Ícono | Nombre | Función |
|----------|-------|--------|---------|
| 1 | Casa | Inicio | Dashboard principal |
| 2 | Gráfico | Análisis | Reportes y visualizaciones |
| 3 | + (FAB) | Nuevo | Registrar transacción (botón flotante central) |
| 4 | Cartera | Cuentas | Gestión de cuentas y tarjetas |
| 5 | Objetivo | Planear | Presupuestos y metas |

### 9.2 Pantalla: Dashboard (Inicio)

**Secciones de arriba a abajo:**

1. **Header con Saldo**
   - Saldo Total (todas las cuentas)
   - Valor Neto (toggle para cambiar vista)
   - Ícono de "ojo" para ocultar montos

2. **Resumen del Mes**
   - Barra de progreso: Ingresos vs Gastos
   - Números: "$X ingresos - $Y gastos = $Z balance"

3. **Gráfico Rápido**
   - Dona pequeña con top 4 categorías del mes
   - Tap para ir a Análisis completo

4. **Próximos Pagos**
   - Lista de 3-5 pagos próximos (tarjetas, fijos)
   - Fecha y monto de cada uno
   - Tap para ver todos

5. **Últimas Transacciones**
   - Lista de 5 transacciones más recientes
   - Tap para ver historial completo

6. **Accesos Rápidos (opcional)**
   - Íconos de cuentas favoritas
   - Tap para ver detalle de cuenta

### 9.3 Pantalla: Nueva Transacción

**Modo por defecto (Rápido):**

1. **Teclado Numérico**
   - Ocupa 60% inferior de pantalla
   - Teclas grandes, fáciles de tocar
   - Botón de borrar, punto decimal

2. **Display de Monto**
   - Monto ingresado en grande
   - Selector de moneda si hay múltiples

3. **Selector de Tipo**
   - Tabs: Gasto | Ingreso | Traspaso
   - Gasto seleccionado por defecto

4. **Carrusel de Categorías**
   - Íconos circulares deslizables
   - Categorías frecuentes primero
   - "Ver todas" al final

5. **Selector de Cuenta**
   - Cuenta por defecto preseleccionada
   - Tap para cambiar

6. **Botón Guardar**
   - Prominente, color de acento
   - "Guardar" o ícono de check

**Modo Detallado (expandible):**
- Tap en "Más opciones" o swipe up
- Revela: Fecha, Comercio, Notas, Etiquetas, Ubicación, Foto, Recurrencia, Cuotas, Reembolsable

### 9.4 Pantalla: Análisis

**Tabs superiores:**
- Gastos | Ingresos | Patrimonio

**Contenido (para Gastos):**

1. **Selector de Periodo**
   - Mes actual (con flechas para navegar)
   - Tap para selector de rango personalizado

2. **Resumen Numérico**
   - Total gastado en el periodo
   - Comparativo con periodo anterior (+X% o -X%)

3. **Gráfico Principal**
   - Dona interactiva por categoría
   - Tap en segmento para desglose

4. **Lista de Categorías**
   - Ordenadas por monto (mayor a menor)
   - Barra de progreso visual
   - Monto y porcentaje del total

5. **Acciones**
   - Botón: "Ver por etiquetas"
   - Botón: "Comparar periodos"
   - Botón: "Exportar"

### 9.5 Pantalla: Detalle de Cuenta (Tarjeta de Crédito)

**Header:**
- Nombre y últimos 4 dígitos
- Color/ícono de la tarjeta

**Barra de Estado:**
- Visualización segmentada (Saldo Corte | Post-Corte | Disponible)
- Números debajo de cada segmento

**Información Clave:**
- Línea de crédito: $XX,XXX
- Próximo corte: DD de Mes
- Fecha límite pago: DD de Mes
- Pago mínimo estimado: $X,XXX

**Acciones:**
- Botón: "Pagar Tarjeta"
- Botón: "Ver Compras Diferidas"

**Lista de Transacciones:**
- Transacciones de esta tarjeta
- Filtrable por periodo

### 9.6 Pantalla: Presupuestos

**Lista de Presupuestos:**

Por cada presupuesto:
- Nombre (ej. "Comida")
- Barra de progreso con color semántico
- "$X de $Y (Z%)"
- Indicador de velocidad: "Agotarás el día X"

**Acciones:**
- FAB: "Nuevo Presupuesto"
- Tap en presupuesto: Ver detalle y transacciones que lo afectan

### 9.7 Pantalla: Metas

**Lista de Metas:**

Por cada meta:
- Nombre e ícono
- Barra de progreso circular o lineal
- "$X de $Y (Z%)"
- "Fecha estimada: Mes Año"

**Acciones:**
- FAB: "Nueva Meta"
- Tap en meta: Ver detalle, historial de aportaciones, proyección

### 9.8 Pantalla: Configuración

**Secciones:**

1. **Perfil**
   - Nombre, moneda base, formato de fecha

2. **Cuentas**
   - Lista de cuentas → Gestionar

3. **Categorías**
   - Lista de categorías → Gestionar

4. **Notificaciones**
   - Toggles por tipo de alerta

5. **Apariencia**
   - Tema (claro/oscuro/auto)
   - Color de acento

6. **Seguridad**
   - Bloqueo de app
   - Modo discreto

7. **Datos**
   - Exportar
   - Importar
   - Eliminar todo

8. **Acerca de**
   - Versión, términos, privacidad

---

## 10. Lógica de Negocio Conceptual

### 10.1 Cálculo de Saldo de Cuenta

```
Saldo Actual = Saldo Inicial + Σ(Ingresos) - Σ(Gastos) + Σ(Traspasos Entrantes) - Σ(Traspasos Salientes)
```

**Para tarjetas de crédito (pasivo):**
```
Deuda Actual = Σ(Gastos con esta tarjeta) - Σ(Pagos a esta tarjeta)
```
(Se muestra como número positivo aunque contablemente es negativo)

### 10.2 Cálculo de Valor Neto

```
Valor Neto = Σ(Saldos de cuentas Activo) + Σ(Valor de Inversiones) - Σ(Deudas de Tarjetas) - Σ(Saldos de Préstamos)
```

### 10.3 Lógica de Tarjeta de Crédito

**Definiciones:**
- `Fecha Corte Anterior`: Día de corte del mes pasado
- `Fecha Corte Actual`: Día de corte de este mes
- `Fecha Límite Pago`: Día para pagar sin intereses

**Cálculos:**
```
Saldo al Corte = Σ(Gastos entre Fecha Corte Anterior y Fecha Corte Actual)

Consumos Post-Corte = Σ(Gastos después de Fecha Corte Actual hasta hoy)

Crédito Disponible = Línea Total - Saldo al Corte - Consumos Post-Corte - Σ(Saldo pendiente de MSI)

Pago Mínimo = Saldo al Corte × Porcentaje Mínimo
```

**Lógica de MSI:**
```
Al registrar compra de $X a N meses:
  - Cuota = X / N
  - Crear transacción de Cuota en periodo actual
  - Para i = 1 hasta N-1:
      Programar transacción de Cuota en (Fecha Corte + i meses)
  - Reducir Crédito Disponible en X (no en Cuota)
```

### 10.4 Lógica de Presupuesto

```
Consumido = Σ(Gastos que coinciden con criterio del presupuesto en el periodo actual)

Porcentaje = (Consumido / Límite) × 100

Disponible = Límite - Consumido

Días Restantes = Días hasta fin de periodo

Gasto Diario Promedio = Consumido / Días Transcurridos

Proyección de Agotamiento = Disponible / Gasto Diario Promedio
```

**Con Rollover:**
```
Límite Efectivo = Límite Base + Sobrante del Periodo Anterior

Sobrante = MAX(0, Límite Efectivo - Consumido)
```

### 10.5 Lógica de Meta

```
Progreso = (Monto Actual / Monto Objetivo) × 100

Faltante = Monto Objetivo - Monto Actual

Aportación Promedio = Σ(Aportaciones últimos 3 meses) / 3

Meses para Completar = Faltante / Aportación Promedio

Fecha Proyectada = Hoy + Meses para Completar
```

### 10.6 Lógica de Saldo Disponible para Gastar

```
Saldo Líquido = Σ(Cuentas de Efectivo + Débito + Ahorro)

Obligaciones Próximas = Σ(Saldos al Corte de Tarjetas) + Σ(Gastos Fijos próximos 15 días)

Dinero Apartado = Σ(Montos en Metas de Ahorro)

Saldo Disponible Real = Saldo Líquido - Obligaciones Próximas - Dinero Apartado
```

### 10.7 Validaciones

| Contexto | Validación |
|----------|------------|
| Transacción | Monto debe ser mayor a 0 |
| Transacción | Fecha no puede ser futura (excepto programadas) |
| División | Suma de partes debe igualar total |
| Traspaso | Cuenta origen ≠ Cuenta destino |
| Tarjeta | Día de corte entre 1 y 28 |
| Presupuesto | Límite debe ser mayor a 0 |
| Meta | Monto objetivo debe ser mayor a monto inicial |
| MSI | Número de cuotas debe ser mayor a 1 |

---

## 11. Escenarios Especiales y Edge Cases

### 11.1 Transacciones

| Escenario | Comportamiento Esperado |
|-----------|------------------------|
| Gasto en moneda extranjera | Solicitar tipo de cambio; guardar monto original y convertido |
| Gasto con fecha pasada | Permitir; recalcular presupuestos y reportes de ese periodo |
| Editar monto de transacción antigua | Recalcular saldos y presupuestos afectados |
| Eliminar transacción de hace meses | Recalcular todo el histórico desde esa fecha |
| Transacción recurrente cae en día inválido (31 de febrero) | Usar último día del mes |

### 11.2 Tarjetas de Crédito

| Escenario | Comportamiento Esperado |
|-----------|------------------------|
| Fecha de corte = hoy | Cerrar periodo, calcular saldo al corte |
| Pago mayor al saldo | Permitir; tarjeta queda con "saldo a favor" |
| Compra diferida excede línea disponible | Advertir pero permitir (usuario puede tener arreglos con banco) |
| Cancelación de tarjeta | Archivar, no eliminar; mantener histórico |
| Cambio de fecha de corte | Aplicar desde siguiente periodo; no afectar histórico |

### 11.3 Presupuestos

| Escenario | Comportamiento Esperado |
|-----------|------------------------|
| Presupuesto excedido | Mostrar en rojo; permitir seguir registrando |
| Rollover acumula demasiado | Aplicar límite máximo configurable |
| Categoría sin presupuesto | No afecta ningún presupuesto; solo aparece en reportes |
| Gasto dividido afecta múltiples presupuestos | Cada parte afecta su presupuesto correspondiente |

### 11.4 Metas

| Escenario | Comportamiento Esperado |
|-----------|------------------------|
| Meta completada | Notificar; mantener visible con opción de archivar |
| Retiro de dinero de meta | Permitir; reducir progreso; recalcular proyección |
| Fecha límite pasada sin completar | Notificar; sugerir ajustar fecha o monto |
| Meta con monto inicial mayor a objetivo | Error de validación al crear |

### 11.5 Conciliación

| Escenario | Comportamiento Esperado |
|-----------|------------------------|
| Saldo real ≠ saldo calculado | Ofrecer crear "ajuste" para cuadrar |
| Transacción duplicada detectada | Alertar; ofrecer eliminar |
| Transacción faltante | Sugerir buscar en historial o crear nueva |

### 11.6 Datos

| Escenario | Comportamiento Esperado |
|-----------|------------------------|
| Importar archivo con formato incorrecto | Mostrar errores específicos; permitir corregir |
| Importar transacciones duplicadas | Detectar por fecha+monto+cuenta; preguntar qué hacer |
| Respaldo corrupto | Notificar; no sobrescribir datos actuales |
| Cambio de moneda base | Preguntar si convertir histórico o solo aplicar a futuro |

### 11.7 Fechas y Tiempo

| Escenario | Comportamiento Esperado |
|-----------|------------------------|
| Usuario cambia zona horaria | Mantener fechas absolutas; no recalcular |
| Año bisiesto (29 febrero) | Manejar correctamente en recurrencias y cálculos |
| Cambio de año | Cerrar reportes anuales; iniciar nuevos |

---

## 12. Ideas Futuras y Extensiones

### 12.1 Corto Plazo (Versión 2.x)

1. **Widget de Pantalla de Inicio**
   - Mostrar saldo disponible
   - Acceso directo a registro rápido
   - Últimas transacciones

2. **Atajos de Teclado / 3D Touch**
   - Acciones rápidas desde ícono de app
   - "Registrar Gasto", "Ver Saldo", "Agregar Ingreso"

3. **Modo Viaje Mejorado**
   - Detección automática de cambio de país
   - Sugerencia de activar modo viaje
   - Resumen al regresar

4. **Plantillas Inteligentes**
   - Sugerir plantillas basadas en patrones
   - "Parece que compras café todos los días a las 8am"

### 12.2 Mediano Plazo (Versión 3.x)

1. **Sincronización Multi-Dispositivo**
   - Mismos datos en teléfono y tablet
   - Sincronización en tiempo real

2. **Modo Familia/Pareja**
   - Cuentas compartidas
   - Presupuestos familiares
   - Visibilidad configurable

3. **Lectura de Notificaciones Bancarias**
   - Detectar notificaciones de bancos
   - Sugerir registro automático
   - "Detectamos un cargo de $500 en OXXO. ¿Registrar?"

4. **Integración con Calendarios**
   - Sincronizar pagos programados con calendario del sistema
   - Recordatorios nativos

5. **Reportes Personalizados**
   - Constructor de reportes drag-and-drop
   - Guardar reportes favoritos

### 12.3 Largo Plazo (Versión 4.x+)

1. **Conexión Bancaria (Open Banking)**
   - Sincronización automática de transacciones
   - Saldos en tiempo real
   - Requiere cumplimiento regulatorio

2. **Asistente Inteligente**
   - Chat para consultas: "¿Cuánto gasté en comida el mes pasado?"
   - Sugerencias proactivas
   - Alertas contextuales

3. **Simulador Financiero Avanzado**
   - "¿Qué pasa si compro un auto a crédito?"
   - Proyecciones a 5-10 años
   - Escenarios de inflación

4. **Gamificación Completa**
   - Sistema de niveles
   - Logros y badges
   - Retos comunitarios (anónimos)
   - Rachas de registro

5. **Educación Financiera Integrada**
   - Tips contextuales
   - Mini-cursos dentro de la app
   - Explicaciones de conceptos al tocar términos

6. **API para Integraciones**
   - Conectar con hojas de cálculo
   - Automatizaciones con servicios externos
   - Exportación programada

7. **Versión Web**
   - Acceso desde computadora
   - Misma funcionalidad que móvil
   - Sincronización completa

---

# APÉNDICES

---

## Apéndice A: Glosario de Términos

| Término | Definición |
|---------|------------|
| Saldo al Corte | Monto total de compras realizadas en un periodo de facturación de tarjeta de crédito, que debe pagarse antes de la fecha límite |
| MSI | Meses Sin Intereses; promoción donde una compra se divide en cuotas mensuales sin costo adicional |
| Rollover | Acumulación del presupuesto no utilizado hacia el siguiente periodo |
| Valor Neto | Patrimonio total calculado como Activos menos Pasivos |
| Gastos Hormiga | Pequeños gastos frecuentes que individualmente parecen insignificantes pero suman cantidades importantes |
| Traspaso | Movimiento de dinero entre cuentas propias que no representa ingreso ni gasto |
| Conciliación | Proceso de verificar que los saldos registrados coincidan con los saldos reales |

## Apéndice B: Categorías Predeterminadas Sugeridas

**Gastos:**
- 🍔 Alimentación
  - Supermercado
  - Restaurantes
  - Café
  - Delivery
- 🚗 Transporte
  - Gasolina
  - Uber/Taxi
  - Transporte Público
  - Estacionamiento
  - Mantenimiento Auto
- 🏠 Hogar
  - Renta/Hipoteca
  - Servicios (Luz, Agua, Gas)
  - Internet/Teléfono
  - Mantenimiento
  - Muebles
- 🎬 Entretenimiento
  - Streaming
  - Salidas
  - Hobbies
  - Viajes
- 💊 Salud
  - Médicos
  - Medicinas
  - Gimnasio
  - Bienestar
- 📚 Educación
  - Cursos
  - Libros
  - Materiales
- 👔 Ropa y Accesorios
- 📱 Tecnología
- 💰 Finanzas
  - Comisiones
  - Intereses
  - Seguros
- 🎁 Regalos
- 🐕 Mascotas
- ❓ Otros

**Ingresos:**
- 💼 Salario
- 💵 Freelance
- 📈 Inversiones
- 🎁 Regalos Recibidos
- 💰 Reembolsos
- ❓ Otros Ingresos

---

## Apéndice C: Ejemplo de Flujo de Datos Mensual

**Situación:** Usuario con salario quincenal, 2 tarjetas de crédito, meta de ahorro activa.

**Día 1 del mes:**
- Sistema genera reporte del mes anterior
- Presupuestos se reinician (o aplican rollover)
- Notificación: "Nuevo mes. Tu saldo disponible es $X"

**Día 5 (Corte Tarjeta A):**
- Sistema calcula Saldo al Corte de Tarjeta A
- Notificación: "Tarjeta A cortó. Debes pagar $X antes del día 20"

**Día 15 (Quincena):**
- Usuario registra ingreso de nómina
- Sistema actualiza saldos
- Si hay aportación automática a meta, se registra
- Notificación: "Recibiste tu quincena. Saldo disponible: $X"

**Día 18 (3 días antes de pago Tarjeta A):**
- Notificación: "Recuerda pagar Tarjeta A. Vence el día 20. Saldo: $X"

**Día 20 (Límite pago Tarjeta A):**
- Usuario registra pago de tarjeta
- Sistema actualiza deuda
- Si no paga: Notificación de alerta

**Día 22 (Corte Tarjeta B):**
- Mismo flujo que Tarjeta A

**Día 28:**
- Notificación: "Quedan 3 días del mes. Has gastado $X de tu presupuesto de $Y"

**Día 30/31:**
- Sistema cierra el mes para reportes
- Calcula totales finales
- Prepara reporte mensual

---

*Fin del Documento de Especificación Funcional v2.0*

---

> **Nota para Desarrollo:** Este documento debe ser la referencia única para la implementación. Cualquier ambigüedad debe resolverse consultando los casos de uso y la lógica de negocio aquí definidos. Las decisiones de implementación técnica (arquitectura, frameworks, bases de datos) son independientes de este documento y deben documentarse por separado.

