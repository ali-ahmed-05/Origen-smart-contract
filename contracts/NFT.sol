// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "hardhat/console.sol";


contract NFT is ERC721Enumerable , Ownable {

    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIds;
    Counters.Counter public _packageIds; // 1 - 17

    struct Package{
        uint256 price;
        string URI;
        bool exist;
        bool _isActive;
    }mapping (uint256 => Package) public package;

    address private token;
    
    // uint256 public tokenIds; 
    mapping (uint256 => string) private _tokenURIs;
  //  mapping (uint256 => string) private _packageURIs;
  //  mapping (uint256 => bool) private _packageExist;
    mapping (uint256 => uint256) private _tokenIDToPackage;
  //  mapping (uint256 => bool) private _isActive;


    
    mapping(address => bool) private _owner;

    constructor() ERC721("Origen", "Origen")  {
        _owner[_msgSender()] = true;
    }

    modifier mint_mod(uint256 ID , bool _bool) {
        require(package[ID]._isActive == _bool, "Unactive : requested id not available");
        require(package[ID].exist , "nonexistent Package");
        _;
    }

    function addOwner(address owner_) public {
        require(_owner[_msgSender()]==true,"cannot Assign owner");
        _owner[owner_]=true;
    }

    function baseURI() public view returns(string memory){
        return "https://origen.mypinata.cloud/ipfs/";
    }

    function enablePackage(uint256 ID) mint_mod(ID , false) onlyOwner public {
        package[ID]._isActive = true;
    }

    function disablePackage(uint256 ID) mint_mod(ID , true) onlyOwner public {
        package[ID]._isActive = false;
    }

    function createPackage(string memory packageURI , uint256 _price) onlyOwner public payable returns (uint) {
        _packageIds.increment();
        uint256 _id = _packageIds.current();
        setPackageURI(_id,packageURI);
        package[_id]._isActive = true;
        package[_id].exist = true;
        package[_id].price = _price;
        return _id;
    }

    function createToken(uint256 ID) mint_mod(ID , true) public payable returns (uint) {
        IERC20(token).transferFrom(_msgSender() , address(this) , package[ID].price);
        uint256 _id = getTokenId();
        _mint(_msgSender(), _id);
        setTokenURI(_id,createTokenURI(_id));
        _tokenIDToPackage[_id] = ID;
        return _id;
    }
   
    function setTokenURI(uint256 tokenId, string memory tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = tokenURI;
    }

    function setPackageURI(uint256 packageId, string memory packageURI) internal virtual {
        package[packageId].URI = packageURI; 
    }
    function setPackagePrice(uint256 packageId , uint256 _price) internal virtual {
        package[packageId].price = _price; 
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory _packageURI = package[_tokenIDToPackage[tokenId]].URI;
        string memory base = baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _packageURI , _tokenURI));
        }
        return super.tokenURI(tokenId);
    }
    
    function createTokenURI(uint256 tokenId) public view returns (string memory) {
        // string memory _packageURI = _packageURIs[packageId];
        // string memory base = baseURI();
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        // return string(abi.encodePacked(base, _packageURI  , Strings.toString(tokenId)));  
        return string(abi.encodePacked(Strings.toString(tokenId)));  
    }

    // for development
    

    function getTokenId() internal returns (uint256) {
            _tokenIds.increment();
            return _tokenIds.current();
    }

    function withdrawEth() public onlyOwner {
        (bool callSuccess, ) = payable(owner()).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Something went wront. Eth is not transferred");
    }

    function totalSupply() public override view returns(uint256){
        return _tokenIds.current();
    }

    

    function setTokenAddress(address _token) public onlyOwner{
        require(_token != address(0),"0 address");
        token = _token ;
    }
    
}