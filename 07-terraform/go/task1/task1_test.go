package main

import "testing"

func TestConvert(t *testing.T) {
	var v float64
	v = Convert(12)
	if v != 39.37007874015748 {
		t.Error("Expected 39.37007874015748, got ", v)
	}
}
