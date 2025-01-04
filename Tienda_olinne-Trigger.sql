-- 1. Creación de Roles
-- Rol Super Administrador
create role SuperAdministrador;

-- Rol de super administrador(privilegios de crear usuarios y gestionar procesos)
create role Administrador;

-- Crear el rol CRUD
create role CRUD;

-- Crear el rol CRU (no podrá eliminar)
create role CRU;

-- Crear el rol Solo Lectura(hacer consultas a las tablas)
create role SoloLectura;

-- 2. Creación (Usuarios y asignación de roles)

-- Contraseña para el usuario
create user 'super_admin'@'localhost' identified by 'Leito_2015';
-- Asignar el rol Super Administrador al usuario
grant SuperAdministrador to 'super_admin'@'localhost';
-- Crear el usuario Administrador, crear usuarios y gestionar procesos
-- Contraseña segura para el usuario
create user 'admin_user'@'localhost' identified by 'Sofi_2022';
-- Asignar el rol Administrador al usuario
grant Administrador to 'admin_user'@'localhost';

-- Contraseña segura para el usuario
create user 'crud_user'@'localhost' identified by 'CrudUser123!';

-- Asignar el rol CRUD al usuario
grant CRUD to 'crud_user'@'localhost';
-- Contraseña segura para el usuario
create user 'cru_user'@'localhost' identified by 'CruUser123!';

-- Asignar el rol CRU al usuario
grant CRU to 'cru_user'@'localhost';--
-- Crear el usuario Solo Lectura
create user 'read_only_user'@'localhost' identified by 'ReadOnly123!';

-- Asignar el rol Solo Lectura al usuario
grant SoloLectura to 'read_only_user'@'localhost';

-- 3. Otros Privilegios

-- Rol Super Administrador (crear y eliminar bases de datos)
grant create, drop on *.* to 'super_admin'@'localhost';

-- Para el rol Administrador (crear usuarios y gestionar procesos)
GRANT CREATE USER, ALTER, SHOW DATABASES, PROCESS, GRANT OPTION ON *.* TO 'admin_user'@'localhost';

-- Para el rol CRUD (insertar, actualizar y eliminar datos)
grant insert, update, delete on *.* to 'crud_user'@'localhost';

-- Para el rol CRU (insertar y actualizar, pero sin eliminar)
grant insert, update on *.* to 'cru_user'@'localhost';
-- Para el rol Solo Lectura (realizar consultas a las tablas)
grant select on *.* to 'read_only_user'@'localhost';
-- 4. APLICAR CAMBIOS
FLUSH PRIVILEGES;


-- Tigers
-- Crear la tabla de empleados
CREATE TABLE empleados (
    EmpID INT AUTO_INCREMENT PRIMARY KEY,       
    Nombre VARCHAR(100) NOT NULL,               
    Departamento VARCHAR(100) NOT NULL,         
    Salario DECIMAL(10, 2) NOT NULL              
);
-- Crear la tabla de auditoría
CREATE TABLE auditoria_empleados (
    AudID INT AUTO_INCREMENT PRIMARY KEY,        
    Accion VARCHAR(10) NOT NULL,                 
    EmpID INT NOT NULL,                         
    Nombre VARCHAR(100) NOT NULL,                
    Departamento VARCHAR(100) NOT NULL,          
    Salario DECIMAL(10, 2) NOT NULL,             
    Fecha DATETIME NOT NULL                     
);

-- Crear el trigger para registrar las operaciones en la tabla de auditoría
DELIMITER $$

CREATE TRIGGER auditoria_insert
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_empleados (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('INSERT', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER auditoria_update
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_empleados (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('UPDATE', OLD.EmpID, OLD.Nombre, OLD.Departamento, OLD.Salario, NOW());
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER auditoria_delete
AFTER DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_empleados (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('DELETE', OLD.EmpID, OLD.Nombre, OLD.Departamento, OLD.Salario, NOW());
END $$

DELIMITER ;



