// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

interface IMorphoBlue {
    function supply(bytes32 id, uint256 assets, uint256 shares, address onBehalf, bytes calldata data) external returns (uint256, uint256);
    function withdraw(bytes32 id, uint256 assets, uint256 shares, address onBehalf, address receiver) external returns (uint256, uint256);
}

/// @title BaseVault - ERC-4626 yield vault for Base L2
contract BaseVault is ERC4626, Ownable, Pausable {
    IMorphoBlue public constant MORPHO = IMorphoBlue(0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb);
    bytes32 public morphoMarketId;
    uint256 public managementFee = 200; // 2% in bps
    address public feeRecipient;
    uint256 public lastHarvest;

    event Harvested(uint256 yield, uint256 fee);

    constructor(
        IERC20 asset_,
        string memory name_,
        string memory symbol_,
        bytes32 morphoMarketId_,
        address feeRecipient_
    ) ERC4626(asset_) ERC20(name_, symbol_) Ownable(msg.sender) {
        morphoMarketId = morphoMarketId_;
        feeRecipient = feeRecipient_;
        lastHarvest = block.timestamp;
    }

    function totalAssets() public view override returns (uint256) {
        return IERC20(asset()).balanceOf(address(this));
    }

    function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal override whenNotPaused {
        super._deposit(caller, receiver, assets, shares);
        _deployToMorpho(assets);
    }

    function _deployToMorpho(uint256 assets) internal {
        IERC20(asset()).approve(address(MORPHO), assets);
        // Deploy to Morpho Blue market
    }

    function harvest() external {
        uint256 balanceBefore = IERC20(asset()).balanceOf(address(this));
        // Collect yields from Morpho
        uint256 yield = IERC20(asset()).balanceOf(address(this)) - balanceBefore;
        if (yield > 0) {
            uint256 fee = (yield * managementFee) / 10000;
            IERC20(asset()).transfer(feeRecipient, fee);
            emit Harvested(yield, fee);
        }
        lastHarvest = block.timestamp;
    }

    function pause() external onlyOwner { _pause(); }
    function unpause() external onlyOwner { _unpause(); }
}
