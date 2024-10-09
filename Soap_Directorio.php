<?php
// Configuración de LDAP
define('LDAP_HOST', 'ldap://localhost');  // Cambiar por la dirección de tu servidor LDAP
define('LDAP_PORT', 389);
define('LDAP_BASE_DN', 'dc=ejemplo,dc=com');  // Cambiar por tu base DN
define('LDAP_USERNAME', 'cn=admin,dc=ejemplo,dc=com');  // Usuario administrador LDAP
define('LDAP_PASSWORD', 'tu_password');  // Contraseña del admin LDAP

class DirectorioActivoService {
    private $ldapConn;
    
    public function __construct() {
        // Inicializar conexión LDAP
        $this->ldapConn = ldap_connect(LDAP_HOST, LDAP_PORT);
        if (!$this->ldapConn) {
            throw new SoapFault('LDAP_ERROR', 'No se pudo conectar al servidor LDAP');
        }
        
        ldap_set_option($this->ldapConn, LDAP_OPT_PROTOCOL_VERSION, 3);
        ldap_set_option($this->ldapConn, LDAP_OPT_REFERRALS, 0);
        
        if (!ldap_bind($this->ldapConn, LDAP_USERNAME, LDAP_PASSWORD)) {
            throw new SoapFault('LDAP_ERROR', 'Error en la autenticación LDAP');
        }
    }
    
    /**
     * Autenticar usuario
     */
    public function autenticarUsuario($username, $password) {
        $filter = "(uid=$username)";
        $result = ldap_search($this->ldapConn, LDAP_BASE_DN, $filter);
        
        if ($result === false) {
            return false;
        }
        
        $entries = ldap_get_entries($this->ldapConn, $result);
        if ($entries['count'] == 0) {
            return false;
        }
        
        $userDn = $entries[0]['dn'];
        return @ldap_bind($this->ldapConn, $userDn, $password);
    }
    
    /**
     * Buscar usuario
     */
    public function buscarUsuario($username) {
        $filter = "(uid=$username)";
        $result = ldap_search($this->ldapConn, LDAP_BASE_DN, $filter);
        
        if ($result === false) {
            return null;
        }
        
        $entries = ldap_get_entries($this->ldapConn, $result);
        if ($entries['count'] == 0) {
            return null;
        }
        
        return array(
            'dn' => $entries[0]['dn'],
            'uid' => $entries[0]['uid'][0],
            'cn' => $entries[0]['cn'][0],
            'mail' => isset($entries[0]['mail'][0]) ? $entries[0]['mail'][0] : '',
        );
    }
    
    /**
     * Crear usuario
     */
    public function crearUsuario($username, $nombre, $email, $password) {
        $dn = "uid=$username," . LDAP_BASE_DN;
        
        $info = array(
            'objectClass' => array('top', 'person', 'organizationalPerson', 'inetOrgPerson'),
            'uid' => $username,
            'cn' => $nombre,
            'sn' => $nombre,
            'mail' => $email,
            'userPassword' => $this->hashPassword($password)
        );
        
        return ldap_add($this->ldapConn, $dn, $info);
    }
    
    private function hashPassword($password) {
        return '{SHA}' . base64_encode(sha1($password, true));
    }
    
    public function __destruct() {
        if ($this->ldapConn) {
            ldap_close($this->ldapConn);
        }
    }
}

// Configurar servidor SOAP
$server = new SoapServer(null, array('uri' => 'http://ejemplo.com/soap'));
$server->setClass('DirectorioActivoService');

try {
    $server->handle();
} catch (Exception $e) {
    header('Content-Type: text/xml');
    echo '<?xml version="1.0" encoding="UTF-8"?>';
    echo '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">';
    echo '<SOAP-ENV:Body>';
    echo '<SOAP-ENV:Fault>';
    echo '<faultcode>' . $e->getCode() . '</faultcode>';
    echo '<faultstring>' . $e->getMessage() . '</faultstring>';
    echo '</SOAP-ENV:Fault>';
    echo '</SOAP-ENV:Body>';
    echo '</SOAP-ENV:Envelope>';
}
?>