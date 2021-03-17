^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package smach_ros
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

2.0.4 (2019-08-09)
------------------

2.0.3 (2019-05-20)
------------------

2.0.2 (2019-03-14)
------------------
* Merge pull request `#2 <https://github.com/mojin-robotics/executive_smach/issues/2>`_ from ipa-fxm/fix_string_format_exception
  fix string format exception
* fix string format exception
* Merge pull request `#1 <https://github.com/mojin-robotics/executive_smach/issues/1>`_ from ipa-bnm/fix/preempt_timeout
  Fix/preempt timeout and merge with ros
* Merge branch 'indigo-devel' of github.com:unity-robotics/executive_smach into indigo-devel
* merge
* cancel action on preemption timeout
* Merge pull request `#8 <https://github.com/mojin-robotics/executive_smach/issues/8>`_ from ipa320/local_changes_20170911
  Local changes 20170911
* support unicode
* check whether ActionServer are still available
* Merge pull request `#4 <https://github.com/mojin-robotics/executive_smach/issues/4>`_ from ipa-bnm/fix/condition_state_race_condition
  fixed possible race condition inside condition_state
* fixed possible race condition inside condition_state
* Merge pull request `#3 <https://github.com/mojin-robotics/executive_smach/issues/3>`_ from ipa-bnm/fix/race_condition
  fixed possible race condition inside simple_action_state
* fixed possible race condition inside simple_action_state
* Merge pull request `#2 <https://github.com/mojin-robotics/executive_smach/issues/2>`_ from ipa-bnm/feature/condition_state_output_key
  allow condition states to modifiy userdata
* allow condition states to modifiy userdata
* Merge pull request `#1 <https://github.com/mojin-robotics/executive_smach/issues/1>`_ from ipa-bnm/indigo-devel
  modifications for project
* Merge pull request `#1 <https://github.com/mojin-robotics/executive_smach/issues/1>`_ from LoyVanBeek/indigo-devel
  action state timeout
* publisher queue size for introspection server
* Merge branch 'feature/ConcurrencyFix' of github.com:athackst/executive_smach into indigo-devel
* small cleanup
* changed smach_ros.start() to use thread pool so an outcome can be returned
* Merge branch 'feature/ConcurrencyFixTemp' into feature/ConcurrencyFix
* added shutdown handler, added threaded start to smach_ros
* Contributors: Allison Thackston, Benjamin Maidel, Florian Weisshardt, ipa-fmw, ipa-fxm

2.0.1 (2017-06-08)
------------------
* [fix] SimpleActionState will wait forever for a missing ActionServer `#41 <https://github.com/ros/executive_smach/pull/41>`_
* [fix] monitor state callback args and adding unit test for monitor state that modifies userdata
* [improve] Specify queue sizes for introspection publishers `#31 <https://github.com/ros/executive_smach/pull/31>`_
* [improve] make ServiceState more robust to termination while waiting for service `#32 <https://github.com/ros/executive_smach/pull/32>`_
* [build] make rostest in CMakeLists optional `#45 <https://github.com/ros/executive_smach/pull/45>`_
* change MonitorState and document its behavior 
* increment n_checks only *after* checking
  otherwise, setting max_checks=1 results in a MonitorState that returns the 'valid' outcome for any message
* [test] adding test for actionlib timeout
* [maintenance] Update maintainer. switching to package.xml format 2
* Contributors: Isaac I.Y. Saito, Jonathan Bohren, Loy, Lukas Bulwahn, Nils Berg, contradict

2.0.0 (2014-04-17)
------------------
* smach_ros: Adding rostests to cmakelists
* Merging changes, resolving conflicts, from strands-project (@cburbridge)
* cleaning up and removing rosbuild support
* merging groovy and hydro
* Listing available goal slots in case of specifying wrong ones
* Fix syntax errors, doc typos and indentations glitches
* if monitor state prempted before executing, return.
* Adding event for thread synchronization in concurrence and using event not condition in monitor state
* Listing available goal slots in case of specifying wrong ones
* [MonitorState] Make exception handler more verbose
* edited monitor state to allow input and output keys
* Contributors: Boris Gromov, Bruno Lacerda, Felix Kolbe, Hendrik Wiese, Jonathan Bohren, cburbridge

1.3.1 (2013-07-22)
------------------
* adding changelogs
* added missing catkin_package() calls in CMakeLists.txt files of packages smach and smach_ros
* Updating maintainer name

* added missing catkin_package() calls in CMakeLists.txt files of packages smach and smach_ros
* Updating maintainer name
