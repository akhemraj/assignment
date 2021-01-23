pragma solidity >=0.7.0;

contract ShopKeep{
    
    address payable owner;
    address payable buyer;
    
    constructor(){
        owner = msg.sender;
    }
    
    struct Item{
        string name;
        uint price;
        uint quantity;
    }    

    mapping (string => Item) public items;
    
    modifier onlyOwner{
        require(
          msg.sender == owner 
        );
        _;
    }
    
    modifier checkAmount{
        require(
          msg.sender.balance >= msg.value
        );_;
    }
    
    function setItem(string memory _name, uint  _price, uint  _quantity) public onlyOwner{
        
        Item storage item = items[_name];
        item.name = _name;
        item.price = _price;
        item.quantity = _quantity;
        
    }
    
    function getItems(string memory _name) view  public returns(string memory, uint, uint){
        return (items[_name].name, items[_name].price, items[_name].quantity);
    }
    
    function buyItem(string memory _name) payable public checkAmount{
        Item storage boughtItem = items[_name]; 
        require(msg.value == boughtItem.price*1000000000000000000, "Price not matching");
        require(boughtItem.quantity > 0);
        reduceQuantity(_name);
    }
    
    function reduceQuantity(string memory _name) internal returns(uint){
        Item storage boughtItem = items[_name];
        boughtItem.quantity = boughtItem.quantity - 1;
        items[_name] = boughtItem;
        return boughtItem.quantity;
    }
    
    function totalItemsRemaining(string memory _name) view public returns(uint){
        return (items[_name].quantity);
    }
    
    
}