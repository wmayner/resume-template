My Resumé
=========

Check out the live version [here][1].

Why is this single, static page built as a web app, you ask? I wanted to get a feel for the various technologies involved in the stack, without worrying about the logic and design of a real application. This way, I get a nice, paperless, easily-accessible version of my resumé - and so do you!

I'll be adding a minimal navbar and links to social media, github, etc. as soon as I have some time to get around to it.

Run it
------

```sh
git clone https://github.com/wmayner/resume.git
cd ~/resume
node app.js
```

Then point your browser to [http://localhost:3000][2].

Use `cake dev` for development instead of `node app.js`.

Customize it
------------

### Content ###

Name and contact info are set in `src/app.coffee`. Resume content is rendered from `data/resume.json`.

Social media icons are generated from the `socialmedia` property of the `resume` object. Properties of `socialmedia` must have an `iconName` property that has the filename of the corresponding icon (these icons should be placed in `public/img`) and a `url` property which points to your profile on the social media site.

Each resume section is a property of of the `sections` object.
`sections` has a special, optional property called `skillbars`, which is rendered differently than other sections; it must have properties of the form `"a_skill": {"Name of Skill (this will be displayed)": "<integer between 0 and 100>"`.

Also, don't forget to remove my Google Analytics script!

### Style ###

Customize `src/less/custom.less` to your liking.

Thanks
------

This was inspired by @philipthomas's [cv][3]. Thanks to @twilson63 for the Cakefile from [express-coffee][4], and to @visionmedia for developing [Express][5].

[1]: http://www.willmayner.com/
[2]: http://localhost:3000
[3]: https://github.com/philipithomas/cv-philipithomas 
[4]: https://github.com/twilson63/express-coffee
[5]: https://github.com/visionmedia/express
