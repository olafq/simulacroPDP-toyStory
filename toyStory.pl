% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(andy, jessie, 8).
duenio(andy,buzz,3).
duenio(sam, jessie, 3).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes).
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(stacyMalibu,deAccion(deTrapo,[original(sombrero)])).
juguete(seniorCaraDePapa,caraDePapa([ original(pieIzquierdo),original(pieDerecho) ])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, [original(sombrero)])).
esRaro((caraDePapa(seniorCaraDePapa, [ original(pieIzquierdo),original(pieDerecho) ]))).

% Dice si una persona es coleccionista
esColeccionista(sam).

%Punto 1 tematica/2: relaciona a un juguete con su temática. La temática de los cara de papa es caraDePapa.
tematica(Juguete,Tematica) :-
juguete(_,Juguete),
tematicaJuguete(Juguete,Tematica).

tematicaJuguete(deTrapo(Tematica),Tematica).
tematicaJuguete(deAccion(Tematica,_),Tematica).
tematicaJuguete(miniFiguras(Tematica,_),Tematica).
tematicaJuguete(caraDePapa(_),caraDePapa).

%1. b. esDePlastico/1: Nos dice si el juguete es de plástico, lo cual es verdadero sólo para lasminiFiguras y los caraDePapa.
esDePlastico(Juguete) :-
    juguete(_,Juguete),
    esDePlasticoJuguete(Juguete).
esDePlasticoJuguete(miniFiguras(_,_)).
esDePlasticoJuguete(caraDePapa(_)).

%1. c. esDeColeccion/1: Tanto lo muñecos de acción como los cara de papa son de colección si son raros, los de trapo siempre lo son, y las mini figuras, nunca.
esDeColeccion(Juguete) :-
    juguete(_,Juguete),
    esDeColeccionJuguete(Juguete).

esDeColeccionJuguete(deTrapo(_)).
esDeColeccionJuguete(Juguete) :-
    esAccionOCaraDePapa(Juguete),
    esRaro(Juguete).

esAccionOCaraDePapa(deAccion(_,_)).
esAccionOCaraDePapa(caraDePapa(_)).

%2. amigoFiel/2: Relaciona a un dueño con el nombre del juguete que no sea de plástico que tiene hace más tiempo. Debe ser completamente inversible.
amigoFiel(Duenio,NombreDeJuguete) :-
duenio(Duenio,NombreDeJuguete,Anio),
forall(jugueteQueNoEsDePlastico(Duenio,_,OtroAnio),Anio >=OtroAnio).

jugueteQueNoEsDePlastico(Duenio,NombreDeJuguete,Anio) :-
    duenio(Duenio,NombreDeJuguete,Anio),
    juguete(NombreDeJuguete,Juguete),
    not(esDePlastico(Juguete)).

%3. superValioso/1: Genera los nombres de juguetes de colección que tengan todas sus piezas originales, y que no estén en posesión de un coleccionista.
superValioso(NombreDeJuguete) :-
    juguete(NombreDeJuguete,Juguete),
    esDeColeccionJuguete(Juguete),
    tieneTodasPiezasOriginales(Juguete),
    not(esDeColeccionista(NombreDeJuguete)).

esDeColeccionista(NombreDeJuguete) :-
    duenio(Duenio,NombreDeJuguete,_),
    esColeccionista(Duenio).

tieneTodasPiezasOriginales(Juguete) :-
 forall(pieza(Juguete,Pieza),esOriginal(Pieza)).

pieza(Juguete,Pieza) :-
  piezas(Juguete, Piezas),
  member(Pieza, Piezas).

piezas(caraDePapa(Piezas),Piezas).
piezas(deAccion(deTrapo,Piezas),Piezas).

esOriginal(original(_)).

%4. dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le pertenezcan que
%hagan buena pareja. Dos juguetes distintos hacen buena pareja si son de la misma temática.
%Además woody y buzz hacen buena pareja. Debe ser complemenente inversible.

duoDinamico(Duenio,NombreJuguete1,NombreJuguete2) :-
    duenio(Duenio,NombreJuguete1,_),
    duenio(Duenio,NombreJuguete2,_),
    NombreJuguete1\=NombreJuguete2,
    hacenBuenaPareja(NombreJuguete1,NombreJuguete2).

hacenBuenaPareja(NombreJuguete,NombreOtroJueguete) :-
tematicaNombre(NombreJuguete,Tematica),
tematicaNombre(NombreOtroJueguete,Tematica).

