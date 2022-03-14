package main

import (
	"io"
	"io/ioutil"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/dawidd6/jezdzik/server/config"
	"github.com/dawidd6/jezdzik/server/vehicle"
	"github.com/stianeikeland/go-rpio"
	"gopkg.in/yaml.v2"
)

func main() {
	in, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatalln(err)
	}

	cfg := &config.Config{}
	err = yaml.Unmarshal(in, cfg)
	if err != nil {
		log.Fatalln(err)
	}

	err = rpio.Open()
	if err != nil {
		log.Fatalln(err)
	}

	veh := vehicle.New(cfg)
	veh.Init()
	veh.Enable()
	veh.Stop()

	done := make(chan bool, 1)
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM, syscall.SIGKILL)
	go func() {
		<-sig
		veh.Stop()
		veh.Disable()
		rpio.Close()
		done <- true
	}()

	addrTCP, err := net.ResolveTCPAddr("tcp", ":8888")
	if err != nil {
		log.Fatalln(err)
	}

	addrUDP, err := net.ResolveUDPAddr("udp", ":9999")
	if err != nil {
		log.Fatalln(err)
	}

	listenerTCP, err := net.ListenTCP("tcp", addrTCP)
	if err != nil {
		log.Fatalln(err)
	}

	connUDP, err := net.ListenUDP("udp", addrUDP)
	if err != nil {
		log.Fatalln(err)
	}

	client := ""

	go func() {
		for {
			connTCP, err := listenerTCP.Accept()
			if err != nil {
				log.Println(err)
				continue
			}

			host, _, err := net.SplitHostPort(connTCP.RemoteAddr().String())
			if err != nil {
				log.Println(err)
				continue
			}

			if client == "" {
				client = host
			} else {
				connTCP.Close()
				continue
			}

			for {
				b := make([]byte, 1)

				n, err := connTCP.Read(b)
				if err == io.EOF {
					client = ""
					break
				}
				if err != nil {
					log.Println(err)
					continue
				}

				_, err = connTCP.Write(b[:n])
				if err != nil {
					log.Println(err)
					continue
				}
			}
		}
	}()

	go func() {
		for {
			b := make([]byte, 1)

			err := connUDP.SetReadDeadline(time.Now().Add(time.Millisecond * 200))
			if err != nil {
				log.Println(err)
				continue
			}

			n, addrUDP, err := connUDP.ReadFrom(b)
			if err, ok := err.(net.Error); ok && err.Timeout() {
				veh.Stop()
				continue
			}
			if err != nil {
				log.Println(err)
				continue
			}

			host, _, err := net.SplitHostPort(addrUDP.String())
			if err != nil {
				log.Println(err)
				continue
			}

			if client != host {
				continue
			}

			switch string(b[:n]) {
			case "f":
				veh.Forward()
			case "b":
				veh.Backward()
			case "l":
				veh.Left()
			case "r":
				veh.Right()
			}
		}
	}()

	<-done
}
