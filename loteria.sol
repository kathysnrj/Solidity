// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract Loteria{
    address internal owner;
    uint256 internal num; 
    uint256 public numGanador;
    uint256 public precio;
    bool public juego;//juego activo o desactivo true se usa sino false
    address public ganador;

    constructor(uint _numeroGanador, uint256 _precio) public payable{
        owner =  msg.sender;
        num = 0;
        numGanador = _numeroGanador;
        precio = _precio;
        juego = true;
    }

    function comprobarAciertos(uint256 _num) private view returns(bool){
        if(_num == numGanador){
            return  true;
        }else{
            return false;
        }

    }
    

    function numeroRandom() private view returns(uint256){
        return uint256( keccak256( abi.encode(now, msg.sender, num)))% 10 ;
    }


function participar() external payable returns(bool resultado, uint256 numero){
    require(juego == true); 
    require(msg.value == precio);
    uint256 numUsuario = numeroRandom();
    bool acierto = comprobarAciertos(numUsuario);
    
    if(acierto == true){
        juego = false;
        msg.sender.transfer(address(this).balance + (num * (precio/2)));
        ganador = msg.sender;
        resultado = true;
        numero = numUsuario;
    }else{
        num++;
        resultado = false;
        numero = numUsuario;
    }
}
    function verPremio() view public returns(uint256){
        return address(this).balance - (num * (precio/2));
    }
  
    function retirarFondosContrato() external returns(uint256){
        require(msg.sender == owner);
        require(juego == false);
        msg.sender.transfer(address(this).balance);
        return address(this).balance;
    }
}

