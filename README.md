# OVERVIEW

## SERVER

```zsh
open server/HabitServer.app
```

```
/users: A GET request to this endpoint will return a dictionary containing the users of the social network.
/habits: A GET request to this endpoint will return a dictionary containing the habits a user can log.
/images: Combined with the name of an image, a GET request to this endpoint will return the profile image associated with a user.
/userStats: A GET request to this endpoint will return a summary of logged habits for all users. It can also be combined with a query parameter, ids, to return statistics for a subset of users.
/habitStats: A GET request to this endpoint will return a summary of user logs for all habits. It can also be combined with a query parameter, names, to return statistics for a subset of habits.
/combinedStats: A GET request to this endpoint will return a combined response comprising information from /userStats and /habitStats.
/userLeadingStats: Combined with a user ID, a GET request to this endpoint will return user statistics containing just those habits in which the user is leading. If a user isn't leading in any habits, no statistics will be returned.
/loggedHabit: A POST to this endpoint will log a new event related to[…]
```
