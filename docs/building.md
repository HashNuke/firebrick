## Building everything

#### Converting images from svg to png using imagemagick

    convert -resize 50x50 -background transparent art/ionicons/compose.svg assets/images/compose.png
    convert -resize 50x50 -background transparent art/ionicons/trash-b.svg assets/images/trash.png
    convert -resize 50x50 -background transparent art/ionicons/android-inbox.svg assets/images/inbox.png
    convert -resize 50x50 -background transparent art/ionicons/paper-airplane.svg assets/images/sent.png

Then compile assets and the images will be added to the assets dir


#### Compiling assets

Assuming you have ruby installed and have run `bundle install`, run the following command

    bundle exec rake assets:compile

