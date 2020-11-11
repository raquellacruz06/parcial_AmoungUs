class Jugador{
	const color
	const mochila = []
	var nivelSospecha = 40
	var tareasARealizar = #{}
	var property nave
	var tareasRealizadas = #{}
	
	method realizarSabotaje()
	method realizarCualquierTarea(){
		self.realizarTarea(tareasARealizar.anyOne())
	}
	method cumplioTodasLasTareas() = tareasARealizar.all({unaTarea=> tareasRealizadas.contains(unaTarea)})
	method realizarTarea(tarea){
		if(tareasARealizar.contais(tarea)){
			tarea.hacerTarea(self)
		self.avisarALaNave()
		tareasRealizadas.add(tarea)
		}
	}
	method eliminarItem(items){
		mochila.removeAll(items)
	}
	method avisarALaNave(){
		nave.chequearTareas()
	}
	method buscarEnMochila(item){
		mochila.contains(item)
	}
	method aumentarNivelSospecha(cantidad){
		nivelSospechacha += cantidad
	}
	method esSospechoso() = nivelSospecha > 50
	method buscarItem(item){
		mochila.add(item)
	}
	method encontrarTodosLosItems(items){
		items.forEach({unItem=>self.buscarEnMochila(unItem)})
	}
	
}

object nave {
	const jugadores = #{}
	var cantTripulantes 
	var cantImpostores
	var  nivelOxigeno
	method algunoTieneTuboOxigeno() = jugadores.any({unJugador => unJugador.buscarEnMochila(tuboOxigeno)})
	method aumentarNivelOxigeno(cantidad){
		nivelOxigeno += cantidad
	}
	method oxigenoAcabado() = nivelOxigeno == 0
	method chequearTareas() = jugadores.all({unJugador => unJugador.cumplioTarea()})
	method verSiGanaron() {
		if(self.chequearTareas()){
			self.error("Ganaron los tripulantes")
		} {}
	}
}

class Impostor inherits Jugador{
	override method cumplioTodasLasTareas() = true
	override method realizarTarea(tarea) {}
}
class Tripulante inherits Jugador{
	
	method buscarEnMochila(elemento){
		mochila.contains(elemento)
	}
	
}
class Tarea{
	method hacerTarea(persona){
		persona.encontrarTodosLosItems(self.itemsRequeridos())
		persona.aumentarNivelSospecha(self.nivelRequerido())
		persona.eliminarItem(self.itemsRequeridos())
	}
	
}
object arreglarTableroElectrico inherits Tarea{
	var property itemsRequeridos = [llaveInglesa]
		var property nivelRequerido = 10
		
}
object sacarLaBasura inherits Tarea{
	
		var property itemsRequeridos = [escoba,bolsaDeConsorcio]
		var property nivelRequerido = -4
	
}
object ventilarLaNave inherits Tarea{

	override method hacerTarea(persona){
		persona.nave().aumentarNivelOxigeno(5)
	}
}
class Sabotaje{
	method hacerSabotaje(persona){
		persona.aumentarNivelSospecha(5)
		
	}
}

object reducirOxigeno inherits Sabotaje{
	override method hacerSabotaje(persona){
		
		if(persona.nave().algunoTieneTuboOxigeno()){
			
		}persona.nave().aumentarNivelOxigeno(-10)
		super(persona)
		if(persona.nave().oxigenoAcabado()){
			self.error("Ganaron los impostores")
		}
	}
}

object impugnarAUnJugador inherits Sabotaje{
	
}