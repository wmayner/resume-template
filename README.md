Resumé
======

Check out the live version [here][1].

Why is this single, static page built as a web app, you ask? I wanted to get a feel for the various technologies involved in the stack, without worrying about the logic and design of a real application. This way, I get a nice, paperless, easily-accessible version of my resumé - and so do you!

Run it
------

```sh
git clone https://github.com/wmayner/resume.git
cd ~/resume
cake dev
```

Then point your browser to [localhost:3000][2].

Customize it
------------

### Content ###

The app renders the contents of `data/resume.json`. Each section is a property of of the `sections` object. A section has the mandatory `title` property and optional properties `place`, `date`, `subtitle`, and `desc`.

`sections` has a special, optional property called `skillbars`, which is rendered differently than other sections; it must have properties of the form `"a_skill": {"Name of Skill (this will be displayed)": "<integer between 0 and 100>"`.

Also, don't forget to remove my Google Analytics script!

### Style ###

Customize `src/less/custom.less` to your liking.

Thanks
------

This was inspired by @philipthomas's [cv][3].

[1]: http://www.willmayner.com/
[2]: localhost:3000
[3]: https://github.com/philipithomas/cv-philipithomas 
