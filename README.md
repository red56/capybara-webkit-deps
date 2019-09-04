# Custom circleci 2 image for testing

With Per-project tags and branches


## Process

Decide a docker tag based on project name and date (typically):

${PROJECT}-${DATE}
e.g. bws-2019-08-25

### build locally to ensure it works...

```
docker build .             
```

### Get image onto docker hub -- push option 1 
push the local build to docker hub

```
docker build . -t red56/capybara-webkit-deps:bws-2019-08-25
docker push red56/capybara-webkit-deps:bws-2019-08-25
```

### Get image onto docker hub -- push option 2
push to github and let docker hub autobuild

```
git checkout -b bws-2019-08-25
git commit (etc)
git push -u origin head             
```

### And test with circleci

when built, change ref in circeci/config.yml
ensure it works and then 

### Fossilize  

* if push option 1, then just commit changes to the project branch and push
* if push option 2, then git PR to project branch, merge, and delete old branch
* In commit message / PR message, ensure intent of the changes is recorded.
  something like 
  `"pin nodejs to 10.15.3"`

* tag git with docker tag (it's just easier to have them both linked this way).

* keep using the git == docker tag in circleci, it helps for traceability (don't switch to branch-named docker tag, despite its existance)

* master? 
  Can optionally force-update master with the latest changes.
  Master is only a nicety for github. project branches are what's being used.

### Another branch on same day?

yes sometimes - if so add on a reason or letter to the date.

## Docker reminders

remember earlier things are the base layers -- keep those to be the least chainging
