// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;

contract SmartParking {
    uint256 public UserCount;
    uint256 public fishCount; // Updated from fishCount
    struct User {
        uint256 id;
        string name;
        string password;
        string phone;
    }

    struct Fish { // Updated from Fish
        uint256 id;
        string type_poisson; // Updated from brand
        string image_url; // Updated from lisencePlate
        string localisation; // Updated from model
    }

    mapping(uint256 => User) public users;
    mapping(uint256 => Fish) public fishes; // Updated from fishs

    constructor() public {
        UserCount = 0;
        fishCount = 0;
    }

    event UserAdded(uint256 _id);
    event UserDeleted(uint256 _id);
    event UserEdited(uint256 _id);
    event FishAdded(uint256 _id); // Updated from FishAdded
    event FishDeleted(uint256 _id); // Updated from FishDeleted
    event FishEdited(uint256 _id); // Updated from FishEdited

    function getUserCount() public view returns (uint256) {
        return UserCount;
    }

    function addUser(
        string memory _name,
        string memory _password,
        string memory _phone
    ) public {
        users[UserCount] = User(
            UserCount,
            _name,
            _password,
            _phone
        );
        emit UserAdded(UserCount);
        UserCount++;
    }

    function deleteUser(uint256 _id) public {
        delete users[_id];
        UserCount--;
        emit UserDeleted(_id);
    }

    function editUser(
        uint256 _id,
        string memory _name,
        string memory _password,
        string memory _phone
    ) public {
        users[_id] = User(_id, _name, _password, _phone);
        emit UserEdited(_id);
    }

    function getFishCount() public view returns (uint256) { // Updated from getFishCount
        return fishCount;
    }

    function addFish(
        string memory _type_poisson, // Updated from _brand
        string memory _image_url, // Updated from _lisencePlate
        string memory _localisation // Updated from _model
    ) public {
        fishes[fishCount] = Fish(
            fishCount,
            _type_poisson,
            _image_url,
            _localisation
        );
        emit FishAdded(fishCount); // Updated from FishAdded
        fishCount++;
    }

    function deleteFish(uint256 _id) public { // Updated from deleteFish
        delete fishes[_id];
        fishCount--;
        emit FishDeleted(_id); // Updated from FishDeleted
    }

    function editFish(
        uint256 _id,
        string memory _type_poisson, // Updated from _brand
        string memory _image_url, // Updated from _lisencePlate
        string memory _localisation // Updated from _model
    ) public {
        fishes[_id] = Fish(_id, _type_poisson, _image_url, _localisation);
        emit FishEdited(_id); // Updated from FishEdited
    }
}
