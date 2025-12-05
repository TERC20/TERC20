// SPDX-License-Identifier: MIT
// Factory: CreateMyToken (https://www.createmytoken.com)
pragma solidity 0.8.30;

struct AuthInfo {
    address owner;
}

struct TokenInfo {
    string name;
    string symbol;
    uint8 decimals;
}

struct SupplyInfo {
    address mintTarget;
    uint256 initialSupply;
    uint256 maxSupply;
}

struct AntiWhaleConfig {
    uint256 maxHoldingPercent;
    address[] maxHoldingExemptAddresses;
}

struct DeflationaryConfig {
    uint256 burnPercent;
    address[] burnExemptAddresses;
}
