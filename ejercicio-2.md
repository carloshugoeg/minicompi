## 1. Simulación de la Tabla de Símbolos
El estado de la pila de ámbitos (donde cada índice en la pila representa un diccionario {variable: tipo}) se vería de la siguiente forma en los tres momentos clave:

Momento A: Justo después de declarar int y = a * 2;

Global: {'x': 'int', 'test': 'void(int)'}
Local (Nivel 1): {'a': 'int', 'y': 'int'}
Momento B: Justo antes de cerrar el bloque interno

Global: {'x': 'int', 'test': 'void(int)'}
Local (Nivel 1): {'a': 'int', 'y': 'int'}
Local (Nivel 2): {'x': 'float'}
Momento C: Al llegar a la línea escribir(z);

Global: {'x': 'int', 'test': 'void(int)'}
Local (Nivel 1): {'a': 'int', 'y': 'int'} (Al salir de las llaves {}, el Nivel 2 fue destruido "popped" de la pila).
2. Detección de Errores Semánticos
Tomando en cuenta los tipos de datos, los nombres y los ámbitos, estos son los tres errores semánticos presentes:

Incompatibilidad de tipos en Operación/Asignación (y = y + x;): La variable y fue declarada como int, pero en ese instante la variable x dentro del bloque es de tipo float (5.5). La suma int + float resulta en un float, y tratar de asignarlo directamente a una variable int es un error de incompatibilidad estricta de tipos (no hay un cast o conversión explícita).
Variable no declarada (escribir(z);): Se intenta utilizar (e imprimir) una variable z como argumento. Sin embargo, en ningún momento del código, ni a nivel global ni a nivel local de test, existe una declaración para esta variable.
(Dependiendo de la rigurosidad de tu diseño de Pseudo-C++ y si separaste las operaciones) Operación aritmética inválida: En muchos compiladores semánticos, el solo hecho de intentar aplicar el operador + entre un operando int y un operando float sin un casteo previo ya levanta un error propio, previo al error de la asignación.
3. El Fenómeno del Shadowing
¿Cómo decide su método obtener_tipo_variable cuál utilizar? El método recorre la Pila de Ámbitos en orden inverso (de arriba hacia abajo), buscando desde el ámbito más local (tope de la pila) hacia el más global. En cuanto encuentra la primera coincidencia del nombre de la variable, se detiene y retorna ese tipo.
¿Qué valor (o tipo) se usaría para x en la línea y = y + x;? Se usaría el tipo float (cuyo valor es 5.5). Al buscar en el tope de la pila, la tabla de símbolos encuentra primero la declaración local del bloque, "ocultando" (shadowing) a la variable global int x = 10.
4. Generación de Código Intermedio
Al traducir el bloque interno a Código de Tres Direcciones (C3D), asignando variables temporales de manera única para diferenciar la x local de la x global, quedaría así:

text
t1 = 5.5
x_local = t1
t2 = y + x_local
y = t2
5. Cierre del Ejercicio (Script de Python)
He creado el archivo en tu sistema: /Users/hugoescobar/Documents/University/Quinto Sem/Compiladores/minicompi/simulador.py para cumplir con este último requerimiento.

El código base para tu reporte es el siguiente:

python
class TablaSimbolos:
    def __init__(self):
        self.ambitos = [{}] 
        self.historial = {}
    def entrar_ambito(self):
        self.ambitos.append({})
    def salir_ambito(self):
        if len(self.ambitos) > 1:
            self.ambitos.pop()
    def declarar_variable(self, nombre, tipo):
        self.ambitos[-1][nombre] = tipo
    def guardar_estado(self, momento):
        import copy
        self.historial[momento] = copy.deepcopy(self.ambitos)
    def imprimir_resumen_final(self):
        print("=== HISTORIAL DE LA PILA DE ÁMBITOS ===")
        for momento, pila in self.historial.items():
            print(f"\n{momento}:")
            for i, ambito in enumerate(pila):
                nivel = "Global" if i == 0 else f"Local (Nivel {i})"
                print(f"  [{nivel}] -> {ambito}")
# --- EJECUCIÓN ---
tabla = TablaSimbolos()
tabla.declarar_variable("x", "int")
tabla.declarar_variable("test", "void(int)")
tabla.entrar_ambito()
tabla.declarar_variable("a", "int")
tabla.declarar_variable("y", "int")
tabla.guardar_estado("Momento A")
tabla.entrar_ambito()
tabla.declarar_variable("x", "float")
tabla.guardar_estado("Momento B")
tabla.salir_ambito()
tabla.guardar_estado("Momento C")
if __name__ == "__main__":
    tabla.imprimir_resumen_final()
Al ejecutarlo automáticamente, la salida coincide exactamente con lo dibujado en el Problema 1:

text
=== HISTORIAL DE LA PILA DE ÁMBITOS ===
Momento A:
  [Global] -> {'x': 'int', 'test': 'void(int)'}
  [Local (Nivel 1)] -> {'a': 'int', 'y': 'int'}
Momento B:
  [Global] -> {'x': 'int', 'test': 'void(int)'}
  [Local (Nivel 1)] -> {'a': 'int', 'y': 'int'}
  [Local (Nivel 2)] -> {'x': 'float'}
Momento C:
  [Global] -> {'x': 'int', 'test': 'void(int)'}
  [Local (Nivel 1)] -> {'a': 'int', 'y': 'int'}