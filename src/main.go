package main

import (
	"encoding/json"
	"time"
	"os"
	"net/http"
	"fmt"
	"log"
	"runtime"
	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

var version string = "v1"

type OS struct {
	Time string
	Host string
	OSType string
	Version string
}

type KeepAlive struct {
	State		string `json:"state"`
}

type newAPIHandler struct { }
func (eh *newAPIHandler) getHealthz(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	json.NewEncoder(w).Encode(KeepAlive{State: "I'm alive!"})
}

func (eh *newAPIHandler) getOperatingSystemHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	
	host, _ := os.Hostname()
	ostype := runtime.GOOS 
	
	msg := OS{ 
		time.Now().Format(time.RFC850), 
		host, 
		ostype,
		version}	

	json.NewEncoder(w).Encode(msg)
}

func (eh *newAPIHandler) optionsHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(200)
}

func main() {
	handler := newAPIHandler{}

	r := mux.NewRouter()
	apirouter := r.PathPrefix("/api").Subrouter()
	apirouter.Methods("GET").Path("/").HandlerFunc(handler.getHealthz)
	apirouter.Methods("GET").Path("/os").HandlerFunc(handler.getOperatingSystemHandler)
	apirouter.Methods("OPTIONS").Path("/os").HandlerFunc(handler.optionsHandler)

	server := cors.Default().Handler(r)

	port := ":8081"
	if os.Getenv("AES_KEYS_PORT") != "" {
		port = os.Getenv("AES_KEYS_PORT")
	} 
	fmt.Print("Listening on ", port)
	log.Fatal(http.ListenAndServe( port , server))
}
