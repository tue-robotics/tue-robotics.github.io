---
layout: post
title:  "From UI to motors"
date:   2018-09-25 21:55:00
---

How do commands given to the robot get translated into motor commands? 

There are several layers to this, as you can see in 
[software-architecture.html](https://github.com/tue-robotics/tue-robotics.github.io/blob/master/software-architecture.html).
When you use [Telegram](https://telegram.org/) to chat with the robot, 
your text command first gets sent to the servers of Telegram, 
which passes the message on to our [telegram_ros](https://github.com/tue-robotics/telegram_ros) node. That node implements a [Telegram Bot](https://core.telegram.org/bots)

Instead of Telegram, there is also a speech-to-text engine on our robots, that take in audio and try to convert that to text.
On Amigo, we use [dragonfly_speech_recognition](https://github.com/tue-robotics/dragonfly_speech_recognition). 
This also uses the grammar (as describer below) to aid in speech recognition. 
The grammar restricts what the STT can hear and thus the result is always something the robot can at least parse.

Because we want to be able to both talk to the robot and text with it, each taing turns or even falling back from one modality to another, we use the [HMI](https://github.com/tue-robotics/hmi). 
The Human Machine Interface provides a client that the GPSR's conversation_engine uses. This client is connected to several servers that implement some way for the robot to ask the user a question. 
This can thus be voice (via STT)or text (via Telegram or Slack) or some mock interface for testing. 

The text is eventually read by the 
[conversation_engine](https://github.com/tue-robotics/conversation_engine). 
This interprets the command using the [grammar_parser](https://github.com/tue-robotics/grammar_parser).
The result of the parsing is an action description that gets sent to the [action_server](https://github.com/tue-robotics/action_server). 

The action_server performs some action planning to execute the desired command, which results either in
- A sequence of actions
- An error. The most interesting one being that the command is underspecified. 

In the last case, the conversion_engine talks with the user to fill in more details of the command, also using Telegram or via speech.

Once a sequence of actions is defined, it gets executed by the action_server, which also reports on the progress of the action.

The actions themselves are implemented using the [robot_smach_states](https://github.com/tue-robotics/tue_robocup/tree/master/robot_smach_states).
This is a library of various state machines that for example provide Grab, NavigateTo..., Place, LearnOperator actions.
Each of those accepts a robot-parameter, which is an instance of a Robot-subclass from the [robot_skills](https://github.com/tue-robotics/tue_robocup/tree/master/robot_skills)-package, for example Amigo, Sergio and Hero.
When the state machines execute, they call methods of RobotParts (eg. a Base, Arm, Head, Worldmodel etc), 
which in turn tap into the ROS [Action Servers](http://wiki.ros.org/actionlib#Client-Server_Interaction), [Services](http://wiki.ros.org/ROS/Tutorials/UnderstandingServicesParams#ROS_Services) and [Topics](http://wiki.ros.org/ROS/Tutorials/UnderstandingTopics) of the robot.

In short, the robot_skills provide an abstract, mostly ROS-independent interface to the actual robot.
This way, we don't need to instantiate a lot of clients to ROS actions and services etc in the actual in the higher layers.  

A major component in our robots is the worldmodel, called [ED](https://github.com/tue-robotics/ed) (Environment Descriptor).
We use this to get a symbolic representation of the world. ED Keeps track of objects and uses various plugins to e.g. recognize objects.
ED, through the [ed_localization](https://github.com/tue-robotics/ed_localization.git)-plugin, also provides a maps for the robot to localize itself (over a map-topic like the standard ROS map server) and various other tasks. 

There are several action_servers ont he robot, for example for navigation. 
ROS robots typoically use move_base but we have a more advanced version called [cb_base_navigation](https://github.com/tue-robotics/cb_base_navigation), which does Constraint Based navigation.
The advantage of that is that we can move to an area (defined by some mathematically described constraints) rather than a single Pose.

Another action-server is provided by [MoveIt](https://moveit.ros.org/) to command the arms to various joint goals and cartesian goals.

These planners talk with the hardware interface components, that use EtherCAT to interface with the motors and encoders to send references and read back what the various joint really did.

That is all published on the joint_states-topic. 
The robot_state_publisher than uses that to publish TF-frames so we can see where different parts of the robot are and so that relative positions can be calculated etc.
