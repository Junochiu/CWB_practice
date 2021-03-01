pragma solidity 0.7.0 <0.8.0;

import "./Ownable.sol";

struct TOKEN
{
    string Name;
    string Symbol;
    uint8 Dec;
    uint Amount;
}

contract ERC20Token is Ownable
{
    mapping(address => uint) balances;
    mapping(address => mapping(address=>uint)) allowed;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    TOKEN public token = TOKEN({Name:"Jutok",Symbol:"Ju",Dec:18,Amount:10000});
    
    // ERC20 functions
    function name() public view returns(string memory) {return token.Name;}
    function symbol() public view returns(string memory) {return token.Symbol;}
    function decimals() public view returns(uint8) {return token.Dec;}
    function totalSupply() public view returns(uint256) {return token.Amount;}
    function balanceOf(address _owner) public view returns (uint256 balance) {return balances[_owner];}
    
    function transfer(address _to, uint _value) public returns (bool success){
        require(balances[msg.sender] >= _value,'not enough token for transfer');
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint _value) public returns(bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns(bool success)
    {
        require(balances[_from] >= _value);
        require(allowed[_from][msg.sender] >= _value);
        require(_from != address(0),"transfer from address(0)");
        require(_to != address(0),"transfer to address(0)");
        balances[_from] = balances[_from] - _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint remaining)
    {
        return allowed[_owner][_spender];
    }
    
    // Ownable
    function mint(address _to, uint _value) public onlyOwner
    {
        require(_to != address(0),"mint into address(0)");
        balances[_to] = _value;
        token.Amount += _value;
        emit Transfer(address(0),_to,_value);
    }
    
    function buy_token(address _buyer) payable external
    {
        /*uint eth2tkn = 1;
        require(msg.value == _value*eth2tkn);
        balances[_buyer] += _value*eth2tkn;
        token.Amount += _value*eth2tkn;
        emit Transfer(address(0),_buyer,_value);
        */
        uint _value = msg.value;
        balances[_buyer] += _value;
        token.Amount += _value;
        emit Transfer(address(0),_buyer,_value);
    }
    
    function withdraw_eth() external onlyOwner
    {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
    }
}
