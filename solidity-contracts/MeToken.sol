pragma solidity 0.4.19;


contract meToken {

  // Public Variables of the token
    string public name;
    string public symbol;
    uint public totalSupply;
    uint8 public decimals;
    mapping(address => uint) public balances;
    mapping(address => mapping (address => uint256)) internal allowed;
    uint public tokenPrice = 100 szabo;

    //Private variables
    address private beneficiary = 0xff1A7c1037CDb35CD55E4Fe5B73a26F9C673c2bc;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Purchase(address indexed purchaser, uint tokensBought, uint amountContributed);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    function meToken() public {

        name = "ME Token";
        symbol = "MET";
        decimals = 18;
        totalSupply = 100000000 * 10**uint(decimals);
        balances[beneficiary] = totalSupply; // All tokens initially belong to me until they are purchased

        Transfer(address(0), beneficiary, totalSupply);
    }
    // Any transaction sent to the contract will trigger this anonymous function
    // All ether will be sent to the purchase function
    function () public payable {
        purchase(msg.sender);
    }

    function name() public view returns (string) {
        return name;
    }

    function symbol() public view returns (string) {
        return symbol;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(balances[msg.sender] + _value >= balances[msg.sender]);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }
    // Purchase tokens from my reserve
    function purchase(address _buyer) public payable returns (bool) {
        require(_buyer != address(0));
        require(balances[beneficiary] > 0);
        require(msg.value != 0);

        uint memory amount = msg.value / tokenPrice;
        beneficiary.transfer(msg.value);
        balances[beneficiary] -= amount;
        balances[_to] += amount;
        Transfer(beneficiary, _buyer, amount);
        Purchase(_buyer, amount, msg.value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    // ERC-20 Approval functions
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}
