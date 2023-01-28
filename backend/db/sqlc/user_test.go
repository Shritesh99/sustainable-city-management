package db

import (
	"context"
	"database/sql"
	"testing"

	"github.com/stretchr/testify/require"
	"tcd.ie/ase/group7/sustainablecity/util"
)

func createRandomUser(t *testing.T) User {
	arg := CreateUserParams {
		FirstName: util.RandomName(),
		LastName: util.RandomName(),
	}

	user, err := testQueries.CreateUser(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, user)
	require.Equal(t, arg.FirstName, user.FirstName)
	require.Equal(t, arg.LastName, user.LastName)
	require.NotZero(t, user.UserID)

	return user
}

func TestCreateUser(t *testing.T) {
	createRandomUser(t);
}

func TestGetUser(t *testing.T) {
	user1 := createRandomUser(t)
	user2, err := testQueries.GetUser(context.Background(), user1.UserID)
	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.UserID, user2.UserID)
	require.Equal(t, user1.FirstName, user2.FirstName)
	require.Equal(t, user1.LastName, user2.LastName)
}

func TestUpdateUser(t *testing.T) {
	user1 := createRandomUser(t)

	arg := UpdateUserParams {
		UserID: user1.UserID,
		FirstName: util.RandomName(),
		LastName: util.RandomName(),
	}

	user2, err := testQueries.UpdateUser(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, user2)
	require.Equal(t, user1.UserID, user2.UserID)
	require.Equal(t, arg.FirstName, user2.FirstName)
	require.Equal(t, arg.LastName, user2.LastName)

	// check if lastname is nil
	arg = UpdateUserParams {
		UserID: user1.UserID,
		FirstName: util.RandomName(),
	}
	user3, err := testQueries.UpdateUser(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, user3)
	require.Equal(t, user1.UserID, user3.UserID)
	require.Equal(t, arg.FirstName, user3.FirstName)

	// check if firstname is nil
	arg = UpdateUserParams {
		UserID: user1.UserID,
		LastName: util.RandomName(),
	}
	user4, err := testQueries.UpdateUser(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, user4)
	require.Equal(t, user1.UserID, user4.UserID)
	require.Equal(t, arg.LastName, user4.LastName)
}

func TestDeleteUser(t *testing.T) {
	user1 := createRandomUser(t)
	err := testQueries.DeleteUser(context.Background(), user1.UserID)
	require.NoError(t, err)
	
	user2, err := testQueries.GetUser(context.Background(), user1.UserID)
	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, user2)
}

func TestListUsers(t *testing.T) {
	for i := 0; i < 10; i++ {
		createRandomUser(t)
	}

	arg := ListUsersParams {
		Limit: 5,
		Offset: 5,
	}

	users, err := testQueries.ListUsers(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, users, 5)
	for _, user := range users {
		require.NotEmpty(t, user)
	}
}

