pragma solidity ^0.4.15;

contract owned {
    address  public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract SimpleContract is owned {

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => bool) public frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event FrozenFunds(address indexed target, bool frozen);

    function SimpleContract(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter) {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        if (centralMinter != 0) owner = centralMinter;
    }

    function transfer(address _to, uint256 _value) {
        require(!frozenAccount[msg.sender]);
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function mintToken(address _target, uint256 _mintedAmount) onlyOwner {
        balanceOf[_target] += _mintedAmount;
        totalSupply += _mintedAmount;
        Transfer(0, owner, _mintedAmount);
        Transfer(owner, _target, _mintedAmount);
    }

    function freezeAccount(address _target, bool _freeze) onlyOwner {
        require(_target != owner);
        frozenAccount[_target] = _freeze;
        FrozenFunds(_target, _freeze);
    }

}