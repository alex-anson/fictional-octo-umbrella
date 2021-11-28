pragma solidity >=0.5.0;

contract Decentragram {
  string public name = 'Decentragram';

  // Store Images
  uint public imageCount = 0;
  // use this to generate ids ^
  mapping(uint => Image) public images;
  // 'images' is now a ƒn ^

  struct Image {
    uint id; // uint = unsigned integer. non-negative number.
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

// pass in the values for the event
  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // create the event .. emit the event after an image has been tipped (in the tipImageOwner ƒn)
  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

// he uses the underscore convention to differentiate state variables and ƒn arguments 
// Solidity has a global variable - msg - it represents the global message that's coming in with the ethereum transaction. it has some properties on it (ex: msg.sender - the person who's calling the uploadImage function (it invokes when someone uploads an image) - it's their ethereum address)
// Solidity supports "events" - lets us know when things happen on the blockchain ... gives a lot of info
// Solidity 'safeguards' - 'require' ƒn .... first arg is an expression that'll evaluate to a boolean. if true, ƒn will continue execution. if false, it'll halt execution.
  // Create Images
  function uploadImage(string memory _imgHash, string memory _description) public {
    // Description and image must exist
    require(bytes(_imgHash).length > 0);
    require(bytes(_description).length > 0); // bytes is another data type
    // Make sure uploader address exists
    require(msg.sender != address(0x0));

    // Increment image id
    imageCount ++;

    // how to add new images to the mapping (Add Image to Contract) ⌄
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);

    // Trigger an event (see what data comes back)
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // Tip Images
  // 'payable' keyword is what allows you to send cryptocurrency when this ƒn is invoked
  function tipImageOwner(uint _id) public payable {
    // Make sure the id is valid. (make sure the image exists)
    require(_id > 0 && _id <= imageCount);

    // Fetch the image from storage
    Image memory _image = images[_id];
    // ^ Image = data type. memory = "it's not an image from storage" (this dude is the worst). "storage is on the blockchain.. this '_image' is a local variable in memory inside this ƒn call"

    // Fetch the image author. read it off of the struct
    address payable _author = _image.author;

    // Pay the author by sending them Ether
    // transfer = special solidity function. msg.value = amount of cryptocurrency
    address(_author).transfer(msg.value);

    // update some values on the _image before putting it back into the Struct
    // Increment the tip amount
    _image.tipAmount = _image.tipAmount + msg.value;
    // Update the image ... put the image back into the mapping (the Struct)
    images[_id] = _image;

    // Trigger the event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);

  }
}