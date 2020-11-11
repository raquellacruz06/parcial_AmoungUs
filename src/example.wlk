class Jugador{
	const color
	const mochila = []
	var property nivelSospecha = 40
	var tareasARealizar = #{}
	var property nave
	var tareasRealizadas = #{}
	var personalidad
	var estado 
	method sacarDeLaLista()
	method salir() {
		nave.sacarJugador(self)
		 continuaJugando = false
		}
	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
	}
	method votoPersona() = nave.votosPara(self)
	method tieneMochilaVacia() = mochila.isEmpty()
	method votar(){
		if(continuaJugando){
			personalidad.criterioVotacion(nave)
			} else {}
	}
	method llamarAUnaReunionDeEmergencia(){
		nave.iniciarVotacion()
	}
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
	var  nivelOxigeno
	const tripulantes = #{}
	const impostores = #{}
	const votados = []
	method verQuienGano(){
		if(impostores.isEmpty()){
			self.error("Ganaron los tripulantes")
		}else if(self.cantidadImpostores() == self.cantidadTripulantes()){
			self.error("Ganaron los impostores")
	}
	method sacarImpostor(persona){
		impostores.remove(persona)
	}
	method sacarTripulante(persona){
		tripulantes.remove(persona)
	}
	method sacarJugador(jugador){
		jugadores.remove(jugador)
	}
	method expulsarJugador(jugador){
		jugador.salir()
		jugador.sacarDeLaLista()
		self.verQuienGano()
	}
	method expulsarJugadorMasVotado() = self.expulsarJugador(self.elMasVotado())
	method votosPara(jugador) = votados.ocurrenceOf(jugador)
	method elMasVotado() = jugadores.max({unJugador => unJugador.votoPersona()})	//al poner max, nos evitamos tirar un error
	method agregarNuevoVotado(votado) {
		votados.add(votado)
	} 
	method algunoTieneTuboOxigeno() = jugadores.any({unJugador => unJugador.buscarEnMochila(tuboOxigeno)})
	method aumentarNivelOxigeno(cantidad){
		nivelOxigeno += cantidad
	}
	method cantidadImpostores() = impostores.size()
	method cantidadTripulantes() = tripulantes.size()
	method iniciarVotacion() {
		jugadores.forEach({unJugador=>unJugador.votar()})
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
	override method sacarDeLaLista(){
		nave.sacarImpostor(self)
	}
}
class Tripulante inherits Jugador{
	override method sacarDeLaLista(){
		nave.sacarTripulante(self)
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
	method impugnar(jugador){
		jugador.cambiarEstado(impugnado)
	}
}

class Personalidad{
	method votar(nave){
		nave.agregarNuevoVotado(self.devolverVotado(nave))
	}
	method devolverVotado(nave) = nave.jugadores().findOrDefault({unJugador => self.criterioVotacion()},votoEnBlanco)
	
}

object troll inherits Personalidad{
	method criterioVotacion(nave) = nave.jugadores().findOrDefault({unJugador => !unJugador.esSospechoso()},votoEnBlanco)	
}

object detective inherits Personalidad{
	method elMasSospechoso(nave) = nave.jugadores().max({unJugador=> unJugador.nivelSospecha()}) 			//TERMINAR
	method criterioVotacion(nave) = self.elMasSospechoso(nave)
}
object materialistas inherits Personalidad{
	method criterioVotacion(nave) = nave.jugadores().findOrDefault({unJugador => unJugador.tieneMochilaVacia()}, votoEnBlanco)
}

object votoEnBlanco inherits Jugador{
	override method salir(){}
}

object jugando{
	method votar() = personalidad.criterioVotacion(nave)
			
}
object expulsado{
	method votar() {}
}
object impugnado{
	method votar() = votoEnBlanco
}




