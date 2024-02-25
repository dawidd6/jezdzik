const statuser = document.querySelector("p.statuser#one");
const controller = document.querySelector("div.controller#one");
const control = {
  up: controller.querySelector("button.control#up"),
  left: controller.querySelector("button.control#left"),
  reset: controller.querySelector("button.control#reset"),
  right: controller.querySelector("button.control#right"),
  down: controller.querySelector("button.control#down"),
};

statuser.innerHTML = "Connecting...";
statuser.style.display = "";
controller.style.display = "none";

const ws = new WebSocket(`ws://${location.host}/ws`);

ws.onopen = (event) => {
  console.log("open", event);
};

ws.onerror = (event) => {
  console.log("error", event);
};

ws.onmessage = (event) => {
  console.log("message", event);

  const message = JSON.parse(event.data);

  switch (message.key) {
    case "hello":
      statuser.style.display = "none";
      controller.style.display = "";
      break;
    default:
      break;
  }
};

ws.onclose = (event) => {
  console.log("close", event);

  switch (event.code) {
    case 1008:
      statuser.innerHTML = `Another client is already connected!`;
      break;
    default:
      statuser.innerHTML = `Disconnected from server!`;
      break;
  }

  statuser.style.display = "";
  controller.style.display = "none";
};

let going = false;

const drive = (key) => {
  JSON.stringify({ key: "drive", value: key });
  ws.send(key);
  going = true;
};

for (const key in control) {
  control[key].oncontextmenu = (event) => event.preventDefault();
  if (key === "reset") {
    control[key].onclick = reset;
  } else {
    control[key].onpointerdown = () => drive(key);
    control[key].onpointerup = reset;
    control[key].onpointerleave = reset;
  }
}
