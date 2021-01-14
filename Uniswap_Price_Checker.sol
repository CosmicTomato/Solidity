
pragma solidity ^0.7.4;

interface Token {
    function decimals() external view returns (uint);
}
interface IUniswapV2Router {
    function WETH() external pure returns (address);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

contract PriceChecker{
	address public constant uniswapV2router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
	IUniswapV2Router router = IUniswapV2Router(uniswapV2router);

    function shitcoinPrice(address tokenAddress) public view returns (uint) {
    	uint amountIn = getAmountIn(tokenAddress);
        address[] memory _path = new address[](2);
        _path[0] = tokenAddress;
        _path[1] = router.WETH();
        uint[] memory _amts = router.getAmountsOut(amountIn, _path);
        return _amts[1];
    }

    function getEthPerToken(address tokenAddress) public view returns (uint[] memory) {
    	uint amountIn = getAmountIn(tokenAddress);
        address[] memory _path = new address[](2);
        _path[0] = tokenAddress;
        _path[1] = router.WETH();
        uint[] memory _amts = router.getAmountsOut(amountIn, _path);
        return _amts;
    }

    function getAmountIn(address tokenAddress) public view returns (uint) {
    	Token token = Token(tokenAddress);
    	uint decimals = token.decimals();
    	uint amountIn = (10 ** decimals);
    	return amountIn;
    }

    function getDecimals(address tokenAddress) public view returns (uint) {
    	uint decimals = Token(tokenAddress).decimals();
    	return decimals;
    }
}