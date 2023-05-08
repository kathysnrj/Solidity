// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Saludo{
string public name;
string public saludoPrefijo = "Tajamar";
constructor(string memory inicialNombre) {
    name = inicialNombre;
    
}
function setName(string memory nuevonombre )public{
    name= nuevonombre;
}
//encodepacked usa memoria minima requerida para codificar datos
//una direccion solo usara 20 bytes y para matrices dinamicas se almacenaran sin lingitud
function getSaludo() public view returns(string memory){
    return string(abi.encodePacked(saludoPrefijo, name));
}
}