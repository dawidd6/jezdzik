package main

import (
	"embed"
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
)

//go:embed index.html index.js index.css
var webAssets embed.FS

// //go:embed config.json
var configBytes []byte

var (
	connected = false
	upgrader  = &websocket.Upgrader{}
	config    map[string]any
)

func noop(speed uint) {
	if speed > 255 {
		speed = 255
	}

	//platform.LeftEnable.Pwm()
	//platform.LeftEnable.Freq(2000)
	//platform.LeftEnable.DutyCycle(uint32(speed), 255)

	//platform.RightEnable.Pwm()
	//platform.RightEnable.Freq(2000)
	//platform.RightEnable.DutyCycle(uint32(speed), 255)

	//platform.LeftForward.Output()
	//platform.LeftBackward.Output()

	//platform.RightForward.Output()
	//platform.RightBackward.Output()
}

func main() {
	err := json.Unmarshal(configBytes, &config)
	if err != nil {
		log.Fatalln(err)
	}

	//err = rpio.Open()
	//if err != nil {
	//	log.Fatalln(err)
	//}
	//defer rpio.Close()

	http.Handle("/", http.FileServer(http.FS(webAssets)))
	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		addr := r.RemoteAddr
		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			log.Println(addr, err)
			return
		}

		if connected {
			err = errors.New("another client is already connected")
			message := websocket.FormatCloseMessage(1008, err.Error())
			timeout := 10 * time.Second
			deadline := time.Now().Add(timeout)
			conn.WriteControl(websocket.CloseMessage, message, deadline)
			conn.Close()
			log.Println(addr, err)
			return
		}

		connected = true

		message := map[string]any{"key": "hello", "value": nil}
		err = conn.WriteJSON(message)
		if err != nil {
			log.Println(addr, err)
			return
		}

		for {
			var message map[string]any

			err := conn.ReadJSON(&message)
			if err != nil {
				log.Println(addr, err)
				break
			}

			key := message["key"]
			value := message["value"]

			switch key {
			case "drive":
				log.Println(addr, value)
			case "speed":
				log.Println(addr, value)
			default:
				log.Println(addr, "wrong key", key)
			}
		}

		connected = false
	})
	http.ListenAndServe(":8080", nil)
}
