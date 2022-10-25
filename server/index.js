const PORT =17339

const WebSocket = require('ws');
const server = new WebSocket.Server({
  port: PORT
});

var rooms = {}

server.on('connection', function(socket) {

  socket.on('message', (msg) => {
    let task = JSON.parse(Utf8ArrayToStr(msg))
    
    if (task.type == "createroom" ) {
      let roomID = generateRandomRoomID();
      rooms[roomID] = {
        "status": "not_started",
        "roomID": roomID,
        "socketA": socket,
        "socketB": undefined,
        "positions": {
          "a": undefined,
          "b": undefined
        }
      }
    } else
    if (task.type == "createroom") {

    }
  });

});


function generateSID(known_sid) {
  var getRandomCode = ()=> {
    do {
      var randomnumber = random(10000000000000, 99999999999999);
      if (false ==(String(randomnumber) in known_sid)) {
        return randomnumber;
      } 
    } while (true);
  }
  var random = (min, max) => {  
    return Math.floor(
      Math.random() * (max - min + 1) + min
    )
  }

  return getRandomCode()
}

function generateRandomRoomID() {
  let ID = "";
  let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  for ( var i = 0; i < 5; i++ ) {
    ID += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return ID;
}


function Utf8ArrayToStr(array) {
  var out, i, len, c;
  var char2, char3;

  out = "";
  len = array.length;
  i = 0;
  while(i < len) {
  c = array[i++];
  switch(c >> 4)
  { 
    case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
      // 0xxxxxxx
      out += String.fromCharCode(c);
      break;
    case 12: case 13:
      // 110x xxxx   10xx xxxx
      char2 = array[i++];
      out += String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
      break;
    case 14:
      // 1110 xxxx  10xx xxxx  10xx xxxx
      char2 = array[i++];
      char3 = array[i++];
      out += String.fromCharCode(((c & 0x0F) << 12) |
                     ((char2 & 0x3F) << 6) |
                     ((char3 & 0x3F) << 0));
      break;
  }
  }

  return out;
}