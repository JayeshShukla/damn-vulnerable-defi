https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/node_modules/@openzeppelin/contracts/utils/Address.sol#L122-L142

```solidity
 /**
     @dev value : 0 call -> function selector
            reverts if no contract
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
```


https://github.com/JayeshShukla/damn-vulnerable-defi/blob/207d65b756fc8a011089b8a1e4d85bbfae58e84c/node_modules/@openzeppelin/contracts/utils/Address.sol#L203-L226

```solidity
    /**
      succes -> returndata (function selector return)
            failure && returndata.length > 0 ? returndata : errormessage
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                /// @solidity memory-safe-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
```