# :no_entry_sign: userblock

Script that performs the blocking or removal of users who have not logged in to the system within a period of time.

## Arguments

### Syntax

```
[-block days | -remove days] [-out filename]
```

### Options

- **block**: performs the user's blocking in the system so that the user cannot log in;
- **remove**: backs up user data, compressing it in `/backup_users/username_date.tar.gz`, and removes them from the system.
- **out**: specifies an output file to store the generated data
