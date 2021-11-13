pragma solidity >=0.5.0;

contract Decentragram {
  string public name = 'Decentragram';

  // Store Images
  mapping(uint => Image) public images;
  // 'images' is now a ƒn

  struct Image {
    uint id; // uint = unsigned integer. non-negative number.
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  // Create Images
  function uploadImage() public {
    // how to add new images to the mapping:
    images[1] = Image(1, 'abc123', 'Hello, world.', 0, address(0x0));
  }

  // Tip Images
}