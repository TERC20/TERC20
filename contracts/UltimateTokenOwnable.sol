// SPDX-License-Identifier: MIT
// Factory: CreateMyToken (https://www.createmytoken.com)
pragma solidity 0.8.30;

import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

import { Initializable } from "@solady/utils/Initializable.sol";
import { Ownable } from "@solady/auth/Ownable.sol";
import { ERC20 } from "@solady/tokens/ERC20.sol";

import { AuthInfo, TokenInfo, SupplyInfo } from "@tokens/utils/Structs.sol";

contract UltimateTokenOwnable is Initializable, ERC20, Ownable {
    TokenInfo internal _tokenInfo;

    uint256 public maxSupply;
    bool public paused;

    error ERC20ExceededCap(uint256 increasedSupply, uint256 maxSupply);
    error ERC20TransferPaused();

    function initialize(
        AuthInfo memory authInfo,
        TokenInfo memory tokenInfo,
        SupplyInfo memory supplyInfo
    ) public initializer {
        maxSupply = Math.max(supplyInfo.maxSupply, supplyInfo.initialSupply);

        _mint(supplyInfo.mintTarget, supplyInfo.initialSupply);
        _initializeOwner(authInfo.owner);

        _tokenInfo = tokenInfo;
    }

    function name() public view virtual override returns (string memory) {
        return _tokenInfo.name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _tokenInfo.symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return _tokenInfo.decimals;
    }

    function setTransferPaused(
        bool _paused
    ) external onlyOwner {
        paused = _paused;
    }

    function _beforeTokenTransfer(
        address,
        address,
        uint256
    ) internal view virtual override {
        require(!paused, ERC20TransferPaused());
    }

    function mint(
        address to,
        uint256 amount
    ) external onlyOwner {
        if (totalSupply() + amount > maxSupply) {
            revert ERC20ExceededCap(totalSupply() + amount, maxSupply);
        }

        super._mint(to, amount);
    }

    function burn(
        uint256 value
    ) external {
        super._burn(msg.sender, value);
    }

    function disableInitializer() external initializer { }
}
