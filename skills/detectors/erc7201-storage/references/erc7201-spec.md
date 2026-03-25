# ERC-7201 Reference

## Standard

EIP-7201: Namespaced Storage Layout
Status: Final

## Key Points

- Defines a formula for deriving storage slot locations for structs: `keccak256(abi.encode(uint256(keccak256(id)) - 1)) & ~bytes32(uint256(0xff))`
- The `id` is a string like `"openzeppelin.storage.ERC20"`
- The `& ~bytes32(uint256(0xff))` clears the last byte, ensuring a 256-slot aligned namespace
- NatSpec annotation `@custom:storage-location erc7201:<id>` is required on the struct for tooling support

## OpenZeppelin Convention

OpenZeppelin uses the namespace pattern `openzeppelin.storage.<ContractName>`:

```solidity
/// @custom:storage-location erc7201:openzeppelin.storage.ERC20
struct ERC20Storage {
    mapping(address account => uint256) _balances;
    mapping(address account => mapping(address spender => uint256)) _allowances;
    uint256 _totalSupply;
}
```

The slot is derived and accessed via:

```solidity
bytes32 private constant ERC20StorageLocation =
    0x52c63247e1f47db19d5ce0460030c497f067ca4cebf71ba98eeadabe20bace00;

function _getERC20Storage() private pure returns (ERC20Storage storage $) {
    assembly {
        $.slot := ERC20StorageLocation
    }
}
```

## Common Mistakes

1. Forgetting the annotation entirely (struct works but tooling can't verify layout)
2. Using `@custom:storage-slot` (incorrect key — must be `storage-location`)
3. Using `@custom:storage-definition` (incorrect key)
4. Omitting the `erc7201:` scheme prefix
5. Using a namespace that doesn't match the keccak input string
