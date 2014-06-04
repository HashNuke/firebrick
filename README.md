# Firebrick

To start your new Phoenix application you have to:

1. Install dependencies with `mix deps.get`
2. Start Phoenix router with `mix phoenix.start`

Now you can visit `localhost:4000` from your browser.


## Notes

* If you choose to change the application's structure, you could manually start the router from your code like this `Firebrick.Router.start`


## Firebrick notes

* Could have used a boolean field in Mail model, to indicate if the mail was the root of a thread. But that would mean, deleting the first mail would delete the entire thread. Not good.
