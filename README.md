# Taffy_video
Videos on how to use Taffy


These files are used for two videos. Originally I was only going to do one video but it got too long. These videos were posted on 

https://coldfusion.adobe.com/2018/10/taffy-rest-part-1-setup/

and

TBD


# What is Taffy and what does it have to do with ColdFusion? Hi, my name is James Mohler and I am going to talk to you today about Taffy by attuttle.

Taffy is a really easy quick way to make REST web services. These services can be consumed by just about anything. 

Sometime just querying a db and returning JSON is tough. And then you factor in the fact that REST not only uses GET and POST, it also uses PUT, PATCH, and DELETE

# Let's do a quick history lession.

In the beginning..., circa 1998. Javascript existed but it was hard to use. It was hard to program. The DOM (Document Object Model) like we know it today did not exist. Netscape and Microsoft each had their own versions of Javascript. ColdFusion really helped out in this space. <cfform> was able to create all kinds of form validation That was a killer feature. You didn't have to do a form submit followed by server side validation. Much of this functionality could be pushed to the browser. You should still do server side validation, just case.

In 2003, the situation was a little better. ColdFusion had Flash Forms, which could do all kinds sophisticated client side form. The idea of the DOM was also taking hold.

In 2008, some BIG Javascript libraries came into place. I was introduced to YUI and it had all kinds of smart widgets. jQuery and jQuery UI came out around this time. And that provided the foundation for some very powerful client side functionality.

By the time you get to 2013, client side libraries are getting bigger and bigger and cover more and more functionality. Twitter Bootstrap, jQuery, and AngularJS are all big and are all covering different parts making browsers do all kinds of things.

So where does that leave us today? It leaves with having to deliver a lot JSON to some very sophisticated Javascript powered frontends. In some ways the Webserver's job similier, in other ways it is much more demanding.

#And this is where Taffy comes in

I want to get data out of my database and deliver JSON. Let's take a look at the Taffy Dashboard. The Taffy Dashboard allows us to look at all the Taffy-powered rest services on our ColdFusion server.

This particular endpoint has a single resource called statesProvinces and it responses only to a GET. This is a good starting point, let's watch it in action. It returns back an array of structs, each with four keys.

#Let's dive into some code, and see what makes this tick.

Our first file is dot .gitignore. I am hiding some directories and that I don't want to be a part of my release. When I later check in my code, these won't be a part of it.

Next we have box.json. Commandbox uses track dependencies. 

The first dependency is "taffy". That is our main topic of discussion. It is going to reach out to Github and pull everything from the latest release

Next we have "formutils". I did a video a while back on that one. It allows forms to be submitted to ColdFusion as an array and struct. We won't be using it very much on the demo, but it is there anyway.

Last we have a github repository called "NorthAmerica". I have all my DB scripts in there. We will be needed them later.

The next part box.json, is the InstallPaths. It works exactly how it sounds.

OK let's move on to our next set of files.

# index.cfm and Application.cfc are now up

index.cfm is easy to talk about. It is blank. When I first saw this it reminded me a lot of how FW/1.

Now let's look at application.cfc. This is where all the work is done, so I am going to take this real slow. If you haven't already, you should download this project, so that you can follow along in your favorite text editor.

Line 2: The extends is how we are going to bring in all of the functionality into the entire application. Taffy changes how the page lifecycle work. You can't mix plain ColdFusion pages with Taffy AND you don't want to do that anyway. A Taffy REST webservice does not have to be in the root of your site. It can be off in a subdirectory

Line 4: Name is not to interesting. Just keep it unique
Line 5 and 6: We are setting up application variable support; we will not be setting up session variable support. If you think you need session variables, you are doing something wrong.

Lines 8 through 10: We are going to be powering our stuff by a database. There is no requirement that you use ColdFusion's ORM, but I like its scalability and clean code

Lines 13 and 14: These are as close to configuration as we are going to get in this file. I wouldn't change it unless there was business need to do so.

#Let's look at the rest of application.cfc#

Line 15: is a normal onApplicationStart() functionality

Line 17: brings in formutils. Formutils is a service. It has no per-request variables. So I can keep it attached to the application scope.

Line 19: This is where some Taffy magic happens.

Line 23: onTaffyRequest() is specific to the Taffy framework. Think of it like onRequestStart() on a normal page. On this presentation we won't be doing much with it. On future videos I hope to show what it is good for.

Line 25: It looks this is where formutils does its work

Let's step back a second. As a developer, what did we really have to worry about? 

We have to connect to a database
We have to make sure that application wide variables are setup right. Formutils is not requirement
We have to make sure that requests in general are handled.

