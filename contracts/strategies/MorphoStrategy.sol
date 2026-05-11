// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IMorpho {
    function supply(bytes32 id, uint256 assets, uint256 shares, address onBehalf, bytes memory data) external returns (uint256, uint256);
    function withdraw(bytes32 id, uint256 assets, uint256 shares, address onBehalf, address receiver) external returns (uint256, uint256);
}

contract MorphoStrategy {
    IERC20 public immutable asset;
    IMorpho public constant MORPHO = IMorpho(0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb);
    bytes32 public marketId;
    address public vault;

    uint256 public totalDeposited;

    constructor(address asset_, bytes32 marketId_, address vault_) {
        asset = IERC20(asset_); marketId = marketId_; vault = vault_;
    }

    function deposit(uint256 assets) external {
        require(msg.sender == vault, "Not vault");
        asset.approve(address(MORPHO), assets);
        MORPHO.supply(marketId, assets, 0, address(this), "");
        totalDeposited += assets;
    }

    function withdraw(uint256 assets) external returns (uint256) {
        require(msg.sender == vault, "Not vault");
        MORPHO.withdraw(marketId, assets, 0, address(this), vault);
        totalDeposited -= assets;
        return assets;
    }

    function totalAssets() external view returns (uint256) { return totalDeposited; }
}