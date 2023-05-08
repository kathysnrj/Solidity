// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract Test {
                          
    uint num1 = 2;
    uint num2 = 4;
 
   function getResult(
   ) public view returns(
     uint producto, uint sum){
      producto = num1 * num2;
      sum = num1 + num2;
   }
}