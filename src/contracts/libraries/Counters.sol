// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./SafeMath.sol";

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
 * directly accessed.
 */

library Counters {
    using SafeMath for uint256;

    // build your own variable type with the keyword 'struct'

    /** Keep trqck of our values of arithmetic changes to our code. */
    struct Counter {
        uint256 value;
    }

    /** Find the current value of the counter */
    // Declare the parameter as 'storage' because we modify its state and we want to preserve it.
    function current(Counter storage counter) internal view returns (uint256) {
        return counter.value;
    }

    /** Decrement the counter */
    function decrement(Counter storage counter) internal {
        counter.value = counter.value.sub(1);
    }

    /** Increment the counter */
    function increment(Counter storage counter) internal {
        counter.value += 1;
    }
}
