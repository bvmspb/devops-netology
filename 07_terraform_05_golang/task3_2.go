package main

import (
    "fmt"
    "errors"
)

func Min(values []int) (min int, e error) {
    if len(values) == 0 {
        return 0, errors.New("Cannot detect a minimum value in an empty slice")
    }

    min = values[0]
    for _, v := range values {
            if (v < min) {
                min = v
            }
    }

    return min, nil
}

func main() {
    values_list := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}

    v, err := Min(values_list)

    if err != nil {
        fmt.Println(err, v)      // Zero cannot be used 0
    }

    fmt.Println("The list of values:", values_list)
    fmt.Println("Minimum value from the list is:", v)
}

