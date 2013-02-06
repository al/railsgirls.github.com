---
layout: default
title: Extending Your Rails Girls App With Javascript
permalink: app/extensions/javascript
---

# Extending your Rails Girls App with Javascript

**By this stage you should have your app running.** If not [**follow the app tutorial**](/app) and then come back here.

## Prologue

*High-level overview of what Javascript is, where it fits into the HTML/CSS/Rails jigsaw, and the kinds of things you can do with it goes here. Words like progressive enhancement, etc. might be used.*

**Summary**: In this tutorial we are going to add a little bit of Javascript to the app. When we are finished, should be able to do some basic validation of user input. If a required field in your form is omitted, the user will be shown an error message and will not be allowed to proceed until they have corrected it. This will all happen on the client-side, i.e. in the browser, without contacting the Rails app on the server. When done well, this type of thing can make filling in a form a much nicer experience for your users.

## *1.*Saying Hello!

Open `app/assets/javascripts/application.js` in your text editor and add this line to the bottom (after all of the lines beginning with `//= require`):

{% highlight javascript %}
alert("Hello Rails Girls");
{% endhighlight %}

Open [http://localhost:3000/ideas](http://localhost:3000/ideas) in your browser and you should be presented with something like

![Alert](/images/app/extensions/javascript/alert.jpg "Alert")

+--{.aside}
<a class="toggle" href="javascript: void(0);">Aside: What just happened?</a>

+--{.aside-inner}
Rails has taken all the files in your `app/assets/javascripts/` directory and combined them into a single file which you can see if you like by opening  [http://localhost:3000/assets/application.js](http://localhost:3000/assets/application.js) in your browser (your code will be at the bottom, after all the stuff that was included by the `//= require` lines).

Inside your `app/views/layouts/application.html.erb` file you will see that you have a line that reads:

{% highlight erb %}
<%= javascript_include_tag "application" %>
{% endhighlight %}

This has made your browser load the `application.js` file and process the commands in it from top to bottom. When it encountered your `alert` command, it popped up the alert box containing your message.
=--
=--

## *2.*Being Interactive

Saying *Hello* every time the page loads is all very well, but let's make it happen only when the user does something, like submitting the form to create or update an Idea.

How can we know when the user submits the Idea form? Your browser broadcasts a `submit` *event* whenever the form is submitted, and we'll use a library called jQuery to *listen* for it and do our stuff.

Modify your `app/assets/javascripts/application.js` file and replace the line you added earlier with this:

{% highlight javascript %}
$(document).ready(function() {

  $("form").submit(
    function(event) {
      alert("You submitted the form!");
    }
  );

});
{% endhighlight %}

Now when you go to [http://localhost:3000/ideas/new](http://localhost:3000/ideas/new) nothing should happen until you click the submit button which should bring up your alert again.

+--{.aside}
<a class="toggle" href="javascript: void(0);">Aside: jQuery</a>

+--{.aside-inner}
[jQuery](http://jquery.com/) is a very popular library that makes doing things in Javascript much easier. Rails adds jQuery to your applications by default so you don't need to do anything to special to enable it.

As a general rule, you should always wrap your jQuery code like so:

{% highlight javascript %}
$(document).ready(function() {
  // Write your code in here ...
});
{% endhighlight %}

This will become second nature to you. All it does is make sure that your browser has finished displaying your page before it tries to run you your scripts, otherwise they might not work the way you intended.
=--
=--

+--{.aside}
<a class="toggle" href="javascript: void(0);">Aside: jQuery Selectors</a>

+--{.aside-inner}
A key feature of jQuery is being able to access parts of your webpages using *selectors* which are very much like the selectors you have already seen used in CSS.

In the code we just added we selected the `<form>` tag on our page by writing `$("form")`.

To select other parts of the page we just need to change the stuff in between the quotation marks.

* To select every `<div>` on the page, we would write `$("div")`
* To select every link (`<a>`) on the page, we would write `$("a")`
* To select the element of the page that has `id="idea_name"`, we would write `$("#idea_name")`
* To select every element of the page that has `class="field"`, we would write `$(".field")`

[jQuery Selectors](http://api.jquery.com/category/selectors/) can be as simple or as complex as you require, but you'll learn how to write them as you come to need them.
=--
=--

+--{.aside}
<a class="toggle" href="javascript: void(0);">Aside: jQuery Events</a>

+--{.aside-inner}
Once we have selected our `$("form")`, we use jQuery to *bind* a piece of code to any `submit` event that the form broadcasts.

We have told jQuery that whenever the form broadcasts a `submit` event, we want it to run this piece of code:

{% highlight javascript %}
function(event) {
  alert("You submitted the form!");
}
{% endhighlight %}

We call that function a *callback*.

There are [lots of events](http://api.jquery.com/category/events/) that get triggered when stuff happens in your pages.

* Clicking on something (like a link) triggers a `click` event, which you can bind to like so: `$("something").click(function() { // Your click event handler });`
* Changing a form element (by typing in a text box for example) triggers a `change` event, which you can bind to like so: `$("something").change(function() { // Your change event handler });`

=--
=--

## *3.*Being Useful

Popping up an alert box every time you submit the form isn't really very useful &hellip; in fact, it's going to get pretty annoying pretty quickly.

Let's modify our Javascript to implement some basic *client-side validation* instead. We'll prevent the user from submitting the form unless they have filled in the name field.

Update your code like so:

{% highlight javascript %}
$(document).ready(function() {

  $("form").submit(
    function(event) {

      // Make sure name is not blank
      var name = $("#idea_name").val();
      if(name == "") {
        return false;
      }
      else {
        // Do nothing.
      }

    }
  );

});
{% endhighlight %}

Now if you visit [http://localhost:3000/ideas/new](http://localhost:3000/ideas/new), fill in the description field ___but leave the name field empty___, and click submit, nothing should happen.

Then fill in the name field with some text and click submit again, and everything should work like it did before.

+--{.aside}
<a class="toggle" href="javascript: void(0);">Aside: Why was the form submission prevented?</a>

+--{.aside-inner}
If a callback function returns the value `false`, the event is cancelled and nothing more will happen.

In our code we are inspecting the contents of the name field with a little bit of jQuery:

{% highlight javascript %}
var name = $("#idea_name").val();
{% endhighlight %}

`$("#idea_name")` locates the name field using its unique `id` attribute, and invoking the `val()` method on it gives us back its contents. We store that value in a variable called `name` (the variable could be called anything, but `name` makes sense and is easier to understand than something like `myObscureVariableName`).

To check whether or not `name` is blank we compare it to the empty string (written `""`) using the equality operator `==`. `name == ""` will be true only if the `name` string is blank, otherwise it will be false.

Finally we use a small `if` statement. *If* the stuff in the brackets is true, *then* we return false (preventing the form from being submitted), *else* we don't do anything (and form submission proceeds as normal).
=--
=--

## *4.*Giving Feedback

Our client-side validation seems to work, but it isn't very user friendly. Let's do a little more and display a useful error message if the name field is blank.

Firstly, add a little new markup to your form so that we have somewhere to put our error message. Update `app/views/ideas/_form.html.erb` and add this code after `<%= f.text_field :name %>`:

{% highlight erb %}
<br />
<span class="error" id="idea_name_error"></span>
{% endhighlight %}

Then we'll add a little CSS too. Put this in `app/assets/stylesheets/application.css`:

{% highlight css %}
form .error {
  color: red;
  display: none;
}
{% endhighlight %}

Finally modify you Javascript to insert a helpful error message into this new `<span>` as required:

{% highlight javascript %}
$(document).ready(function() {

  $("form").submit(
    function(event) {

      // Make sure name is not blank
      var name = $("#idea_name").val();
      if(name == "") {

        $("#idea_name_error").text("Cannot be blank").show();

        return false;
      }
      else {

        $("#idea_name_error").hide();

      }

    }
  );

});
{% endhighlight %}

Now if you try to submit your form with a blank name you should see your error message appear near by.

+--{.aside}
<a class="toggle" href="javascript: void(0);">Aside: Explanation</a>

+--{.aside-inner}
After adding a place to put our error message (the `<span>`), and initially hiding it with some CSS, we are using some jQuery to set its contents and *show* or *hide* it as appropriate when our submit callback runs.

If the `$("#idea_name")` field is blank, we locate our `<span>` using its id, then use the `text()` function to insert some text into it, and finally use the `show()` function to make sure it's visible.

On the other hand, if the `$("#idea_name")` field is not blank, we again locate our `<span>` and this time use the `hide()` function to make it invisible (it's still there in the page, you just won't be able to see it).

Try changing the `show` and `hide` methods to `fadeIn` and `fadeOut`, or `slideDown` and `slideUp` respectively &hellip; jQuery has lots of nice visual effects that can be used to enhance the appearance of your app (if used wisely!).
=--
=--

## *4.*Validating Other Fields

So far we have only required that a name be supplied. An Idea isn't much without some kind of description, so let's require that the description field be filled in too.

We'll use the same basic logic, but this time we need check both fields, and at the end cancel the form submission if either one of them is blank.

To being with we'll need to add an error container for the description field, so insert this after `<%= f.text_area :description %>` in your form template:

{% highlight erb %}
<br />
<span class="error" id="idea_description_error"></span>
{% endhighlight %}

Now update your script to look like this:

{% highlight javascript %}
$(document).ready(function() {

  $("form").submit(
    function(event) {

      var isValid = true;

      // Make sure name is not blank
      var name = $("#idea_name").val();
      if(name == "") {
        $("#idea_name_error").text("Cannot be blank").show();

        isValid = false;
      }
      else {
        $("#idea_name_error").hide();
      }

      // Make sure description is not blank
      var description = $("#idea_description").val();
      if(description == "") {
        $("#idea_description_error").text("Cannot be blank").show();

        isValid = false;
      }
      else {
        $("#idea_description_error").hide();
      }

      return isValid;
    }
  );

});
{% endhighlight %}

Now test it out. Remember to try all possible scenarios to be sure it's working correctly;

* name blank, description not blank
* name not blank, description blank
* name blank, description blank
* name not blank, description not blank

+--{.aside}
<a class="toggle" href="javascript: void(0);">Aside: Explanation</a>

+--{.aside-inner}
Firstly, notice how the two sections `// Make sure name is not blank`, and `// Make sure description is not blank` are almost identical. The only difference is which field each of them is concerned about.

The biggest difference to what we had done before this is that we no longer `return false;` immediately when we encounter an error. If we did, then an error in the name field would prevent us from checking the description field and only one message would be displayed even if they were both invalid. That would be a bad user experience.

Instead we use a new variable called `isValid`. Initially we set this to `true`. If we encounter an error, either in the name tests, or the description tests, we set it to `false`. In this was the `isValid` variable lets us *remember* whether or not we have detected any problems to date.

After all the tests have been performed we `return isValid;`. Remember that `isValid` will either still be `true`, implying that no problems were found and thus will not prevent the submission of the form, or `false`, meaning that at least one problem was found and will stop the form from being submitted.
=--
=--

## Epilogue

*Some kind of closing statements, probably of the inspirational kind, i.e. you can do this and that and could even write your entire front end in Javascript. Indeed you can even use Javascript in the backend these days, etc.*