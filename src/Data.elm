module Data exposing (Author, Book, data, findById)


type alias Author =
    { name : String
    }


type alias Book =
    { id : Int
    , author : Author
    , title : String
    , synopsis : String
    , url : String
    }


data : List Book
data =
    [ Book 1
        (Author "Richard Feldman")
        "Elm in Action"
        """
        Elm is more than just a cutting-edge programming language, it's a chance to upgrade
        the way you think about building web applications. Once you get comfortable with
        Elm's refreshingly different approach to application development, you'll be working
        with a clean syntax, dependable libraries, and a delightful compiler that essentially
        eliminates runtime exceptions. Elm compiles to JavaScript, so your code runs in any
        browser, and Elm's best-in-class rendering speed will knock your socks off.
        Let's get started!
        """
        "https://www.manning.com/books/elm-in-action"
    , Book 2
        (Author "Matthew Griffith")
        "Why Elm?"
        """
        Among today’s frontend technologies, the Elm programming language is genuinely unique.
        Lightweight and easy to work with,
        Elm is a functional language that compiles to JavaScript with code that’s fast,
        hard to break, easily testable, and extremely maintainable. In this report,
        author Matthew Griffith provides a quick overview of Elm with emphasis on its
        advantages over JavaScript and other popular frontend frameworks.
        """
        "https://www.oreilly.com/library/view/why-elm/9781491990728/"
    , Book 3
        (Author "Jeremy Fairbank")
        "Programming Elm"
        """
        Elm brings the safety and stability of functional programing to front-end development,
        making it one of the most popular new languages. Elm’s functional nature and static typing
        means that run-time errors are nearly impossible, and it compiles to JavaScript for easy
        web deployment. This book helps you take advantage of this new language in your web site
        development. Learn how the Elm Architecture will help you create fast applications.
        Discover how to integrate Elm with JavaScript so you can update legacy applications.
        See how Elm tooling makes deployment quicker and easier.
        """
        "https://pragprog.com/book/jfelm/programming-elm"
    , Book 4
        (Author "Alex S. Korban")
        "Practical Elm for a Busy Developer"
        """
        You get excited about Elm, so you breeze through the Elm guide, and get a few simple examples
        running. Then you come up with a great project idea, make a start on it and... things grind to a halt.

        Now that you need a real world data model, a sophisticated UI and fully fleshed out interactions,
        Elm starts to feel truly cryptic and you start getting really frustrated. You want to make progress,
        but you just keep hitting one brick wall after another.
        """
        "https://korban.net/elm/book/"
    ]


findById : List Book -> Int -> Maybe Book
findById books id =
    case books of
        [] ->
            Nothing

        head :: tail ->
            if head.id == id then
                Just head

            else
                findById tail id
