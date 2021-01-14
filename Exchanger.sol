// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.7.5;

//MATH OPERATIONS -- designed to avoid possibility of errors with built-in math functions
library SafeMath {
    //@dev Multiplies two numbers, throws on overflow.
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
    //@dev Integer division of two numbers, truncating the quotient (i.e. rounds down).
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        return c;
    }
    //@dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        uint256 c = a - b;
        return c;
    }
    //@dev Adds two numbers, throws on overflow.
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
//end library
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Ownable {
    address internal _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Exchanger is Ownable {
	address public tokenA;
	address public tokenB;
	uint256 public exchangeRate; //exchange rate is amount B per 10^18 A tokens. this allows the price of either A or B to be greater, with a single exchange rate for the two
	uint256 constant internal RAY = 1e18; //multiplier for calculating exchanges
	constructor(address _tokenA, address _tokenB, uint256 initRate) {
		tokenA = _tokenA;
		tokenB = _tokenB
		exchangeRate = initRate;
	}
	function swapAtoB(uint256 amountA) external {
		uint256 amountB = getAmountB(amountA);
		require(IERC20(tokenB).balanceOf(address(this)) >= amountB, "swapAtoB: trade is too large");
		IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
		IERC20(tokenB).transfer(msg.sender, amountB);
	}
	function swapBtoA(uint256 amountB) external {
		uint256 amountA = getAmountA(amountB);
		require(IERC20(tokenA).balanceOf(address(this)) >= amountA, "swapBtoA: trade is too large");
		IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);
		IERC20(tokenA).transfer(msg.sender, amountA);
	}
	function getamountB(uint256 amountA) internal returns(uint256) {
		uint256 amountB = (amountA.mul(exchangeRate)).div(RAY);
		return amountB;
	}
	function getamountA(uint256 amountB) internal returns(uint256) {
		uint256 amountA = (amountB.mul(RAY)).div(exchangeRate);
		return amountA;
	}
	function setRate(uint256 newRate) external onlyOwner() {
		exchangeRate = newRate;
	}
	function transferERC20(address tokenAddress, address dest, uint256 amountTokens) external onlyOwner() {
		IERC20(tokenAddress).transfer(dest, amountTokens);
	}
}
