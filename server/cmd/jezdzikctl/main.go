package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/nsf/termbox-go"
)

func main() {
	done := make(chan bool, 1)
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM, syscall.SIGKILL)
	go func() {
		<-sig
		done <- true
	}()

	connTCP, err := net.Dial("tcp", os.Args[1]+":"+"8888")
	if err != nil {
		log.Fatalln(err)
	}

	b := make([]byte, 1)

	_, err = connTCP.Write([]byte{1})
	if err != nil {
		log.Fatalln(err)
	}

	_, err = connTCP.Read(b)
	if err != nil {
		log.Fatalln(err)
	}

	connUDP, err := net.Dial("udp", os.Args[1]+":"+"9999")
	if err != nil {
		log.Fatalln(err)
	}

	err = termbox.Init()
	if err != nil {
		log.Fatalln(err)
	}
	defer termbox.Close()

	go func() {
		for {
			b := make([]byte, 1)
			_, err := connTCP.Read(b)
			if err == io.EOF {
				done <- true
				return
			}
		}
	}()

	go func() {
		for {
			event := termbox.PollEvent()

			switch event.Key {
			case termbox.KeyArrowUp:
				fmt.Printf("%-6s\n", "up")
				connUDP.Write([]byte("f"))
			case termbox.KeyArrowDown:
				fmt.Printf("%-6s\n", "down")
				connUDP.Write([]byte("b"))
			case termbox.KeyArrowLeft:
				fmt.Printf("%-6s\n", "left")
				connUDP.Write([]byte("l"))
			case termbox.KeyArrowRight:
				fmt.Printf("%-6s\n", "right")
				connUDP.Write([]byte("r"))
			default:
				done <- true
				return
			}
		}
	}()

	<-done
}
