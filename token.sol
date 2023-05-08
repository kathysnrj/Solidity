// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.2 <0.9.0;
 




interface IToken {
   
    function totalSupply() external view returns (uint256);//implemnetar cantidad de token que hay
    function balanceOf(address account) external view returns (uint256);//cuantos token tiene una direccion
    function transfer(address recipient, uint256 amount) external returns (bool);//enviar token de una cartera a otra cartera
    function allowance(address owner, address spender) external view returns (uint256);//implementar permisos una carter apermita a otroa cartera usar o enviar token 
	
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}





interface IERC20Metadata is IToken {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint256);
}



abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode
        return msg.data;
    }
}




contract Token is Context, IToken, IERC20Metadata {
    mapping (address => uint256) private _balances; //guardando los balances para llevar un control de numero de token de cada cartera
    mapping (address => mapping (address => uint256)) private _allowances; //pertenecias o permisos que carteras esta dando permiso a otrs cartera para que gaste en su nombre
    uint256 private _totalSupply;//la cantidad total de token
    uint256 private _decimals;//decimales que usaremos en nuestra moneda
    string private _name;//nombre
    string private _symbol;//simbolo de nuestro token
    address private _owner;//propietario del contrato


//memory que la variable se va a gusrdar en memoria, existe mientras ocurra la llamada a la funcion
    constructor (string memory name_, string memory symbol_,uint256 initialBalance_,uint256 decimals_) {//cuando desplegamos el token se depliega el contructor 
        _name = name_; //nombre del token
        _symbol = symbol_; //simbolod el token
        _totalSupply = initialBalance_* 10**decimals_; //total supllay, balance incial que hemos dicho en el despliegue 100 token 18 decimales = 
        _balances[msg.sender] = _totalSupply;
        _decimals = decimals_;
        _owner = msg.sender;//propietario del contrato la cartera que crea el token
        emit Transfer(address(0), msg.sender, _totalSupply);//evento de tranferencia desde la direccion 0 al ejecutar de este contrato se le va a enviar todos los token
    }
//Una función que permite que un contrato de herencia anule su comportamiento se marcará como virtual.
// La función que anula esa función base debe marcarse como anulad
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint256) {
        return _decimals;
    }
//Una función que permite que un contrato de herencia anule su comportamiento se marcará como virtual. La función que anula esa función base debe marcarse como anulad
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];//permisos que le ha dado una cartera a otra
    }
// aprovar que una persona puede enviar unos de mis tokes, amount es la cantidad 
//_spender es el que autoriza
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);//solcitar la aprovacion de la cartera que hizo el despliegue a otra cartera
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "Transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

   
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "Decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }


    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "Transfer from the zero address");//compreba que no sea una direccion nula
        require(recipient != address(0), "Transfer to the zero address");//compreba que no sea una direccion nula

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer amount exceeds balance");//ver que tenenmos token para enviar sino no se enviara ejemplo 100 token

        _balances[sender] = senderBalance - amount;//restar a su balence la cantidad q se le ha enviado
        _balances[recipient] += amount;//sumar a su balence la cantidad q se le ha enviado

        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "Approve from the zero address");//compreba que no sea una direccion nula
        require(spender != address(0), "Approve to the zero address");//compreba que no sea una direccion nula
        _allowances[owner][spender] = amount;//permite aprovacion
        emit Approval(owner, spender, amount);//ejecuta evento que debe haber una aprovacion de parte de la cartera propietaria
    }

    /*function mint(uint256 amount) public returns(bool) {
        require(msg.sender == _owner, "Only the owner can mint new tokens");
        _totalSupply += amount;
        _balances[_owner] += amount;
        emit Transfer(address(0), _owner, amount);
        return true;
    }
    function burn(uint256 amount) public returns(bool) {
        require(_balances[msg.sender] >= amount, "Amount exceeded");
        _totalSupply -= amount;
        _balances[msg.sender] -= amount;
        emit Burn(msg.sender, amount);
        return true;
    }*/
}