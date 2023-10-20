# csci5611pj2   
# Name: Bob Zhou
 

### control the simulation:
   Cloth simulation:   wsad to navigate camera, arrow keys to set the view direction

**r** to reset

# demo image:
![alt text](https://github.com/bobhansky/csci5611pj2/blob/main/showcase_img.png)

### demo video:

[https://www.youtube.com/watch?v=kgArrB1H1Wc](https://www.youtube.com/watch?v=xenI89jDz_g)


# Timestamp
## (also available under the youtube video description )
<pre>

Basic Pinball Dynamics && Circular Obstacles can be seen throghout the video
  
- Textured Background:                0:05
  
- Plunger/Launcher to shoot balls:    0:29
      Each ball (at most 5 balls) is sent by this plunger (just a path seperated by a line) with a 
      random velovity within a specific range
  
- Line-Segment/Polygonal Obstacles:   0:40

- Multiple Balls Interacting          0:42
  
- Particle System Effects:            0:45
      when ball hits purple rectangle, fountain-like particle effects would be triggered.
  
- Sound Effects                       1:12
      firework sound, may not be heard in the video, please try it on local machine and then can hear it.
</pre>



## • List of the tools/library you used && All code for your project with a clear indication of what code you wrote
     Vec2.pde is provided by Dr Stephen J Guy.
     All other files are written by me.
     Using processing. Only use the Sound Library (by Processing) as extra dependency.

## Brief write-up explaining difficulties you encountered
     intersecting with line-segment or polygon can be annoying.
