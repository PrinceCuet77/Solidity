- [Learning Solidity from YT](#learning-solidity-from-yt)
  - [Variables](#variables)

# Learning Solidity from YT

## Variables

- `uint` range:

![uint range](Photo/uint-range.png)

- Function:

![Function](Photo/function.png)

- If I **modify** the state variable then use only `public`

```js
//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Calculator {
  uint256 result = 0;

  function add(uint256 num) public {
    result += num;
  }
}
```

- If I **don't modify** the declared contract variable then use `public view`

```js
//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Calculator {
  uint256 result = 0;

  function add(uint256 num) public view {
    return result;
  }
}
```
