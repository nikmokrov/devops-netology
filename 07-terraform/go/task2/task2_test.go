package main

import (
	"fmt"
	"os/exec"
	"strings"
	"testing"
)

func TestMain(t *testing.T) {
	var err error
	cmd := exec.Command("./task2")
	out, err := cmd.CombinedOutput()
	sout := string(out)
	if err != nil || !strings.Contains(sout, "Min: 9") {
		fmt.Println(sout)
		t.Errorf("%v", err)
	}
}
