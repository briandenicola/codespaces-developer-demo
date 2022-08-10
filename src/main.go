package main

import (
	"time"
	"os"
	"net/http"
	"fmt"
	"log"
	"runtime"
	"github.com/gin-gonic/gin"
)

var version string = "v1"

type OS struct {
	Time string
	Host string
	OSType string
	Version string
}

type HealthState struct {
	State string
}

type newAPIHandler struct { }
func (eh *newAPIHandler) getHealthz(c *gin.Context) {
	c.JSON(http.StatusOK, HealthState{State: "I'm alive!"})
}

func (eh *newAPIHandler) getOperatingSystemHandler(c *gin.Context) {
	
	host, _ := os.Hostname()
	ostype := runtime.GOOS 
	
	msg := OS{ 
		time.Now().Format(time.RFC850), 
		host, 
		ostype,
		version}	

	c.JSON(http.StatusOK, msg)
}

func (eh *newAPIHandler) optionsHandler(c *gin.Context) {
	c.String(http.StatusOK, "pong")
}

func setupRouter() *gin.Engine {
	handler := newAPIHandler{}

	gin.SetMode(gin.ReleaseMode)

	r := gin.Default()
	r.GET("/", handler.getHealthz)
	r.GET("/api/os", handler.getOperatingSystemHandler)
	r.OPTIONS("/api/os", handler.optionsHandler)

	return r
}

func main() {
	r := setupRouter()

	port := ":8081"
	if os.Getenv("AES_KEYS_PORT") != "" {
		port = os.Getenv("AES_KEYS_PORT")
	} 

	fmt.Print("Listening on ", port)
	log.Fatal(r.Run(port))

	r.Run(port)
}
