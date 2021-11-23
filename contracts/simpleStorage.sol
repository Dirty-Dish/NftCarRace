// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
contract SimpleStorage {
    
    uint256 favNum;
//    bool favBool = true;
//    string favString = "string";
//    int256 favInt = -5;
//    address favAddy = 0xDFa4F5260D357ebD423bEa850f73219c611A2E2d;
//    bytes32 favBite = "cat";

    struct People {
        uint256 favNum;
        string name;
    }
    
    People[] public people;
    mapping(string => uint256) public nameToFavNum;

    function store(uint256 _2ndNum) public returns(uint256){
        favNum = _2ndNum;
        return favNum;
    }
    // view and pure functions do not hange blockchain
    // they just read from it, o no gas fee
    function retrieve() public view returns(uint256){
        return favNum;
    }
    
    //memory means keep till exicution
    //storage means keep forever
    function addPerson(string memory _name, uint256 _favNum) public {
        people.push(People(_favNum, _name));
        nameToFavNum[_name] = _favNum;
    }
}