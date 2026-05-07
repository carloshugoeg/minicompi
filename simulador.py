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

    def obtener_tipo_variable(self, nombre):
        for ambito in reversed(self.ambitos):
            if nombre in ambito:
                return ambito[nombre]
        return None

    def imprimir_resumen_final(self):
        print("Historial de la pila")
        for momento, pila in self.historial.items():
            print(f"\n{momento}:")
            for i, ambito in enumerate(pila):
                nivel = "Global" if i == 0 else f"Local (Nivel {i})"
                print(f"  [{nivel}] -> {ambito}")

tabla = TablaSimbolos()

# parte Global
# int x = 10;
tabla.declarar_variable("x", "int")
# void test(int a)
tabla.declarar_variable("test", "void(int)")

# Entramos a test(int a)
tabla.entrar_ambito()
# declarar 'a'
tabla.declarar_variable("a", "int")
# int y = a * 2
tabla.declarar_variable("y", "int")

# Momento A: Justo después de declarar 'int y = a * 2;'
tabla.guardar_estado("Momento A")

# Entramos al bloque anidado { ... }
tabla.entrar_ambito()
# float x = 5.5;
tabla.declarar_variable("x", "float")

# Momento B: Justo antes de cerrar el bloque interno
tabla.guardar_estado("Momento B")

# Salimos del bloque anidado }
tabla.salir_ambito()

# x = y + 1;
# escribir(z);

# Momento C: Al llegar a la línea 'escribir(z);'
tabla.guardar_estado("Momento C")

if __name__ == "__main__":
    tabla.imprimir_resumen_final()
