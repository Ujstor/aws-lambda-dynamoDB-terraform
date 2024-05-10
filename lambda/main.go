package main

import (
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
	Username string `json:"username"`
}

func HandleRequest(event MyEvent) (string, error) {
	if event.Username == "" {
		return "", fmt.Errorf("User name cannot be empty")
	}

	return fmt.Sprintf("Successfuly called by - %s", event.Username), nil
}

func main() {
	lambda.Start(HandleRequest)
}