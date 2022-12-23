package main

import "fmt"

func Convert(foot float64) float64 {
	return foot / 0.3048
}

func main() {
	fmt.Print("Введите метры: ")
	var input float64
	_, err := fmt.Scanf("%f", &input)
	if err != nil {
		panic("Это не число!")
	}
	output := Convert(input)
	fmt.Print("Получите футы: ")
	fmt.Println(output)
}
