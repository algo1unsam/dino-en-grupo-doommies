import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo({ self.jugar()})
    	keyboard.up().onPressDo({dino.saltar()})
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		gameOver.animacionGameOver()
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	const goalMsg = "!!! GAME OVER !!!"
	const msg = ["!", "!", "!", " ", "G", "A", "M", "E", " ", "O", "V", "E", "R", " ", "!", "!", "!"]
	var strMsg = ""
	var charIndex = 0
	
	method position() = game.center()
	method text() = strMsg
	
	method animacionGameOver() {
		charIndex = 0
		strMsg = ""
		game.schedule(100, {self.animarMensaje()})
	}
	
	method animarMensaje() {
		if (strMsg != goalMsg) {
			strMsg += msg.get(charIndex)
			charIndex++
			game.schedule(100, {self.animarMensaje()})
		}
	}
	
}

object reloj {
	
	var tiempo = 0 
	

	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo += 1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	
	method detener(){
		game.removeTickEvent("tiempo")
	}

}

object cactus {
	 
	var position = self.posicionInicial()

	method image() = "cactus.png"
	method position() = position
	
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() < 0) {
			position = new Position(x = game.width(), y = position.y())
		} 
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus");
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	
	var flag = 0

	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if( flag == 0){
		self.subir()
		game.schedule(250, {=> self.bajar()})
		}
	}
	
	
	method subir(){
		flag = 1
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
		flag = 0
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}