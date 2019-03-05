class Session
    attr_reader :idUser, :nameUser
    def initialize(sql)
        @conexion = sql
        @idUser   = nil
        @nameUser = nil
    end

    def registerUser(name, email, pass)
        respuesta = "-"
        begin
            @conexion.query("CALL create_user('#{name}','#{email}','#{pass}')")
            respuesta = "creacion exitosa"
        rescue => e
            if e.errno == 1062
                respuesta = "El email '#{email}' ya esta registrado"
            else
                respuesta = e.sql_state
            end
        end
        respuesta
    end

    def login (email, pass)
        result = @conexion.query("SELECT u.iduser, u.name_user FROM users u WHERE u.email = '#{email}' AND u.pass = SHA1('#{pass}') LIMIT 1")
        if result.count < 1
            "Error en el correo o contraseña, por favor vuelva a intentarlo"
        else
            @idUser = result.first["iduser"];
            @nameUser = result.first["name_user"];
            "El usuario '#{result.first["name_user"]}' se a logueado correctamente"
        end
    end

end
