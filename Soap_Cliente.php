<?php
try {
    $cliente = new SoapClient(null, array(
        'location' => 'http://tu-servidor/soap-server.php',
        'uri' => 'http://ejemplo.com/soap',
        'trace' => 1
    ));
    
    // Ejemplo de autenticación
    $resultado = $cliente->autenticarUsuario('usuario', 'password');
    if ($resultado) {
        echo "Usuario autenticado correctamente\n";
    } else {
        echo "Error en la autenticación\n";
    }
    
    // Ejemplo de búsqueda de usuario
    $usuario = $cliente->buscarUsuario('usuario');
    if ($usuario) {
        echo "Usuario encontrado:\n";
        print_r($usuario);
    }
    
    // Ejemplo de creación de usuario
    $resultado = $cliente->crearUsuario(
        'nuevousuario',
        'Nuevo Usuario',
        'nuevo@ejemplo.com',
        'password123'
    );
    if ($resultado) {
        echo "Usuario creado correctamente\n";
    }
    
} catch (SoapFault $e) {
    echo "Error SOAP: " . $e->getMessage() . "\n";
}
?>