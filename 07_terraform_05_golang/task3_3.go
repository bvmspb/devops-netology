package main

import "fmt"

func main() {
    var values_list []int

	for i := 0; i < 100; i++ {
	    if( i%3 == 0 ) {
	        values_list = append(values_list,i)
//             fmt.Print(i," ")
        }
	}
	fmt.Printf("values=%v\nlength=%d \n", values_list, len(values_list))
}
