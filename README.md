HRChain
Steps
Check the installed versions of npm and node:

Run npm -v to check the npm version.
Run node -v to check the node version.
Check the installed versions of Truffle, Ganache, Solidity, Node, and Web3.js:

Run truffle version to display the versions.
The output should look like this:
Truffle v5.11.5 (core: 5.11.5)
Ganache v7.9.1
Solidity - 0.8.20 (solc-js)
Node v20.9.0
Web3.js v1.10.0
Compile the contracts:
- Run truffle compile.
- The output should look like this:
```
Compiling your contracts...
Compiling .\contracts\DateTime.sol
Compiling .\contracts\HRChain.sol
Compiling .\contracts\cryptography\ECDSA.sol
Artifacts written to C:[filepath]
Compiled successfully using:
- solc: 0.8.20+commit.a1b79de6.Emscripten.clang


Run the development server:

Run npm run dev.
Make sure to replace [filepath] with the actual file path in the output of the truffle compile command.

These steps will help you set up and run HRChain on your local environment.
