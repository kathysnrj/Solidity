
 
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.1;


interface IERC20 {
   
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
	//para aprobar permisos otra cartera actue en nuestro nombre
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


pragma solidity 0.8.12;


interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint256);
}

pragma solidity 0.8.12;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // 
        return msg.data;
    }
}

pragma solidity 0.8.12;


contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping (address => uint256) private _balances; //
    mapping (address => mapping (address => uint256)) private _allowances; //
    uint256 private _totalSupply;//la cantidad total de token
    uint256 private _decimals;//decimales que usaremos en nuestra moneda
    string private _name;//nombre
    string private _symbol;//simbolo de nuestro token
    address private _owner;//propietario del contrato



    constructor (string memory name_, string memory symbol_,uint256 initialBalance_,uint256 decimals_) {// 
        _name = name_; //nombre del token
        _symbol = symbol_; //simbolod el token
        _totalSupply = initialBalance_* 10**decimals_; // 
        _balances[msg.sender] = _totalSupply;
        _decimals = decimals_;
        _owner = msg.sender;//
        emit Transfer(address(0), msg.sender, _totalSupply);//ev
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint256) {
        return _decimals;
    }

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
        return _allowances[owner][spender];//per
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);//s
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
        require(sender != address(0), "Transfer from the zero address");//co
        require(recipient != address(0), "Transfer to the zero address");//co 

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer amount exceeds balance");//v

        _balances[sender] = senderBalance - amount;//restar ao
        _balances[recipient] += amount;//sumar a
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");
       _allowances[owner][spender] = amount;//permite aprovacion
        emit Approval(owner, spender, amount);
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