tematicaNombre(NombreJuguete,Tematica) :-
    juguete(NombreJuguete,Juguete),
    tematica(Juguete,Tematica).
hacenBuenaPareja(woody,buzz).

%5. felicidad/2: Relaciona un dueño con la cantidad de felicidad que le otorgan todos sus juguetes:
%● las minifiguras le dan a cualquier dueño 20 * la cantidad de figuras del conjunto
%● los cara de papas dan tanta felicidad según qué piezas tenga: las originales dan 5, las de repuesto,8.
%● los de trapo, dan 100
%● Los de acción, dan 120 si son de colección y el dueño es coleccionista. Si no dan lo mismo que los de trapo.
%Debe ser completamente inversible.

felicidad(Duenio,FelicidadTotal) :-
    duenio(Duenio,_,_),
    findall(Felicidad,felicidadDuenioPorUnJuguete(Duenio,Felicidad),Felicidades),
    sumlist(Felicidades,FelicidadTotal).

felicidadDuenioPorUnJuguete(Duenio,Felicidad) :-
    duenio(Duenio,NombreJuguete,_),
    juguete(NombreJuguete,Juguete),
    felicidadJuguete(Duenio, Juguete, Felicidad).

felicidadJuguete(_,miniFiguras(_,CantidadDeFiguras), Felicidad) :-
    Felicidad is 20 * CantidadDeFiguras.

felicidadJuguete(_,deTrapo(_), 100).

felicidadJuguete(_,caraDePapa(Piezas), Felicidad) :-
    member(Pieza,Piezas),
    felicidadXPieza(Pieza,Felicidad).

felicidadJuguete(Duenio,Juguete,120) :-
   esDeAccionDeColeccionYdeColeccionista(Duenio,Juguete).

felicidadJuguete(Duenio,Juguete,Felicidad) :-
    not(esDeAccionDeColeccionYdeColeccionista(Duenio,Juguete)),
    felicidadJuguete(_,deTrapo(_),Felicidad).

felicidadXPieza(original(_),5).
felicidadXPieza(repuesto(_),8).

esDeAccionDeColeccionYdeColeccionista(Duenio,accion(_,_)) :-
    esDeColeccionJuguete(accion(_,_)),
    esColeccionista(Duenio).

%6. puedeJugarCon/2: Relaciona a alguien con un nombre de juguete cuando puede jugar con él. Esto ocurre cuando:
%● este alguien es el dueño del juguete
% o bien, cuando exista otro que pueda jugar con este juguete y pueda prestárselo
%Alguien puede prestarle un juguete a otro cuando es dueño de una mayor cantidad de juguetes.

puedeJugarCon(Duenio,NombreJuguete) :-
    duenio(Duenio,NombreJuguete,_).

puedeJugarCon(Duenio,NombreJuguete) :-
    puedePrestarle(OtroDuenio,Duenio),
    puedeJugarCon(OtroDuenio,NombreJuguete).

puedePrestarle(Duenio,OtroDuenio) :-
    cantidadJuguetes(Duenio,Juguetes),
    cantidadJuguetes(OtroDuenio,Juguetes2),
    Juguetes > Juguetes2.

cantidadJuguetes(Duenio,CantJuguetes) :-
    juguetesDe(Duenio,NombreJuguetes),
    length(NombreJuguetes,CantJuguetes).
juguetesDe(Duenio,NombreJuguetes) :-
    duenio(Duenio,_,_),
    findall(NombreJuguete,duenio(Duenio,NombreJuguete,_),NombreJuguetes).

%7. podriaDonar/3: relaciona a un dueño, una lista de juguetes propios y una cantidad de felicidad cuando entre
%todos los juguetes de la lista le generan menos que esa cantidad de felicidad. Debe ser inversible para sus primeros dos argumentos.

podriaDonar(Duenio,NombreJuguetes,FelicidadTope) :-
  juguetesDe(Duenio, NombresJuguetes),
  felicidad(Duenio, Felicidad),
  FelicidadTope >= Felicidad.


% Se usa polimorfismo en los siguientes predicados:
%   tematica/2. porque usa tematicaJuguete.
%   esDePlastico/1.porque usa esDePlasticoJuguete
%   esDeColeccion/1. porque usa esDeColeccionJuguete
%   pieza/2. porque usa piezas 
%   felicidad/2. porque usa felicidadXJuguete
