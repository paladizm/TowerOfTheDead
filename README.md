Tower Of The Dead
==============

This was a project I did for a gamejam in October 2013. The theme was Halloween and this is what came out of it.
Tower of the Dead is a "climber" game where the player climbs a tower and dodges evil flaming skulls as they fall. The 
score system is super simple the longer you last the higher your score. 

<a href="http://i.imgur.com/7hEzIy1.jpg" target="_blank"><img src="http://i.imgur.com/7hEzIy1.jpg" width="160px" height="240px" /></a>
<a href="http://i.imgur.com/fIZp1Vh.jpg" target="_blank"><img src="http://i.imgur.com/fIZp1Vh.jpg" width="160px" height="240px" /></a>

Tech Used
---------

I used the up and coming [Loom Engine](http://loomsdk.com) to create this game! Loom's fast CLI workflow was AWESOME and
extreemly fast for development. 

I targeted iOS for this particular project focusing on retina displays. All of my assets are sized for the iPhone 5
and adjusted from that. 

Building The Project
--------------------

With the Loom CLI building this project is easy! First make sure you are in the project folder.

Then Run:

    loom run --desktop

This will compile and run the project on the desktop.

If you want to run this on your phone you must first add your provisioning profile

    loom provision <Path to your Provisioning Profile>

Then run it

    loom run --ios

Notes
-----
This Code is NOT OPTIMIZED. I was testing out a new technology and was trying to get things done as fast as I could
within the time limits. 

Here are some things this could benifit from:
- Sprites
- Music/Sounds
- An Overarching Player Class
- An Overarching Enemy Class
- Spliting out Overlay Methods from the Level Code
- Making use of Looms LML Structure and CSS
- Timer Optimization
- Further Object Destruction
- Resource Manager
- Refactoring for readability and optimization

That being said feel free to use this code in your projects!

