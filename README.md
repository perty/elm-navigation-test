# elm-navigation-test
Showing how to set up navigation in Elm. Parsing URL with query
parameters.

This based on the shared state pattern by Ossi Hanhinen. 
See https://github.com/ohanhi/elm-shared-state .

## Goals


* Parse URL like http://host:port/details?id=2 even when
that is the starting URL. Thus, you can bookmark a page.

* Simulate loading of data. 

* Use a Node server to catch all requests and return the index file. 
Necessary behavior for a back end serving a SPA. 
 
* Explicit code. No import with "as", just full path.
Not for production but makes it easier when trying to understand where
things come from.

* Generous use of Debug.log. Again, not for production but for understanding.

* Good readme (you will be the judge)

* No fancy graphics or asynchronous loading. For that, see Ossi's 
repository mentioned above.

## The application

The application shows a list of books on the Listing page which is reached 
from the Home page. Clicking on a book takes you to the Details page for that
book.


## Flow

When the application starts up, it will be given the current URL
which may be like `http://localhost:3005/details?id=3`.

What happens when I click the Listing button on the Home Page?

The home page will create a message `NavigateTo ListingRoute` which is
wrapped by `updateRouter` with `RouterMsg`. So there is message within 
a message within a message.

That reaches the main `update` function which case statement identifies it 
as a `Router` message. So `Router.updater` is called which sees the `HomeMsg`
tag and calls `Home.update`. 
That update calls `Browser.Navigation.pushUrl` which creates an
`UrlChange` message. 

Back in the main update function, we see it is an `UrlChange` message and
pass that on to `Router.update`. The URL is parsed. The `route` of
`Route.Model` now gets the value `ListingRoute`. 

````
Main msg: : RouterMsg (HomeMsg (NavigateTo ListingRoute))
Router msg: : HomeMsg (NavigateTo ListingRoute)
Main msg: : UrlChange { fragment = Nothing, host = "localhost", path = "/listing", port_ = Just 3005, protocol = Http, query = Nothing }
Router msg: : UrlChange { fragment = Nothing, host = "localhost", path = "/listing", port_ = Just 3005, protocol = Http, query = Nothing }
parseUrl: { fragment = Nothing, host = "localhost", path = "/listing", port_ = Just 3005, protocol = Http, query = Nothing }
````

What differs when we are selecting a book from the list is that the
URL parser picks out the value of the query parameter (`Maybe Int`)
and that is passed on when the view is rendered. See `Router.pageView`.

Note that the list has two options for navigating to the details, both 
a link and a button. The application logic handles the link by responding
to the `LinkClicked` event.

````
Main msg: : LinkClicked (Internal { fragment = Nothing, host = "localhost", path = "/details", port_ = Just 3005, protocol = Http, query = Just "id=4" })
Main msg: : UrlChange { fragment = Nothing, host = "localhost", path = "/details", port_ = Just 3005, protocol = Http, query = Just "id=4" }
````

### Shared state update

The `Listing` page demonstrates how a page can update the shared state. When user
press the _button_ to select a book, `Listing` returns a `SharedStateUpdate AddBookId`
as result from the update function. Clicking on the link has not that effect.

In the `Main.updateRouter` function,
`SharedState.update`  gets the `SharedUpdate` message and 
has the opportunity to update the shared state.

## Structure and Responsibilities

The main module relies on the `Routing.Router` module to know about the
pages of the application and route the messages to them. 
The `Routing.Helper` is used by both the pages and the router so it is
partially motivated to avoid circular dependencies.



