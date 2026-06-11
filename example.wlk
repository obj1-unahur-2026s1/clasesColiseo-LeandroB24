class ArmaDeFilo{
  const filo
  const longitud

  method ataque() = filo * longitud
}

class ArmaContundente{
  const peso

  method ataque() = peso
}

object casco{
  method proteccion(luchador) = 10
}
object escudo{
  method proteccion(luchador) = 5 + luchador.destreza() * 0.1
}

class Gladiador{
  var vida = 100

  method defensa()
  method fuerza()
  method destreza()
  method vida() = vida

  method atacar(unGladiador){
    unGladiador.recibirAtaque(self)
  }

  method recibirAtaque(unGladiador){
    vida = vida - (unGladiador.poderDeAtaque() - self.defensa())
  }

  method pelearCon(unGladiador){
    self.atacar(unGladiador)
    unGladiador.atacar(self)
  }

  method curar(){
    vida = 100
  }
}

class Mirmillon inherits Gladiador{
  var arma
  var armadura
  var fuerza

  method cambiarArma(unArma){arma=unArma}
  method cambiarArmadura(unaArmadura){armadura=unaArmadura}
  
  method cambiarFuerza(valor){fuerza=valor}
  override method fuerza() = fuerza
  override method destreza() = 15

  method poderDeAtaque() = fuerza + arma.ataque()

  override method defensa() = armadura.proteccion(self) + self.destreza()

  method formarGrupoCon(unGladiador){ return
    new Grupo(
      nombre="Mirmillolandia",
      miembros=#{unGladiador,self}
    )
  }
}

class Dimachaerus inherits Gladiador{
  const armas = []
  var destreza

  method agregar(unArma){armas.add(unArma)}
  method quitar(unArma){armas.remove(unArma)}

  override method fuerza() = 10
  override method destreza() = destreza

  method poderDeAtaque() = armas.sum({a=>a.ataque()}) + self.fuerza()

  override method defensa() = destreza/2
  
  override method atacar(unGladiador){
    super(unGladiador)
    destreza += 1
  }

  method formarGrupoCon(unGladiador){return
    new Grupo(
      nombre="D-" + (self.poderDeAtaque()+unGladiador.poderDeAtaque()).toString(),
      miembros=#{unGladiador,self}
    )
  }
}

class Grupo{
  const property miembros = #{}
  const property nombre
  var cantPeleas = 0

  method agregar(unGladiador){miembros.add(unGladiador)}
  method quitar(unGladiador){miembros.remove(unGladiador)}

  method puedenCombatir() = miembros.filter({m=>m.vida() > 0})
  method campeon() = self.puedenCombatir().max({m=>m.poderDeAtaque()})

  method combatirCon(unGrupo){
    self.campeon().pelearCon(unGrupo.campeon())
    self.campeon().pelearCon(unGrupo.campeon())
    self.campeon().pelearCon(unGrupo.campeon())
    cantPeleas+=3
  }
}

object coliseo{
  method organizarCombate(unGrupo,otroGrupo){
    unGrupo.combatirCon(otroGrupo)
  }

  method organizarCombateContraGladiador(unGrupo,unGladiador){
    unGrupo.forEach({g=>g.pelearCon(unGladiador)})
  }

  method curar(unGladiador){
    unGladiador.curar()
  }

  method curarGrupo(unGrupo){
    unGrupo.miembros().forEach({g=>g.curar()})
  }
}