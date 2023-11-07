// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//import required packages
import "./cryptography/ECDSA.sol";
import "./DateTime.sol";

contract HR_Chain {
    //--------------------------- Settings---------------------------
    struct Client {
        string name;
        uint8 userID;
        string[] info; //User can add their self intro, etc
        uint8 docCount; //default = 0
        uint8 stageAcc; //default = 0
    }

    struct DocDetails {
        string docInfo;
        uint256 timestamp; // Timestamp of when the signature is recorded
        bytes32 hash; // Cryptographic hash of the document's content
        bytes signature;
    }

    //Used to store the addresses of certificated companies/schools
    address[] certifiedList;

    //Used to store the addresses
    address[] clientList;

    address public admin;

    mapping(address => Client) public client;
    mapping(address => mapping(uint => DocDetails)) docs;

    uint public startTime;

    //enum used to keep track of stages
    enum stageAcc {
        Init,
        AccVerified
    }

    constructor() {
        admin = msg.sender;

        startTime = block.timestamp;

        //Add the admin addresses to the certifiedList
        certifiedList.push(msg.sender);
    }

    //---------------------------modifiers---------------------------
    modifier adminOnly() {
        require(msg.sender == admin, "Only accessible by admin!");
        _;
    }

    bool isMatch; //default = false

    //Only accessible by admin and verifiedInstitutions
    modifier accessedOnly() {
        //check whether the msg.sender is a certified Institution
        for (uint8 i = 0; i < clientList.length; i++) {
            if (msg.sender == clientList[i]) {
                isMatch = true;
            }
        }

        require(msg.sender == admin || isMatch, "Access Denied");
        _;

        isMatch = false;
    }

    //Only client can access this function
    modifier clientOnly() {
        //check whether the inputted address is in the registered_patient array
        isExistingClient(msg.sender);
        require(isClient, "Registered client only!");

        //reset the bool
        isClient = false;
        _;
    }

    modifier validAcc(address _address) {
        require(
            client[_address].stageAcc == uint8(stageAcc.AccVerified),
            "Account not yet verified."
        );
        _;
    }

    //------------------------------------------------------------------------
    function timeNow() external view returns (uint) {
        return block.timestamp;
    }

    function Certified_List() external view returns (address[] memory) {
        return certifiedList;
    }

    function Client_List() external view adminOnly returns (address[] memory) {
        return clientList;
    }

    function accRequest() external {
        require(msg.sender != admin, "Cannot register an admin account.");
        isExistingClient(msg.sender);
        require(!isClient, "Account already registered"); //isClient = false

        generate_ClientID();

        client[msg.sender].name = userID;
        client[msg.sender].userID = clientNo;

        client[msg.sender].docCount = 0;
        client[msg.sender].stageAcc = uint8(stageAcc.Init); //0

        clientList.push(msg.sender);
    }

    function register_client(address _addressClient) external adminOnly {
        require(_addressClient != admin);
        isExistingClient(_addressClient);
        require(!isClient, "Account already registered"); //isClient = false

        generate_ClientID();

        client[_addressClient].name = userID;
        client[_addressClient].userID = clientNo;

        client[_addressClient].docCount = 0;
        client[_addressClient].stageAcc = uint8(stageAcc.Init); //0

        client[_addressClient].stageAcc = uint8(stageAcc.AccVerified);

        clientList.push(_addressClient);
    }

    function verifyAcc(address _address) public adminOnly {

        isExistingClient(_address);
        require(isClient, "CLient not found.");

        isClient = false;

        if (client[_address].stageAcc == uint8(stageAcc.Init)) {
            client[_address].stageAcc = uint8(stageAcc.AccVerified);
        }
    }

    function set_username(string memory _name) external clientOnly {
        client[msg.sender].name = _name;
    }

    function add_info(string[] memory _info) external clientOnly {
        client[msg.sender].info = _info;
    }

    function return_info(
        address _address
    ) external view returns (string[] memory) {
        return client[_address].info;
    }

    event paymentSettled(address from, address to, uint amount);

    function make_payment(
        address payable toAddress
    ) public payable clientOnly validAcc(msg.sender) {
        toAddress.transfer(msg.value);

        emit paymentSettled(msg.sender, toAddress, msg.value);
    }

    //---------------------------For signature verification---------------------------
    //address[] certifiedList; //Use to store adresses of certified parties

    string docMessage;

    function generate_Doc(
        address _address,
        string memory message
    ) public accessedOnly returns (string memory) {
        for (uint8 i = 0; i < clientList.length; i++) {
            if (_address == clientList[i]) {
                docMessage = string(
                    abi.encodePacked(
                        client[_address].name,
                        "-",
                        uint2str(client[_address].userID),
                        "-",
                        uint2str(block.timestamp),
                        "-",
                        message
                    )
                );

                return docMessage;
            }
        }

        revert("Client not found.");
    }

    function record_signs(
        address _address,
        bytes32 _hash,
        bytes memory _signature
    ) external accessedOnly validAcc(_address) {
        require(
            docs[_address][client[_address].docCount].timestamp == 0,
            "Signature already recorded"
        ); // Check if document already exists

        DocDetails memory sign = DocDetails(
            docMessage,
            block.timestamp,
            _hash,
            _signature
        );
        docs[_address][client[_address].docCount] = sign;
        client[_address].docCount++;
    }

    function retrieve_signs(
        address _address,
        uint8 _docNum
    ) external view returns (string memory, uint256, bytes32, bytes memory) {
        _docNum--; //convert the entered 1-based input to 0-based
        return (
            docs[_address][_docNum].docInfo,
            docs[_address][_docNum].timestamp,
            docs[_address][_docNum].hash,
            docs[_address][_docNum].signature
        );
    }

    event certifiedListUpdated();

    function add_Certified(address _address) public adminOnly {
        //check whether the inputted address exists in the certifiedList already
        for (uint8 i = 0; i < certifiedList.length; i++) {
            if (_address == certifiedList[i]) {
                isMatch = true;
            }
        }

        //!isMatch := isMatch = false
        require(!isMatch, "Address already certified.");

        certifiedList.push(_address);
        isMatch = false; //reset isMatch

        emit certifiedListUpdated();
    }

    //verifies the signature with the ECDSA.sol library
    using ECDSA for bytes32;

    /*  Code explanation for function verifyDoc:
    Recover the signer's address from the hash and signature
    then compare it one by one in the address in the certifiedList
    to check its authenticity

    If the document/record stored is successfully verified
    (i.e. issued by our verified institutions or companies),
    then the result will be displayed with "true" and the signer's address.

    Else, the result will be displayed as "false", with a null address
    of 0x0000000000000000000000000000000000000000

*/
    function verifyDoc(
        bytes32 hash,
        bytes memory signature
    ) public view returns (bool, address) {
        // Recover the signer's address from the hash and signature
        address signer = hash.recover(signature);

        // Check if the recovered signer is in the expected signers list
        for (uint i = 0; i < certifiedList.length; i++) {
            if (signer == certifiedList[i]) {
                return (true, signer);
            }
        }

        // Signature is invalid if the recovered signer is not in the expected signers list
        // address(0) will return an address of: 0x0000000000000000000000000000000000000000
        return (false, address(0));
    }

    //Using the DateTime library for date conversion
    using DateTime for uint256;

    function timestampToDateTime(
        uint256 timestamp
    )
        external
        pure
        returns (
            uint256 year,
            uint256 month,
            uint256 day,
            uint256 hour,
            uint256 minute,
            uint256 second
        )
    {
        (year, month, day, hour, minute, second) = DateTime.timestampToDateTime(
            timestamp
        );
    }

    //---------------------------All internal function---------------------------
    //these 2 variables will be updated automatically
    string private userID = "Client0";
    uint8 private clientNo = 0;

    //interal function that is called by function register_Client()
    //to inctrement the ClientID, from Client0 --> Client1 --> Client2 etc
    function generate_ClientID() internal {
        clientNo++; //increment by 1
        //update new userID
        userID = string(abi.encodePacked("Client", uint2str(clientNo)));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = uint8(48 + (_i % 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }

        return string(bstr);
    }

    //check whether the _address has been registered as a client already
    bool isClient; //default = False

    //check whether it is a registered client already
    function isExistingClient(address _address) internal {
        //loop through the array named clientList
        //to check that whether the address is a client
        for (uint8 i = 0; i < clientList.length; i++) {
            if (_address == clientList[i]) {
                isClient = true;
                break;
            }
        }
    }
}
