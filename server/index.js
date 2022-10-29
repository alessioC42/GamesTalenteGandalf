const WSPORT = 17339;
const HTTPPORT = 8080;

const app = require('express')();
const http = require('http').Server(app);
const io = require('socket.io')(http);

const WebSocket = require('ws');
const server = new WebSocket.Server({
  port: WSPORT
});

var rooms = {};
var playerCount = 0;

server.on('connection', function (socket) {
  console.log("a new client has logged in.");
  playerCount += 1;
  brodcastPlayerCount(playerCount);
  var ownRoomID = "";

  socket.on('message', (msg) => {
    let task = JSON.parse(Utf8ArrayToStr(msg));
    let asociatedRoom = "";

    if (task.type == "createroom") {
      let roomID = generateRandomRoomID();
      asociatedRoom = roomID;
      rooms[roomID] = {
        "status": "not_started",
        "roomID": roomID,
        "socketA": socket,
        "socketB": undefined,
        "positions": {
          "a": { "x": 200, "y": 100 },
          "b": { "x": 200, "y": 300 }
        },
        "inputs": {
          "a": "0000",
          "b": "0000"
        }
      }
      socket.send(JSON.stringify({ "type": "roomID", "ID": roomID }));
      console.log("room created: " + roomID);

      ownRoomID = roomID;
      brodcastOpenLobby(roomID);

    } else

      if (task.type == "join_room") {
        let roomID = task.roomID;
        brodcastClosedLobby(roomID);
        console.log("user trys to join lobby: " + roomID);
        if (roomID in rooms) {
          if (rooms[roomID]["socketB"] == undefined) {
            rooms[roomID]["socketB"] = socket;
            asociatedRoom = roomID;
            socket.send(JSON.stringify({ "type": "joined_room", "ID": roomID }));
            setTimeout(() => {
              rooms[roomID]["socketA"].send(JSON.stringify({ "type": "game_start" }));
              rooms[roomID]["socketB"].send(JSON.stringify({ "type": "game_start" }));
            }, 100)
          } else {
            socket.send(JSON.stringify({ "type": "error", "error": "lobby full" }));
          }
        } else {
          socket.send(JSON.stringify({ "type": "error", "error": "lobby not found" }));
        }
      } else

        if (task.type == "set_position") {
          let pos = task.position;
          let roomID = task.roomID;

          try {
            if (rooms[roomID]["socketA"] == socket) {
              rooms[roomID]["positions"]["a"] = pos;
            } else if (rooms[roomID]["socketB"] == socket) {
              rooms[roomID]["positions"]["b"] = pos;
            }
          } catch { close_room(roomID) }

          try {
            rooms[roomID]["socketA"].send(JSON.stringify({
              "type": "positions",
              "roomID": roomID,
              "mate": rooms[roomID]["positions"]["b"],
              "me": rooms[roomID]["positions"]["a"]
            }));
            rooms[roomID]["socketB"].send(JSON.stringify({
              "type": "positions",
              "roomID": roomID,
              "mate": rooms[roomID]["positions"]["a"],
              "me": rooms[roomID]["positions"]["b"]
            }));
          } catch (_err) { close_room(roomID) }
        } else

          if (task.type == "set_input") {

            let input = task.input;
            let roomID = task.roomID;

            try {
              if (rooms[roomID]["socketA"] == socket) {
                rooms[roomID]["inputs"]["a"] = input;
              } else if (rooms[roomID]["socketB"] == socket) {
                rooms[roomID]["inputs"]["b"] = input;
              }
            }
            catch (err) {
              close_room(roomID);
            }
            try {
              rooms[roomID]["socketA"].send(JSON.stringify({
                "type": "inputs",
                "roomID": roomID,
                "mate": rooms[roomID]["inputs"]["b"],
                "me": rooms[roomID]["inputs"]["a"]
              }));
              rooms[roomID]["socketB"].send(JSON.stringify({
                "type": "inputs",
                "roomID": roomID,
                "mate": rooms[roomID]["inputs"]["a"],
                "me": rooms[roomID]["inputs"]["b"]
              }));
            } catch (_err) { close_room(roomID) }
          }
  });

  socket.on("close", () => {
    close_room(ownRoomID);
    playerCount -= 1;
    brodcastPlayerCount(playerCount);
    console.log("a user has logged out.");
  });

  socket.on("error", () => {
    close_room(ownRoomID);
    console.log("an socket error occured... closing room.");
  })
});

function close_room(roomID) {
  if (rooms[roomID]) {
    try {
      rooms[roomID]["socketA"].send(JSON.stringify({ "type": "room_close" }));
    } catch (_err) { }
    try {
      rooms[roomID]["socketB"].send(JSON.stringify({ "type": "room_close" }));
    } catch (_err) { }
    rooms[roomID] = undefined;
    console.log("room closed: " + roomID);
    brodcastClosedLobby(roomID);
  }
}

function generateRandomRoomID() {
  let ID = "";
  let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  for (var i = 0; i < 5; i++) {
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
  while (i < len) {
    c = array[i++];
    switch (c >> 4) {
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
        out += String.fromCharCode(((c & 0x0F) << 12) | ((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
        break;
    }
  }

  return out;
}


function brodcastOpenLobby(code) {
  io.emit("add_code", code);
}

function brodcastClosedLobby(code) {
  io.emit("remove_code", code);
}

function brodcastPlayerCount(playerCount) {
  io.emit("player_count", String(playerCount));
}

io.on("connection", (socket)=>{})

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/websrc/index.html');
});

http.listen(HTTPPORT, () => {
  console.log(`Monitor server running at http://localhost:${HTTPPORT}/`);
});