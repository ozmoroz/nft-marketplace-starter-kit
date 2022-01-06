// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    /** Safe addition function */
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 r = x + y;
        require(r >= x, "Error: Safemath - addition overflow");
        return r;
    }

    /** Safe subtraction function */
    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
        require(x >= y, "Error: Safemath - addition overflow");
        uint256 r = x - y;
        return r;
    }

    /** Safe multiplication function */
    function mul(uint256 x, uint256 y) internal pure returns (uint256) {
        // gas optimisation
        if (x == 0) return 0;
        uint256 r = x * y;
        require(r / x == y, "Error: Safemath - multiplication overflow");
        return r;
    }

    /** Safe division function */
    function div(uint256 x, uint256 y) internal pure returns (uint256) {
        // gas optimisation
        if (x == 0) return 0;
        require(y > 0, "Error: Safemath - division overfby zero");
        return x / y;
    }

    /** Safe modulo function */
    function mod(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "Error: Safemath - modulo by zero");
        return x % y;
    }
}
