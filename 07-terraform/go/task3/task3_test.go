package main

import (
	"fmt"
	"os/exec"
	"strings"
	"testing"
)

func TestMain(t *testing.T) {
	var err error
	cmd := exec.Command("./task3")
	out, err := cmd.CombinedOutput()
	sout := string(out)
	if err != nil || !strings.Contains(sout, "3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99") {
		fmt.Println(sout)
		t.Errorf("%v", err)
	}
}
