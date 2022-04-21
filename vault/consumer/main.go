package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

func main() {
	for range time.Tick(time.Second * 10) {
		go func() {
			r, err := http.Get("http://svc-app.app:3000")
			if err != nil {
				log.Fatalln(err)
			}

			b, err := ioutil.ReadAll(r.Body)
			if err != nil {
				log.Fatalln(err)
			}

			s := string(b)
			log.Println(s)
		}()
	}
}
