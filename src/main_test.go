package main

import (
	"testing"
	"strings"
	"net/http"
	"net/http/httptest"
	"regexp"
)

func TestGetHealthz(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	api := newAPIHandler{}
	
	handler := http.HandlerFunc(api.getHealthz)
	handler.ServeHTTP(rr, req)
	
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	expected := `{"state":"I'm alive!"}`
	if strings.TrimSpace(rr.Body.String()) != strings.TrimSpace(expected) {
		t.Errorf("handler returned unexpected body: got '%v' want '%v'", rr.Body.String(), expected)
	}
}

func TestGetOperatingSystemHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/api/os", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	api := newAPIHandler{}
	
	handler := http.HandlerFunc(api.getOperatingSystemHandler)
	handler.ServeHTTP(rr, req)
	
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	expected := `"Version":"v1"`
	r := regexp.MustCompile(expected)
	matches := r.FindAllStringSubmatch(rr.Body.String(), -1)
	if matches == nil {
		t.Errorf("handler returned unexpected body: got '%v' want Version as defined as'%v'", strings.TrimSpace(rr.Body.String()), expected)
	}
}