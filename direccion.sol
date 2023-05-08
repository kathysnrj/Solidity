// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

contract Ejemplo{
    uint numero;
    address duenho;//guardar la direccion del propietario
    
    //la direccion que lo despliega va hacer el propietario del contrato
    constructor(){
        //msg variable global y siempre contiene informacion sobre quien llama a la
        duenho = msg.sender;//especifica la direccion que esta llamando a la funcion
        
         
    }

    function setNumero(uint number) public {
                
        numero = number;

    }
    
    function getNumero() public view returns(uint){
        return numero;
    }
}