# Firebrick

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.


### Notes

#### To setup SMTP port forwarding on OS X

```
# to start pf
sudo pfctl -evf tools/smtp-port-forward.pfconf

# to stop pf
sudo pfctl -d

# to dry run the pf.conf
sudo pfctl -vnf tools/smtp-port-forward.pfconf
```

References:
* <http://www.chrisvanpatten.com/port-forwarding-mavericks>
* <https://gist.github.com/kujohn/7209628>
