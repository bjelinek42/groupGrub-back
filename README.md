# groupGrub

groupGrub is an app that aims to reduce the frustration when groups are trying to decide democratically where they will go out to eat together. Each user is a part of a group, and each user has a profile with favorite restaurants. When a group decides they want to go out to eat, a member can create a new vote which will take all the favorites from each user and find the top three most popular restaurants. These three restaurants will then be voted on by each member. Following the vote, the winning restaurant will be displayed on the group page. No more awkwardness deciding where to eat!

## Installation

Backend:

Uses Ruby 3.0.3 and Rails 7.0.2.3. Simply clone and bundle install

```bash
bundle install
```
Included seeds file will allow it to run without having to add all new users and favorites. Just create, seed, and migrate

```bash
rails db:create, migrate, seed
```

Remember to start the server

```bash
rails server
```

## Usage

Users can sign up and select their group. Groups are currently static although this will change in future editions. Users will be directed to their profile page.

Users can navigate to the "Search Restaurants" page on to navbar. They will be asked to enter a city, which will return cities to choose from (if you do not find your city, try adding the state following the city). Restaurants will then populate from the chosen city. This is currently limited to 50 results per the third-party API based on the highest rated restaurants in the city.  Users can add these restaurants to their favorite, which will appear on their profiles. 

The group page shows the group name, members, and most recent restaurant winner. It will also indicate if a vote is currently in progress. The user can generate a vote, but only one at a time. The vote will automatically close when all users have voted. 

### Roadmap

-Ability to create groups

-link to directions sent out when vote concluded

-more restaurant choices

-users can be in multiple groups

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