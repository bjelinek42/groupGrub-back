# groupGrub Backend

This is the API for [groupGrub Frontend](https://github.com/bjelinek42/groupGrub-front).

groupGrub is an app that aims to reduce the frustration when groups are trying to decide democratically where they will go out to eat together. Each user is a part of a group, and each user has a profile with favorite restaurants. When a group decides they want to go out to eat, a member can create a new vote which will take all the favorites from each user and find the top three most popular restaurants. These three restaurants will then be voted on by each member. Following the vote, the winning restaurant will be displayed on the group page. No more awkwardness deciding where to eat!



## Installation

Backend:

Uses Ruby 3.0.3 and Rails 7.0.2.3. Clone and bundle install

```bash
bundle install
```
Included seeds file will allow the app to run without having to add all new users and favorites. Just create, seed, and migrate. The first three groups (Ultimate, Party, and Lyft) are populated with favorites and are ready for votes. The final group (Home) is empty and let's you see what the experience is like without pre-existing members. 

```bash
rails db:create db:migrate db:seed
```

Remember to start the server

```bash
rails server
```

## Usage

The users controller will create users with required group_id. It also houses the user show action for profile view.

The sessions controller creates a current session, which allows users to see their group, any current votes, profile, and allows them to add favorite restaurants.

The restaurant controller handles API access to both searched cities and restaurants in the searched cities. When favorited, the restaurants are added to the database with relevant information, and added to the restaurant_users table. If the restaurant is already in the database, it is only added to the restaurant_users table.

The groups controller handles sending info for signup as to which groups are available. It also send info regarding the current users group to the group and profile page on the frontend.

The restaurant_users table hold the users favorited restaurants. The restaurant_users controller handles deleting from the restaurant_users table. Adding to the table is handled in the restaurant create action.

The vote_restaurants controller is where the vote is generated and tallied. only one vote is allowed at a time. The create action finds the top three choices based on all the users in the group and creates a vote for each restaurant and each user. This ends up being 3 times the number of users in a group, meaning that if there are 5 group members, 15 rows will end up being created. As users vote, the corresponding vote will be changed to "true" and will not allow another vote. After every group member votes, the active column is changed to "false" indicating the vote is over, and the winning restaurant is saved on the groups table for future reference. Users will then be able to generate a new vote. 

### Roadmap

-Ability to create groups

-Users can be in multiple groups

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
MIT License

Copyright (c) 2022 Benjamin Jelinek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.