package api

import (
	"fmt"
	"lambda-func/database"
	"lambda-func/types"
)

type ApiHandler struct {
	dbStore database.DynamoDBClient
}

func NewApiHandler(dbStore database.DynamoDBClient) ApiHandler {
	return ApiHandler{
		dbStore: dbStore,
	}
}

func (api ApiHandler) RegisterUserHandler(event types.RegisterUser) error {
	if event.Password == "" || event.Username == "" {
		return fmt.Errorf("username and password are required")
	}

	userExist, err := api.dbStore.DoesUserExist(event.Username)
	if err != nil {
		return fmt.Errorf("error while checking if user exist: %s", err)
	}

	if userExist {
		return fmt.Errorf("user already exist")
	}

	err = api.dbStore.InsertUser(event)
	if err != nil {
		return fmt.Errorf("error while registering user: %s", err)
	}

	return nil
}
