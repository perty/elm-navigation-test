# elm-navigation-test
Showing how to set up navigation in Elm.

This based on the shared state pattern. https://github.com/ohanhi/elm-shared-state

I just wanted to make my own to thoroughly understand it.

There are three pages: Home, Listing and Details.

## Flow

What happens when I click the button om the Home Page?

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

