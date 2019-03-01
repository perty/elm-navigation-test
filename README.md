# elm-navigation-test
Showing how to set up navigation in Elm.

This based on the shared state pattern. https://github.com/ohanhi/elm-shared-state

## Goal

I just wanted to make my own to thoroughly understand it.

* Proper URLs, not fragments. Use a node server to catch
all requests and return the index file. Necessary behavior for a 
back end serving a SPA. 
 
* Explicit code. No import with "as", just full path.
Not for production but makes it easier when trying to understand where
things come from.

* Generous use of Debug.log. Again, not for production but for understanding.

* Good readme (you be the judge)

* No fancy graphics or asynchronous loading. For that, see Ossi's 
repository mentioned above.

## The application

There are three pages: Home, Listing and Details. The home page is of course
the starting point where there is one button that takes you to the listings
page and changes the URL.

The listing page lists a number of items. Each has an id and clicking 
on them sends you to the details page with id supplied as a query parameter.


## Flow

What happens when I click the button on the Home Page?

The home page will create a message `NavigateTo` which is wrapped by
`updateRouter` with `RouterMsg`. So there is message within a message within
a message.

That reaches the main update function which case statement identifies it 
as a `Router` message. So `updateRouter`is called which sees the `HomeMsg`
tag and calls `updateHome`. That update calls `pushUrl` which returns an
`UrlChange` message. 

Back in the main update function, we see it is an UrlChange message and
pass that on to `updateRouter`.

````
Main msg: : RouterMsg (HomeMsg (NavigateTo ListingRoute))
Router msg: : HomeMsg (NavigateTo ListingRoute)
Home navigate to : ({},<internals>,NoUpdate)
Main msg: : UrlChange { fragment = Just "/listing", host = "localhost", path = "/", port_ = Just 8000, protocol = Http, query = Nothing }
Router msg: : UrlChange { fragment = Just "/listing", host = "localhost", path = "/", port_ = Just 8000, protocol = Http, query = Nothing }
```

