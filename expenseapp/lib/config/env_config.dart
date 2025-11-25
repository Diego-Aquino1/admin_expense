import 'dart:io';
import 'package:flutter/foundation.dart';

/// Configuración del entorno de la aplicación
/// Detecta automáticamente la plataforma y usa la URL base correspondiente
class EnvConfig {
  EnvConfig._();

  // ==========================================
  // CONFIGURACIÓN POR PLATAFORMA
  // ==========================================
  
  /// URL base para desarrollo local
  /// 
  /// Android: Usa 10.0.2.2 para emulador (apunta al localhost del host)
  ///          Para dispositivo físico, usa tu IP local (ej: 192.168.1.100)
  /// iOS: Usa localhost (127.0.0.1)
  /// Web: Usa localhost
  static const String _androidBaseUrl = 'http://10.0.2.2:8000/api';
  static const String _iosBaseUrl = 'http://localhost:8000/api';
  static const String _webBaseUrl = 'http://localhost:8000/api';
  
  /// Puerto del servidor backend
  static const int backendPort = 8000;
  
  /// IP local para Android (dispositivos físicos)
  /// Cambia esto por la IP de tu máquina en la red local
  /// Para encontrarla: `ipconfig` (Windows) o `ifconfig` (Mac/Linux)
  /// Ejemplo: '192.168.1.100'
  static const String? androidLocalIp = null; // null usa emulador (10.0.2.2)
  
  /// URL de producción (para releases)
  static const String? productionBaseUrl = null;

  // ==========================================
  // DETECCIÓN AUTOMÁTICA
  // ==========================================
  
  /// Obtiene la URL base de la API según la plataforma
  static String get apiBaseUrl {
    // Si hay una URL de producción configurada y estamos en release, usarla
    if (productionBaseUrl != null && kReleaseMode) {
      return productionBaseUrl!;
    }
    
    // Detectar plataforma
    if (kIsWeb) {
      return _webBaseUrl;
    }
    
    if (Platform.isIOS) {
      return _iosBaseUrl;
    }
    
    if (Platform.isAndroid) {
      // Si hay una IP local configurada, usarla (para dispositivo físico)
      if (androidLocalIp != null) {
        return 'http://$androidLocalIp:$backendPort/api';
      }
      // Si no, usar la IP del emulador
      return _androidBaseUrl;
    }
    
    // Por defecto (Linux, Windows, macOS desktop)
    return _iosBaseUrl;
  }

  /// Obtiene información del entorno actual
  static Map<String, dynamic> get environmentInfo {
    return {
      'platform': kIsWeb 
        ? 'Web' 
        : Platform.operatingSystem,
      'isRelease': kReleaseMode,
      'isDebug': kDebugMode,
      'apiBaseUrl': apiBaseUrl,
      'backendPort': backendPort,
    };
  }

  /// Imprime información del entorno (útil para debugging)
  static void printEnvironmentInfo() {
    final info = environmentInfo;
    debugPrint('═══════════════════════════════════════');
    debugPrint('🌍 Entorno de la aplicación');
    debugPrint('═══════════════════════════════════════');
    debugPrint('Plataforma: ${info['platform']}');
    debugPrint('Modo: ${info['isRelease'] ? 'Release' : 'Debug'}');
    debugPrint('URL API: ${info['apiBaseUrl']}');
    debugPrint('Puerto: ${info['backendPort']}');
    debugPrint('═══════════════════════════════════════');
  }
}
