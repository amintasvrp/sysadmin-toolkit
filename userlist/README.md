# :card_file_box: userlist

Script that lists the users of the system according to the type of parameter that is passed.

## Arguments

The following user data is displayed: the username, the UID and the full name.

### Syntax

```
-all [-active | -nonactive] [-order] [-groups] [-dir] [-out filename]

-human [-active | -nonactive] [-order] [-groups] [-dir] [-out filename]

-user username [-out filename]
```

### Options
- **all**: show all users;
- **human**: show only human users of the system (usually on systems GNU/Linux human users use the UID from 1000);
- **active**: show only active users in the system;
- **nonactive**: show only blocked users in the system;
- **order**: show users sorted alphabetically;
- **groups**: show a list of groups that each user belongs to;
- **dir**: show each user's default directory and its size;
- **out**: specifies an output file to store the generated data;
- **user**: displays the complete data (username, UUID, full name, activity and list of groups that it is part of) of a given user.