We just don't have to do all that much to make this work.

# Let's look at some beans and resources.

I am going to use bean, ORM, Entity all as the same thing. For purposes of this, we don't need to make any unneeded distinctions.

On the right is our Entity. ColdFusion makes this really simple

Line 1: as soon as you set persistent="true", you have got yourself an entity. ColdFusion is going to try to find a table that is similar to the name of the file. In this case, statesProvinces.cfc should be backed by dbo.stateProvinces.

Line 3: This says there is column called id, and it is a primary key.
Line 4: is a plain field
Line 5: does not allow inserts or updates. I have looked ahead in my code. This is a calculated field. If we tried to insert or update it, it would through an error
Line 6: is a plain field

ColdFusion's ORM is very powerful. When I start up this website, it will query the database to find out more about the db table that powers this cfc. This keeps me from writing select, insert, and delete statements over and over again.

# Let's look at /resources/statesProvinces.cfc

I like keeping resources with the same name as the bean. And the bean should have the same name as the backing table. All of them are plural. That is not a requirement, I just do it for my sanity.

Line 1: One of those extends again. It kind of hard to see the rest of Line 1. Let me get a better view of that.

# Hmmm. taffy_uri

taffy_uri is where the router is defined. That might seem like a strange place to put the router. But it makes a lot of sense. If a new end point is needed, all we have to do is drop a .cfc with an appropriate taffy_uri. A couple of notes here.

1. statesprovinces is in the slash resources subdirectory. I can make the slash resources have ANY kind of structure I want. I can move statesProvinces into an even deeper subdirectory and it would not make any difference.
2. Don't look in Adobe ColdFusion documentation for taffy_uri. It is not there. This is a custom attribute. All ColdFusion knows is that it is there. Taffy knows what to do with it. In our case it will define the endpoint.
3. You might have noticed that there is no output="false" anywhere. It is not needed.

Let's get back to some code

Line 3: a function called get that takes no parameters. There can only be five functions in a Taffy object, GET, POST, PUT, PATCH, and DELETE. If you create a function that does not have those names, they should probably be private. 

I am going to read some lines out of order. Please bear with with

On Lines 8 and 9: I want to load all rows from the db table

##

If wanted only USA, it would look like this. The first parameter is for the bean, the second is for what is equivalent to a where clause

# Let's go back to getting all the rows

Line 10 is the sort order.

EntityLoad returns and array of objects, or an empty array if nothing matches. On line 7, I am going to use the built-in function, EntityToQuery. This will build a query based on the array of objects. Here is where a subtile bug can come in. If the EntityLoad returned an empty array, EntityToQuery will crash because it has no idea what name any potential columns.

On Line 6, we have a Taffy function called queryToArray. That seems strange. It looks almost as if we are undoing what we just did. EntityLoad returned an array. queryToArray seems like it should return an array. Isn't it the same? No it is not. EntityLoad return an array of objects. Those objects had data, member functions and anything else we ever thought of adding to the bean. queryToArray returns a very clean array of structs. It is almost exactly want we want to return.

Line 5 says return rep. rep is a Taffy function. rep is short for "RepresentationOf" and that will make the exact structure we want to return. It will be escaped, quoted and anything else we need. Every function you write should have return rep()

# We need to get this Taffy REST service going

Server.json has all the information for Commandbox to get ColdFusion running

# Let's start this

Start Commandbox by typing box

One of the beautiful things about Commandbox is I can bring up ColdFusion environment without having to do a full install.

I already have the latest version ColdFusion 2018 cached, so when I type start, it will be quick. If it takes longer for you that, is OK.

Let's type start and off we go.

Not only does Commandbox start ColdFusion, it also brings up the default page on the default browser.

...And we get a beautiful crash. Can't find taffy.core.api

# Why did we get a crash?

We started ColdFusion, but we did not get all that Github stuff. Let's stop the server

And install the stuff from github

And Start again. By the way, my starts are going slow because I have BOINC running in the background. The CPUs are about 90% right now.

Tada. Taffy Dashboard is up.

Let's run our webservice. It just crashed! What is this about?

Well there are a couple of things wrong. I haven't setup the database. Commandbox did a fresh install of ColdFusion. There are no datasources defined.

This video is already getting kind of long. So the next video is going to cover getting the database running and getting ColdFusion to use that database.

Thank you for watching

Happy Coding!


# Resources:

https://github.com/atuttle/Taffy

http://taffy.io/

https://stackoverflow.com/questions/tagged/taffy

https://github.com/jmohler1970/Taffy_video


