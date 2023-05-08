//SPDX-License-Identifier: GLP-3.0

pragma solidity 0.8.18;

contract SimpleAlmacen{
    uint  almacenDatos;
    function set(uint x) public  {
        almacenDatos = x;
    }
    function get() public view returns(uint)  {
        return almacenDatos;
    }
    

}